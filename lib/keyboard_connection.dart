import 'dart:async';

import 'package:flutter/services.dart';

class KeyboardConnection {
  static const _methodChannel = MethodChannel('keyboard_connection');
  static const _eventChannel = EventChannel('keyboard_connection_updates');

  static Future<bool> get keyboardConnected async =>
      await _methodChannel.invokeMethod('getKeyboardConnected') ?? false;

  static Stream<bool> get keyboardConnectedStream =>
      _eventChannel.receiveBroadcastStream().cast();
}
