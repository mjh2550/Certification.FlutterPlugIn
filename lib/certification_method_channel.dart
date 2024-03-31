import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'certification_platform_interface.dart';

/// An implementation of [CertificationPlatform] that uses method channels.
class MethodChannelCertification extends CertificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('certification');

  @override
  Future<int?> initialize(String downloadUrl, String verifyUrl) async {
    return await methodChannel.invokeMethod<int>(
        'initialize', {"downloadUrl": downloadUrl, "verifyUrl": verifyUrl});
  }

  @override
  Future<bool?> certAuth(String userId, String password) async {
    return await methodChannel.invokeMethod<bool>(
        'certAuth', {"userId": userId, "password": password});
  }

  @override
  Future<String?> encrypt(
      String userId, String password, String plainText) async {
    return await methodChannel.invokeMethod<String>('encrypt',
        {"userId": userId, "password": password, "plainText": plainText});
  }
}
