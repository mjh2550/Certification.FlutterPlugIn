import 'dart:ffi';

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
  final String _downloadUrl =
      'http://172.17.14.41/CERTWebservice/HIS.Cert.WebService.asmx';
  final String _verifyUrl =
      'http://172.17.14.41/Cert/CertRESTfulService.svc/verifications';
  final String _userId = 'CCC0EMR';
  final String _password = '88888888';
  final String _plainText = '<TestSignTest></TestSignTest>';
  int _initResult = -1;
  bool _isValidPassword = false;
  String _cipherText = '';
  final TextEditingController _userIdTextController = TextEditingController();
  final TextEditingController _userPwTextController = TextEditingController();
  final TextEditingController _plainTextController = TextEditingController();
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  final _certificationPlugin = Certification();

  @override
  void initState() {
    super.initState();
    _userIdTextController.text = _userId;
    _userPwTextController.text = _password;
    _plainTextController.text = _plainText;
    initCertificate();
  }

  Future<void> initCertificate() async {
    int? libInitializeResult;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      await requestPermission(Permission.storage);
      await requestPermission(Permission.manageExternalStorage);
      libInitializeResult =
          await _certificationPlugin.initialize(_downloadUrl, _verifyUrl);
    } on PlatformException {
      libInitializeResult = -1;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _initResult = libInitializeResult ?? -1;
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
            Text(
                'initialize result : $_initResult, ${LibInitResult.systemNativeInitSuccess.equalTo(_initResult)}'),
            TextField(
              controller: _userIdTextController,
              decoration: const InputDecoration(
                hintText: 'Enter UserId',
              ),
            ),
            TextField(
              controller: _userPwTextController,
              decoration: const InputDecoration(
                hintText: 'Enter CertPw',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool result;

                try {
                  result = await _certificationPlugin.certAuth(
                          _userIdTextController.text,
                          _userPwTextController.text) ??
                      false;
                } on PlatformException {
                  result = false;
                }

                setState(() {
                  _isValidPassword = result;
                });
              },
              child: const Text('Check Password'),
            ),
            Text('certAuth: $_isValidPassword'),
            TextField(
              controller: _plainTextController,
              decoration: const InputDecoration(
                hintText: 'Enter PlainText',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String result;

                try {
                  result = await _certificationPlugin.encrypt(
                          _userIdTextController.text,
                          _userPwTextController.text,
                          _plainTextController.text) ??
                      'ERROR';
                } on PlatformException {
                  result = 'ERROR';
                }

                setState(() {
                  _cipherText = result;
                });
              },
              child: const Text('Encrypt'),
            ),
            Text('Cipher Text: $_cipherText'),
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
}
