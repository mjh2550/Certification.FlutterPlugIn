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
  int _delTest = -2;
  int _checkTest = 0;
  int _gpkiTest = 0;
  String _verifyTest = 'N';
  String _encTest = 'N';
  String _createTest = 'N';
  String _filePathTest = 'N';
  String _keyFilePathTest = 'N';
  TextEditingController _textController = TextEditingController();
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
            ElevatedButton(
              onPressed: () => getCertWithGPKI(),
              child: const Text('GPKI TEST'),
            ),
            Text('CertWithGPKI: $_gpkiTest'),
            ElevatedButton(
              onPressed: () => getCertfilePath(_certDn),
              child: const Text('certFilePath TEST'),
            ),
            Text('certFilePath: $_filePathTest'),
            ElevatedButton(
              onPressed: () => getCertPrivateKeyfilePath(_certDn),
              child: const Text('KeyFilePath TEST'),
            ),
            Text('KeyFilePath: $_keyFilePathTest'),
            ElevatedButton(
              onPressed: () => deleteCert(_filePathTest),
              child: const Text('deleteCert Test'),
            ),
            Text('delTest(none:-2, success:0, fail:-1): $_delTest'),
            ElevatedButton(
              onPressed: () =>
                  checkCertPassword(_filePathTest, _textController.text),
              child: const Text('CheckPW Test'),
            ),
            Text('checkTest(success:1, fail:-1): $_checkTest'),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter CertPw',
              ),
            ),
            ElevatedButton(
              onPressed: () => createCert(),
              child: const Text('createXML Test'),
            ),
            Text('createXML: $_createTest'),
            ElevatedButton(
              onPressed: () => verifySignData(),
              child: const Text('verifyTest'),
            ),
            Text('verifyTest: $_verifyTest'),
            ElevatedButton(
              onPressed: () => encryptCert(),
              child: const Text('encrypt Test'),
            ),
            Text('encTest: $_encTest'),
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

  ///GPKI 테스트
  Future<void> getCertWithGPKI() async {
    List<dynamic>? testResult;
    try {
      testResult = await _certificationPlugin.getUserCertificateListWithGpki();
    } on PlatformException {
      testResult = [];
    }

    setState(() {
      _gpkiTest = testResult?.length ?? 0;
    });
  }

  ///인증서 비밀번호 검증
  Future<void> checkCertPassword(String keyFilePath, String certPw) async {
    int testResult;
    try {
      testResult = await _certificationPlugin.checkPwd(keyFilePath, certPw);
    } on PlatformException {
      testResult = -1;
    }

    setState(() {
      _checkTest = testResult;
    });
  }

  ///XML 인증서 데이터 생성
  Future<void> createCert() async {
    String testResult;
    try {
      testResult = await _certificationPlugin.createCert();
    } on PlatformException {
      testResult = 'fail';
    }

    setState(() {
      _createTest = testResult;
    });
  }

  ///인증서 데이터 암호화
  Future<void> encryptCert() async {
    String testResult;
    try {
      testResult = await _certificationPlugin.encryptCert(_createTest, _certDn, _textController.text);
    } on PlatformException {
      testResult = 'fail';
    }

    setState(() {
      _encTest = testResult;
    });
  }

  ///인증서 데이터 검증(SOAP)(Deprecated)
  Future<void> verifySignData() async {
    String testResult;
    try {
      testResult = await _certificationPlugin.verifySignData('tt');
    } on PlatformException {
      testResult = 'fail';
    }

    setState(() {
      _verifyTest = testResult;
    });
  }

  ///인증서 데이터 검증(REST)
  Future<void> verifications() async {
    try {} on PlatformException {}
  }

  ///인증서 데이터 삭제
  Future<void> deleteCert(String keyFilePath) async {
    int testResult;
    try {
      testResult = await _certificationPlugin.deleteCert(keyFilePath);
    } on PlatformException {
      testResult = -1;
    }

    setState(() {
      _delTest = testResult;
      if(testResult == 0) {
        _certDn = "";
        _filePathTest = "";
        _keyFilePathTest = "";
      }
    });
  }

  Future<void> getCertfilePath(String certDn) async {
    String testResult;
    try {
      testResult = await _certificationPlugin.getCertFilePath(certDn);
    } on PlatformException {
      testResult = "notfound";
    }

    setState(() {
      _filePathTest = testResult;
    });
  }

  Future<void> getCertPrivateKeyfilePath(String certDn) async {
    String testResult;
    try {
      testResult = await _certificationPlugin.getCertKeyFilePath(certDn);
    } on PlatformException {
      testResult = "notfound";
    }

    setState(() {
      _keyFilePathTest = testResult;
    });
  }
}
