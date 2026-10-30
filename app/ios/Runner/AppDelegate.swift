import CoreLocation
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FarmingDiaryHeading") {
      HeadingStreamHandler.register(with: registrar)
    }
  }
}

/// 以 CLLocationManager 提供磁北方位（度、順時針），對應 Android 端的 farmingdiary/heading。
/// 不需要定位權限；裝置不支援羅盤時送出錯誤 `no_sensor`。
final class HeadingStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
  private var sink: FlutterEventSink?

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterEventChannel(name: "farmingdiary/heading", binaryMessenger: registrar.messenger())
    channel.setStreamHandler(HeadingStreamHandler())
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard CLLocationManager.headingAvailable() else {
      return FlutterError(code: "no_sensor", message: "此裝置沒有方位感測器", details: nil)
    }
    sink = events
    manager.delegate = self
    manager.headingFilter = 1
    manager.startUpdatingHeading()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    manager.stopUpdatingHeading()
    sink = nil
    return nil
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    guard newHeading.headingAccuracy >= 0 else { return }
    sink?(newHeading.magneticHeading)
  }
}
