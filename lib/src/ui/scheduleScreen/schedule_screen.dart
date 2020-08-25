import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';
import 'package:vseschedule_03/src/resources/repository.dart';

import '../../blocs/schedule_bloc.dart';
import '../../blocs/schedule_bloc_provider.dart';
import '../../vschedule_app.dart';
import '../picker_widget.dart';
import 'event_widget.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScheduleScreenState();
  }
}

class ScheduleScreenState extends State<ScheduleScreen> {

  static const String _BGRND_IMG = "images/schedule_pixel2_960_mirr.jpg";
  ScheduleBloc bloc;
  final Repository repository = Repository.getInstance();
  final _log = Logger('ScheduleScreen');


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    bloc = ScheduleBlocProvider.of(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = deviceHeight * 0.2;
    final double bottomBarHeight = deviceHeight * 0.1;
    final double bodyHeight = deviceHeight - (appBarHeight + bottomBarHeight);

    return Container(
      /// Background
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(_BGRND_IMG), fit: BoxFit.cover),
      ),

      child: Scaffold(
          backgroundColor: Colors.transparent,
          /// DatePickerWidget
          appBar: scheduleHeader(bloc, deviceHeight, deviceWidth),

          body: Container(
            width: deviceWidth,
            height: bodyHeight,
            color: Color(0xFF27292B),
            /// ScheduleBody
            child: buildSchedule(),
          ),
          /// Bottom navigation
          bottomNavigationBar: scheduleFooter(deviceHeight)
      ),
    );
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

                return buildEventsOnDay(dbStream, selectedDay);

              } else {
                return loading();
              }
            },
          );
        }
        else {
          return loading();
        }
      },
    );
  }

  PreferredSize scheduleHeader(ScheduleBloc bloc, double deviceHeight, double deviceWidth) {

    // GETS CALLED TWICE, WTF???
    _log.info("sched header");

    return PreferredSize(
      preferredSize: Size.fromHeight(deviceHeight * 0.2),
      child: Column(
        children: <Widget>[
          Container(height: (deviceHeight * 0.01)),
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

  Widget loading() {
    return Center(
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(greenBackground),
        )
    );
  }

  Widget buildEventsOnDay(
      AsyncSnapshot<dynamic> dbStream,
      AsyncSnapshot<dynamic> selectedDay
    ) {

    List<ScheduleEvent> daySchedule = dbStream.data;
    if(daySchedule.isEmpty) {
      return Center(child: Text("Volníčko :-)"));
    }
    else {
      List<Widget> widgetsToDisplay = List<ScheduleEventWidget>();
      Map<DateTime, List<ScheduleEvent>> normalized = _normalize(daySchedule);
      List<DateTime> sortedKeys = normalized.keys.toList();
      sortedKeys.sort();

      sortedKeys.forEach((key) {
        widgetsToDisplay.add(ScheduleEventWidget(normalized[key], normalized[key][0].getState(TimeOfDay.now(), selectedDay.data as int)));
      });


      return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(children: widgetsToDisplay),
          )
      );
    }
  }

  /// Method which sets a structure to overlapping events
  Map<DateTime, List<ScheduleEvent>> _normalize(List<ScheduleEvent> l) {
    Map<DateTime, List<ScheduleEvent>> normalized = Map<DateTime, List<ScheduleEvent>>();

    l.forEach((el) {
      normalized.putIfAbsent(el.getDateTimeFrom(), () => []);
      normalized.putIfAbsent(el.getDateTimeUntil(), () => []);
    });

    l.forEach((el) {
      normalized.keys.forEach((key) {
        if (el.getDateTimeFrom() == key) {
          normalized[key].add(el);
        }
        if (el.getDateTimeFrom().isBefore(key) && el.getDateTimeUntil().isAfter(key)) {
          normalized[key].add(el);
        }
      });
    });

    normalized.removeWhere((key, value) => normalized[key].isEmpty);

    return normalized;
  }

}

