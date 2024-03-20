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
}
