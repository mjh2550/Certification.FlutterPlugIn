
import 'certification_platform_interface.dart';

class Certification {
  Future<String?> getPlatformVersion() {
    return CertificationPlatform.instance.getPlatformVersion();
  }
}
