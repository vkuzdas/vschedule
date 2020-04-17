import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:vseschedule_03/src/logging/logger.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';
import 'package:vseschedule_03/src/resources/http/insis_client_provider.dart';

void main() {

  test('Success', () async {
    InsisClientProvider icp = InsisClientProvider();
    List<ScheduleEvent> schedule = await icp.getSchedule("kuzv06", "3BigElephants");
    expect(schedule.length, 10);
  });

  test('Wrong credentials', () async {
    InsisClientProvider icp = InsisClientProvider();
    List<ScheduleEvent> schedule = await icp.getSchedule("abc", "efg");
  });

}