import 'certification_platform_interface.dart';

class Certification {
  /// 초기화
  Future<int?> initialize(String downloadUrl, String verifyUrl) {
    return CertificationPlatform.instance.initialize(downloadUrl, verifyUrl);
  }

  /// 인증서 비밀번호 검증
  Future<bool?> certAuth(String userId, String password) {
    return CertificationPlatform.instance.certAuth(userId, password);
  }

  /// 암호화
  Future<String?> encrypt(String userId, String password, String plainText) {
    return CertificationPlatform.instance.encrypt(userId, password, plainText);
  }
}
