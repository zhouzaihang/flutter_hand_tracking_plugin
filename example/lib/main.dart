import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hand_tracking_plugin/flutter_hand_tracking_plugin.dart';
import 'package:flutter_hand_tracking_plugin/texture_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = new TextureController();
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initializeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterHandTrackingPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hand Tracking Example App'),
        ),
        body: Center(
          child: _controller.isInitialized
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Texture(textureId: _controller.textureId),
                )
              : Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  Future<Null> initializeController() async {
    await _controller.initialize(200, 200);
    setState(() {});
  }
}
