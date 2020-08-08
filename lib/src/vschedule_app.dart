import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/resources/repository.dart';
import 'package:vseschedule_03/src/ui/scheduleScreen/schedule_screen.dart';

import 'blocs/login_bloc_provider.dart';
import 'blocs/schedule_bloc_provider.dart';
import 'ui/login_screen.dart';

// Should be moved to theme
const Color blackBackground = Color(0xFF212325);
const Color greenBackground = Color(0xFF2C8F4E);
const Color greenBackgroundFaded = Color(0x882C8F4E);
const Color greenBackgroundVeryFaded = Color(0xFF508964);
const Color whiteFont = Color(0xFFB9B9B9);
const Color whiteFontFaded = Color(0x55B9B9B9);
const Color orange = Color(0xFFFBAF3F);
const Color cyan = Color(0xFF27AAE0);
const Color darkBlue = Color(0xFF3E5BA7);


class VscheduleApp extends StatelessWidget {

  Repository repo;

  Widget build(BuildContext context) {

    /// App display properties
    SystemChrome.setEnabledSystemUIOverlays([]);// disable upper bar
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    /// Logging setup
    Logger.root.level = Level.CONFIG;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.loggerName}: ${record.time}: ${record.message}');
    });

    repo = Repository.getInstance();
    bool signedInPreviously = repo.isEmpty();

    return MaterialApp(
      title: 'vschedule',
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      darkTheme: vscheduleDarkThemeData(),


      // TODO: this boolean does not work
      initialRoute: signedInPreviously ? "/login" : "/schedule",
      routes: {
        "/login": (ctxt) => LoginBlocProvider(child: LoginScreen()),
        "/schedule": (ctxt) => ScheduleBlocProvider(child: ScheduleScreen())
      },
    );
  }


  /// Common features used across the app
  /// Colors, Fonts, Buttons, ...
  ThemeData vscheduleDarkThemeData() {
    return ThemeData(

      /// Text
      textTheme: TextTheme(
        headline5: // LOGO "vschedule" on Login Page
        TextStyle(fontFamily: "Poppins", fontSize: 50.0, fontWeight: FontWeight.w100, letterSpacing: 1.5, color: greenBackground,
            shadows: [
              Shadow(offset: Offset(-0.3, -0.3), color: greenBackground),/*bottomLeft*/
              Shadow(offset: Offset(0.3, -0.3), color: greenBackground),/*bottomRight*/
              Shadow(offset: Offset(0.3, 0.3), color: greenBackground),/*topRight*/
              Shadow(offset: Offset(-0.3, 0.3), color: greenBackground),/*topLeft*/
            ]),
        headline6: // Page Title, "Rozvrh" on ScheduleScreen
        TextStyle(letterSpacing: 1.0, fontFamily: "Poppins", fontSize: 32),
        bodyText2: TextStyle(fontSize: 15.0, color: whiteFont),
      ),
      fontFamily: 'Quicksand',

      /// Colors
      scaffoldBackgroundColor: blackBackground,
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

      /// Card Widget
      cardTheme: CardTheme(
        elevation: 0.0,
        color: blackBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      cardColor: blackBackground,
    );
  }
}
