import 'package:flutter/material.dart';
import 'package:flutter_hand_tracking_plugin/flutter_hand_tracking_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HandTrackingViewController _controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hand Tracking Example App'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                child: HandTrackingView(
                  onViewCreated: (HandTrackingViewController c) {
                    setState(() => _controller = c);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
