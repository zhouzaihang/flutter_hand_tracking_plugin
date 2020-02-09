package xyz.zhzh.flutter_hand_tracking_plugin

import android.graphics.SurfaceTexture
import android.util.Log
import android.util.Size
import android.view.Surface
import androidx.annotation.NonNull
import com.google.mediapipe.components.*
import com.google.mediapipe.formats.proto.LandmarkProto
import com.google.mediapipe.framework.AndroidAssetUtil
import com.google.mediapipe.framework.Packet
import com.google.mediapipe.framework.PacketGetter
import com.google.mediapipe.glutil.EglManager
import com.google.protobuf.InvalidProtocolBufferException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.view.TextureRegistry

/** FlutterHandTrackingPlugin */
class FlutterHandTrackingPlugin(private val registry: Registrar) : MethodCallHandler {
    companion object {
        private const val TAG = "FlutterHandTrackingPlugin"
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

        init { // Load all native libraries needed by the app.
            System.loadLibrary("mediapipe_jni")
            System.loadLibrary("opencv_java3")
        }

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

    private val entry: TextureRegistry.SurfaceTextureEntry = registry.textures().createSurfaceTexture()
    // {@link SurfaceTexture} where the camera-preview frames can be accessed.
    private val previewFrameTexture: SurfaceTexture = entry.surfaceTexture()
    // Creates and manages an {@link EGLContext}.
    private val eglManager: EglManager = EglManager(null)
    // Sends camera-preview frames into a MediaPipe graph for processing, and displays the processed
    // frames onto a {@link Surface}.
    private var processor: FrameProcessor? = null
    // Converts the GL_TEXTURE_EXTERNAL_OES texture from Android camera into a regular texture to be
    // consumed by {@link FrameProcessor} and the underlying MediaPipe graph.
    private var converter: ExternalTextureConverter? = null
    // Handles camera access via the {@link CameraX} Jetpack support library.
    private var cameraHelper: CameraXPreviewHelper? = null

    init {
        // Initialize asset manager so that MediaPipe native libraries can access the app assets, e.g.,
        // binary graphs.
        AndroidAssetUtil.initializeNativeAssetManager(registry.context())
        processor = FrameProcessor(registry.context(),
                eglManager.nativeContext,
                BINARY_GRAPH_NAME,
                INPUT_VIDEO_STREAM_NAME,
                OUTPUT_VIDEO_STREAM_NAME)
        processor!!.videoSurfaceOutput.setFlipY(FLIP_FRAMES_VERTICALLY)
        processor!!.addPacketCallback(OUTPUT_HAND_PRESENCE_STREAM_NAME) { packet: Packet ->
            val handPresence = PacketGetter.getBool(packet)
            if (!handPresence)
                Log.d(TAG, "[TS:${packet.timestamp}] Hand presence is false, no hands detected.")
        }
        processor!!.addPacketCallback(OUTPUT_LANDMARKS_STREAM_NAME) { packet: Packet ->
            val landmarksRaw = PacketGetter.getProtoBytes(packet)
            try {
                val landmarks =
                        LandmarkProto.NormalizedLandmarkList.parseFrom(landmarksRaw)
                if (landmarks == null) {
                    Log.d(TAG, "[TS:" + packet.timestamp + "] No hand landmarks.")
                    return@addPacketCallback
                }
                // Note: If hand_presence is false, these landmarks are useless.
                Log.d(
                        TAG,
                        "[TS:"
                                + packet.timestamp
                                + "] #Landmarks for hand: "
                                + landmarks.landmarkCount)
                Log.d(TAG, getLandmarksDebugString(landmarks))
            } catch (e: InvalidProtocolBufferException) {
                Log.e(TAG, "Couldn't Exception received - $e")
                return@addPacketCallback
            }
        }
        PermissionHelper.checkAndRequestCameraPermissions(registry.activity())
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "create" -> {
                val arguments = call.arguments as Map<*, *>
                val width = arguments["width"] as Int
                val height = arguments["height"] as Int
                previewFrameTexture.setDefaultBufferSize(width, height)
                // camera-preview frames get rendered onto, potentially with scaling and rotation)
                // based on the size of the SurfaceView that contains the display.
                val viewSize = Size(width, height)
                // TODO: open camera and set Texture
                converter = ExternalTextureConverter(eglManager.context)
                converter!!.setFlipY(FLIP_FRAMES_VERTICALLY)
                converter!!.setConsumer(processor)
                if (!PermissionHelper.cameraPermissionsGranted(registry.activity())) {
                    PermissionHelper.checkAndRequestCameraPermissions(registry.activity())
                    result.error("DENIED", "Access denied open camera", null)
                }
                startCamera()
                processor!!.videoSurfaceOutput.setSurface(Surface(previewFrameTexture))
//                val displaySize = cameraHelper!!.computeDisplaySizeFromViewSize(viewSize)
//                val isCameraRotated = cameraHelper!!.isCameraRotated
                // Connect the converter to the camera-preview frames as its input (via
                // previewFrameTexture), and configure the output width and height as the computed
                // display size.
                converter!!.setSurfaceTexture(previewFrameTexture, width, height)
//                converter!!.setSurfaceTextureAndAttachToGLContext(previewFrameTexture, width, height)
//                        if (isCameraRotated) displaySize.height else displaySize.width,
//                        if (isCameraRotated) displaySize.width else displaySize.height)
//                previewFrameTexture.setDefaultBufferSize(width, height)

                result.success(entry.id())
            }
            "dispose" -> {
                val textureId: Long = call.arguments as Long
                // TODO: Render dispose by textureId
                converter?.close()
                result.success(textureId)
            }
            else -> result.notImplemented()
        }
    }

    private fun startCamera() {
        cameraHelper = CameraXPreviewHelper()
//        cameraHelper!!.setOnCameraStartedListener { surfaceTexture: SurfaceTexture? ->
//            previewFrameTexture = surfaceTexture
//        }
        cameraHelper!!.startCamera(registry.activity(), CAMERA_FACING,  /*surfaceTexture=*/previewFrameTexture)
    }

}
