import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const methodChannel = MethodChannel('keyboard_connection');

  TestWidgetsFlutterBinding.ensureInitialized();

  test('getKeyboardConnected', () async {
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (message) async => false);
    expect(await methodChannel.invokeMethod('getKeyboardConnected'), false);

    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, (message) async => true);
    expect(await methodChannel.invokeMethod('getKeyboardConnected'), true);

    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });
}
