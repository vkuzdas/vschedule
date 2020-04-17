//
//// TODO Consider making this a Singleton!
//// TODO Consider lighter solution!
//
//import 'dart:io';
//
//import 'package:logger/logger.dart';
//import 'package:puppeteer/puppeteer.dart';
//
//import '../../logging/logger.dart';
//
///// Crawler for parsing INSIS timetable schedule behind login form
//class InsisBrowser {
//  final _logger = getLogger("InsisCrawler");
//
//  static String _SCHEDULE_JS_QUERY =
//  """
//    trs => trs.map(tr => {
//      var str = '';
//      str = str + '{"day": "' + tr.cells[1].innerText +
//                   '", "from": "' + tr.cells[2].innerText +
//                   '", "until": "' + tr.cells[3].innerText +
//                   '", "course": "' + tr.cells[4].innerText +
//                   '", "entry": "' + tr.cells[5].innerText +
//                   '", "room": "' + tr.cells[6].innerText +
//                   '", "teacher": "' + tr.cells[7].innerText +
//                   '"}'
//      return str;
//    })
//  """;
//
//
//  static String SCHEDULE_URL =
//      "https://insis.vse.cz/auth/katalog/rozvrhy_view.pl";
//
//  Browser _browser;
//  Page _currentPage;
//
//  // Initiate crawler
//  init() async {
//    _browser = await puppeteer.launch();
//    _currentPage = await _browser.newPage();
//    _logger.log(Level.info, "Crawler initialized.");
//  }
//
//  // Log user in
//  login(String user, String password) async {
//    await _currentPage.goto(SCHEDULE_URL, wait: Until.networkIdle);
//    await _currentPage.type("input[name='credential_0']", user);
//    await _currentPage.type("input[name='credential_1']", password);
//    await _currentPage.click("input[type='submit']");
//    await _currentPage.waitForSelector("select[name='format']");
//    _logger.i("Logged in to INSIS.");
//  }
//
//  // Parse timetable/schedule
//  Future<List<dynamic>> getJsonSchedule() async {
//    List<dynamic> schedule;
//    if (_currentPage.url == SCHEDULE_URL) {
//      try {
//        await _currentPage.select("select[name='format']", ["list"]);
//        await _currentPage.click("input[type='submit'");
//        const selector = '#tmtab_1 > tbody > tr';
//        await _currentPage.waitForSelector(selector);
//
//        schedule = await _currentPage.$$eval(selector, _SCHEDULE_JS_QUERY);
//        _logger.i("Schedule scraped.");
//      } catch (exception) {
//        _logger.e("Schedule scrape failed. $exception");
//      }
//    } else {
//      _logger.e("Wrong URL, cannot scrape this!");
//      throw ProcessException;
//    }
//    return schedule;
//  }
//
//  // Log user out
//  logout() async {
//    await _currentPage.goto("https://insis.vse.cz/auth/system/logout.pl",
//        wait: Until.networkIdle);
//    await _currentPage.click("input[type='submit'");
//    _logger.i("Logged out.");
//  }
//
//  // Close the browser
//  disposeBrowser() async {
//    await _browser.close();
//    _logger.i("Browser disposed.");
//  }
//}
