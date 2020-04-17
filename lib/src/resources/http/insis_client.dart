import 'package:vseschedule_03/src/logging/logger.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';

class InsisClient {


  static final InsisClient _instance = InsisClient._internal();
  final _logger = getLogger("InsisClient");

  String _INSIS_ROOT = "https://insis.vse.cz";
  String _SCHEDULE_URI = "/auth/katalog/rozvrhy_view.pl?osobni=1&z=1&k=1&f=0&studijni_zpet=0&rozvrh=2935&rozvrh=2934&rozvrh=2875&format=list&zobraz=Zobrazit";

  Map<String, String> _headers;
  Map<String, String> _body;


  factory InsisClient() {
    _instance._init();
    return _instance;
  }

  InsisClient._internal();

  
  _init() {
    _headers = {
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en;q=0.9,en-US;q=0.8,cs-CZ;q=0.7",
      "Connection": "keep-alive",
      "Host": "insis.vse.cz",
      "Sec-Fetch-Dest": "document",
      "Sec-Fetch-Mode": "navigate",
      "Sec-Fetch-Site": "none",
      "Sec-Fetch-User": "?1",
      "Upgrade-Insecure-Requests": "1",
      "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) snap Chromium/80.0.3987.132 Chrome/80.0.3987.132 Safari/537.36",
      "Origin": "https://insis.vse.cz",
      "Referer": "https://insis.vse.cz/auth/katalog/rozvrhy_view.pl"
    };
    _body = {
      "login_hidden": "1",
      "destination": "/auth/",
      "auth_id_hidden": "0",
      "auth_2fa_type": "no",
      "credential_k": "",
      "credential_2": "86400"
    };
  }

  void login(String user, String password) async {
    _body.addAll({"credential_0": user, "credential_1": password});
    Response res = await post(_INSIS_ROOT + "/auth/", headers: _headers, body: _body);

    //SocketException or 403
    if(res.statusCode == 403) {
      throw ClientException("Server responded with " + res.statusCode.toString() + ": " + res.reasonPhrase + ". Try entering valid credentials.");
    }

    _logger.i(res.reasonPhrase + " " + res.statusCode.toString());
    String uisAuth = res.headers["set-cookie"].split(';')[0];

    _headers.addAll({"Cookie": uisAuth});
  }

  Future<List<ScheduleEvent>> getSchedule() async {
    Response res = await get(_INSIS_ROOT + _SCHEDULE_URI, headers: _headers);

    _logger.i(res.reasonPhrase + " " + res.statusCode.toString());

    Document dom = parse(res.body);
    List<Element> scheduleElement = dom.querySelectorAll('#tmtab_1 > tbody > tr');
    List<ScheduleEvent> schedule = [];
    scheduleElement.forEach((el) => {
      schedule.add(_parseSchedule(el))
    });

    return schedule;
  }

  logout() async{

  }


  ScheduleEvent _parseSchedule(Element el) {
    String day = el.nodes[0].nodes[0].nodes[0].text;
    String from = el.nodes[1].nodes[0].nodes[0].text;
    String until = el.nodes[2].nodes[0].nodes[0].text;
    String course = el.nodes[3].nodes[0].nodes[0].nodes[0].text;
    String entry = el.nodes[4].nodes[0].nodes[0].text;
    String room = el.nodes[5].nodes[0].nodes[0].nodes[0].text;
    String teacher = el.nodes[6].nodes[0].nodes[0].nodes[0].nodes[0].text;
    return ScheduleEvent.fromStrings(day, from, until, course, entry, room, teacher, "1", "0");
  }
}