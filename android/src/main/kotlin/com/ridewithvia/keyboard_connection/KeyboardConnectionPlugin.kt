package com.ridewithvia.keyboard_connection

import android.content.ComponentCallbacks
import android.content.Context
import android.content.res.Configuration
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** KeyboardConnectionPlugin */
class KeyboardConnectionPlugin: FlutterPlugin, MethodCallHandler, ComponentCallbacks {
  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private lateinit var context : Context
  private var eventSink: EventChannel.EventSink? = null

  /* FlutterPlugin */

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    context.registerComponentCallbacks(this)

    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "keyboard_connection")
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "keyboard_connection_updates")
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        events?.success(isHardwareKeyboardConnected(context.resources.configuration))
      }

      override fun onCancel(arguments: Any?) {
        eventSink = null
      }
    })
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    context.unregisterComponentCallbacks(this)
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  /* MethodCallHandler */

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getKeyboardConnected") {
      result.success(isHardwareKeyboardConnected(context.resources.configuration))
    } else {
      result.notImplemented()
    }
  }

  /* ComponentCallbacks */

  override fun onConfigurationChanged(newConfig: Configuration) {
    eventSink?.success(isHardwareKeyboardConnected(newConfig))
  }

  override fun onLowMemory() {
  }

  /* Private functions */

  private fun isHardwareKeyboardConnected(configuration: Configuration): Boolean {
    // https://stackoverflow.com/a/31299623/16129427
    return configuration.keyboard != Configuration.KEYBOARD_NOKEYS
  }
}
