import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';

import '../../vschedule_app.dart';
import 'event_card_widget.dart';
import 'event_line_bullet_widget.dart';

enum ScheduleEventState { PAST, CURRENT, FUTURE }


class ScheduleEventWidget extends StatefulWidget {

  ScheduleEventState _state;
  List<ScheduleEvent> _events;

  ScheduleEventWidget(this._events, this._state);

  @override
  _ScheduleEventWidgetState createState() => _ScheduleEventWidgetState();

}

class _ScheduleEventWidgetState extends State<ScheduleEventWidget> {

  ListQueue<ScheduleEvent> cardsQModel;
  ListQueue<Widget> cardsQView;

  @override
  void initState() {
    super.initState();
    if(widget._events.length > 1) {
      cardsQModel = ListQueue<ScheduleEvent>();
      cardsQView = ListQueue<Widget>();
      double multiplier = 0;
      widget._events.forEach((event) {
        event.margin = (multiplier++)*4;
        cardsQModel.add(event);
      });
      cardsQView = _fillViews();
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

  Widget buildStack() {
    Color fontColor = ( widget._state == ScheduleEventState.PAST ? whiteFontFaded : whiteFont);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// LEFT: Time
        Expanded(
            flex: 2,
            child: Container(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  widget._events[0].getFrom(),
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
            child: EventLineBulletWidget(widget._state)
        ),

        /// RIGHT: Card
        Expanded(
            flex: 5,
            child: Column(
                children: <Widget>[
                  Container(
                    height: 140,
                    width: 350,
                    child: Stack(
                        alignment: Alignment.center,
                        children: cardsQView.toList()
                    )
                  ),
                ]
            )
        )
      ],
    );
  }

  Widget buildCard() {
    Color fontColor = ( widget._state == ScheduleEventState.PAST ? whiteFontFaded : whiteFont);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// LEFT: Time
        Expanded(
            flex: 2,
            child: Container(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  widget._events[0].getFrom(),
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
            child: EventLineBulletWidget(widget._state)
        ),

        /// RIGHT: Card
        Expanded(
            flex: 5,
            child: Column(
                children: <Widget>[
                  Container(
                    height: 140,
                    width: 350,
                    child: EventCardWidget(_colorFromString(widget._events[0].getCourse().substring(0,6)),
                        false,
                        widget._events[0].getCourse(), widget._events[0].getTeacher(),
                        widget._events[0].getRoom(), widget._events[0].getEntry(), widget._events[0].getUntil()),
                  ),
                ]
            )
        )
      ],
    );
  }

  Color _colorFromString(String str) {
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

  ListQueue<Widget> _fillViews() {
    ListQueue<Widget> queue = ListQueue<Widget>();

    cardsQModel.forEach((model) {
      EventCardWidget card = EventCardWidget(
          _colorFromString(model.getCourse().substring(0,6)), true,
          model.getCourse(), model.getTeacher(),
          model.getRoom(), model.getEntry(), model.getUntil()
      );
      queue.add(
        Positioned(
          bottom: model.margin, right: model.margin,
          child: Draggable(
            onDragEnd: (drag) {
              _sendBackward();
            },
            childWhenDragging: Container(),
            feedback: Container(
              width: 250,
              height: 140,
              child: card,
            ),
            child: Container(
              width: 250,
              height: 140,
              child: card,
            ),
          ),
        )
      );
    });
    return queue;
  }

  void _sendBackward() {
    setState(() {
      List<double> margins = cardsQModel.map((card) => card.margin).toList();

      ScheduleEvent removed = cardsQModel.removeLast();
      cardsQModel.addFirst(removed);

      for (var i = 0; i < margins.length; i++) {
        cardsQModel.elementAt(i).margin = margins[i];
      }

      cardsQView = _fillViews();
    });
  }

}