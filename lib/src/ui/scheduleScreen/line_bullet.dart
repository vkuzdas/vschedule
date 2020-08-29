import 'package:flutter/material.dart';

import 'event_widget.dart';



/// Middle widget of ScheduleScreen.
///
/// Indicates one of three states in which an event can occur on current day:
///   1) Event already happened
///   2) Event is currently happening
///   3) Event will happen
class LineBullet extends StatelessWidget {
  // TODO: Variable name conflicts "StatelessWidget"
  final EventState _state;
  final double _iconSize = 35;

  double devH;
  double devW;

  LineBullet(this._state);

  @override
  Widget build(BuildContext context) {
    devH = MediaQuery.of(context).size.height;
    devW = MediaQuery.of(context).size.width;

    switch (_state) {
      case EventState.PAST:
        return getPast(context);
      case EventState.CURRENT:
        return getCurrent(context);
      case EventState.FUTURE:
        return getFuture(context);
    }
  }

  Column getPast(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.secondary.withOpacity(0.5), size: _iconSize),
        Container(
            height: devH * 0.16,
            child: VerticalDivider(indent: 5,
              endIndent: 5,
              thickness: 1.5,
              width: 1.5,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary
                  .withOpacity(0.5),)),
      ],
    );
  }

  Column getCurrent(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(Icons.radio_button_checked, color: Theme.of(context).colorScheme.secondary, size: _iconSize),
        Container(
            height: devH * 0.16,
            child: VerticalDivider(indent: 5,
              endIndent: 5,
              thickness: 1.5,
              width: 1.5,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,)),
      ],
    );
  }

  Column getFuture(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(Icons.radio_button_unchecked, color: Theme.of(context).colorScheme.secondary, size: _iconSize),
        Container(
            height: devH * 0.16, //13,28%
            child: VerticalDivider(indent: 5,
              endIndent: 5,
              thickness: 1.5,
              width: 1.5,
              color: Theme
                  .of(context)
                  .colorScheme
                  .secondary,)),
      ],
    );
  }
}