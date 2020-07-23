import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/schedule_event.dart';

//TODO should the connection be closed?... elaborate https://stackoverflow.com/questions/54055106/not-closing-the-database-with-flutters-sqflite
class DBProvider {

  static final DBProvider _instance = DBProvider._internal();

  final _log = Logger("DBEventProvider");
  final String _TABLE = "ScheduleEvents";
  Database _db;

  // dart singleton
  factory DBProvider() {
    _instance._init();
    return _instance;
  }

  DBProvider._internal();


  void _init() async {
//    _logger.log(Level.info,"Initializing db.");
    print("Initializing db.");
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, "schedule_events.db");
    _db = await openDatabase(
        path,
        version: 1,
        onCreate: (newDb, version) {
//          newDb.delete("Test");
//          newDb.delete("$_TABLE");
          newDb.execute("""
            CREATE TABLE $_TABLE(
              day       INTEGER,
              [from]    TEXT,
              until     TEXT,
              course    TEXT,
              entry     TEXT,
              room      TEXT,
              teacher   TEXT
            )
          """);}
    );
    _log.info("New db at " + path);
    List<Map<String, dynamic>> controlQuery = await _db.rawQuery("PRAGMA table_info([$_TABLE])");
    _log.info("Tables:  " + controlQuery.toString());

//    saveEvent(ScheduleEvent.fromStrings("Mon", "09:15", "10:45", "4EK212 Quantitative Management", "Lecture", "NB A", "J. Sekničková"));
//
//    saveEvent(ScheduleEvent.fromStrings("Thu", "09:15", "10:45", "4EK212 Quantitative Management", "Lecture", "NB A", "J. Sekničková"));
//
//    saveEvent(ScheduleEvent.fromStrings("Fri", "09:15", "10:45", "4EK212 Quantitative Management", "Lecture", "NB A", "J. Sekničková"));
//
//    saveEvent(ScheduleEvent.fromStrings("Tue", "07:30", "09:00", "4IT115 Software Engineering", "Lecture", "Vencovského aula", "A. Buchalcevová"));
//    saveEvent(ScheduleEvent.fromStrings("Tue", "09:15", "10:45", "TVSTHA Thai boxing", "Seminar", "CK 0127 (JA)", "T. Vaněk"));
//    saveEvent(ScheduleEvent.fromStrings("Tue", "11:00", "12:30", "4EK212 Quantitative Management", "Seminar", "SB 231", "M. Černý"));
//    saveEvent(ScheduleEvent.fromStrings("Tue", "12:45", "14:15", "3MG216 Fundamentals of Marketing for Students of IT and Statistics", "Seminar", "JM 189 (JM)", "M. Zamazalová"));
//    saveEvent(ScheduleEvent.fromStrings("Tue", "14:30", "16:00", "4IZ210 Information and Knowledge Processing", "Lecture", "NB D", "J. Rauch"));
//
//    saveEvent(ScheduleEvent.fromStrings("Wed", "09:15", "10:45", "4IT218 Database Management Systems", "Seminar", "SB 202", "H. Palovská"));
//    saveEvent(ScheduleEvent.fromStrings("Wed", "09:15", "10:45", "4ST204 Statistics for Informatics", "Seminar", "SB 104", "F. Habarta"));
//    saveEvent(ScheduleEvent.fromStrings("Wed", "12:45", "14:15", "1FU201 - Accounting I.", "Seminar", "SB 234", "J. Janhubová"));

    List<Map<String, dynamic>> controlQuery2 = await _db.rawQuery("SELECT * FROM ScheduleEvents");
    _log.info("After insert:  " + controlQuery2.toString());
  }

//  Future<List<ScheduleEvent>> getEventsByDay(String day) async {
//    final result = await _db.query(
//      _TABLE, columns: null, where: "day = ?", whereArgs: [day],
//    );
//    List<ScheduleEvent> schedule = [];
//    result.forEach((json) {
//      ScheduleEvent event = ScheduleEvent.fromStrings();
//      schedule.add(event);
//    });
//    return schedule;
//  }

//  Future<List<ScheduleEvent>> getSchedule() async {
//    final result = await _db.rawQuery("SELECT * FROM $_TABLE");
//    List<ScheduleEvent> schedule = [];
//    result.forEach((json) {
//      ScheduleEvent event = ScheduleEvent.fromDB(json);
//      schedule.add(event);
//    });
//    return schedule;
//  }

  void saveEvent(ScheduleEvent event) {
    _log.info("DB event insert: [" + event.getFrom() + ", "+event.getRoom() + "]");
    Map<String, dynamic> values = {
      "day"     : event.getDayNumber(),
      "[from]"  : event.getFrom(),     // FROM is a keyword
      "until"   : event.getUntil(),
      "course"  : event.getCourse(),
      "entry"   : event.getEntry(),
      "room"    : event.getRoom(),
      "teacher" : event.getTeacher()
    };
    _db.insert(_TABLE, values);
  }

  // since all methods are async, is there possibility of dirty read and stuff?
  void updateEventPriority(ScheduleEvent updateEvent, int priority) {
    _db.update(_TABLE,
        {'priority': priority},
        where: "day = ?, until = ?, room = ?",
        whereArgs: [updateEvent.getDayNumber(), updateEvent.getFrom(), updateEvent.getRoom()]);
  }

  Future<List<ScheduleEvent>> getEventsOnDay(String day) async {
    List<ScheduleEvent> schedule;
    List<Map<String, dynamic>> result = await _db.query("ScheduleEvents", columns: null, where: "day = ?", whereArgs: [day],);
    result.forEach((element) {
      schedule.add(ScheduleEvent.fromStrings(
          element["day"], element["from"], element["until"],
          element["course"], element["entry"], element["room"],
          element["teacher"]));
    });
    return schedule;
  }

  _deleteEvent(ScheduleEvent event) async {
    return await _db.delete("ScheduleEvents",
        where: "day = ?, until = ?, room = ?",
        whereArgs: [event.getDayNumber(), event.getFrom(), event.getRoom()]);
  }
}

final DBProvider dbProvider = DBProvider();