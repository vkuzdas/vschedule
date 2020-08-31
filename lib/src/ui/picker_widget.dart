import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {

  Function(int) onChanged;
  DatePicker({this.onChanged}) : assert(onChanged != null);

  @override
  State<StatefulWidget> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {

  static final Map<int, String> _dayMap = {
    1: "Po",
    2: "Út",
    3: "St",
    4: "Čt",
    5: "Pá",
    6: "So",
    7: "Ne"
  };
  static final Map<int, String> _monthMap = {
    1: "LEDEN",
    2: "ÚNOR",
    3: "BŘEZEN",
    4: "DUBEN",
    5: "KVĚTEN",
    6: "ČERVEN",
    7: "ČERVENEC",
    8: "SRPEN",
    9: "ZÁŘÍ",
    10: "ŘÍJEN",
    11: "LISTOPAD",
    12: "PROSINEC"
  };

  int _selected;
  String _selectedMonth;
  DateTime _NOW;
  FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _NOW = DateTime.now();
    _selected = 0;      /// today is 0th index
    _selectedMonth = getMonthTag(daysInFuture(_selected));
    _controller = FixedExtentScrollController(initialItem: 0);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double childSize = deviceWidth/7;

    return Column(
      children: <Widget>[
        Container( // dynamic Month text
            padding: EdgeInsets.only(left: deviceWidth * 0.05),
            width: deviceWidth,
            child: Text(
              _selectedMonth,
              textAlign: TextAlign.left,
              style: TextStyle(fontFamily: "Poppins", fontSize: 14),
            )
        ),
        Container( // day picker
          height: childSize,
          child: RotatedBox(
            quarterTurns: 3,
            child: ListWheelScrollView.useDelegate(
              onSelectedItemChanged: (int) {
                widget.onChanged(int); // pass selected into bloc sink
                setState(() { /// Rebuild selectedWidget, possibly Month text
                  _selected = int;
                  _selectedMonth =
                  ( getMonthTag(daysInFuture(int)) == _selectedMonth ) ?
                  _selectedMonth : getMonthTag(daysInFuture(int));
                });
              },
              perspective: double.minPositive,
              controller: _controller,
              physics: SlowFixedExtentScrollPhysics(),
              itemExtent: childSize, // 7 days per width
              childDelegate: ListWheelChildBuilderDelegate(
                  builder: (ctxt, int) {
                    return RotatedBox(quarterTurns: 1,
                        child: selectedWidget(int)
                    );
                  }
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// State widgets
  Widget selectedWidget(int i) {
    if (i == _selected) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _NOW.add(Duration(days: i)).day.toString(), /// [1..31]
            style: TextStyle(fontFamily: "Poppins" ,fontSize: 16, fontWeight: FontWeight.w800),
          ),
          Text(
            _getDayTag(_NOW.add(Duration(days: i))), /// [Po...Ne]
            style: TextStyle(fontFamily: "Poppins" ,fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ],
      );
    }
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(DateTime.now().add(Duration(days: i)).day.toString(), style: TextStyle(color: Color(0x88B9B9B9)),),
          Text(""),
        ],
      );
    }
  }


  ///Helper methods
  String _getDayTag(DateTime time) {
    return _dayMap[time.weekday]; /// [Po...Ne]
  }

  String getMonthTag(DateTime time) {
    return _monthMap[time.month]; /// [Leden...Prosinec]
  }

  DateTime daysInFuture(int i) {
    return _NOW.add(Duration(days:i));
  }

}

/// Custom Scroll physics, stops on a widget position
class SlowFixedExtentScrollPhysics extends FixedExtentScrollPhysics {
  const SlowFixedExtentScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  double get minFlingVelocity => double.infinity;

  @override
  double get maxFlingVelocity => double.infinity;

  @override
  double get minFlingDistance => double.infinity;

//  @override
//  double carriedMomentum(double existingVelocity) {
//
//  }

  @override
  SlowFixedExtentScrollPhysics applyTo(ScrollPhysics ancestor) {
    return SlowFixedExtentScrollPhysics(parent: buildParent(ancestor));
  }
}