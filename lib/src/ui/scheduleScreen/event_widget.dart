import 'package:flutter/cupertino.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        /// LEFT: Time
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
            child: Text(
              _scheduleEvent.getFrom(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.w400, fontFamily: "Poppins", letterSpacing: 2.0, color: fontColor
              ),
            )
          )
        ),

        /// MIDDLE: Line & bullet
        Expanded(
          flex: 1,
          child: EventLineBulletWidget(_scheduleEventState)
        ),

        /// RIGHT: Card
        Expanded(
          flex: 5,
          child: Column(
            children: <Widget>[
              Container(
                height: 140,
                width: 350,
                child: EventCardWidget(colorFromString(_scheduleEvent.getCourse().substring(0,6)), 135, 250, _scheduleEvent.getCourse(), _scheduleEvent.getTeacher(), _scheduleEvent.getRoom(), _scheduleEvent.getEntry()),
              ),
            ]
          )
        )
      ],
    );
  }

  Color colorFromString(String str) {
//    String str = "4EK101";
    int hash = 0;
    for (var i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
    }
    String colour = '#';
    for (var i = 0; i < 3; i++) {
      int value = (hash >> (i * 8)) & 0xFF;
      if(value < 16) {
        colour += '0';
      }
      colour += value.toRadixString(16);
    }
    return Color(int.parse(colour.substring(1, 7), radix: 16) + 0xFF000000);
  }



}