import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  double _height;
  double _width;
  int _cutoff;
  Color _color;

  final String _course;
  final String _teacher;
  final String _room;
  final String _entry;
  final String _until;
  final bool _goesInStack;

  EventCard(this._goesInStack, this._course, this._teacher, this._room,
      this._entry, this._until) {
    this._color = _colorFromString(_course.substring(0, 6));
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
      if (value < 16) {
        colour += '0';
      }
      colour += value.toRadixString(16);
    }
    return Color(int.parse(colour.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    if (_goesInStack) {
      _height = 120;
      _width = 230;
      _cutoff = 10; // 15,9387
    } else {
      _height = 140;
      _width = 250;
      _cutoff = 40; // 18,5977
    }

    CardTheme cardTheme = Theme.of(context).cardTheme;

    return Stack(
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
                color: (_entry.toLowerCase() == "lecture") ? cardTheme.color.withOpacity(0.9) : cardTheme.color,
                shape: cardTheme.shape,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: <Widget>[

                      /// COURSE
                      Container( padding: EdgeInsets.all(5),alignment: Alignment.centerLeft,
                          child: Text(_adjustText(_course, _cutoff), style: TextStyle(fontWeight: FontWeight.w800, fontFamily: "Poppins"),)
                      ),
                      /// TEACHER
                      Row(
                        children: <Widget>[
                          Icon(Icons.person, color: Theme.of(context).colorScheme.secondary, size: 20),
                          SizedBox(width: 2,),
                          Container( padding: EdgeInsets.all(2),alignment: Alignment.centerLeft,
                              child: Text(_teacher, style: TextStyle(fontSize: 12 ,fontFamily: "Poppins"))
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      /// ROOM
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_on, color: Theme.of(context).colorScheme.secondary, size: 20),
                          SizedBox(width: 2,),
                          Container( padding: EdgeInsets.all(2),alignment: Alignment.centerLeft,
                              child: Text(_room, style: TextStyle(fontSize: 12 ,fontFamily: "Poppins"))
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      /// UNTIL
                      Row(
                        children: <Widget>[
                          Icon(Icons.event_available, color: Theme.of(context).colorScheme.secondary, size: 20),
                          SizedBox(width: 2,),
                          Container( padding: EdgeInsets.all(2),alignment: Alignment.centerLeft,
                              child: Text(_until, style: TextStyle(fontSize: 12 ,fontFamily: "Poppins"))
                          ),
                        ],
                      ),

                    ],
                  ),
                )
            ),
          ),
        ]
    );
  }

  String _adjustText(String course, int cutOff) {
    if(course.length > cutOff) {
      return course.substring(0,cutOff) + " ...";
    }
    return course;
  }

}
