import 'certification_platform_interface.dart';

class Certification {
  Future<String?> getPlatformVersion() {
    return CertificationPlatform.instance.getPlatformVersion();
  }

  Future<int?> libInitialize() {
    return CertificationPlatform.instance.libInitialize();
  }

  Future<bool?> setServiceUrl(String url) async {
    return CertificationPlatform.instance.setServiceUrl(url);
  }

  Future<String?> getCertification(String userId) async {
    return CertificationPlatform.instance.getCertification(userId);
  }

  Future<List<Object?>?> getUserCertificateListWithGpki() async {
    return CertificationPlatform.instance.getUserCertificateListWithGpki();
  }

  ///인증서 비밀번호 검증
  Future<int> checkPwd(String pw) async {
    return CertificationPlatform.instance.checkPwd(pw);
  }

  ///인증서 데이터 검증(SOAP)(Deprecated)
  Future<String> verifySignData(String sign) async {
    return CertificationPlatform.instance.verifySignData(sign);
  }

  ///인증서 데이터 암호화
  Future<String> encryptCert(String xmlString, String certPw) async {
    return CertificationPlatform.instance.encryptCert(xmlString, certPw);
  }

  ///인증서 데이터 삭제
  Future<int> deleteCert() async {
    return CertificationPlatform.instance.deleteCert();
  }

  ///XML 인증서 데이터 생성
  Future<String> createCert() async {
    ///TODO: createCert
    return "<TestSignTest></TestSignTest>";
  }

  ///인증서 데이터 검증(REST)
  Future<String> verifications() async {
    ///TODO: verifications
    return "1";
  }
}
