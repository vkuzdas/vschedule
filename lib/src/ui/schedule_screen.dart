import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:vseschedule_03/src/ui/event_card.dart';
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
          appBar: PreferredSize(
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
          ),
          body: Container(
            height: bodyHeight,
            color: Color(0xFF27292B),
            child: Row(
              children: <Widget>[
                //Time
                Expanded(
                  flex: 2,
//
                  child: Container(decoration: BoxDecoration(border: Border.all(width: 0.5)),
                    child: Column(children: <Widget>[
                      Container(height: 25,),
                      Text("9:15 AM"),
                      Container(height: 50,),
                      Text("11:00 AM"),
                      Container(height: 50,),
                      Text("12:45 AM"),
                    ],)),
                ),
                // Line & bullet
                Expanded(
                  flex: 1,
                  child: Container(decoration: BoxDecoration(border: Border.all(width: 0.5))),
                ),
                Expanded(
                  flex: 4,
                  child: Container(decoration: BoxDecoration(border: Border.all(width: 0.5)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topRight,
                            height: 300,
                            width: 300,
                            child: EventCard(Colors.red, 140, 220, "Java", "Pelikán", "JM 105" ),
                          )
                        ],
                      )
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
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
          ),
        ),
      ),
    );
  }

  card() {
      return Stack(
        overflow: Overflow.visible,
        children:<Widget>[
          Positioned(
            top: 0.1,
            right: 10,
            height: 100,
            width: 200,
            child: Card(
              elevation: 0.0,
              color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
            ),
          ),
          Positioned(
            right: 0,
            height: 100.2,
            width: 200,
            child: Card(
              elevation: 0.0,
              color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
            ),
          ),

//            Positioned(
//              bottom: 30,
//              child: Card(
//              color: Colors.grey[900],
//
//              shape: RoundedRectangleBorder(
//  //          side: BorderSide(color: Colors.white70, width: 1),
//                borderRadius: BorderRadius.circular(10),
//              ),
//
//              margin: EdgeInsets.all(10.0),
//              child: Container(
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.stretch,
//                  children: <Widget>[
////                      Padding(
////                        padding: const EdgeInsets.all(4.0),
////                        child: Text(
////                          'Programming in Java Language',
////                          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w800),
////
////                        ),
////                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(4.0),
//                        child: Row(
//                          children: <Widget>[
//                            Icon(Icons.location_on, color: Theme.of(context).colorScheme.secondary),
//                            Text(
//                              'JM 105',
//                              style: TextStyle(fontSize: 14, color: Colors.white),
//                            ),
//                          ],
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(4.0),
//                        child: Row(
//                          children: <Widget>[
//                            Icon(Icons.person, color: Theme.of(context).colorScheme.secondary),
//                            Text(
//                              'J. Pavlíčková',
//                              style: TextStyle(fontSize: 14, color: Colors.white),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
        ]
      );
  }

}

