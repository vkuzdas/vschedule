import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../logging/logger.dart';
import '../../models/schedule_event.dart';

//TODO should the connection be closed?... elaborate https://stackoverflow.com/questions/54055106/not-closing-the-database-with-flutters-sqflite
class DBEventProvider  {

  static final DBEventProvider _instance = DBEventProvider._internal();

  Logger _logger = getLogger("DBEventProvider");
  final String _TABLE = "ScheduleEvents";
  Database _db;

  // dart singleton
  factory DBEventProvider() {
    _instance._init();
    return _instance;
  }

  DBEventProvider._internal();


  void _init() async {
    _logger.i("Initializing db.");
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
    _logger.i("New db at " + path);
    List<Map<String, dynamic>> controlQuery = await _db.rawQuery("PRAGMA table_info([$_TABLE])");
    _logger.i("Tables:  " + controlQuery.toString());
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
    _logger.i("DB event insert: [" + event.getFrom() + ", "+event.getRoom() + "]");
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


  // TODO: bad signature semantics
  _getEvents(ScheduleEvent event) async {
    return await _db.query("ScheduleEvents",
      columns: null,
      where: "day = ?, until = ?, room = ?",
      whereArgs: [event.getDayNumber(), event.getFrom(), event.getRoom()],);
  }

  _deleteEvent(ScheduleEvent event) async {
    return await _db.delete("ScheduleEvents",
        where: "day = ?, until = ?, room = ?",
        whereArgs: [event.getDayNumber(), event.getFrom(), event.getRoom()]);
  }
}

final DBEventProvider dbProvider = DBEventProvider();