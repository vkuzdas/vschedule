import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'picker_widget.dart';
import '../blocs/schedule_bloc.dart';
import '../blocs/schedule_bloc_provider.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleScreenState();
  }
}

class ScheduleScreenState extends State<ScheduleScreen> {

  final Map<int, String> _dayMap = {
    1: "Po",
    2: "Út",
    3: "St",
    4: "Čt",
    5: "Pá",
    6: "So",
    7: "Ne"
  };

  final Map<int, String> _monthMap = {
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

  String _getDayTag(DateTime time) {
    return _dayMap[time.weekday];
  }

  String _getMonthTag(DateTime time) {
    return _monthMap[time.month]; /// [Leden...Prosinec]
  }

  DateTime daysBack(int i) {
    return _NOW.subtract(Duration(days:i));
  }

  @override
  void initState() {
    super.initState();
    _NOW = DateTime.now();
    _selected = 0;      /// today is 0th index
    _selectedMonth = _getMonthTag(daysBack(_selected));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final bloc = ScheduleBloc();

    return ScheduleBlocProvider(

      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/schedule_pixel2_960.jpg"),
              fit: BoxFit.cover),
        ),

        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(deviceHeight * 0.4),
            child: Column(
              children: <Widget>[

                Container(height: (deviceHeight * 0.15)),

                Container(
                  padding: EdgeInsets.only(left: deviceWidth * 0.05),
                  height: (deviceHeight * 0.05),
                  width: deviceWidth,
                  child: Text(
                    "Rozvrh",
                    textAlign: TextAlign.left,
                    style: TextStyle(letterSpacing: 1.0, fontFamily: "Poppins", fontSize: 32),
                  ),
                ),

                Container(height: deviceHeight * 0.02),

                PickerWidget()

//                Container(
//                  padding: EdgeInsets.only(left: deviceWidth * 0.05),
//                  width: deviceWidth,
//                    child: Text(
//                      _selectedMonth,
//                      textAlign: TextAlign.left,
//                      style: TextStyle(fontFamily: "Poppins", fontSize: 14),
//                    )
//                ),
//
//                Container(
//                  height: 60,
//                  child: RotatedBox(
//                    quarterTurns: 1,
//                    child: ListWheelScrollView.useDelegate(
//                      onSelectedItemChanged: (int) {
//                        setState(() { /// Rebuild selectedWidget, possibly Month text
//                          _selected = int;
//                          _selectedMonth =
//                            ( _getMonthTag(daysBack(int)) == _selectedMonth ) ?
//                                  _selectedMonth : _getMonthTag(daysBack(int));
//                        });
//                      },
//                      perspective: double.minPositive,
//                      controller: FixedExtentScrollController(initialItem: 0),
//                      physics: SlowFixedExtentScrollPhysics(),
//                      itemExtent: 60,
//                      childDelegate: ListWheelChildBuilderDelegate(
//                          builder: (ctxt, int) {
//                            return RotatedBox(quarterTurns: 3,
//                                child: selectedWidget(int)
//                            );
//                          }
//                      ),
//                    ),
//                  ),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget selectedWidget(int i) {
    if (i == _selected) {
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
}


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
