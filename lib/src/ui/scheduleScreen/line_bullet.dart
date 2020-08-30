import 'package:flutter/material.dart';

import '../app_colors.dart';
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

  double _iconSize;
  double devH;
  double lineH;
  double indent;
  double iconOpacity;

  Widget displayWidget;
  IconData displayIcon;

  LineBullet(this._state);

  @override
  Widget build(BuildContext context) {
    devH = MediaQuery
        .of(context)
        .size
        .height;
    lineH = devH * 0.16;
    _iconSize = devH * 0.05;
    indent = devH * 0.01;

    setAppearance();
    return buildWidget();
  }

  void setAppearance() {
    if (_state == EventState.PAST) {
      displayIcon = Icons.check_circle_outline;
      iconOpacity = 0.5;
    } else if (_state == EventState.CURRENT) {
      displayIcon = Icons.radio_button_checked;
      iconOpacity = 1;
    } else {
      displayIcon = Icons.radio_button_unchecked;
      iconOpacity = 1;
    }
  }

  Widget buildWidget() {
    Color color = AppColors.greenBackground.withOpacity(iconOpacity);
    return Column(
      children: <Widget>[
        Icon(displayIcon,
            color: color,
            size: _iconSize
        ),
        Container(
            height: lineH,
            child: VerticalDivider(
              indent: indent,
              thickness: 1.5,
              width: 1.5,
              color: color,
            )
        ),
      ],
    );
  }

}