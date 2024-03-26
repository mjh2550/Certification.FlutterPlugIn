package com.ezcaretech.certification

import android.app.Activity
import android.content.Context
import android.os.Environment
import com.ezcaretech.certification.cert.XMLSignGenerator

// import com.ezcaretech.certification.verify
import com.isolutec.icertmanager.iCertClient
import com.lumensoft.ks.KSCertificate
import com.lumensoft.ks.KSCertificateLoader
import com.lumensoft.ks.KSCertificateManager
import com.lumensoft.ks.KSException
import com.lumensoft.ks.KSUtil

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.IOException

import java.util.*

import kotlin.concurrent.thread

/** CertificationPlugin */
class CertificationPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var iCertClient: iCertClient

  init {
    iCertClient = iCertClient()
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "certification")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "libInitialize" -> {
        result.success(KSCertificateManager.libInitialize())
      }
      "setServiceUrl" -> {
        iCertClient.SetServiceUrl(call.argument("url"))
        result.success(true)
      }
      "getCertification" -> {
        thread {
          result.success(iCertClient.GetCertification(call.argument("userId")))
        }
      }
      "getUserCertificateListWithGpki" -> {
        try {
          var list : List<KSCertificate?> = getCertifications()
          result.success(list)
        } catch (ex: KSException) {
          result.error("KSException", ex.message, ex.stackTrace)
        }
      }
      "deleteCert" -> {
        try {
          var keyFilePath : String? = call.argument("keyFilePath")
          var response = KSCertificateManager.deleteCert(keyFilePath)
          result.success(response)
        } catch (ex: KSException) {
          result.error("KSException", ex.message, ex.stackTrace)
          result.success(-1)
        }
      }
      "encryptCert" -> {
        try {
          thread {
            var xmlString: String = call.argument("xmlString") ?: ""
            var certPw: String = call.argument("certPw") ?: ""
            var iCertDn: String = call.argument("iCertDn") ?: ""
            var ksCertificate : KSCertificate? = getKSCertificate(iCertDn)
            if(ksCertificate == null) {
              result.error("KSException", "인증서를 불러오지 못해 암호화에 실패하였습니다.","")
            } else {
              var encryptionXml = XMLSignGenerator().encryptCert(
                xmlString,
                ksCertificate!!,
                certPw
              )
              result.success(encryptionXml)
            }
          }
        } catch (ex: KSException) {
          result.error("KSException", ex.message, ex.stackTrace)
        }
      }
      "checkPwd" -> {
        try {
           var keyFilePath : String? = call.argument("keyFilePath")
           var certPw : String? = call.argument("certPw")
           var response = if(KSCertificateManager.checkPwd(keyFilePath, certPw)) 1 else -1
          result.success(response)
        } catch (ex: KSException) {
          result.error("KSException", ex.message, ex.stackTrace)
        }
      }
      "verifySignData" -> {
        try {
          // var sign = call.argument("sign")
          result.success("sign")
        } catch (ex: KSException) {
          result.error("KSException", ex.message, ex.stackTrace)
        }
      }
      "getCertFilePath" -> {
        var certDn : String = call.argument("certDn") ?: ""
        result.success(getCertFilePath(certDn))
      }
      "getPrivateKeyFilePath" -> {
        var certDn : String = call.argument("certDn") ?: ""
        result.success(getPrivateKeyFilePath(certDn ))
      }
      else -> {
        result.notImplemented()
      }
    }
  }


  /**
   * 인증서 경로 찾는 함수
   */
  private fun getCertFilePath(certDn: String): String {
    // 인증서와 개인 키가 저장된 기본 디렉토리 경로
    val baseDirPath = "${Environment.getExternalStorageDirectory()}/NPKI/SignKorea/USER/"

    // 인증서 파일 경로
    val certFilePath = "$baseDirPath$certDn/signCert.der"

    // 인증서 파일 존재 여부 확인
    val certFile = File(certFilePath)
    return if (certFile.exists()) {
      certFilePath
    } else {
      // 인증서 파일을 찾지 못한 경우에 대한 처리
      "not_found"
    }
  }

  /**
   * 인증서 개인 키 경로 찾는 함수
   */
  private fun getPrivateKeyFilePath(certDn: String): String {
    // 인증서와 개인 키가 저장된 기본 디렉토리 경로
    val baseDirPath = "${Environment.getExternalStorageDirectory()}/NPKI/SignKorea/USER/"

    // 개인 키 파일 경로
    val privateKeyFilePath = "$baseDirPath$certDn/signPri.key"

    // 개인 키 파일 존재 여부 확인
    val privateKeyFile = File(privateKeyFilePath)
    return if (privateKeyFile.exists()) {
      privateKeyFilePath
    } else {
      // 개인 키 파일을 찾지 못한 경우에 대한 처리
      "not_found"
    }
  }

  // @Throws(KSException::class)
  // private fun ksCertificate(filePath: String): KSCertificate {
  //   val certificateData = KSUtil.readFile(filePath)
  //   return KSCertificate(certificateData, filePath)
  // }

  private fun getKSCertificate(iCertDn: String): KSCertificate? {
    return try {
        val list: List<KSCertificate?> = getCertifications()
        val ksCert: KSCertificate? = list.firstOrNull {
          it?.subjectDn == iCertDn
        }
        ksCert
      } catch (ex: KSException) {
        null
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

  private fun getCertifications(): List<KSCertificate?> {
    var userCerts: Vector<KSCertificate?>? =
      KSCertificateLoader.getUserCertificateListWithGpki(context) as Vector<KSCertificate?>?
    userCerts = KSCertificateLoader.FilterByExpiredTime(userCerts) as Vector<KSCertificate?>?
    return userCerts?.toList() ?: listOf()
  }
}
