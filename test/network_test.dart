import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';




void main() {

  ScheduleEvent parseSchedule(Element el) {
    String day = el.nodes[0].nodes[0].nodes[0].text;
    String from = el.nodes[1].nodes[0].nodes[0].text;
    String until = el.nodes[2].nodes[0].nodes[0].text;
    String course = el.nodes[3].nodes[0].nodes[0].nodes[0].text;
    String entry = el.nodes[4].nodes[0].nodes[0].text;
    String room = el.nodes[5].nodes[0].nodes[0].nodes[0].text;
    String teacher = el.nodes[6].nodes[0].nodes[0].nodes[0].nodes[0].text;
    return ScheduleEvent.fromStrings(day, from, until, course, entry, room, teacher);
  }

  test('NetworkService test', () async {
    String INSIS_ROOT = "https://insis.vse.cz";
    Map<String, String> loginHeaders = {
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
      "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) snap Chromium/80.0.3987.132 Chrome/80.0.3987.132 Safari/537.36"
    };
    Map<String, String> body = {
      "login_hidden": "1",
      "destination": "/auth/",
      "auth_id_hidden": "0",
      "auth_2fa_type": "no",
      "credential_0": "kuzv06",
      "credential_1": "3BigElephants",
      "credential_k": "",
      "credential_2": "86400"
    };
    Response result = await post(INSIS_ROOT + "/auth/", headers: loginHeaders, body: body);
    print(result.statusCode);

    String uisAuth = result.headers["set-cookie"].split(';')[0];

    Map<String, String> scheduleHeaders = {
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en;q=0.9,en-US;q=0.8,cs-CZ;q=0.7",
      "Cache-Control": "max-age=0",
      "Connection": "keep-alive",
      "Content-Type": "application/x-www-form-urlencoded",
      "Cookie" : uisAuth,
      "Host": "insis.vse.cz",
      "Origin": "https://insis.vse.cz",
      "Referer": "https://insis.vse.cz/auth/katalog/rozvrhy_view.pl",
      "Sec-Fetch-Dest": "document",
      "Sec-Fetch-Mode": "navigate",
      "Sec-Fetch-Site": "same-origin",
      "Sec-Fetch-User": "?1",
      "Upgrade-Insecure-Requests": "1",
      "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) snap Chromium/80.0.3987.132 Chrome/80.0.3987.132 Safari/537.36"
    };

    result = await get("https://insis.vse.cz/auth/katalog/rozvrhy_view.pl?osobni=1&z=1&k=1&f=0&studijni_zpet=0&rozvrh=2935&rozvrh=2934&rozvrh=2875&format=list&zobraz=Zobrazit",
        headers: scheduleHeaders);
    Document dom = parse(result.body);
    List<Element> scheduleElement = dom.querySelectorAll('#tmtab_1 > tbody > tr');
    List<ScheduleEvent> schedule = [];
    scheduleElement.forEach((el) => {
      schedule.add(parseSchedule(el))
    });

    print(schedule);
    print("done");

  });

  test('exception?', () async {
    Response res = await get("https://insis.vse.cz/auth");
    print(res.statusCode);

  });

}