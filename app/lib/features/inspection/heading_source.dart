import 'package:flutter/services.dart';

import '../../domain/geo.dart';

/// 原生方位來源（Android 旋轉向量感測器、iOS CLLocationManager），見 MainActivity.kt／AppDelegate.swift。
/// 單位：度，0 = 磁北，順時針；已做平滑處理。
class HeadingSource {
  static const _channel = EventChannel('farmingdiary/heading');

  Stream<double> stream() {
    double? smoothed;
    return _channel.receiveBroadcastStream().map((event) {
      smoothed = smoothHeading(smoothed, (event as num).toDouble());
      return smoothed!;
    });
  }
}
