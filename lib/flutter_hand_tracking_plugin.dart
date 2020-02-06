import 'dart:async';

import 'package:flutter/services.dart';

const NAMESPACE = "xyz.zhzh.flutter_hand_tracking_plugin";

class FlutterHandTrackingPlugin {
  static const MethodChannel _channel = const MethodChannel(NAMESPACE);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
