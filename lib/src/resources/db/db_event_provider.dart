

//TODO should the connection be closed?... elaborate https://stackoverflow.com/questions/54055106/not-closing-the-database-with-flutters-sqflite
import 'dart:io';

import '../../logging/logger.dart';
import '../../models/schedule_event.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBEventProvider  {
  static final DBEventProvider _instance = DBEventProvider._internal();

  Logger _logger = getLogger("DBEventProvider");
  final String _TABLE = "ScheduleEvents";
  Database _db;

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
          newDb.execute(
              """
          CREATE TABLE $_TABLE
          (
              day       TEXT,
              [from]    TEXT,
              until     TEXT,
              course    TEXT,
              entry     TEXT,
              room      TEXT,
              teacher   TEXT,
              display   INTEGER,
              priority  INTEGER
           )
          """
          );


        }
    );
    _logger.i("New db at " + path);
    List<Map<String, dynamic>> q = await _db.rawQuery("PRAGMA table_info([$_TABLE])");
    _logger.i("Tables:  " + q.toString());
  }





  Future<List<ScheduleEvent>> getEventsByDay(Day day) async {
    final result = await _db.query(
      _TABLE, columns: null, where: "day = ?", whereArgs: [day.toString().substring(4,7)],
    );
    List<ScheduleEvent> schedule = [];
    result.forEach((json) {
      ScheduleEvent event = ScheduleEvent.fromDb(json);
      schedule.add(event);
    });
    return schedule;
  }

  Future<List<ScheduleEvent>> getSchedule() async {
    final result = await _db.rawQuery("SELECT * FROM $_TABLE");
    List<ScheduleEvent> schedule = [];
    result.forEach((json) {
      ScheduleEvent event = ScheduleEvent.fromDb(json);
      schedule.add(event);
    });
    return schedule;
  }



  void saveEvent(ScheduleEvent event) {
    _logger.i("DB event insert: ["+event.from+ "; "+event.room+"]");
    _db.insert(_TABLE, event.toMapForDb());
  }



  // since all methods are async, is there possibility of dirty read and stuff?
  void updateEventPriority(ScheduleEvent updateEvent, int priority) {
    _db.update(_TABLE,
        {'priority': priority},
        where: "day = ?, until = ?, room = ?",
        whereArgs: [updateEvent.day, updateEvent.from, updateEvent.room]);
  }







  _getEvents(ScheduleEvent event) async {
    return await _db.query("ScheduleEvents",
      columns: null,
      where: "day = ?, until = ?, room = ?",
      whereArgs: [event.day, event.from, event.room],);
  }

  _deleteEvent(ScheduleEvent event) async {
    return await _db.delete("ScheduleEvents",
        where: "day = ?, until = ?, room = ?",
        whereArgs: [event.day, event.from, event.room]);
  }
}

final DBEventProvider dbProvider = DBEventProvider();