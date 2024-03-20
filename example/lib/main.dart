import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:certification/certification.dart';
import 'package:certification/lib_init_result.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  int _libInitializeResult = -1;
  String _certDn = 'Unknown';
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  final _certificationPlugin = Certification();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initCertificate();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _certificationPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() => _platformVersion = platformVersion);
  }

  Future<void> initCertificate() async {
    int? libInitializeResult;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      await requestPermission(Permission.storage);
      await requestPermission(Permission.manageExternalStorage);
      libInitializeResult = await _certificationPlugin.libInitialize();
      await _certificationPlugin.setServiceUrl(
          'http://172.17.14.41/CERTWebservice/HIS.Cert.WebService.asmx');
    } on PlatformException {
      libInitializeResult = -1;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _libInitializeResult = libInitializeResult ?? -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            Center(
              child: Text('Running on: $_platformVersion'),
            ),
            Text(
                'Library initialize result : $_libInitializeResult, ${LibInitResult.systemNativeInitSuccess.equalTo(_libInitializeResult)}'),
            ElevatedButton(
              onPressed: () => downloadCertDn('CCC0EMR'),
              child: const Text('Login to CCC0EMR'),
            ),
            Text('CertDN: $_certDn'),
          ],
        ),
      ),
    );
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      _permissionStatus = status;
    });
  }

  Future<void> downloadCertDn(String staffNo) async {
    String certDn;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      certDn = await _certificationPlugin.getCertification(staffNo) ??
          'Unknown CertDN';
    } on PlatformException {
      certDn = 'Failed to get CertDN.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _certDn = certDn;
    });
  }
}
