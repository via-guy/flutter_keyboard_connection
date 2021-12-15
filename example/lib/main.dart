import 'package:flutter/material.dart';
import 'package:keyboard_connection/keyboard_connection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: StreamBuilder<bool>(
            stream: KeyboardConnection.keyboardConnectedStream,
            initialData: false,
            builder: (context, snapshot) {
              final keyboardConnected = snapshot.data ?? false;
              return Center(
                child: Text(
                  '${keyboardConnected ? 'keyboard connected' : 'No keyboard connected'}\n',
                ),
              );
            },
          ),
        ),
      );
}
