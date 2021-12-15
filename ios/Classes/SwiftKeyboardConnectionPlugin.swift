import Flutter
import GameController
import UIKit

public class SwiftKeyboardConnectionPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftKeyboardConnectionPlugin()

        let methodChannel = FlutterMethodChannel(name: "keyboard_connection", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: methodChannel)

        let eventChannel = FlutterEventChannel(name: "keyboard_connection_updates", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }

    static var isHardwareKeyboardConnected: Bool { GCKeyboard.coalesced != nil }

    private var keyboardDidConnectHandler: NSObjectProtocol!
    private var keyboardDidDisconnectHandler: NSObjectProtocol!
    private var eventSink: FlutterEventSink?

    override init() {
        super.init()

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
                keyboardDidConnect()
            }
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        NotificationCenter.default.removeObserver(keyboardDidConnectHandler!)
        NotificationCenter.default.removeObserver(keyboardDidDisconnectHandler!)
        eventSink = nil
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getKeyboardConnected") {
            result(SwiftKeyboardConnectionPlugin.isHardwareKeyboardConnected)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        events(SwiftKeyboardConnectionPlugin.isHardwareKeyboardConnected)
        eventSink = events
        return nil
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
