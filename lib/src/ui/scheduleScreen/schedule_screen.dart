import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';
import 'package:vseschedule_03/src/resources/repository.dart';
import 'package:vseschedule_03/src/ui/app_colors.dart';

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

  static const String _BGRND_IMG = "images/schedule_pixel2_960_mirr.jpg";
  ScheduleBloc bloc;
  final Repository repository = Repository.getInstance();
  final _log = Logger('ScheduleScreen');
  Size _devSize;

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

    _devSize = MediaQuery
        .of(context)
        .size;
    final double appBarHeight = _devSize.height * 0.2;
    final double bottomBarHeight = _devSize.height * 0.1;
    final double bodyHeight = _devSize.height -
        (appBarHeight + bottomBarHeight);

    return Container(

      /// Background
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(_BGRND_IMG), fit: BoxFit.cover),
      ),

      child: Scaffold(
          backgroundColor: Colors.transparent,

          /// DatePickerWidget
          appBar: scheduleHeader(bloc),

          body: Container(
            width: _devSize.width,
            height: bodyHeight,
            color: AppColors.blackBackground2,

            /// ScheduleBody
            child: buildSchedule(),
          ),

          /// Bottom navigation
          bottomNavigationBar: scheduleFooter(_devSize.height)
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

  PreferredSize scheduleHeader(ScheduleBloc bloc) {
    // GETS CALLED TWICE, WTF???
    _log.info("sched header");

    return PreferredSize(
      preferredSize: Size.fromHeight(_devSize.height * 0.2),
      child: Column(
        children: <Widget>[
          Container(height: (_devSize.height * 0.01)),
          Container(
            padding: EdgeInsets.only(left: _devSize.width * 0.05),
            height: (_devSize.height * 0.05),
            width: _devSize.width,
            child: Text(
              "Rozvrh",
              textAlign: TextAlign.left,
              style: TextStyle(letterSpacing: 1.0,
                  fontFamily: "Poppins",
                  fontSize: _devSize.height * 0.045),
            ),
          ),
          Container(height: _devSize.height * 0.02),
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
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenBackground),
    )
    );
  }

  Widget buildEventsOnDay(AsyncSnapshot<dynamic> dbStream,
      AsyncSnapshot<dynamic> selectedDay) {
    List<ScheduleEvent> daySchedule = dbStream.data;
    if(daySchedule.isEmpty) {
      return Center(child: Text("Volníčko :-)"));
    }
    else {
      List<Widget> widgetsToDisplay = List<ScheduleEventWidget>();
      Map<DateTime, ListQueue<ScheduleEvent>> normalized = _normalize(
          daySchedule);
      List<DateTime> sortedKeys = normalized.keys.toList();
      sortedKeys.sort();

      sortedKeys.forEach((key) {
        widgetsToDisplay.add(
            ScheduleEventWidget(
                normalized[key], selectedDay.data as int, _devSize));
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
  Map<DateTime, ListQueue<ScheduleEvent>> _normalize(List<ScheduleEvent> l) {
    Map<DateTime, ListQueue<ScheduleEvent>> normalized = Map<DateTime,
        ListQueue<ScheduleEvent>>();

    l.forEach((el) {
      normalized.putIfAbsent(el.getDateTimeFrom(), () => new ListQueue());
      normalized.putIfAbsent(el.getDateTimeUntil(), () => new ListQueue());
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

