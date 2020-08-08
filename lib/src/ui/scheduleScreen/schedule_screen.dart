import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';
import 'package:vseschedule_03/src/resources/repository.dart';

import '../../blocs/schedule_bloc.dart';
import '../../blocs/schedule_bloc_provider.dart';
import '../picker_widget.dart';
import 'event_widget.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleScreenState();
  }
}

class ScheduleScreenState extends State<ScheduleScreen> {

  ScheduleBloc bloc;
  final Repository repository = Repository.getInstance();
  final _log = Logger('ScheduleScreen');


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
//    bloc.dispose();
    super.dispose();
  }



  Widget buildSchedule() {
    return StreamBuilder(
      stream: bloc.selectedDay,
      builder: (streamContext, selectedDay) {
        if (selectedDay.connectionState == ConnectionState.active) {
          int weekday = ((selectedDay.data as int) + DateTime.now().weekday) % 7; // selected -> weekday conversion
          return FutureBuilder(
            future: repository.getEventsOnWeekday(weekday),
            builder: (futureContext, dbStream) {
              if(dbStream.connectionState == ConnectionState.done) {
                List<ScheduleEvent> daySchedule = dbStream.data;
                List<ScheduleEventWidget> dayWidgets = List<ScheduleEventWidget>();
                if(daySchedule != null) {
                  daySchedule.forEach((ev) {
                    dayWidgets.add(ScheduleEventWidget(ev, ev.getState(TimeOfDay.now(), selectedDay.data as int)));
                  });
                }
                return SingleChildScrollView(
                  child: Column(
                    children: dayWidgets,
                  )
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    bloc = ScheduleBlocProvider.of(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = deviceHeight * 0.27;
    final double bottomBarHeight = deviceHeight * 0.1;
    final double bodyHeight = deviceHeight - (appBarHeight + bottomBarHeight);

    return Container(
      /// Background
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/schedule_pixel2_960.jpg"),
            fit: BoxFit.cover
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        /// DatePickerWidget
        //TODO: pass in bloc, stream dates into it
        appBar: scheduleHeader(bloc, deviceHeight, deviceWidth),
        body: Container(
          height: bodyHeight,
          color: Color(0xFF27292B),
          child: buildSchedule(),
//          child: Column(
//            children: buildSchedule()
//          )
        ),
        /// Bottom navigation
        bottomNavigationBar: scheduleFooter(deviceHeight)
      ),
    );
  }

  PreferredSize scheduleHeader(ScheduleBloc bloc, double deviceHeight, double deviceWidth) {

    // GETS CALLED TWICE, WTF???
    _log.info("sched header");

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
          DatePicker(onChanged: bloc.selectedDaySink,)
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

}

