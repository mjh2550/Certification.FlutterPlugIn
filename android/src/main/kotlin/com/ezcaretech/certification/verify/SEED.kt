// package com.ezcaretech.certification.verify

// import org.bouncycastle.crypto.engines.SEEDEngine
// import org.bouncycastle.crypto.modes.CBCBlockCipher
// import org.bouncycastle.crypto.paddings.PKCS7Padding
// import org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher
// import org.bouncycastle.crypto.params.KeyParameter
// import org.bouncycastle.crypto.params.ParametersWithIV
// import org.bouncycastle.util.encoders.Base64

// class SEED {
//     fun encryptString(data: String, key: ByteArray, iv: ByteArray): String {
//         val engine = SEEDEngine()
//         val blockCipher = CBCBlockCipher(engine)
//         val padded = PKCS7Padding()
//         val cipher = PaddedBufferedBlockCipher(blockCipher, padded)
//         val keyParam = KeyParameter(key)
//         val ivAndKey = ParametersWithIV(keyParam, iv)
//         cipher.init(true, ivAndKey)

//         val input = data.toByteArray(Charsets.UTF_8)
//         val output = ByteArray(cipher.getOutputSize(input.size))
//         val len = cipher.processBytes(input, 0, input.size, output, 0)
//         cipher.doFinal(output, len)

//         return Base64.toBase64String(output)
//     }

//     fun decryptString(encryptedData: String, key: ByteArray, iv: ByteArray): String {
//         val engine = SEEDEngine()
//         val blockCipher = CBCBlockCipher(engine)
//         val padded = PKCS7Padding()
//         val cipher = PaddedBufferedBlockCipher(blockCipher, padded)
//         val keyParam = KeyParameter(key)
//         val ivAndKey = ParametersWithIV(keyParam, iv)
//         cipher.init(false, ivAndKey)

//         val input = Base64.decode(encryptedData)
//         val output = ByteArray(cipher.getOutputSize(input.size))
//         val len = cipher.processBytes(input, 0, input.size, output, 0)
//         cipher.doFinal(output, len)

//         return String(output, Charsets.UTF_8)
//     }
// }