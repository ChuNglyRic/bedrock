package com.chunglyric.bedrock

import android.app.Activity
import android.view.Window
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlin.coroutines.CoroutineContext

class BedrockPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, CoroutineScope {
    private lateinit var channel: MethodChannel
    private var _activity: Activity? = null
    private val _job: Job = Job()

    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Default + _job

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "chunglyric.com/bedrock")
        channel.setMethodCallHandler(this)
    }

    private fun handleWakelockEnable(arguments: Any): Deferred<BedrockMethodCallResult> = async {
        val activity: Activity = _activity ?: return@async BedrockMethodCallResult(succeed = false, errorMessage = "activity is null")
        val enable: Boolean = (if (arguments is Boolean) arguments else null) ?: return@async BedrockMethodCallResult(succeed = false, errorMessage = "arguments is null")
        launch(Dispatchers.Main) {
            if (enable) activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) else activity.window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }.join()
        return@async BedrockMethodCallResult(succeed = true)
    }

    private fun Window.hasFlag(flags: Int): Boolean {
        return this.attributes.flags and flags != 0
    }

    private fun handleWakelockStatus(): Deferred<BedrockMethodCallResult> = async {
        val activity: Activity = _activity ?: return@async BedrockMethodCallResult(succeed = false, errorMessage = "activity is null")
        val enable: Boolean = activity.window.hasFlag(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        return@async BedrockMethodCallResult(succeed = true, result = enable)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        var methodCallDeferred: Deferred<BedrockMethodCallResult>? = null

        when (call.method) {
            "wakelockEnable" -> methodCallDeferred = handleWakelockEnable(call.arguments)
            "wakelockStatus" -> methodCallDeferred = handleWakelockStatus()
            else -> result.notImplemented()
        }

        methodCallDeferred?.invokeOnCompletion {
            if (methodCallDeferred.isCancelled) {
                result.error("bedrock", "${call.method} ${it?.localizedMessage}", null)
                return@invokeOnCompletion
            }
            if (methodCallDeferred.isCompleted) {
                var methodCallResult = methodCallDeferred.getCompleted()
                if (methodCallResult.succeed) {
                    result.success(methodCallResult.result)
                    return@invokeOnCompletion
                }
                result.error("bedrock", methodCallResult.errorMessage, null)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        _job.cancel()
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        _activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        _activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        _activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        _activity = null
    }
}
