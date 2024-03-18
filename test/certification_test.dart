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
}
