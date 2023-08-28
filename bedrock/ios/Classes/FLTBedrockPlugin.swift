import Flutter
import UIKit

public class FLTBedrockPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "chunglyric.com/bedrock", binaryMessenger: registrar.messenger())
    let instance = FLTBedrockPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handleWakelocEnable(arguments: Any?) {
    if let enable = arguments as? Bool {
      UIApplication.shared.isIdleTimerDisabled = enable
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "wakelockEnable":
      handleWakelocEnable(arguments: call.arguments)
      result(nil)
    case "wakelockStatus":
      result(UIApplication.shared.isIdleTimerDisabled)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
