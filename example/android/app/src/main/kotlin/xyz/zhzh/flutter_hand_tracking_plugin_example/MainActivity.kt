package xyz.zhzh.flutter_hand_tracking_plugin_example

import androidx.annotation.NonNull
import android.util.Log // 导入 Android 日志工具

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    // 当 Activity 启动时，Flutter 将会配置 FlutterEngine
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        // 使用 GeneratedPluginRegistrant 注册所有 Flutter 插件
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // 添加日志打印，以便在配置 FlutterEngine 时进行调试
        Log.d("MainActivity", "FlutterEngine 已配置")
    }
}
