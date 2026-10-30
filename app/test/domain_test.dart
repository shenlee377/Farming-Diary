import 'dart:typed_data';

import 'package:farming_diary/domain/blur.dart';
import 'package:farming_diary/domain/geo.dart';
import 'package:farming_diary/domain/state_machines.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('工作狀態機', () {
    test('依 DOMAIN_MODEL §3.1 轉移', () {
      var s = TaskStatus.draft.apply(TaskAction.schedule);
      expect(s, TaskStatus.scheduled);
      s = s.apply(TaskAction.startStaffing);
      expect(s, TaskStatus.staffing);
      s = s.apply(TaskAction.staffingFilled);
      expect(s, TaskStatus.ready);
      s = s
          .apply(TaskAction.start)
          .apply(TaskAction.report)
          .apply(TaskAction.confirm);
      expect(s, TaskStatus.completed);
    });

    test('非法轉移丟出例外', () {
      expect(
        () => TaskStatus.draft.apply(TaskAction.confirm),
        throwsA(isA<IllegalTransition>()),
      );
      expect(
        () => TaskStatus.completed.apply(TaskAction.cancel),
        throwsA(isA<IllegalTransition>()),
      );
    });

    test('人手只看已答應人數', () {
      expect(isStaffingFilled(acceptedCount: 1, headcountNeeded: 2), isFalse);
      expect(isStaffingFilled(acceptedCount: 2, headcountNeeded: 2), isTrue);
      expect(isStaffingFilled(acceptedCount: 0, headcountNeeded: 0), isFalse);
    });
  });

  group('人員安排狀態機', () {
    test('打過電話只到「等回覆」，不算答應', () {
      final s = AssignmentStatus.notContacted.apply(AssignmentAction.contact);
      expect(s, AssignmentStatus.awaitingReply);
      expect(s.countsAsAccepted, isFalse);
      expect(s.apply(AssignmentAction.accept).countsAsAccepted, isTrue);
    });

    test('改期後已答應的人需要再確認', () {
      final s = AssignmentStatus.accepted.apply(
        AssignmentAction.taskRescheduled,
      );
      expect(s, AssignmentStatus.needsReconfirm);
      expect(s.countsAsAccepted, isFalse);
      expect(
        () => s.apply(AssignmentAction.accept),
        throwsA(isA<IllegalTransition>()),
      );
    });
  });

  group('施藥狀態彙總', () {
    test('沒有紀錄是「尚未確認」，不推論為未施用', () {
      expect(aggregatePesticideStatus([]), PesticideStatus.unknown);
    });

    test('任何一筆已施用就是已施用', () {
      expect(
        aggregatePesticideStatus([
          PesticideStatus.confirmedNone,
          PesticideStatus.applied,
          PesticideStatus.unknown,
        ]),
        PesticideStatus.applied,
      );
    });

    test('混有尚未確認時不得彙總為未施用', () {
      expect(
        aggregatePesticideStatus([
          PesticideStatus.confirmedNone,
          PesticideStatus.unknown,
        ]),
        PesticideStatus.unknown,
      );
      expect(
        aggregatePesticideStatus([PesticideStatus.confirmedNone]),
        PesticideStatus.confirmedNone,
      );
    });
  });

  group('地理', () {
    test('約 100 公尺見方的田面積約 1 公頃', () {
      // 臺灣中部緯度附近，緯度 0.0009° ≈ 100 m
      const lat = 23.78, lng = 120.46;
      final dLng = 100 / (111320 * 0.9151); // cos(23.78°) ≈ 0.9151
      final ring = [
        const GeoPoint(lat, lng),
        GeoPoint(lat, lng + dLng),
        GeoPoint(lat + 100 / 110574, lng + dLng),
        const GeoPoint(lat + 100 / 110574, lng),
      ];
      expect(polygonAreaSquareMeters(ring), closeTo(10000, 150));
      expect(
        polygonAreaSquareMeters(ring.reversed.toList()),
        closeTo(10000, 150),
      );
    });

    test('少於 3 點面積為 0', () {
      expect(
        polygonAreaSquareMeters(const [GeoPoint(23, 120), GeoPoint(23.1, 120)]),
        0,
      );
    });

    test('軌跡點過濾：精度差或太近的略過', () {
      const a = GeoPoint(23.78, 120.46, accuracyMeters: 4);
      expect(shouldKeepTrackPoint(null, a), isTrue);
      expect(
        shouldKeepTrackPoint(
          a,
          const GeoPoint(23.78, 120.46, accuracyMeters: 30),
        ),
        isFalse,
      );
      expect(
        shouldKeepTrackPoint(
          a,
          const GeoPoint(23.780001, 120.46, accuracyMeters: 4),
        ),
        isFalse,
      );
      expect(
        shouldKeepTrackPoint(
          a,
          const GeoPoint(23.7801, 120.46, accuracyMeters: 4),
        ),
        isTrue,
      );
    });

    test('方位文字與轉向', () {
      expect(headingToDirection(0), '北');
      expect(headingToDirection(285), '西北西');
      expect(headingToDirection(355), '北');
      expect(turnDelta(350, 10), 20);
      expect(turnDelta(10, 350), -20);
      expect(turnGuidance(90, 285).text, '往左轉約 165°');
      expect(turnGuidance(270, 285).aligned, isTrue);
      expect(turnGuidance(200, 285).text, '往右轉約 85°');
    });

    test('方位平滑跨越北方不會繞一大圈', () {
      final s = smoothHeading(350, 10, factor: 0.5);
      expect(s, closeTo(0, 0.001));
    });
  });

  group('模糊快篩', () {
    Uint8List image(int w, int h, int Function(int x, int y) f) {
      final bytes = Uint8List(w * h);
      for (var y = 0; y < h; y++) {
        for (var x = 0; x < w; x++) {
          bytes[y * w + x] = f(x, y);
        }
      }
      return bytes;
    }

    test('細節多的畫面分數高於平滑畫面', () {
      const w = 64, h = 64;
      final sharp = image(w, h, (x, y) => ((x ~/ 2 + y ~/ 2) % 2) * 255);
      final flat = image(w, h, (x, y) => 128 + (x ~/ 16));
      final sharpScore = laplacianVariance(
        sharp,
        width: w,
        height: h,
        rowStride: w,
      );
      final flatScore = laplacianVariance(
        flat,
        width: w,
        height: h,
        rowStride: w,
      );
      expect(sharpScore, greaterThan(defaultBlurThreshold));
      expect(flatScore, lessThan(defaultBlurThreshold));
    });

    test('rowStride 大於寬度時只讀有效像素', () {
      const w = 32, h = 32, stride = 40;
      final bytes = Uint8List(stride * h)..fillRange(0, stride * h, 255);
      for (var y = 0; y < h; y++) {
        for (var x = 0; x < w; x++) {
          bytes[y * stride + x] = 100;
        }
      }
      expect(
        laplacianVariance(bytes, width: w, height: h, rowStride: stride),
        0,
      );
    });

    test('分類：太暗、模糊、清晰', () {
      expect(
        classifyFrame(blurScore: 500, brightness: 20),
        FrameQuality.tooDark,
      );
      expect(
        classifyFrame(blurScore: 10, brightness: 120),
        FrameQuality.blurry,
      );
      expect(
        classifyFrame(blurScore: 500, brightness: 120),
        FrameQuality.sharp,
      );
    });
  });
}
