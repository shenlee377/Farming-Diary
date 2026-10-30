import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/geo.dart';

/// 田界形狀預覽（沒有底圖；地圖服務尚未選定，見 PROJECT_BRIEF A4）。
class BoundaryPreview extends StatelessWidget {
  final List<GeoPoint> points;
  final bool closed;
  final double height;

  const BoundaryPreview(
    this.points, {
    super.key,
    this.closed = true,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: '田界形狀，共 ${points.length} 個點',
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: _BoundaryPainter(
            points,
            closed,
            scheme.primary,
            scheme.outline,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _BoundaryPainter extends CustomPainter {
  final List<GeoPoint> points;
  final bool closed;
  final Color color;
  final Color grid;

  _BoundaryPainter(this.points, this.closed, this.color, this.grid);

  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = grid
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      border,
    );
    if (points.isEmpty) return;

    // 以第一點為原點的等距投影（公尺），田區尺度誤差可忽略
    final lat0 = points.first.lat * math.pi / 180;
    final xs = points
        .map((p) => (p.lng - points.first.lng) * 111320 * math.cos(lat0))
        .toList();
    final ys = points.map((p) => (p.lat - points.first.lat) * 110540).toList();
    final minX = xs.reduce(math.min), maxX = xs.reduce(math.max);
    final minY = ys.reduce(math.min), maxY = ys.reduce(math.max);
    final spanX = math.max(maxX - minX, 1.0),
        spanY = math.max(maxY - minY, 1.0);
    const pad = 16.0;
    final scale = math.min(
      (size.width - 2 * pad) / spanX,
      (size.height - 2 * pad) / spanY,
    );
    final offsetX = (size.width - spanX * scale) / 2;
    final offsetY = (size.height - spanY * scale) / 2;
    Offset at(int i) => Offset(
      offsetX + (xs[i] - minX) * scale,
      size.height - (offsetY + (ys[i] - minY) * scale),
    );

    final path = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(at(i).dx, at(i).dy);
    }
    if (closed && points.length > 2) path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(at(points.length - 1), 6, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_BoundaryPainter old) =>
      old.points != points || old.closed != closed || old.color != color;
}
