import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

class CredentialProvider {

  final _log = Logger("CredentialProvider");
  FlutterSecureStorage _storage;
  static final String _USR = "usr";
  static final String _PWD = "pwd";

  String _usr;
  String _pwd;

  // private static instance
  static final CredentialProvider _instance =
      CredentialProvider._singletonConstructor();

  // private constructor
  CredentialProvider._singletonConstructor() {
    _storage = new FlutterSecureStorage();
  }

  // instance accesor
  static CredentialProvider getInstance() {
    return _instance;
  }

  void setUsr(String usr) {
    this._usr = usr;
  }

  void setPwd(String pwd) {
    this._pwd = pwd;
  }

  void encodeCredentials(String key) async {
    await _storage.write(
        key: _USR, value: _usr); // xname/username is not encrypted
    await _storage.write(key: key, value: _pwd);
  }

  Future<bool> canDecodeCredentials(String key) async {
    String user = await _storage.read(key: _USR);
    String password = await _storage.read(key: key);
    if (password != null) {
      _usr = user;
      _pwd = password;
      return true;
    } else {
      return false;
    }
  }

  setDecodedCredentials(String key) async {
    _usr = await _storage.read(key: _USR);
    _pwd = await _storage.read(key: key);
  }

  String getPwd() {
    return _pwd;
  }

  String getUsr() {
    return _usr;
  }

  void deleteAll() async {
    await _storage.deleteAll();
  }
}