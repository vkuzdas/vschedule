import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';

class InsisClient {
  final _log = Logger("InsisClient");

  String _INSIS_ROOT = "https://insis.vse.cz";
  String _SCHEDULE_URI =
      "/auth/katalog/rozvrhy_view.pl?rozvrh_student_obec=1?zobraz=1;format=list;lang=cz";

  Map<String, String> _headers;
  Map<String, String> _body;

  // private static instance
  static final InsisClient _instance = InsisClient._singletonConstructor();

  // private static constructor
  InsisClient._singletonConstructor() {
    _init();
  }

  // instance accesor
  static InsisClient getInstance() {
    return _instance;
  }

  _init() {
    _headers = {
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "cs-CZ;q=0.9,en-US;q=0.8,en;q=0.7",
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

  Future<List<ScheduleEvent>> downloadSchedule(String usr, String pwd) async {
    String uisAuthCookie = await _getAuthCookie(usr, pwd);
    _headers.addAll({"Cookie": uisAuthCookie});
    Future<List<ScheduleEvent>> list = getSchedule();
    return list;
  }

  Future<String> _getAuthCookie(String user, String password) async {
    _body.addAll({"credential_0": user, "credential_1": password});
    Response res =
        await post(_INSIS_ROOT + "/auth/", headers: _headers, body: _body);
    //SocketException or 403
    if (res.statusCode == 403) {
      _log.info(res.reasonPhrase + " " + res.statusCode.toString());
      throw ClientException("Server responded with " +
          res.statusCode.toString() +
          ": " +
          res.reasonPhrase +
          ". Try entering valid credentials.");
    }
    _log.info(res.reasonPhrase + " " + res.statusCode.toString());
    String uisAuth = res.headers["set-cookie"].split(';')[0];
    return uisAuth;
  }

  Future<List<ScheduleEvent>> getSchedule() async {
    Response res = await get(_INSIS_ROOT + _SCHEDULE_URI, headers: _headers);
    _log.info(res.reasonPhrase + " " + res.statusCode.toString());
    Document dom = parse(res.body);
    List<Element> scheduleElement = dom.querySelectorAll('#tmtab_1 > tbody > tr');
    List<ScheduleEvent> schedule = [];
    scheduleElement.forEach((el) => {
      schedule.add(_parseSchedule(el))
    });
    return schedule;
  }

  ScheduleEvent _parseSchedule(Element el) {
    String day,
        from,
        until,
        course,
        entry,
        room,
        teacher = "";
    day = el.nodes[0].nodes[0].text;
    from = el.nodes[1].nodes[0].text;
    until = el.nodes[2].nodes[0].text;
    course = el.nodes[3].nodes[0].text;
    if (course == "Block class " || course == "Bloková akce ") {
      // Block classes dont have entries and rooms -> would result in error
      return ScheduleEvent.fromStrings(
          day,
          from,
          until,
          course,
          "",
          "",
          "");
    }
    entry = el.nodes[4].nodes[0].text;
    room = el.nodes[5].nodes[0].nodes[0].text;
    teacher = el.nodes[6].nodes[0].nodes[0].nodes[0].text;
    return ScheduleEvent.fromStrings(
        day,
        from,
        until,
        course,
        entry,
        room,
        teacher);
  }
}