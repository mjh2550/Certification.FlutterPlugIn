package com.ezcaretech.certification

import android.app.Activity
import android.content.Context
import android.util.Log
import com.lumensoft.ks.KSException
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*
import kotlin.coroutines.*
import kotlinx.coroutines.*

/** CertificationPlugin */
class CertificationPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "certification")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  @OptIn(DelicateCoroutinesApi::class)
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "initialize" -> {
        val downloadUrl = call.argument("downloadUrl") ?: ""
        val verifyUrl = call.argument("verifyUrl") ?: ""
        val retVal = CertificationManager.init(downloadUrl, verifyUrl)
        // result.success(retVal)
        if(retVal == -3701) {
          GlobalScope.launch {
            try {
              // val userId: String = call.argument("userId") ?: ""
              // val password: String = call.argument("password") ?: ""
              // Log.i("userId", userId)
              // Log.i("password", password)
              val retVal = CertificationManager.checkPassword(context, "CCC0EMR", "88888888")
              Log.i("retVal", retVal.toString())
              if(retVal) {
                result.success(-3701)
              }
            } catch (ex: KSException) {
              Log.w("KSException", "${ex.message}\r\n${ex.stackTrace}")
              result.error(ex.errorCode.toString(), ex.message, ex)
            } catch (ex: Exception) {
              Log.w("Exception", "${ex.message}\r\n${ex.stackTrace}")
              result.error("Exception", ex.message, ex)
            }
          }
        }
      }
      "certAuth" -> GlobalScope.launch {
        try {
          val userId: String = call.argument("userId") ?: ""
          val password: String = call.argument("password") ?: ""
          Log.i("userId", userId)
          Log.i("password", password)
          val retVal = CertificationManager.checkPassword(context, userId, password)
          Log.i("retVal", retVal.toString())
          result.success(retVal)
        } catch (ex: KSException) {
          Log.w("KSException", "${ex.message}\r\n${ex.stackTrace}")
          result.error(ex.errorCode.toString(), ex.message, ex)
        } catch (ex: Exception) {
          Log.w("Exception", "${ex.message}\r\n${ex.stackTrace}")
          result.error("Exception", ex.message, ex)
        }
      }
      "encrypt" -> GlobalScope.launch {
        try {
          val userId: String = call.argument("userId") ?: ""
          val password: String = call.argument("password") ?: ""
          val plainText: String = call.argument("plainText") ?: ""
          Log.i("userId", userId)
          Log.i("password", password)
          Log.i("plainText", plainText)
          val cipherText = CertificationManager.encrypt(context, userId, plainText, password)
          result.success(cipherText)
        } catch (ex: KSException) {
          Log.w("KSException", "${ex.message}\r\n${ex.stackTrace}")
          result.error(ex.errorCode.toString(), ex.message, ex)
        } catch (ex: Exception) {
          Log.w("Exception", "${ex.message}\r\n${ex.stackTrace}")
          result.error("Exception", ex.message, ex)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }
}
