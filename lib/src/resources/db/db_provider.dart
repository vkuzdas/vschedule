import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/schedule_event.dart';

// SINGLETON:
// 1) private constructor
// 2) private static instance
// 3) instance accesor

//TODO should the connection be closed?... elaborate https://stackoverflow.com/questions/54055106/not-closing-the-database-with-flutters-sqflite
class DBProvider {
  Future<bool> _isInitilized;

  // private static instance
  static final DBProvider _instance = new DBProvider._singletonConstructor();

  final _log = Logger("DBProvider");

  static final String _SCHEDULE_EVENTS_TABLE = "ScheduleEvents";
  static final String _STATIC_DATA_TABLE = "StaticData";
  static final String _createScheduleEventsTable = """
            CREATE TABLE $_SCHEDULE_EVENTS_TABLE
            ( day       INTEGER,
              [from]    TEXT,
              until     TEXT,
              course    TEXT,
              entry     TEXT,
              room      TEXT,
              teacher   TEXT
            )""";
  static final String _createStaticDataTable = """
            CREATE TABLE $_STATIC_DATA_TABLE 
            ( firstLogin BOOLEAN NOT NULL CHECK (firstLogin IN (0,1)));
  """;

  Database _db;

  // private constructor
  DBProvider._singletonConstructor() {
  }

  // instance accesor
  static DBProvider getInstance() {
    return _instance;
  }

  Future<bool> isInitialized() async {
    return _isInitilized;
  }

