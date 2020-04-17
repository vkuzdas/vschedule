enum Day { Mon, Tue, Wed, Thu, Fri, Sat, Sun }
enum Entry { Lecture, Seminar }

class ScheduleEvent {

  Day day;
  String from;
  String until;
  String course; // TODO split into ident and course?
  Entry entry;
  String room;
  String teacher;
  bool display;
  int priority;

  ScheduleEvent(this.day, this.from, this.until, this.course, this.entry, this.room, this.teacher, this.display, this.priority);

  ScheduleEvent.fromJson(Map<String, dynamic> parsedJson) {
    this.day       = getDayFromString(parsedJson["day"]);
    this.from      = parsedJson["from"];
    this.until     = parsedJson["until"];
    this.course    = parsedJson["course"];
    this.entry     = getEntryFromString(parsedJson["entry"]);
    this.room      = parsedJson["room"];
    this.teacher   = parsedJson["teacher"];
    this.display   = parsedJson["display"];
    this.priority  = parsedJson["priority"];
  }

  ScheduleEvent.fromDb(Map<String, dynamic> parsedJson) {
    this.day       = getDayFromString(parsedJson['day']);
    this.from      = parsedJson['from'];
    this.until     = parsedJson['until'];
    this.course    = parsedJson['course'];
    this.entry     = getEntryFromString(parsedJson['entry']);
    this.room      = parsedJson['room'];
    this.teacher   = parsedJson['teacher'];
    this.display   = parsedJson['display'] == 1;
    this.priority  = parsedJson['priority'];
  }

  ScheduleEvent.fromStrings(
      String day, String from, String until,
      String course, String entry, String room,
      String teacher, String display, String priority
  ) {
    this.day = getDayFromString(day);
    this.from = from;
    this.until = until;
    this.course = course;
    this.entry = getEntryFromString(entry);
    this.room = room;
    this.teacher = teacher;
    this.display = display == "1";
    this.priority = int.parse(priority);
  }



  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>
    {
      "day"      : getDayString(),
      "[from]"     : from,
      "until"    : until,
      "course"   : course,
      "entry"    : getEntryString(),
      "room"     : room,
      "teacher"  : teacher,
      "display"  : (display == true ? 1 : 0),
      "priority" : priority
    };
  }








  Day getDayFromString(String day) {
    day = "Day.$day";
    Day d = Day.values.firstWhere((d) => d.toString() == day, orElse: () => null);
    if (d == null) {
      throw Exception;
    }
    return d;
  }

  Entry getEntryFromString(String entry) {
    entry = "Entry.$entry";
    Entry e = Entry.values
        .firstWhere((e) => e.toString() == entry, orElse: () => null);
    if (e == null) {
      throw Exception;
    }
    return e;
  }

  String getEntryString() {
    if (entry == null) {
      return null;
    }
    if (entry == Entry.Seminar) {
      return "Seminar";
    }
    if (entry == Entry.Lecture) {
      return "Lecture";
    }
  }

  String getDayString() {
    if (day == null) {
      return null;
    }
    return day.toString().substring(4,7);
  }

  bool operator ==(that) {
    return (this.teacher == that.teacher &&
        this.room == that.room &&
        this.course == that.course &&
        this.from == that.from &&
        this.until == that.until &&
        this.day == that.day &&
        this.entry == that.entry &&
        (this.display == that.display) &&
        this.priority == that.priority
    );
  }

  @override
  String toString() {
    return "{day: $day, from: $from, until: $until, " +
           "course: $course, entry: $entry, room: $room"+
           "teacher: $teacher, display: $display, priority: $priority}";
  }
}
