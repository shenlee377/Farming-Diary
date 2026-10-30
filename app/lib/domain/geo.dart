/// 地理與方位計算：田界面積、兩點距離、方位文字、補拍轉向。
library;

import 'dart:math' as math;

class GeoPoint {
  final double lat;
  final double lng;
  final double? accuracyMeters;

  const GeoPoint(this.lat, this.lng, {this.accuracyMeters});

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    if (accuracyMeters != null) 'acc': accuracyMeters,
  };

  factory GeoPoint.fromJson(Map<String, dynamic> json) => GeoPoint(
    (json['lat'] as num).toDouble(),
    (json['lng'] as num).toDouble(),
    accuracyMeters: (json['acc'] as num?)?.toDouble(),
  );
}

const double _earthRadiusMeters = 6371008.8;

double _rad(double deg) => deg * math.pi / 180;

/// 兩點大圓距離（公尺）。
double distanceMeters(GeoPoint a, GeoPoint b) {
  final dLat = _rad(b.lat - a.lat);
  final dLng = _rad(b.lng - a.lng);
  final h =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(_rad(a.lat)) *
          math.cos(_rad(b.lat)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * _earthRadiusMeters * math.asin(math.sqrt(h));
}

/// 多邊形面積（平方公尺），球面公式；少於 3 點回傳 0。
///
/// 手機端估算用，介面須標示「手機估算（球面公式）」；正式面積由後端 PostGIS 計算。
double polygonAreaSquareMeters(List<GeoPoint> ring) {
  if (ring.length < 3) return 0;
  var total = 0.0;
  for (var i = 0; i < ring.length; i++) {
    final p1 = ring[i];
    final p2 = ring[(i + 1) % ring.length];
    total +=
        _rad(p2.lng - p1.lng) *
        (2 + math.sin(_rad(p1.lat)) + math.sin(_rad(p2.lat)));
  }
  return (total * _earthRadiusMeters * _earthRadiusMeters / 2).abs();
}

/// 臺灣常用面積單位：1 分 ≈ 969.917 平方公尺，1 甲 = 10 分，1 公頃 = 10000 平方公尺。
const double squareMetersPerFen = 969.917;

String formatArea(double squareMeters) {
  if (squareMeters <= 0) return '—';
  final fen = squareMeters / squareMetersPerFen;
  final ha = squareMeters / 10000;
  return '${squareMeters.round()} 平方公尺（約 ${fen.toStringAsFixed(2)} 分，${ha.toStringAsFixed(3)} 公頃）';
}

/// 記錄田界時略過精度太差或距離上一點太近的點，避免軌跡抖動。
bool shouldKeepTrackPoint(
  GeoPoint? last,
  GeoPoint next, {
  double maxAccuracyMeters = 15,
  double minStepMeters = 2,
}) {
  final acc = next.accuracyMeters;
  if (acc != null && acc > maxAccuracyMeters) return false;
  if (last == null) return true;
  return distanceMeters(last, next) >= minStepMeters;
}

// ───────────────────────── 方位 ─────────────────────────

const List<String> _directions16 = [
  '北',
  '北北東',
  '東北',
  '東北東',
  '東',
  '東南東',
  '東南',
  '南南東',
  '南',
  '南南西',
  '西南',
  '西南西',
  '西',
  '西北西',
  '西北',
  '北北西',
];

double normalizeHeading(double degrees) {
  final d = degrees % 360;
  return d < 0 ? d + 360 : d;
}

String headingToDirection(double degrees) =>
    _directions16[(normalizeHeading(degrees) / 22.5).round() % 16];

/// 最短轉角：正值往右（順時針），負值往左，範圍 (-180, 180]。
double turnDelta(double current, double target) {
  final diff = normalizeHeading(target - current);
  return diff > 180 ? diff - 360 : diff;
}

const double alignToleranceDegrees = 15;

class TurnGuidance {
  final bool aligned;
  final double delta;
  final String text;

  const TurnGuidance(this.aligned, this.delta, this.text);
}

TurnGuidance turnGuidance(double current, double target) {
  final delta = turnDelta(current, target);
  if (delta.abs() <= alignToleranceDegrees) {
    return TurnGuidance(true, delta, '對準了，按下快門');
  }
  final rounded = (delta.abs() / 5).round() * 5;
  return TurnGuidance(false, delta, '${delta > 0 ? '往右轉' : '往左轉'}約 $rounded°');
}

/// 角度的指數平滑（處理 359° → 0° 的跳躍）。
double smoothHeading(double? previous, double next, {double factor = 0.2}) {
  if (previous == null) return next;
  return normalizeHeading(previous + turnDelta(previous, next) * factor);
}
