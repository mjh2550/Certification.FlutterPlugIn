// package com.ezcaretech.certification.cert

// import android.util.Log
// import com.ezcaretech.ezconsentdomain.model.certification.AuthCert
// import com.ezcaretech.ezconsentdomain.model.certification.Sign
// import com.ezcaretech.ezconsentdomain.model.certification.VerifyCert
// import com.google.gson.Gson
// import com.google.gson.JsonArray
// import com.google.gson.JsonObject
// import com.isolutec.icertmanager.iCertClient
// import com.lumensoft.ks.KSBase64
// import com.lumensoft.ks.KSCertificate
// import com.lumensoft.ks.KSException
// import com.lumensoft.ks.KSSign
// import okhttp3.MediaType.Companion.toMediaTypeOrNull
// import okhttp3.OkHttpClient
// import okhttp3.Request
// import okhttp3.RequestBody.Companion.toRequestBody
// import java.io.UnsupportedEncodingException

// class XMLSignGenerator {

//     /// XML String 생성
//     fun getActingStringXML(arrSignData: ArrayList<Sign>): String? {
//         val sCrLf = "\r\n"
//         var sText = ""
//         sText += "<SavePermitForm_IN>$sCrLf"
//         for (i in arrSignData.indices) {
//             if(arrSignData[i].key.equals("PERMITPAGE",true)) {
//                 val gson = Gson()
//                 val jsonArr = gson.fromJson(arrSignData[i].value, JsonArray::class.java)
//                 for(jsonElement in jsonArr) {
//                     if(jsonElement is JsonObject) {
//                         val jsonObj = jsonElement as JsonObject
//                         val keysToRemove = listOf(
//                             "PAGE_HTML",
//                             "PEN_DATA",
//                             "FUNC_DATA",
//                             "SHAPE_DATA",
//                             "SHAPE_HTML",
//                             "REPEATER_DATA"
//                         )

//                         for(key in keysToRemove) {
//                             if(jsonObj.has(key)) jsonObj.remove(key)
//                         }
//                     }
//                 }
//             val jsonStr = gson.toJson(jsonArr)
//                 sText += "<" + arrSignData[i].key + ">" + jsonStr + "</" + arrSignData[i].key + ">" + sCrLf
//             } else {
//                 sText += "<" + arrSignData[i].key + ">" + arrSignData[i].value + "</" + arrSignData[i].key + ">" + sCrLf
//             }
//         }
//         sText += "</SavePermitForm_IN>$sCrLf"
//         return sText
//     }

//     /// 생성된 XML을 암호화 처리
//     @Throws(KSException::class, UnsupportedEncodingException::class)
//     fun getConvertSignData(sSignedXml: String, authCert: AuthCert): String? {
//         return try {
//             val certificate: KSCertificate = authCert.downloadCert.ksCert as KSCertificate
//             val xmlSignByteArray : ByteArray = sSignedXml.toByteArray(charset("euc-kr"))
//             val signResult = KSSign.koscomSign(
//                 certificate,
//                 xmlSignByteArray,
//                 authCert.certPw!!
//             )
//             val encodedSignResult = KSBase64.encode(signResult)
//             String(encodedSignResult)
//         } catch (e: Exception) {
//             Log.e("getConvertSignData", e.message)
//             null
//         }
//     }

//     /**
//      * 사인데이터 유효성 체크 함수(SOAP)
//      */
//     fun verifySignData(convertData : String, authCert: AuthCert) : Boolean {
//         val iCertClient = authCert.downloadCert.iCertClient as iCertClient
//         return iCertClient.VerifySignData(convertData).equals("T")
//     }

//     /**
//      * 사인데이터 유효성 체크 함수(REST)
//      */
//     fun verifications(convertData: String, appCertRESTServiceUrl: String): VerifyCert {
//         val mediaType = "application/json; charset=utf-8".toMediaTypeOrNull()
//         val client = OkHttpClient()

//         val postData = Gson().toJson(convertData, String::class.java)
//         val requestBody = postData.toRequestBody(mediaType)
//         val request = Request.Builder()
//             .url(appCertRESTServiceUrl)
//             .addHeader("Accept", "application/json")
//             .addHeader("Content-Type", "application/json; charset=utf-8")
//             .post(requestBody)
//             .build()

//         client.newCall(request).execute().use { response ->
//             val responseData: String = response.body?.string() ?: ""
//             Log.e("result : ", "${response.isSuccessful} ${response.code} $responseData")
//             return VerifyCert(
//                 response.isSuccessful,
//                 response.code,
//                 responseData
//             )
//         }
//     }
// }