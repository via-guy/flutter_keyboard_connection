import 'package:flutter_test/flutter_test.dart';
import 'package:keyboard_connection/keyboard_connection.dart';

void main() {
  const _methodChannel = KeyboardConnection.methodChannel;

  TestWidgetsFlutterBinding.ensureInitialized();

  test('getKeyboardConnected', () async {
    expect(await KeyboardConnection.keyboardConnected, false);
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(_methodChannel, (message) async {
      return true;
    });
    expect(await KeyboardConnection.keyboardConnected, true);
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(_methodChannel, null);
  });
}
