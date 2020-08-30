import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';

import '../app_colors.dart';
import 'ev_card.dart';
import 'line_bullet.dart';

enum EventState { PAST, CURRENT, FUTURE }

class ScheduleEventWidget extends StatefulWidget {
  final _log = Logger('ScheduleEventWidget');
  Size _devSize;
  EventState _state;
  ListQueue<ScheduleEvent> _events;

  ScheduleEventWidget(this._events, int selectedDay, this._devSize) {
    this._state = _getState(_events.elementAt(0), selectedDay);
  }

  /// selectedDay =  0  -> datePicker selected TODAY
  /// selectedDay = -1  -> datePicker selected YESTERDAY
  /// selectedDay =  1  -> datePicker selected TOMORROW
  /// selectedDay =  2  -> datePicker selected day after TOMORROW
  EventState _getState(ScheduleEvent ev, int selectedDay) {
    TimeOfDay now = TimeOfDay.now();
    if (selectedDay < 0) {
      return EventState.PAST;
    } else if (selectedDay > 0) {
      return EventState.FUTURE;
    } else {
      DateTime from = ev.getDateTimeFrom();
      DateTime until = ev.getDateTimeUntil();
      DateTime nowDT =
          DateTime(from.year, from.month, from.day, now.hour, now.minute);
      if (until.isBefore(nowDT)) {
        return EventState.PAST;
      } else if (from.isAfter(nowDT)) {
        return EventState.FUTURE;
      } else {
        return EventState.CURRENT;
      }
    }
  }

  @override
  _ScheduleEventWidgetState createState() => _ScheduleEventWidgetState();
}

class _ScheduleEventWidgetState extends State<ScheduleEventWidget> {
  ListQueue<ScheduleEvent> models;
  ListQueue<Widget> cards;
  List<double> margins;

  @override
  void initState() {
    super.initState();
    models = widget._events;
    if (models.length > 1) {
      margins = [];
      double multiplier = 0;
      models.forEach((event) {
        margins.add((multiplier++) * 4);
      });
      cards = _fillViews();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget._events.length == 1) {
      return buildCard();
    } else {
      return buildStack();
    }
  }

  /// SINGLE EVENT
  Widget buildCard() {
    ScheduleEvent ev = widget._events.elementAt(0);
    Color fontColor = (widget._state == EventState.PAST
        ? AppColors.whiteFontFaded
        : AppColors.whiteFont);

    return Container(
      height: widget._devSize.height * 0.22,
      width: widget._devSize.width,
      child:
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

        /// LEFT: Time
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  ev.getFrom(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      letterSpacing: 2.0,
                      color: fontColor),
                )
            )
        ),

        /// MIDDLE: Line & bullet
        Expanded(flex: 1, child: LineBullet(widget._state)),

        /// RIGHT: Card
        Expanded(
            flex: 5,
            child: EventCard(false, ev.getCourse(), ev.getTeacher(),
                ev.getRoom(), ev.getEntry(), ev.getUntil()))
      ]),
    );
  }

  /// EVENTS ARE STACKED
  Widget buildStack() {
    String from = widget._events.elementAt(0).getFrom();
    Color fontColor = (widget._state == EventState.PAST
        ? AppColors.whiteFontFaded
        : AppColors.whiteFont);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        /// LEFT: Time
        Expanded(
            flex: 2,
            child: Container(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  from,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      letterSpacing: 2.0,
                      color: fontColor),
                ))),

        /// MIDDLE: Line & bullet
        Expanded(flex: 1, child: LineBullet(widget._state)),

        /// RIGHT: Card
        Expanded(
          flex: 5,
          child: Container(
              height: widget._devSize.height * 0.22,
              child: Stack(children: cards.toList())),
        )
      ],
    );
  }

  ListQueue<Widget> _fillViews() {
    ListQueue<Widget> queue = ListQueue<Widget>();

    for (var i = 0; i < models.length; i++) {
      EventCard card = EventCard(
          true,
          models.elementAt(i).getCourse(),
          models.elementAt(i).getTeacher(),
          models.elementAt(i).getRoom(),
          models.elementAt(i).getEntry(),
          models.elementAt(i).getUntil());
      queue.add(Positioned(
        bottom: margins[i],
        right: margins[i],
        child: Draggable(
          onDragEnd: (drag) {
            _sendBackward();
          },
          childWhenDragging: Container(),
          feedback: card,
          child: card,
        ),
      ));
    }
    return queue;
  }

  void _sendBackward() {
    setState(() {
      ScheduleEvent removed = models.removeLast();
      models.addFirst(removed);
      cards = _fillViews();
    });
  }
}
