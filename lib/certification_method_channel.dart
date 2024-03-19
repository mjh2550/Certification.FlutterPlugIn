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
  Future<List<Object?>?> getUserCertificateListWithGpki() async {
    return await methodChannel.invokeMethod('getUserCertificateListWithGpki');
  }
}
