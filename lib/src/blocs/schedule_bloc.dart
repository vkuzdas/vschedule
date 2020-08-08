import 'package:rxdart/rxdart.dart';

class ScheduleBloc {

  final _selectedDay = BehaviorSubject<int>(seedValue: 0);

  Stream<int> get selectedDay => _selectedDay.stream;

  Function(int) get selectedDaySink => _selectedDay.sink.add;
}