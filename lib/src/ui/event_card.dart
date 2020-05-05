import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {

  Color _color;
  double _height;
  double _width;
  String _course;
  String _teacher;
  String _room;

  //TODO: how will you differ between seminar and



  EventCard(this._color, this._height, this._width, this._course, this._teacher,
      this._room);

  @override
  Widget build(BuildContext context) {
    CardTheme cardTheme = Theme.of(context).cardTheme;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        /// Background
        Positioned(
          top: 0.1,
          right: 10,
          height: _height,
          width: _width,
          child: Card(
            elevation: cardTheme.elevation,
            color: _color,
            shape: cardTheme.shape,
          ),
        ),

        /// Foreground
        Positioned(
          right: 0,
          height: _height + 0.2,
          width: _width,
          child: Card(
            elevation: cardTheme.elevation,
            color: cardTheme.color,
            shape: cardTheme.shape,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                children: <Widget>[
                  Container( padding: EdgeInsets.all(5),alignment: Alignment.centerLeft,
                      child: Text("Programming in Java Language", style: TextStyle(fontWeight: FontWeight.w800, fontFamily: "Poppins"),)
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.person, color: Theme.of(context).colorScheme.secondary,),
                      Container( padding: EdgeInsets.all(2),alignment: Alignment.centerLeft,
                          child: Text("Pelikán", style: TextStyle(fontSize: 12 ,fontFamily: "Poppins"))
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Theme.of(context).colorScheme.secondary,),
                      Container( padding: EdgeInsets.all(2),alignment: Alignment.centerLeft,
                          child: Text("JM 105", style: TextStyle(fontSize: 12 ,fontFamily: "Poppins"))
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

}
