import Flutter
import GameController
import UIKit

public class SwiftKeyboardConnectionPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    struct Errors {
        static let unsupportedVersion = FlutterError(
            code: "Unsupported OS",
            message: "Hardware keyboard detection is only available on iOS 14+",
            details: nil
        )
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftKeyboardConnectionPlugin()

        let methodChannel = FlutterMethodChannel(name: "keyboard_connection", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: methodChannel)

        let eventChannel = FlutterEventChannel(name: "keyboard_connection_updates", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }

    static var isHardwareKeyboardConnected: Bool {
        if #available(iOS 14.0, *) {
            return GCKeyboard.coalesced != nil
        } else {
            return false
        }
    }

    private var keyboardDidConnectHandler: NSObjectProtocol?
    private var keyboardDidDisconnectHandler: NSObjectProtocol?
    private var eventSink: FlutterEventSink?

    override init() {
        super.init()

        if #available(iOS 14.0, *) {
            keyboardDidConnectHandler = NotificationCenter.default.addObserver(
                forName: .GCKeyboardDidConnect,
                object: nil,
                queue: nil) { [unowned self] _ in
                    keyboardDidConnect()
                }

            keyboardDidDisconnectHandler = NotificationCenter.default.addObserver(
                forName: .GCKeyboardDidDisconnect,
                object: nil,
                queue: nil) { [unowned self] _ in
                    keyboardDidDisonnect()
                }
        }
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        if let keyboardDidConnectHandler = keyboardDidConnectHandler {
            NotificationCenter.default.removeObserver(keyboardDidConnectHandler)
        }
        if let keyboardDidDisconnectHandler = keyboardDidDisconnectHandler {
            NotificationCenter.default.removeObserver(keyboardDidDisconnectHandler)
        }
        eventSink = nil
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getKeyboardConnected") {
            if #available(iOS 14.0, *) {
                result(SwiftKeyboardConnectionPlugin.isHardwareKeyboardConnected)
            } else {
                result(Errors.unsupportedVersion)
            }
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if #available(iOS 14.0, *) {
            events(SwiftKeyboardConnectionPlugin.isHardwareKeyboardConnected)
            eventSink = events
            return nil
        } else {
            events(Errors.unsupportedVersion)
            return Errors.unsupportedVersion
        }
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }


    private func keyboardDidConnect() {
        eventSink?(SwiftKeyboardConnectionPlugin.isHardwareKeyboardConnected)
    }


    private func keyboardDidDisonnect() {
        eventSink?(SwiftKeyboardConnectionPlugin.isHardwareKeyboardConnected)
    }
}
