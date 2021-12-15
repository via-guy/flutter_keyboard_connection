import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class KeyboardConnection {
  @visibleForTesting
  static const methodChannel = MethodChannel('keyboard_connection');
  @visibleForTesting
  static const eventChannel = EventChannel('keyboard_connection_updates');

  static Future<bool> get keyboardConnected async =>
      await methodChannel.invokeMethod('getKeyboardConnected') ?? false;

  static Stream<bool> get keyboardConnectedStream =>
      eventChannel.receiveBroadcastStream().cast();
}
