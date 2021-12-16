# keyboard_connection

Quickly and easily check if an external keyboard (or barcode scanner) is connected to the device.

Supported platforms:
- **Android 4+**
- **iOS 14+**

## Getting Started

To get the current connection status immediately, use:

```Dart
import 'package:keyboard_connection/keyboard_connection.dart';

final isConnected = await KeyboardConnection.keyboardConnected;
```

To listen to updates to the stream, use:

```Dart
final subscriptionListener = KeyboardConnection.keyboardConnectedStream.listen((isConnected) {
  print('Keyboard connected: $isConnected');
});
```

### Android

In order to receive changes to the keyboard connection, you must include in your `AndroidManifest.xml`:
```XML
<manifest ...>
<application ...>
<activity ...
    android:configChanges="keyboard"
    ...>
```

### iOS

The API used for getting the keyboard connected status is only available from iOS 14.
You can still import this plugin, but an error will be thrown when listening for results. 
