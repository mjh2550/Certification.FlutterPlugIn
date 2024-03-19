// package com.ezcaretech.certification.cert

// // import com.ezcaretech.ezconsentdomain.model.certification.AuthCert
// // import com.ezcaretech.ezconsentdomain.model.certification.DownloadCert
// // import com.ezcaretech.ezconsentdomain.model.certification.ICert
// import com.isolutec.icertmanager.iCertClient
// import com.lumensoft.ks.KSCertificate
// import com.lumensoft.ks.KSCertificateManager
// import java.util.*

// class ICertClientManager(private val appCertServiceUrl: String,
//                          private var iCertClient: iCertClient = iCertClient()
// ) {

//     companion object {

//         private var instance : ICertClientManager? = null

//         fun getInstance(appCertServiceUrl : String) : ICertClientManager {
//             return instance ?: synchronized(this) {
//                 instance ?: ICertClientManager(appCertServiceUrl).also {
//                     instance = it
//                 }
//             }
//         }
//     }

//     init {
//         iCertClient.SetServiceUrl(appCertServiceUrl)
//     }

//     fun getICertClient() : Any? = iCertClient
//     fun getCertResponse(userId: String, iCertClient: Any?) : String? {
//         val ictClient = iCertClient as iCertClient
//         return ictClient.GetCertification(userId)
//     }
//     fun getICert(certResponse : String?, certList: Vector<*>) : ICert {
//         return ICert(certResponse, certList)
//     }
//     fun getKsCert(iCert: ICert) : KSCertificate? {
//         for (i in iCert.certList?.indices!!) {
//             val ksCert = iCert.certList!![i] as KSCertificate?
//             if (ksCert?.subjectDn == iCert.strDN) return ksCert
//         }
//         return null
//     }

//     fun checkPwd(ksCert: Any?, certPw: String) : Boolean {
//         val cert = ksCert as KSCertificate?
//         return KSCertificateManager.checkPwd(cert, certPw)
//     }

//     /**
//      * 2023.03.03
//      * 인증서 검증 및 인증서 정보 반환
//      */
//     fun getAuthCert(certId: String, certPw: String, downloadCert: DownloadCert) : AuthCert {
//         return AuthCert(certId, certPw, downloadCert)
//     }
//     fun sign(password: String, message: String){
//         //TODO SET SIGN
//     }

// }