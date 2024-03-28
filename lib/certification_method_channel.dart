import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'certification_platform_interface.dart';

/// An implementation of [CertificationPlatform] that uses method channels.
class MethodChannelCertification extends CertificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('certification');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> libInitialize() async {
    return await methodChannel.invokeMethod<int>('libInitialize');
  }

  @override
  Future<bool?> setServiceUrl(String url) async {
    return await methodChannel
        .invokeMethod<bool>('setServiceUrl', {"url": url});
  }

  @override
  Future<String?> getCertification(String userId) async {
    return await methodChannel
        .invokeMethod('getCertification', {"userId": userId});
  }

  @override
  Future<List<dynamic>?> getUserCertificateListWithGpki() async {
    return await methodChannel.invokeMethod('getUserCertificateListWithGpki');
  }

  ///인증서 비밀번호 검증  
  @override
  Future<int> checkPwd(String keyFilePath, String certPw) async {
    return await methodChannel.invokeMethod('checkPwd', {"keyFilePath" : keyFilePath,"certPw": certPw});
  }

  ///인증서 데이터 검증(SOAP)(Deprecated)
  @override
  Future<String> verifySignData(String sign) async {
    return await methodChannel.invokeMethod('verifySignData', {"sign": sign});
  }

  ///인증서 데이터 암호화
  @override
  Future<String> encryptCert(String xmlString, String iCertDn, String certPw) async {
    return await methodChannel.invokeMethod(
        'encryptCert', {"xmlString": xmlString, "iCertDn" : iCertDn ,"certPw": certPw});
  }

  ///인증서 데이터 삭제   
  @override
  Future<int> deleteCert(String keyFilePath) async {
    return await methodChannel.invokeMethod('deleteCert', {"keyFilePath": keyFilePath});
  }

  ///인증서 파일 경로
  @override
  Future<String> getCertFilePath(String certDn) async {
    return await methodChannel.invokeMethod('getCertFilePath', {"certDn" : certDn});
  }

  ///인증서 개인 키 경로
  @override
  Future<String> getCertKeyFilePath(String certDn) async {
    return await methodChannel.invokeMethod('getPrivateKeyFilePath',  {"certDn" : certDn});
  }

  ///XML 인증서 데이터 생성
  // @override
  // Future<void> createCert() async {
  //   ///TODO: createCert

  // }

  // ///인증서 데이터 검증(REST)
  // @override
  // Future<void> verifications() async {
  //   ///TODO: verifications

  // }
}
