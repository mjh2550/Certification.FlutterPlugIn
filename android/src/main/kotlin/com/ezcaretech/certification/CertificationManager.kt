package com.ezcaretech.certification

import android.content.Context
import android.util.Log
import com.google.gson.Gson
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.isolutec.icertmanager.iCertClient
import com.lumensoft.ks.KSBase64
import com.lumensoft.ks.KSCertificate
import com.lumensoft.ks.KSCertificateLoader
import com.lumensoft.ks.KSCertificateManager
import com.lumensoft.ks.KSException
import com.lumensoft.ks.KSSign
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.async
import java.util.Vector
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody

class CertificationManager {
    companion object {
        private val _certClient = iCertClient()
        private var _verifyUrl: String = ""

        fun init(downloadUrl: String, verifyUrl: String): Int {
            _certClient.SetServiceUrl(downloadUrl)
            _verifyUrl = verifyUrl
            return KSCertificateManager.libInitialize()
        }

        @OptIn(DelicateCoroutinesApi::class)
        private fun downloadCertificate(userId: String) = GlobalScope.async(Dispatchers.IO) {
            _certClient.GetCertification(userId)
        }

        @JvmStatic
        @Throws(KSException::class)
        private fun getCertificateList(context: Context?): Vector<KSCertificate> {
            var userCerts = KSCertificateLoader.getUserCertificateListWithGpki(context)
            userCerts = KSCertificateLoader.FilterByExpiredTime(userCerts)
            return userCerts
        }

        @JvmStatic
        @Throws(KSException::class)
        private fun getCertificate(context: Context?, certDn: String): KSCertificate {
            val certList = getCertificateList(context)

            for (cert in certList) {
                if (cert?.subjectDn == certDn) {
                    return cert
                }
            }

            throw KSException(KSException.KSCERTIFICATE_IS_NULL)
        }

        @JvmStatic
        @Throws(KSException::class)
        suspend fun checkPassword(
            context: Context?,
            userId: String,
            password: String
        ): Boolean  {
            val certDn: String = downloadCertificate(userId).await()
            val certificate = getCertificate(context, certDn)
            val result = KSCertificateManager.checkPwd(certificate.certPath, password)
            KSCertificateManager.deleteCert(certificate.certPath)
            return result
        }

        @JvmStatic
        @Throws(KSException::class)
        suspend fun encrypt(
            context: Context?,
            userId: String,
            plainText: String,
            password: String
        ): String {
            val certDn: String = downloadCertificate(userId).await()
            val certificate = getCertificate(context, certDn)
            val plainData: ByteArray = plainText.toByteArray(charset("euc-kr"))
            val cipherData = KSSign.koscomSign(certificate, plainData, password)
            val base64EncodedData = KSBase64.encode(cipherData)
            val cipherText = String(base64EncodedData)
            val isValid = verify(cipherText).await()
            KSCertificateManager.deleteCert(certificate.certPath)
            if (!isValid) throw KSException(KSException.FAIL_PKCS_VERIFY)
            return cipherText
        }


        @OptIn(DelicateCoroutinesApi::class)
        private fun verify(cipherText: String) = GlobalScope.async(Dispatchers.IO) {
            if (_verifyUrl.isEmpty()) {
                return@async _certClient.VerifySignData(cipherText).equals("T")
            }

            val mediaType = "application/json; charset=utf-8".toMediaTypeOrNull()
            val client = OkHttpClient()
            val postData = Gson().toJson(cipherText, String::class.java)
            val requestBody = postData.toRequestBody(mediaType)
            val request = Request.Builder()
                .url(_verifyUrl)
                .addHeader("Accept", "application/json")
                .addHeader("Content-Type", "application/json; charset=utf-8")
                .post(requestBody)
                .build()

            client.newCall(request).execute().use { response ->
                val responseData: String = response.body?.string() ?: ""
                Log.i("verifyResult", "${response.isSuccessful} ${response.code} $responseData")
                return@async response.isSuccessful
            }
        }

    }
}
