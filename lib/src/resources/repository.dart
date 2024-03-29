import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/resources/http/insis_client_provider.dart';

import '../models/schedule_event.dart';
import 'credentials/credential_provider.dart';
import 'db/db_provider.dart';

class Repository {

  final _log = Logger("Repository");

  DBProvider _dbProvider;
  InsisClientProvider _apiProvider;
  CredentialProvider _credentialProvider;
  String _usr;
  String _pwd;


  // private static instance
  static final Repository _instance = new Repository._singletonConstructor();

  // private constructor
  Repository._singletonConstructor() {
    _dbProvider = DBProvider.getInstance();
    _apiProvider = InsisClientProvider.getInstance();
    _credentialProvider = CredentialProvider.getInstance();
    _log.info("Repository initialized.");
  }

  // instance accesor
  static Repository getInstance() {
    return _instance;
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

  Future<List<ScheduleEvent>> getEventsOnWeekday(int weekday) {
    return _dbProvider.getEventsOnWeekday(weekday);
  }


  /* Database */
  updateScheduleEvent(ScheduleEvent event) {
    // TODO
  }

  _saveScheduleToDB(List<ScheduleEvent> wholeSchedule) {
    wholeSchedule.forEach((event) {
      _dbProvider.insertEvent(event);
    });
    _log.info("Schedule saved.");
  }


  /* Credentials: */
  saveCredentials() {
    _log.info("Credentials saved: [" + _usr + ", " + _pwd + "]");
    if (_usr == null || _pwd == null) {
      throw Exception("Credentials were not set.");
    }
    _credentialProvider.saveCredentials(_usr, _pwd);
  }

  setCredentials(String usr, String pwd) {
    _log.info("Credentials set: [" + usr + ", " + pwd + "]");
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