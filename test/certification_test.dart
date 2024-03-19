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
  Future<int?> libInitialize() => 3701;

  @override
  Future<bool?> setServiceUrl(String url) => Future.value(true);
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

    expect(await certificationPlugin.libInitialize(), 0);
  });
}
