
import 'package:logger/logger.dart';
import 'package:vseschedule_03/src/logging/logger.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';
import 'package:vseschedule_03/src/resources/http/insis_client.dart';

class InsisClientProvider {

  //TODO does not need to be a Signleton
  static final InsisClientProvider _instance = InsisClientProvider._internal();
  Logger _logger = getLogger("InsisClientProvider");
  InsisClient _client;


  factory InsisClientProvider() {
    _instance._init();
    return _instance;
  }

  InsisClientProvider._internal();

  void _init() async {
    _client = InsisClient();
  }


  Future<List<ScheduleEvent>> getSchedule(String usr, String pwd) async {
    await _client.login(usr, pwd);
    List<ScheduleEvent> res = await _client.getSchedule();
    return res;
  }
}