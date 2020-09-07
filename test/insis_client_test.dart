import 'package:flutter_test/flutter_test.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';
import 'package:vseschedule_03/src/resources/http/insis_client.dart';

void main() {
  /// Test of Schedule download
  /// TODO: mock this

  test('Schedule Download', () async {
    InsisClient ic = InsisClient.getInstance();
    List<ScheduleEvent> list;
    try {
      list = await ic.downloadSchedule("", "");
    } on Exception {
      print("fail");
    }
    expect(list.length, 13);
    print("done");
  });
}