  Future<bool> init() async {
    _log.info("Initializing db.");
    Directory dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, "schedule_events.db");
    // gets executed only on app installation
    _db = await openDatabase(path, version: 1, onCreate: (newDb, version) {
      newDb.execute(_createScheduleEventsTable);
      newDb.execute(_createStaticDataTable);
      newDb.insert(_STATIC_DATA_TABLE, {"firstLogin": 1});
    });
//    deleteAllEntries();
//    insertTestBatch();

//    List<Map<String, dynamic>> tableInfo =
//        await _db.rawQuery("PRAGMA table_info([$_SCHEDULE_EVENTS_TABLE])");
//    _log.fine("Tables:  " + tableInfo.toString());
//
//    List<Map<String, dynamic>> select =
//        await _db.rawQuery("SELECT * FROM $_STATIC_DATA_TABLE");
//    _log.fine("Static data query:  " + select.toString());
    _log.info("DB initialized.");
    return true;
  }

  Future<bool> isEmpty() async {
    List<Map<String, dynamic>> select =
    await _db.rawQuery("SELECT * FROM ScheduleEvents");
    return select.isEmpty;
  }

  Future<List<ScheduleEvent>> getEventsByDay(String day) async {
    final result = await _db.query(
      _SCHEDULE_EVENTS_TABLE,
      columns: null,
      where: "day = ?",
      whereArgs: [day],
    );
    List<ScheduleEvent> schedule = [];
    result.forEach((json) {
      ScheduleEvent event = ScheduleEvent.fromStrings(
          json["day"].toString(),
          json["from"],
          json["until"],
          json["course"],
          json["entry"],
          json["room"],
          json["teacher"]);
      schedule.add(event);
    });
    return schedule;
  }

  Future<List<ScheduleEvent>> getSchedule() async {
    final result = await _db.rawQuery("SELECT * FROM $_SCHEDULE_EVENTS_TABLE");
    List<ScheduleEvent> schedule = [];
    result.forEach((json) {
      ScheduleEvent event = ScheduleEvent.fromStrings(
          json["day"],
          json["from"],
          json["until"],
          json["course"],
          json["entry"],
          json["room"],
          json["teacher"]);
      schedule.add(event);
    });
    return schedule;
  }

  Future<void> insertEvent(ScheduleEvent event) async {
    _log.info("DB event insert: [" +
        event.getFrom() +
        ", " +
        event.getRoom() +
        ", " +
        event.getDayNumber().toString() +
        "]");
    Map<String, dynamic> values = {
      "day": event.getDayNumber(),
      "[from]": event.getFrom(), // FROM is a keyword
      "until": event.getUntil(),
      "course": event.getCourse(),
      "entry": event.getEntry(),
      "room": event.getRoom(),
      "teacher": event.getTeacher()
    };
    _db.insert(_SCHEDULE_EVENTS_TABLE, values);

//    List<Map<String, dynamic>> select =
//        await _db.rawQuery("SELECT * FROM ScheduleEvents");
//    _log.fine("After insert:  " + select.toString());
  }

  /// Used to build schedule on daySelect in ScheduleScreen class
  Future<List<ScheduleEvent>> getEventsOnWeekday(int weekday) async {
    List<ScheduleEvent> schedule = new List<ScheduleEvent>();
    List<Map<String, dynamic>> result = await _db.query("ScheduleEvents", columns: null, where: "day = ?", whereArgs: [weekday],);
    result.forEach((map) {
      schedule.add(ScheduleEvent.fromStrings(
          map["day"].toString(),
          map["from"],
          map["until"],
          map["course"],
          map["entry"],
          map["room"],
          map["teacher"]));
    });
    return schedule;
  }

  void saveSchedule(List<ScheduleEvent> list) {
    list.forEach((event) async {
      await insertEvent(event);
    });
    _log.info("Schedule saved.");
  }

  /// All entries are deleted on each login
  Future<int> deleteAllEntries() {
    Future<int> deletedRowCount = _db.delete(_SCHEDULE_EVENTS_TABLE);
    return deletedRowCount;
  }

  Future<bool> isFirstLogin() async {
    try {
      List<Map<String, dynamic>> res = await _db.query(_STATIC_DATA_TABLE);
      _log.info("isFirstLogin?: " + res.toString());
      return (res[0]["firstLogin"] as int) == 0 ? false : true;
    } on Exception catch (e) {
      _log.info(e.toString());
    }
    return false;
  }

  setIsFirstLogin(bool bool) {
    Future<int> deletedRowCount = _db.delete(_STATIC_DATA_TABLE);
    int insertBool = bool ? 1 : 0;
    _db.insert(_STATIC_DATA_TABLE, {"firstLogin": insertBool});
  }

  void _insertTestBatch() {
    insertEvent(ScheduleEvent.fromStrings("Mon", "11:00", "12:30",
        "4EK212 Quantitative Management", "Lecture", "NB A", "J. Sekničková"));
    insertEvent(ScheduleEvent.fromStrings("Thu", "09:15", "10:45",
        "4EK212 Quantitative Management", "Lecture", "NB A", "J. Sekničková"));
    insertEvent(ScheduleEvent.fromStrings("Fri", "09:15", "10:45",
        "4EK212 Quantitative Management", "Lecture",
        "NB A",
        "J. Sekničková"));
    insertEvent(ScheduleEvent.fromStrings(
        "Tue",
        "07:30",
        "09:00",
        "4IT115 Software Engineering",
        "Lecture",
        "Vencovského aula",
        "A. Buchalcevová"));
    insertEvent(ScheduleEvent.fromStrings(
        "Tue",
        "09:15",
        "10:45",
        "TVSTHA Thai boxing",
        "Seminar",
        "CK 0127 (JA)",
        "T. Vaněk"));
    insertEvent(ScheduleEvent.fromStrings(
        "Tue",
        "11:00",
        "12:30",
        "4EK212 Quantitative Management",
        "Seminar",
        "SB 231",
        "M. Černý"));
    insertEvent(ScheduleEvent.fromStrings(
        "Tue",
        "12:45",
        "14:15",
        "3MG216 Fundamentals of Marketing for Students of IT and Statistics",
        "Seminar",
        "JM 189 (JM)",
        "M. Zamazalová"));
    insertEvent(ScheduleEvent.fromStrings(
        "Tue",
        "14:30",
        "16:00",
        "4IZ210 Information and Knowledge Processing",
        "Lecture",
        "NB D",
        "J. Rauch"));
    insertEvent(ScheduleEvent.fromStrings(
        "Wed",
        "09:15",
        "10:45",
        "4IT218 Database Management Systems",
        "Seminar",
        "SB 202",
        "H. Palovská"));
    insertEvent(ScheduleEvent.fromStrings(
        "Wed",
        "09:15",
        "10:45",
        "4ST204 Statistics for Informatics",
        "Seminar",
        "SB 104",
        "F. Habarta"));
    insertEvent(ScheduleEvent.fromStrings(
        "Wed",
        "09:15",
        "10:45",
        "4ST204 Statistics for Informatics",
        "Seminar",
        "SB 104",
        "F. Habarta"));
    insertEvent(ScheduleEvent.fromStrings(
        "Wed",
        "09:15",
        "10:45",
        "4AA204 Statistics for Informatics",
        "Seminar",
        "SB 104",
        "F. Habarta"));
    insertEvent(ScheduleEvent.fromStrings(
        "Wed",
        "12:45",
        "14:15",
        "1FU201 Accounting I.",
        "Seminar",
        "SB 234",
        "J. Janhubová"));
  }


}
