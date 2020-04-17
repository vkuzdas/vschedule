import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:logger/logger.dart';
import '../blocs/schedule_bloc_provider.dart';
import '../logging/logger.dart';
import '../ui/schedule_screen.dart';

import '../blocs/login_bloc_provider.dart';
import '../blocs/login_bloc.dart';



const Color blackBackground = Color(0xFF212325);
const Color greenBackground = Color(0xFF2C8F4E);
const Color greenBackgroundFaded = Color(0x882C8F4E);
const Color greenBackgroundVeryFaded = Color(0xFF508964);
const Color whiteFont = Color(0xFFB9B9B9);
const Color whiteFontFaded = Color(0x88B9B9B9);
const Color orange = Color(0xFFFBAF3F);
const Color cyan = Color(0xFF27AAE0);
const Color darkBlue = Color(0xFF3E5BA7);

class LoginScreen extends StatefulWidget { // stateful since we will be showing progressIndicator and fade a button
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  LoginBloc bloc;
  Logger logger;


  @override
  void initState() {
    super.initState();
    logger = getLogger("LoginScreenState");
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    bloc = LoginBlocProvider.of(context);
    bool notNull(Object o) => o != null;

//    return LoginBlocProvider (
//        child: MaterialApp(
//          title: 'vschedule',
//          home: Container(
//            decoration: BoxDecoration(
//              image: DecorationImage(
//                image: AssetImage("images/login_pixel2_960.jpg"),
//                fit: BoxFit.cover,
//              ),
//            ),
//            child: Scaffold(
//              body: LoginScreen(),
//              backgroundColor: Colors.transparent,
//            ),
//          ),
//        )
//    );

    // TODO --** Scale everything relatively to devices width and height **--
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/login_pixel2_960.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold( // TODO: using Material messes up scrolling
        backgroundColor: Colors.transparent,
        body: Container(
          margin: EdgeInsets.fromLTRB(deviceWidth * 0.1, 0.0, deviceWidth * 0.1, 0.0),
          child: SingleChildScrollView(physics: BouncingScrollPhysics(), // no glow on the end
              child: Column(
              children: <Widget>[
                Container(height: deviceHeight * 0.2),
                logo(context),
                Container(height: deviceHeight * 0.01),
                Container(
                  height: 3,
                  child: StreamBuilder(
                      stream: bloc.loading,
                      builder: (context, snapshot) {
                        return (snapshot.data == true ?  progressIndicator() :  Container(/*EMPTY*/));
                      }
                  ),
                ),
                Container(height: deviceHeight * 0.05),
                xnameField(bloc),
                passwordField(bloc),
                Container(height: deviceHeight * 0.05),
                exceptionNotifier(bloc),
                Container(height: deviceHeight * 0.05),
                Container(
                  height: 50,
                  width: 200,
                  child: StreamBuilder(
                      stream: bloc.loading,
                      builder: (context, snapshot) {
                        return snapshot.data == false ? submitButton(bloc) : Container(/*EMPTY*/);
                      }
                  ),
                ),
                Container(height: deviceHeight * 0.01),
              ].where(notNull).toList(), // since dart does not like null list members
            )
          ),
        ),
      )
    );
  }

  Widget progressIndicator({double height}) {
    logger.i("ProgressIndicator rebuilt");
    return LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(greenBackground),
      backgroundColor: blackBackground,
    );
  }

  Widget logo(BuildContext context) {
    return Text(
      "vschedule",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline,
    );
  }

  /// Every change is sinked to the email stream.
  /// Alternative method onSubmitted and onEditing do not trigger in this use case.
  /// Feasible might be Form's onSaved method.
  /// onSaved does not trigger with every change, only on Form.save
  /// this unfortunately introduces Key besides already used Bloc.
  ///   ==>> using Bloc with onChange
  Widget xnameField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.xname,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.sinkXname,
          style: TextStyle(
              fontSize: 15,
              color: whiteFont
          ),
          decoration: InputDecoration(
            hintText: "xname",
            hintStyle: TextStyle(fontSize: 16, fontFamily: "Quicksand", color: whiteFontFaded),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: greenBackgroundFaded),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: greenBackground),
            ),
          ),
        );
      },
    );
  }

  Widget passwordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.sinkPassword,
          style: TextStyle(
            fontSize: 15,
            color: whiteFont
          ),
          obscureText: true,
          decoration: InputDecoration(
            hintText: "heslo",
            hintStyle: TextStyle(fontSize: 16, fontFamily: "Quicksand", color: whiteFontFaded),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: greenBackgroundFaded),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: greenBackground),
            ),
          ),
        );
      },
    );
  }

  Widget exceptionNotifier(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.exception,
      builder: (context, snapshot){
        return Text(
        snapshot.hasData ? "" + snapshot.data : "",
          style: TextStyle(
          fontFamily: "Quicksand",
            fontSize: 14.0,
            color: Colors.deepOrange,
          )
        );
      },
    );
  }

  Widget submitButton(LoginBloc bloc) {
    logger.i("SubmitButton rebuilt");
    return StreamBuilder(
      stream: bloc.pwdXnmCombined,
      builder: (context, snapshot) {
        return RaisedButton(
            onPressed: snapshot.hasData ? () async {
              bool switchScreen = await bloc.submit();
              if (switchScreen) {
                Navigator.pushNamed(
                    context,
                    "/schedule"
                );
              }
            } : null,
            child: Text(
              "Přihlásit se",
              style: TextStyle(
                fontFamily: "Quicksand",
                color: whiteFont,
                fontWeight: FontWeight.w400,
                fontSize: 18,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 5.0,
                    color: Color.fromARGB(100, 0, 0, 0)
                  )
                ]
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)
            ),
            color: greenBackground,
            disabledColor: greenBackgroundVeryFaded,
          );
        }
    );
  }


}