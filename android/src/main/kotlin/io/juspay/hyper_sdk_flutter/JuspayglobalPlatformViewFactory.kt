package io.juspay.hyper_sdk_flutter	

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class JuspayglobalPlatformViewFactory(private val binaryMessenger: BinaryMessenger) :
    PlatformViewFactory(null) {
    /**
     * Creates a new Android view to be embedded in the Flutter hierarchy.
     *
     * @param context the context to be used when creating the view, this is different than
     * FlutterView's context.
     * @param viewId unique identifier for the created instance, this value is known on the Dart side.
     * @param args arguments sent from the Flutter app. The bytes for this value are decoded using the
     * createArgsCodec argument passed to the constructor. This is null if createArgsCodec was
     * null, or no arguments were sent from the Flutter app.
     */
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return JuspayglobalPlatformView(context!!, viewId, binaryMessenger)
    }
}
