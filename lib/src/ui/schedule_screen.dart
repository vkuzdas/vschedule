import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';

import '../blocs/schedule_bloc.dart';
import '../blocs/schedule_bloc_provider.dart';
import 'event/event_card_widget.dart';
import 'event/event_line_bullet_widget.dart';
import 'event/event_widget.dart';
import 'picker_widget.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleScreenState();
  }
}

class ScheduleScreenState extends State<ScheduleScreen> {

  PreferredSize scheduleHeader(double deviceHeight, double deviceWidth) {
    return PreferredSize(
      preferredSize: Size.fromHeight(deviceHeight * 0.27),
      child: Column(
        children: <Widget>[
          Container(height: (deviceHeight * 0.12)),
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
          DatePicker()
        ],
      ),
    );
  }

  SizedBox scheduleFooter(double deviceHeight) {
    return SizedBox(
      height: deviceHeight*0.1,
      child: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.schedule, color: Theme.of(context).colorScheme.secondary,),
            title: new Text('Rozvrh', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_box),
            title: new Text('About'),
          ),
        ],
      ),
    );
  }

  Container eventTimeSegment() {
    return Container(
        decoration: BoxDecoration(border: Border.all(width: 0.5)),
        child: Column(children: <Widget>[
          Container(height: 10,),
          Text("9:15 AM", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, fontFamily: "Poppins"),),
        ],));
  }

  EventLineBulletWidget eventMidSegment() {
    return EventLineBulletWidget(ScheduleEventState.PAST);
  }

  Container eventCardSegment() {
    return Container(
      alignment: Alignment.topRight,
      height: 140,
      width: 300,
      child: EventCardWidget(Colors.red, 130, 220, "Programming in Java Language", "Pelikán", "JM 105" ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = deviceHeight * 0.27;
    final double bottomBarHeight = deviceHeight * 0.1;
    final double bodyHeight = deviceHeight - (appBarHeight + bottomBarHeight);
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
          appBar: scheduleHeader(deviceHeight, deviceWidth),
          body: Container(
            height: bodyHeight,
            color: Color(0xFF27292B),
            child: ScheduleEventWidget(
              ScheduleEvent.fromStrings("Mon", "9:15", "10:30", "Java", "Seminar", "SB 123", "Pelikan"),
              ScheduleEventState.PAST
            )
          ),
          bottomNavigationBar: scheduleFooter(deviceHeight)
        ),
      ),
    );
  }

}

