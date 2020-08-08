import 'package:flutter/src/material/time.dart';
import 'package:vseschedule_03/src/ui/scheduleScreen/event_widget.dart';

enum Entry { LECTURE, SEMINAR }

/// Model class of most important object which is a single event in a schedule
///
/// An instance is defined by [_from] and [_until] fields. These are DateTime information
/// about when does the event occur in the schedule. Event takes place every week periodically.
/// [_BASE_YEAR], [_BASE_MONTH] and [_BASE_DAY] variables are integers denoting first day of the semester (Monday).
/// Variables are used internally as reference dates since applications concern is Day, Hours and Minutes only.
class ScheduleEvent {

  // arbitrary reference date (start of winter semester of 2020, can be random as long as BASE_DATETIME is  Monday)
  final int _BASE_YEAR  = 2020;
  final int _BASE_MONTH = 9;
  final int _BASE_DAY   = 20; // SATURDAY

  DateTime  _from;    // When does the event start?                               Ex.: "10:30"
  DateTime  _until;   // When does the event end?                                 Ex.: "10:30"
  Entry     _entry;   // Is the event Seminar or a Lecture? (Přednáška x Cvičení) Ex.: "Lecture", "Seminar"
  String    _course;  // Full name of the course, includes ident num.             Ex.: "4EK212 Quantitative Management"
  String    _room;    // Room number.                                             Ex.: "SB 109", "NB A", "Vencovského aula"
  String    _teacher; // Full name of the teacher.                                Ex.: "J. Sekničková"


  ScheduleEvent.fromStrings(
      String day, String from, String until,
      String course, String entry, String room,
      String teacher
  ) {
    this._from    = _createDateTime(day, from);
    this._until   = _createDateTime(day, until);
    this._entry   = _parseEntry(entry);
    this._course  = course;
    this._room    = room;
    this._teacher = teacher;
  }

  Entry _parseEntry(String entry) {
    entry = "Entry." + entry.toUpperCase();
    if (entry == Entry.LECTURE.toString()) {
      return Entry.LECTURE;
    }
    else if (entry == Entry.SEMINAR.toString()) {
      return Entry.SEMINAR;
    }
    else {
      throw FormatException("Got unknown ENTRY on ScheduleEvent Construction.");
    }
  }

  DateTime _createDateTime(String day, String time) {
    int dayInt;
    switch (day) {
      case "Mon" :
        dayInt = DateTime.monday;
        break;
      case "Tue" :
        dayInt = DateTime.tuesday;
        break;
      case "Wed" :
        dayInt = DateTime.wednesday;
        break;
      case "Thu" :
        dayInt = DateTime.thursday;
        break;
      case "Fri" :
        dayInt = DateTime.friday;
        break;
      case "Sun" :
        dayInt = DateTime.sunday;
        break;
      case "Sat" :
        dayInt = DateTime.saturday;
        break;
      case "1" :
        dayInt = DateTime.monday;
        break;
      case "2" :
        dayInt = DateTime.tuesday;
        break;
      case "3" :
        dayInt = DateTime.wednesday;
        break;
      case "4" :
        dayInt = DateTime.thursday;
        break;
      case "5" :
        dayInt = DateTime.friday;
        break;
      case "6" :
        dayInt = DateTime.sunday;
        break;
      case "7" :
        dayInt = DateTime.saturday;
        break;
      default:
        throw FormatException("Got unknown DAY abbreviation on ScheduleEvent Construction.");
    }
    int hours = int.parse(time.split(":")[0]);
    int minutes = int.parse(time.split(":")[1]);
    DateTime createdDateTime = DateTime(_BASE_YEAR, _BASE_MONTH, _BASE_DAY + dayInt, hours, minutes);
    return createdDateTime;
  }

  bool operator ==(that) {
    return (
        this._from == that.from &&
            this._until == that.until &&
            this._entry == that.entry &&
            this._teacher == that.teacher &&
            this._room == that.room &&
            this._course == that.course
    );
  }

  @override
  String toString() {
    return 'ScheduleEvent{from: $_from, until: $_until, entry: $_entry, course: $_course, room: $_room, teacher: $_teacher}';
  }


  /// returns values between { [DateTime.monday],... [DateTime.saturday] }
  int getDayNumber() {
    return _until.weekday;
  }

  String getFrom() {
    String minutes = _from.minute == 0 ? "00" : ""+_from.minute.toString();
    return "" + _from.hour.toString() +":"+ minutes;
  }

  String getUntil() {
    String minutes = _until.minute == 0 ? "00" : ""+_until.minute.toString();
    return "" + _until.hour.toString() +":"+ minutes;
  }

  String getTeacher() {
    return this._teacher;
  }

  String getEntry() {
    return this._entry.toString().split(".")[1];
  }

  String getCourse() {
    return this._course;
  }

  String getRoom() {
    return this._room;
  }

  DateTime getDateTimeFrom() {
    return this._from;
  }


  DateTime getDateTimeUntil() {
    return this._until;
  }

  ScheduleEventState getState(TimeOfDay now, int selectedDay) {
      if (selectedDay < 0) {
        return ScheduleEventState.PAST;
      }
      else if (selectedDay > 0) {
        return ScheduleEventState.FUTURE;
      }
      else {
        DateTime from = this.getDateTimeFrom();
        DateTime until = this.getDateTimeUntil();
        DateTime nowDT = DateTime(from.year, from.month, from.day, now.hour, now.minute);
        if (until.isBefore(nowDT)) {
          return ScheduleEventState.PAST;
        }
        else if (from.isAfter(nowDT)) {
          return ScheduleEventState.FUTURE;
        }
        else {
          return ScheduleEventState.CURRENT;
        }
      }
  }
}
