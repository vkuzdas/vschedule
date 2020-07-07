import 'package:flutter/material.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';

import '../../vschedule_app.dart';
import 'event_card_widget.dart';
import 'event_line_bullet_widget.dart';

enum ScheduleEventState { PAST, CURRENT, FUTURE }

class ScheduleEventWidget extends StatelessWidget {

  ScheduleEventState _scheduleEventState;
  ScheduleEvent _scheduleEvent;

  ScheduleEventWidget(this._scheduleEvent, this._scheduleEventState);

  @override
  Widget build(BuildContext context) {
    Color fontColor = ( _scheduleEventState == ScheduleEventState.PAST ? whiteFontFaded : whiteFont);
    return Row(
      children: <Widget>[

        /// LEFT: Time
        Expanded(
            flex: 2,
            child:
            Container(
                child: Column(children: <Widget>[
                  Container(height: 10,),
                  Text(_scheduleEvent.getFrom(),
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, fontFamily: "Poppins", letterSpacing: 2.0, color: fontColor),),
                ],))
        ),

        /// MIDDLE: Line & bullet
        Expanded(
            flex: 1,
            child: EventLineBulletWidget(_scheduleEventState)
        ),

        /// RIGHT: Card
        Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Container(
                  height: 140,
                  width: 300,
                  child: EventCardWidget(Colors.red, 130, 220, _scheduleEvent.getCourse(), _scheduleEvent.getTeacher(), _scheduleEvent.getRoom()),
                ),
              ]
            )
        )
      ],
    );
  }



}