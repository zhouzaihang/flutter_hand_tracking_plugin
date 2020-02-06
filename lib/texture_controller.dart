import 'package:flutter/services.dart';

class TextureController {
  static const String NAMESPACE = "xyz.zhzh.flutter_hand_tracking_plugin";
  static const MethodChannel _channel = const MethodChannel(NAMESPACE);

  int _textureId;

  int get textureId => _textureId;

  Future<int> initialize(int width, int height) async {
    _textureId = await _channel
        .invokeMethod("create", {"width": width, "height": height});
    return _textureId;
  }

  Future<Null> dispose() =>
      _channel.invokeMethod("dispose", {"textureId": _textureId});

  bool get isInitialized => _textureId != null;
}
