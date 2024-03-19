package com.ezcaretech.certification.cert

import android.content.Context
import com.lumensoft.ks.KSCertificate
import com.lumensoft.ks.KSCertificateLoader
import com.lumensoft.ks.KSCertificateManager
import com.lumensoft.ks.KSException
import java.util.*

class KSWCertManager {

    companion object{

        private var instance : KSWCertManager? = null
        private var userCerts: Vector<KSCertificate?>? = null
        private var selectedCert: KSCertificate? = null

        fun getInstance() : KSWCertManager {
            return instance ?: synchronized(this) {
                instance ?: KSWCertManager().also {
                    instance = it
                }
            }
        }

//        fun setSelectedCert(selectedCert : KSCertificate?){
//            KSW_CertManager.selectedCert = selectedCert
//        }
    }

    @Throws(KSException::class)
    fun getCertificateList(context: Context?): Vector<KSCertificate?>? {
        return try {
            userCerts = KSCertificateLoader.getUserCertificateListWithGpki(context) as Vector<KSCertificate?>?
            userCerts = KSCertificateLoader.FilterByExpiredTime(userCerts) as Vector<KSCertificate?>?
            userCerts
        } catch (e: KSException) {
            throw KSException(KSException.FAIL_MAKECERTLIST)
        }
    }

    @Throws(KSException::class)
    fun libInitialize() : Int {
        return KSCertificateManager.libInitialize()
    }

    @Throws(KSException::class)
    fun deleteCert(ksCert : Any?) : Int {
        val ksCertificate = ksCert as KSCertificate
        return KSCertificateManager.deleteCert(ksCertificate)
    }

}