import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';
import 'package:vseschedule_03/src/resources/http/insis_client.dart';


class InsisClientProvider {

  final _log = Logger("InsisClientProvider");
  InsisClient _client;

  // private static instance
  static final InsisClientProvider _instance = InsisClientProvider._singletonContructor();

  // private static constructor
  InsisClientProvider._singletonContructor() {
    _client = InsisClient.getInstance();
  }

  // instance accesor
  static InsisClientProvider getInstance() {
    return _instance;
  }


  Future<List<ScheduleEvent>> getSchedule(String usr, String pwd) async {
    await _client.login(usr, pwd);
    List<ScheduleEvent> res = await _client.getSchedule();
    return res;
  }

}