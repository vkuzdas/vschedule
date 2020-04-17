
import 'package:flutter/material.dart';
import 'schedule_bloc.dart';

class ScheduleBlocProvider extends InheritedWidget {
  final bloc = ScheduleBloc();

  ScheduleBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify (_) => true;

  static ScheduleBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ScheduleBlocProvider) as ScheduleBlocProvider).bloc;
  }
}