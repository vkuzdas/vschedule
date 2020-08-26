import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';

void main() {
  /// Example of DATETIME SORTING
  test('sort', () {
    List products = [
      "2019-11-25 00:00:00.000",
      "2019-11-22 00:00:00.000",
      "2019-11-22 00:00:00.000",
      "2019-11-24 00:00:00.000",
      "2019-11-23 00:00:00.000"
    ];
    List<DateTime> newProducts = [];
    DateFormat format = DateFormat("yyyy-MM-dd");

    for (int i = 0; i < 5; i++) {
      newProducts.add(format.parse(products[i]));
    }
    newProducts.sort();

    for (int i = 0; i < 5; i++) {
      print(newProducts[i]);
    }
  });

  /// if schedule overlaps, put ScheduleEvents into a Map of Lists
  /// Each MapEntry has a DateTime key and List<ScheduleEvent>
  /// List contains overlapping events
  test('stack test', () {
    // given SORTED list of events, return structred Map<List<events>>
    // that can be represented as overlapping schedule
    List<ScheduleEvent> l = [
      ScheduleEvent.fromStrings(
          "Mon", "01:00", "05:00", null, "Lecture", null, null),
      ScheduleEvent.fromStrings(
          "Mon", "02:00", "03:00", null, "Lecture", null, null),
      ScheduleEvent.fromStrings(
          "Mon", "04:00", "06:00", null, "Lecture", null, null)
    ];

    Map<DateTime, List<ScheduleEvent>> expected =
        Map<DateTime, List<ScheduleEvent>>();
    expected.putIfAbsent(
        DateTime.parse("2020-09-21 01:00:00.000"), () => [l[0]]);
    expected.putIfAbsent(
        DateTime.parse("2020-09-21 02:00:00.000"), () => [l[0], l[1]]);
    expected.putIfAbsent(
        DateTime.parse("2020-09-21 03:00:00.000"), () => [l[0]]);
    expected.putIfAbsent(
        DateTime.parse("2020-09-21 04:00:00.000"), () => [l[0], l[2]]);
    expected.putIfAbsent(
        DateTime.parse("2020-09-21 05:00:00.000"), () => [l[2]]);

    Map<DateTime, List<ScheduleEvent>> actual = normalize(l);

    assert(normalize(l) == expected);
  });
}

/// Method which sets a structure to overlapping events
Map<DateTime, List<ScheduleEvent>> normalize(List<ScheduleEvent> l) {
  Map<DateTime, List<ScheduleEvent>> normalized =
      Map<DateTime, List<ScheduleEvent>>();

  l.forEach((el) {
    normalized.putIfAbsent(el.getDateTimeFrom(), () => []);
    normalized.putIfAbsent(el.getDateTimeUntil(), () => []);
  });

  l.forEach((el) {
    normalized.keys.forEach((key) {
      if (el.getDateTimeFrom() == key) {
        normalized[key].add(el);
      }
      if (el.getDateTimeFrom().isBefore(key) &&
          el.getDateTimeUntil().isAfter(key)) {
        normalized[key].add(el);
      }
    });
  });

  normalized.removeWhere((key, value) => normalized[key].isEmpty);

  return normalized;
}
