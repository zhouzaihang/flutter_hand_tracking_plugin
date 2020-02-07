package xyz.zhzh.flutter_hand_tracking_plugin

import android.graphics.SurfaceTexture
import android.view.Surface
import androidx.annotation.NonNull
import com.google.mediapipe.components.*
import com.google.mediapipe.formats.proto.LandmarkProto
import com.google.mediapipe.glutil.EglManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.view.TextureRegistry

/** FlutterHandTrackingPlugin */
class FlutterHandTrackingPlugin(private val registry: Registrar) : MethodCallHandler {
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
    // Creates and manages an {@link EGLContext}.
    private var eglManager: EglManager? = null
    // Sends camera-preview frames into a MediaPipe graph for processing, and displays the processed
    // frames onto a {@link Surface}.
    private var processor: FrameProcessor? = null
    // Converts the GL_TEXTURE_EXTERNAL_OES texture from Android camera into a regular texture to be
    // consumed by {@link FrameProcessor} and the underlying MediaPipe graph.
    private var converter: ExternalTextureConverter? = null
    // Handles camera access via the {@link CameraX} Jetpack support library.
    private var cameraHelper: CameraXPreviewHelper? = null

    private val entry: TextureRegistry.SurfaceTextureEntry = registry.textures().createSurfaceTexture()

    private var surface: Surface? = null

    init { // Load all native libraries needed by the app.
        System.loadLibrary("mediapipe_jni")
        System.loadLibrary("opencv_java3")

        PermissionHelper.checkAndRequestCameraPermissions(registry.activity())
    }

    companion object {
        private const val NAMESPACE: String = "xyz.zhzh.flutter_hand_tracking_plugin"
        private const val BINARY_GRAPH_NAME = "handtrackinggpu.binarypb"
        private const val INPUT_VIDEO_STREAM_NAME = "input_video"
        private const val OUTPUT_VIDEO_STREAM_NAME = "output_video"
        private const val OUTPUT_HAND_PRESENCE_STREAM_NAME = "hand_presence"
        private const val OUTPUT_LANDMARKS_STREAM_NAME = "hand_landmarks"
        private val CAMERA_FACING = CameraHelper.CameraFacing.FRONT
        // Flips the camera-preview frames vertically before sending them into FrameProcessor to be
        // processed in a MediaPipe graph, and flips the processed frames back when they are displayed.
        // This is needed because OpenGL represents images assuming the image origin is at the bottom-left
        // corner, whereas MediaPipe in general assumes the image origin is at top-left.
        private const val FLIP_FRAMES_VERTICALLY = true

        private fun getLandmarksDebugString(landmarks: LandmarkProto.NormalizedLandmarkList): String {
            var landmarksString = ""
            for ((landmarkIndex, landmark) in landmarks.landmarkList.withIndex()) {
                landmarksString += ("\t\tLandmark["
                        + landmarkIndex
                        + "]: ("
                        + landmark.x
                        + ", "
                        + landmark.y
                        + ", "
                        + landmark.z
                        + ")\n")
            }
            return landmarksString
        }

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), NAMESPACE)
            channel.setMethodCallHandler(FlutterHandTrackingPlugin(registrar))
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "create" -> {
                val arguments = call.arguments as Map<*, *>
                val width = arguments["width"] as Int
                val height = arguments["height"] as Int
                previewFrameTexture = entry.surfaceTexture()
                previewFrameTexture!!.setDefaultBufferSize(width, height)
                // TODO: open camera and set Texture
                startCamera()
                result.success(entry.id())
            }
            "dispose" -> {
                val textureId: Long = call.arguments as Long
                // TODO: Render dispose by textureId
                result.success(textureId)
            }
            else -> result.notImplemented()
        }
    }

    private fun startCamera() {
        cameraHelper = CameraXPreviewHelper()
        cameraHelper!!.setOnCameraStartedListener { surfaceTexture: SurfaceTexture? ->
            previewFrameTexture = surfaceTexture
        }
        cameraHelper!!.startCamera(registry.activity(), CAMERA_FACING,  /*surfaceTexture=*/null)
    }

}
