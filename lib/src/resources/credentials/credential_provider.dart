
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class CredentialProvider {
  static final CredentialProvider _instance = CredentialProvider._internal();

  final _log = Logger("CredentialProvider");
  FlutterSecureStorage _storage;
  final String _USR = "usr";
  final String _PWD = "pwd";


  factory CredentialProvider() {
    _instance._init();
    return _instance;
  }

  CredentialProvider._internal();


  void _init() {
    _storage = new FlutterSecureStorage();
  }

  void saveCredentials(String usr, String pwd) async {
    await _storage.write(key: _USR, value: usr);
    await _storage.write(key: _PWD, value: pwd);
  }

  Future<String> getPwd() async {
    return await _storage.read(key: _PWD);
  }

  Future<String> getUsr() async {
    return await _storage.read(key: _USR);
  }

  void ommit() async {
    await _storage.deleteAll();
  }
}