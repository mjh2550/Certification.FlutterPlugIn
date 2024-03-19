// package com.ezcaretech.certification.verify
// import android.content.Context
// import android.content.pm.PackageManager
// import android.content.pm.PackageInfo
// import android.content.pm.Signature
// import android.util.Base64
// import java.math.BigInteger
// import java.security.MessageDigest
// import java.security.NoSuchAlgorithmException

// class ApkSignatureVerifier {
//     companion object {
//         /**
//          * Get the SHA-256 signature of the APK.
//          * @param context - The application context.
//          * @return - The SHA-256 signature of the APK as a colon-separated string.
//          * @throws PackageManager.NameNotFoundException
//          * @throws NoSuchAlgorithmException
//          */
//         @Throws(PackageManager.NameNotFoundException::class, NoSuchAlgorithmException::class)
//         fun getApkSignatureSHA256(context: Context): String {
//             // Get the package info for the given application
//             val packageInfo: PackageInfo = context.packageManager.getPackageInfo(context.packageName, PackageManager.GET_SIGNATURES)

//             // Get the signature
//             val signatures: Array<Signature> = packageInfo.signatures
//             val cert: ByteArray = signatures[0].toByteArray()

//             // Compute the SHA-256 hash of the signature
//             val md: MessageDigest = MessageDigest.getInstance("SHA-256")
//             val publicKey: ByteArray = md.digest(cert)

//             // Convert the SHA-256 hash to a colon-separated string
//             val key: String = String.format("%0${publicKey.size * 2}X", BigInteger(1, publicKey)).replace(Regex(".."), "$0:")
//             return key.substring(0, key.length - 1)
//         }

//         /**
//          * Verify that the APK is signed with the given SHA1 signature
//          * @param context - The application context
//          * @param sha1Signature - The SHA1 signature to verify
//          * @return - True if the APK is signed with the given SHA1 signature, false otherwise
//          */
//         fun verifyApkSignature(context: Context, sha1Signature: String): Boolean {
//             return try {
//                 // Get the SHA1 signature of the APK
//                 val apkSignature = getApkSignatureSHA256(context)

//                 // Convert the signature to a Base64-encoded string
//                 val base64RunningSignature = Base64.encodeToString(apkSignature.toByteArray(Charsets.UTF_8), Base64.NO_WRAP)

//                 // Convert the signature to a Base64-encoded string
//                 val base64InputSignature = Base64.encodeToString(sha1Signature.toByteArray(Charsets.UTF_8), Base64.NO_WRAP)

//                 // Compare the signatures
//                 base64RunningSignature == base64InputSignature
//             } catch (e: PackageManager.NameNotFoundException) {
//                 e.printStackTrace()
//                 false
//             } catch (e: NoSuchAlgorithmException) {
//                 e.printStackTrace()
//                 false
//             }
//         }
//     }
// }
