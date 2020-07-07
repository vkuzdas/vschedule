import 'package:flutter/material.dart';
import 'package:vseschedule_03/src/resources/repository.dart';
import 'package:vseschedule_03/src/ui/schedule_screen.dart';

import 'blocs/login_bloc_provider.dart';
import 'ui/login_screen.dart';
import 'package:flutter/services.dart';

const Color blackBackground = Color(0xFF212325);
const Color greenBackground = Color(0xFF2C8F4E);
const Color greenBackgroundFaded = Color(0x882C8F4E);
const Color greenBackgroundVeryFaded = Color(0xFF508964);
const Color whiteFont = Color(0xFFB9B9B9);
const Color whiteFontFaded = Color(0x88B9B9B9);
const Color orange = Color(0xFFFBAF3F);
const Color cyan = Color(0xFF27AAE0);
const Color darkBlue = Color(0xFF3E5BA7);


class VscheduleApp extends StatelessWidget {

  Repository repo;

  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([]);// disable upper bar
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    repo = Repository();
    bool signedInPreviously = repo.isEmpty();

    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      darkTheme: vscheduleDarkThemeData(),

      initialRoute: signedInPreviously ? "/login" : "/schedule",
      routes: {
        "/login": (ctxt) => LoginBlocProvider(child: LoginScreen()),
        "/schedule": (ctxt) => ScheduleScreen()
      },

      title: 'vschedule',
    );
  }

  ThemeData vscheduleDarkThemeData() {
    return ThemeData(

      /// Colors
      scaffoldBackgroundColor: blackBackground,
      cardColor: blackBackground,

      colorScheme: ColorScheme.fromSwatch(
        cardColor: blackBackground,
        backgroundColor: blackBackground,
        accentColor: greenBackground,
        brightness: Brightness.dark,
        errorColor: orange,
      ),

      /// Buttons
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
        ),
        buttonColor: greenBackground,
        disabledColor: greenBackgroundVeryFaded,
      ),


      /// TextInputField
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 16, fontFamily: "Quicksand", color: whiteFontFaded),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: greenBackgroundFaded),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: greenBackground)
          ),
          fillColor: blackBackground
      ),

      /// Text
      textTheme: TextTheme(

        headline: // LOGO "vschedule" on Login Page
          TextStyle(fontFamily: "Poppins", fontSize: 50.0, fontWeight: FontWeight.w100, letterSpacing: 1.5, color: greenBackground,
            shadows: [
              Shadow(offset: Offset(-0.3, -0.3), color: greenBackground/*bottomLeft*/),
              Shadow(offset: Offset(0.3, -0.3), color: greenBackground/*bottomRight*/),
              Shadow(offset: Offset(0.3, 0.3), color: greenBackground/*topRight*/),
              Shadow(offset: Offset(-0.3, 0.3), color: greenBackground/*topLeft*/),
            ]),

        title: // Page Title, "Rozvrh" on ScheduleScreen
          TextStyle(letterSpacing: 1.0, fontFamily: "Poppins", fontSize: 32),

        body1: TextStyle(fontSize: 15.0, color: whiteFont),


      ),
      cardTheme: CardTheme(
        elevation: 0.0,
        color: blackBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      fontFamily: 'Quicksand',


    );
  }


}
