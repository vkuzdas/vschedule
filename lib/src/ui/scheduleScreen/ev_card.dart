import 'package:flutter/material.dart';

import '../app_colors.dart';

class EventCard extends StatelessWidget {
  double _height;
  double _width;
  int _cutoff;
  Color _color;

  double devH;
  double devW;

  final String _course;
  final String _teacher;
  final String _room;
  final String _entry;
  final String _until;
  final bool _goesInStack;

  EventCard(this._goesInStack, this._course, this._teacher, this._room,
      this._entry, this._until) {
    this._color = AppColors.colorFromString(_course.substring(0, 6));
  }

  @override
  Widget build(BuildContext context) {
    devH = MediaQuery.of(context).size.height;
    devW = MediaQuery.of(context).size.width;

    if (_goesInStack) {
      _height = devH * 0.20;
      _width = devW * 0.56;
      _cutoff = 10; // 15,9387
    } else {
      _height = devH * 0.22;
      _width = devW * 0.6;
      _cutoff = 40; // 18,5977
    }

    CardTheme cardTheme = Theme.of(context).cardTheme;

    return Container(
      height: _height,
      width: _width,
      child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.bottomRight,
          children: <Widget>[
            /// Background
            Positioned(
              bottom: 0.2,
//          right: 0.001,
              height: _height,
              width: _width + 10,
              child: Card(
                elevation: cardTheme.elevation,
                color: _color,
                shape: cardTheme.shape,
              ),
            ),

            /// Foreground
            Positioned(
              height: _height + 0.5,
              width: _width + 0.01,
              child: Card(
                  elevation: cardTheme.elevation,
                  color: (_entry.toLowerCase() == "lecture")
                      ? cardTheme.color.withOpacity(0.9)
                      : cardTheme.color,
                  shape: cardTheme.shape,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      children: <Widget>[
                        /// COURSE
                        Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _adjustText(_course, _cutoff),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: "Poppins"),
                            )),

                        /// TEACHER
                        Row(
                          children: <Widget>[
                            Icon(Icons.person,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20),
                            SizedBox(
                              width: 2,
                            ),
                            Container(
                                padding: EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                child: Text(_teacher,
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: "Poppins"))),
                          ],
                        ),
                        SizedBox(height: 3),

                        /// ROOM
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20),
                            SizedBox(
                              width: 2,
                            ),
                            Container(
                                padding: EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                child: Text(_room,
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: "Poppins"))),
                          ],
                        ),
                        SizedBox(height: 3),

                        /// UNTIL
                        Row(
                          children: <Widget>[
                            Icon(Icons.event_available,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20),
                            SizedBox(
                              width: 2,
                            ),
                            Container(
                                padding: EdgeInsets.all(2),
                                alignment: Alignment.centerLeft,
                                child: Text(_until,
                                    style: TextStyle(
                                        fontSize: 12, fontFamily: "Poppins"))),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ]),
    );
  }

  String _adjustText(String course, int cutOff) {
    if(course.length > cutOff) {
      return course.substring(0,cutOff) + " ...";
    }
    return course;
  }

}
