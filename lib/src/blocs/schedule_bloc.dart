import 'package:rxdart/rxdart.dart';

class ScheduleBloc {

  final _selected = BehaviorSubject<int>(seedValue: null);

  Stream<int> get selected => _selected.stream;

  Function(int) get sinkSelected => _selected.sink.add;
}