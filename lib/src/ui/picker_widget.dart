import 'package:flutter/material.dart';

class PickerWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return PickerWidgetState();
  }

}

class PickerWidgetState extends State<PickerWidget> {

  static final Map<int, String> dayMap = {
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

  int selected;
  String selectedMonth;
  DateTime NOW;
  // TODO: Add some notifier to this so that [ScheduleBloc] knows what date should be built


  @override
  void initState() {
    super.initState();
    NOW = DateTime.now();
    selected = 0;      /// today is 0th index
    selectedMonth = getMonthTag(daysBack(selected));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[


        Container( // dynamic Month text
            padding: EdgeInsets.only(left: deviceWidth * 0.05),
            width: deviceWidth,
            child: Text(
              selectedMonth,
              textAlign: TextAlign.left,
              style: TextStyle(fontFamily: "Poppins", fontSize: 14),
            )
        ),

        Container(
          height: 60,
          child: RotatedBox(
            quarterTurns: 1,
            child: ListWheelScrollView.useDelegate(
              onSelectedItemChanged: (int) {
                setState(() { /// Rebuild selectedWidget, possibly Month text
                  selected = int;
                  selectedMonth =
                  ( getMonthTag(daysBack(int)) == selectedMonth ) ?
                  selectedMonth : getMonthTag(daysBack(int));
                });
              },
              perspective: double.minPositive,
              controller: FixedExtentScrollController(initialItem: 0),
              physics: SlowFixedExtentScrollPhysics(),
              itemExtent: 60,
              childDelegate: ListWheelChildBuilderDelegate(
                  builder: (ctxt, int) {
                    return RotatedBox(quarterTurns: 3,
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
    if (i == selected) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(
              DateTime.now().subtract(Duration(days: i)).day.toString(), /// [1..31]
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Text(
              _getDayTag(DateTime.now().subtract(Duration(days: i))), /// [Po...Ne]
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      );
    }
    else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(DateTime.now().subtract(Duration(days: i)).day.toString()),
            Text(""),
          ],
        ),
      );
    }
  }


  ///Helper methods
  String _getDayTag(DateTime time) {
    return dayMap[time.weekday]; /// [Po...Ne]
  }

  String getMonthTag(DateTime time) {
    return _monthMap[time.month]; /// [Leden...Prosinec]
  }

  DateTime daysBack(int i) {
    return NOW.subtract(Duration(days:i));
  }

}

/// Custom Scroll physics, stops on a widget position
class SlowFixedExtentScrollPhysics extends FixedExtentScrollPhysics {
  const SlowFixedExtentScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  double get minFlingVelocity => 5.0;

  @override
  double get maxFlingVelocity => 5.0;

  @override
  double get minFlingDistance => 5.0;

  @override
  SlowFixedExtentScrollPhysics applyTo(ScrollPhysics ancestor) {
    return SlowFixedExtentScrollPhysics(parent: buildParent(ancestor));
  }
}