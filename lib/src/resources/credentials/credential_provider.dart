import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class CredentialProvider {

  final _log = Logger("CredentialProvider");
  FlutterSecureStorage _storage;
  final String _USR = "usr";
  final String _PWD = "pwd";


  // private static instance
  static final CredentialProvider _instance = CredentialProvider._singletonConstructor();

  // private constructor
  CredentialProvider._singletonConstructor(){
    _storage = new FlutterSecureStorage();
  }

  // instance accesor
  static CredentialProvider getInstance() {
    return _instance;
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

  void deleteAll() async {
    await _storage.deleteAll();
  }
}