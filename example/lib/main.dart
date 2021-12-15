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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<bool>(
                future: KeyboardConnection.keyboardConnected,
                builder: (context, snapshot) {
                  final keyboardConnected = snapshot.data ?? false;
                  final text = snapshot.hasError
                      ? snapshot.error?.toString()
                      : keyboardConnected
                          ? 'keyboard initially connected'
                          : 'No keyboard initially connected';
                  return Center(
                    child: Text('$text\n'),
                  );
                },
              ),
              StreamBuilder<bool>(
                stream: KeyboardConnection.keyboardConnectedStream,
                initialData: false,
                builder: (context, snapshot) {
                  final keyboardConnected = snapshot.data ?? false;
                  final text = snapshot.hasError
                      ? snapshot.error?.toString()
                      : keyboardConnected
                          ? 'keyboard connected'
                          : 'No keyboard connected';
                  return Center(
                    child: Text('$text\n'),
                  );
                },
              ),
            ],
          ),
        ),
      );
}
