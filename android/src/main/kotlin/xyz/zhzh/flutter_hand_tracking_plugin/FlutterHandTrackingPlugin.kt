package xyz.zhzh.flutter_hand_tracking_plugin

import android.graphics.Canvas
import android.graphics.Color
import android.graphics.SurfaceTexture
import android.view.Surface
import android.view.SurfaceView
import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.view.TextureRegistry

/** FlutterHandTrackingPlugin */
class FlutterHandTrackingPlugin(texturesRegistry: TextureRegistry) : MethodCallHandler {
    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    // {@link SurfaceTexture} where the camera-preview frames can be accessed.
    private var previewFrameTexture: SurfaceTexture? = null
    // {@link SurfaceView} that displays the camera-preview frames processed by a MediaPipe graph.
    private var previewDisplayView: SurfaceView? = null
    // Creates and manages an {@link EGLContext}.
//    private var eglManager: EglManager? = null
    // Sends camera-preview frames into a MediaPipe graph for processing, and displays the processed
    // frames onto a {@link Surface}.
//    private var processor: FrameProcessor? = null
    // Converts the GL_TEXTURE_EXTERNAL_OES texture from Android camera into a regular texture to be
    // consumed by {@link FrameProcessor} and the underlying MediaPipe graph.
//    private var converter: ExternalTextureConverter? = null

    private val entry: TextureRegistry.SurfaceTextureEntry = texturesRegistry.createSurfaceTexture()

    private var surface: Surface? = null


    companion object {
        private const val NAMESPACE: String = "xyz.zhzh.flutter_hand_tracking_plugin"
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), NAMESPACE)
            channel.setMethodCallHandler(FlutterHandTrackingPlugin(registrar.textures()))
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "create" -> {
                val arguments = call.arguments as Map<String, Int>
                val width = arguments.getValue("width").toInt()
                val height = arguments.getValue("height").toInt()
                previewFrameTexture = entry.surfaceTexture()
                previewFrameTexture!!.setDefaultBufferSize(width, height)

                surface = Surface(previewFrameTexture)

                val canvas: Canvas = surface!!.lockCanvas(null)
                //这里的canvas 宽和高只有1个像素 因为surface得创建不是surfaceView拖管的，所以不能够draw实际内容，但是仍然可以绘制背景色
                //int height = canvas.getHeight();
                //int width = canvas.getWidth();
                canvas.drawColor(Color.argb(255, 100, 125, 155))
                surface!!.unlockCanvasAndPost(canvas)

                // TODO: open camera and set Texture
                result.success(entry.id())
            }
            "dispose" -> {
                var textureId: Long = call.arguments as Long
                // TODO: Render dispose by textureId
            }
            else -> result.notImplemented()
        }
    }
}
