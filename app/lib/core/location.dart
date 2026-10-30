/// 定位：用到時才要求權限；被拒絕時說明原因並提供「到設定開啟」（SECURITY_AND_DATA §7）。
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../domain/geo.dart';

enum LocationAccess { granted, serviceOff, denied, deniedForever }

Future<LocationAccess> requestLocationAccess() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    return LocationAccess.serviceOff;
  }
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  return switch (permission) {
    LocationPermission.always ||
    LocationPermission.whileInUse => LocationAccess.granted,
    LocationPermission.deniedForever => LocationAccess.deniedForever,
    _ => LocationAccess.denied,
  };
}

/// 要求定位；失敗時跳出說明。[purpose] 例：「記錄田界」。
Future<bool> ensureLocation(
  BuildContext context, {
  required String purpose,
}) async {
  final access = await requestLocationAccess();
  if (access == LocationAccess.granted) return true;
  if (!context.mounted) return false;
  final (body, action, open) = switch (access) {
    LocationAccess.serviceOff => (
      '手機的定位功能是關閉的。$purpose需要定位，請先打開定位。',
      '打開定位設定',
      Geolocator.openLocationSettings,
    ),
    LocationAccess.deniedForever => (
      '$purpose需要定位權限，請到設定裡允許「使用 App 時」取用位置。',
      '到設定開啟',
      Geolocator.openAppSettings,
    ),
    _ => ('沒有定位權限，無法$purpose。之後需要時會再詢問。', '知道了', () async => true),
  };
  final go = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('需要定位'),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('先不要'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(action),
        ),
      ],
    ),
  );
  if (go == true && access != LocationAccess.denied) await open();
  return false;
}

/// 取一次目前位置（例如拍照時）；拿不到時回傳 null，不阻擋使用者。
Future<GeoPoint?> currentLocationOrNull() async {
  try {
    final permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      return null;
    }
    final p = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 8),
      ),
    );
    return GeoPoint(p.latitude, p.longitude, accuracyMeters: p.accuracy);
  } catch (_) {
    final last = await Geolocator.getLastKnownPosition();
    return last == null
        ? null
        : GeoPoint(
            last.latitude,
            last.longitude,
            accuracyMeters: last.accuracy,
          );
  }
}

/// 連續定位。[keepRunningWhenScreenOff] 為真時：
/// - Android 以前景服務＋常駐通知續錄（使用者在 App 內按下開始，「使用 App 時」權限即可）。
/// - iOS 允許背景更新並顯示藍色定位指示（需 Info.plist 的 UIBackgroundModes: location）。
Stream<GeoPoint> positionStream({
  required bool keepRunningWhenScreenOff,
  String notificationText = '正在記錄田界',
}) {
  final LocationSettings settings;
  if (defaultTargetPlatform == TargetPlatform.android) {
    settings = AndroidSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
      intervalDuration: const Duration(seconds: 1),
      foregroundNotificationConfig: keepRunningWhenScreenOff
          ? ForegroundNotificationConfig(
              notificationTitle: '農田日記',
              notificationText: notificationText,
              notificationChannelName: '田界記錄',
              enableWakeLock: true,
              setOngoing: true,
            )
          : null,
    );
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    settings = AppleSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
      activityType: ActivityType.fitness,
      pauseLocationUpdatesAutomatically: false,
      allowBackgroundLocationUpdates: keepRunningWhenScreenOff,
      showBackgroundLocationIndicator: keepRunningWhenScreenOff,
    );
  } else {
    settings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    );
  }
  return Geolocator.getPositionStream(
    locationSettings: settings,
  ).map((p) => GeoPoint(p.latitude, p.longitude, accuracyMeters: p.accuracy));
}

/// Android 13 以上的前景服務通知需要通知權限，否則通知不顯示（記錄仍會進行）。
Future<void> requestNotificationPermissionIfNeeded() async {
  if (defaultTargetPlatform != TargetPlatform.android) return;
  await ph.Permission.notification.request();
}
