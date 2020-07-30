import 'package:rxdart/rxdart.dart';

class ScheduleBloc {

  final _weekday = BehaviorSubject<int>(seedValue: 0);

  Stream<int> get weekday => _weekday.stream;

  Function(int) get weekdaySink => _weekday.sink.add;
}