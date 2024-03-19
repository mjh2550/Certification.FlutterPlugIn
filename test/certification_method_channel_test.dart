import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:certification/certification_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCertification platform = MethodChannelCertification();
  const MethodChannel channel = MethodChannel('certification');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'getPlatformVersion') {
          return '42';
        } else if (methodCall.method == 'libInitialize') {
          return 0;
        } else {
          return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('libInitialize', () async {
    expect(await platform.libInitialize(), 0);
  });
}
