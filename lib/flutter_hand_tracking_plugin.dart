import 'dart:async';

import 'package:flutter/services.dart';

class FlutterHandTrackingPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_hand_tracking_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
