import 'package:flutter_test/flutter_test.dart';
import 'package:certification/certification.dart';
import 'package:certification/certification_platform_interface.dart';
import 'package:certification/certification_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCertificationPlatform
    with MockPlatformInterfaceMixin
    implements CertificationPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getCertification(String userId) => Future.value('CCC0EMR');

  @override
  Future<List<Object?>?> getUserCertificateListWithGpki() {
    // TODO: implement getUserCertificateListWithGpki
    throw UnimplementedError();
  }

  @override
  Future<int?> libInitialize() => Future.value(3701);

  @override
  Future<bool?> setServiceUrl(String url) => Future.value(true);
  
  @override
  Future<int> checkPwd(String keyFilePath, String certPw) {
    // TODO: implement checkPwd
    throw UnimplementedError();
  }
  
  @override
  Future<int> deleteCert(String keyFilePath) {
    // TODO: implement deleteCert
    throw UnimplementedError();
  }
  
  @override
  Future<String> encryptCert(String xmlString, String certPw) {
    // TODO: implement encryptCert
    throw UnimplementedError();
  }
  
  @override
  Future<String> getCertFilePath(String certDn) {
    // TODO: implement getCertFilePath
    throw UnimplementedError();
  }
  
  @override
  Future<String> getCertKeyFilePath(String certDn) {
    // TODO: implement getCertKeyFilePath
    throw UnimplementedError();
  }
  
  @override
  Future<String> verifySignData(String sign) {
    // TODO: implement verifySignData
    throw UnimplementedError();
  }
}

void main() {
  final CertificationPlatform initialPlatform = CertificationPlatform.instance;

  test('$MethodChannelCertification is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCertification>());
  });

  test('getPlatformVersion', () async {
    Certification certificationPlugin = Certification();
    MockCertificationPlatform fakePlatform = MockCertificationPlatform();
    CertificationPlatform.instance = fakePlatform;

    expect(await certificationPlugin.getPlatformVersion(), '42');
  });

  test('libInitialize', () async {
    Certification certificationPlugin = Certification();
    MockCertificationPlatform fakePlatform = MockCertificationPlatform();
    CertificationPlatform.instance = fakePlatform;

    expect(await certificationPlugin.libInitialize(), 3701);
  });
}
