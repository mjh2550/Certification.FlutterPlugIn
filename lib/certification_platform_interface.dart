import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'certification_method_channel.dart';

abstract class CertificationPlatform extends PlatformInterface {
  /// Constructs a CertificationPlatform.
  CertificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static CertificationPlatform _instance = MethodChannelCertification();

  /// The default instance of [CertificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelCertification].
  static CertificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CertificationPlatform] when
  /// they register themselves.
  static set instance(CertificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> libInitialize() {
    throw UnimplementedError('libInitialize() has not been implemented.');
  }

  Future<bool?> setServiceUrl(String url) {
    throw UnimplementedError('setServiceUrl() has not been implemented.');
  }

  Future<String?> getCertification(String userId) {
    throw UnimplementedError('getCertification() has not been implemented.');
  }

  Future<List<Object?>?> getUserCertificateListWithGpki() {
    throw UnimplementedError('getUserCertificateListWithGpki() has not been implemented.');
  }
}
