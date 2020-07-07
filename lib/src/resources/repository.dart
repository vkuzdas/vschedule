import 'package:logger/logger.dart';
import 'package:vseschedule_03/src/resources/http/insis_client_provider.dart';

import '../logging/logger.dart';
import '../models/schedule_event.dart';
import 'credentials/credential_provider.dart';
import 'db/db_event_provider.dart';

class Repository {

  static final Repository _instance = Repository._internal();

  Logger _logger = getLogger("Repository");
  DBEventProvider _dbProvider;
  InsisClientProvider _apiProvider;
  CredentialProvider _credentialProvider;
  String _usr;
  String _pwd;

  factory Repository() {
    _instance._init();
    return _instance;
  }

  Repository._internal();

  void _init() {
    _dbProvider = DBEventProvider();
    _apiProvider = InsisClientProvider();
    _credentialProvider = CredentialProvider();
    _logger.i("Repository initialized.");
  }


  /* Resource management: */
//  Future<List<ScheduleEvent>> getDaySchedule(String day) async {
//    List<ScheduleEvent> todaySchedule = await _dbProvider.getEventsByDay(day);
//    if (todaySchedule.length == 0) { // empty db
//      _readCredentials();
//      List<ScheduleEvent> wholeSchedule = await _apiProvider.getSchedule(_usr, _pwd);
//      if (wholeSchedule == null) {
//        throw Exception("ApiProvider failed.");
//      } else {
//        _saveScheduleToDB(wholeSchedule);
//        todaySchedule = await _dbProvider.getEventsByDay(day);
//      }
//    }
//    return todaySchedule;
//  }


  /* Database */
  updateScheduleEvent(ScheduleEvent event) {
    // TODO
  }

  _saveScheduleToDB(List<ScheduleEvent> wholeSchedule) {
    wholeSchedule.forEach((event) {
      _dbProvider.saveEvent(event);
    });
    _logger.i("Schedule saved.");
  }


  /* Credentials: */
  saveCredentials() {
    _logger.i("Credentials saved: [" + _usr + ", " + _pwd + "]");
    if (_usr == null || _pwd == null) {
      throw Exception("Credentials were not set.");
    }
    _credentialProvider.saveCredentials(_usr, _pwd);
  }

  setCredentials(String usr, String pwd) {
    _logger.i("Credentials set: [" + usr + ", " + pwd + "]");
    this._usr = usr;
    this._pwd = pwd;
  }

  _readCredentials() async {
    final String usr = await _credentialProvider.getUsr();
    final String pwd = await _credentialProvider.getPwd();
    if (usr == null || pwd == null) {
      throw Exception("CredentialProvider is empty.");
    }
    _usr = usr;
    _pwd = pwd;
  }

  bool isEmpty() {
    return true;
  }
}