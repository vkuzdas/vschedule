//import 'package:logger/logger.dart';
//
//import 'dart:convert';
//
//import '../../models/schedule_event.dart';
//import 'insis_browser.dart';
//import '../../logging/logger.dart';
//
//class InsisBrowserProvider {
//  static final InsisBrowserProvider _instance = InsisBrowserProvider._internal();
//  Logger _logger = getLogger("ApiEventProvider");
//  String _usr;
//  String _pwd;
//  InsisBrowser _crawler;
//
//  factory InsisBrowserProvider() {
//    _instance._init();
//    return _instance;
//  }
//
//  InsisBrowserProvider._internal();
//
//  void _init() async {
//    InsisBrowser crawler = InsisBrowser();
//    await crawler.init();
//  }
//
//
//  Future<List<ScheduleEvent>> getSchedule(String usr, String pwd) async {
//    await _crawler.login(_usr, _pwd);
//    final parsedJsonList = await _crawler.getJsonSchedule();
//    await _crawler.logout();
//    await _crawler.disposeBrowser();
//
//    List<ScheduleEvent> schedule = [];
//    parsedJsonList.forEach((json) {
//      final parsedJson = jsonDecode(json);
//      ScheduleEvent event = ScheduleEvent.fromJson(parsedJson);
//      schedule.add(event);
//    });
//
//    return schedule;
//  }
//}