import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/resources/repository.dart';
import 'package:vseschedule_03/src/ui/scheduleScreen/schedule_screen.dart';

import 'blocs/login_bloc_provider.dart';
import 'blocs/schedule_bloc_provider.dart';
import 'ui/app_colors.dart';
import 'ui/login_screen.dart';

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

      title: 'všerozvrh',
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      darkTheme: vscheduleDarkThemeData(),
      debugShowCheckedModeBanner: false,

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
      accentColor: AppColors.whiteFontFaded,

      /// Text
      textTheme: TextTheme(
        headline5: // LOGO "vschedule" on Login Page
            TextStyle(
                fontFamily: "Poppins",
                fontSize: 50.0,
                fontWeight: FontWeight.w100,
                letterSpacing: 1.5,
                color: AppColors.greenBackground,
                shadows: [
              Shadow(
                  offset: Offset(-0.3, -0.3), color: AppColors.greenBackground),
              /*bottomLeft*/
              Shadow(
                  offset: Offset(0.3, -0.3), color: AppColors.greenBackground),
              /*bottomRight*/
              Shadow(
                  offset: Offset(0.3, 0.3), color: AppColors.greenBackground),
              /*topRight*/
              Shadow(
                  offset: Offset(-0.3, 0.3),
                  color: AppColors.greenBackground), /*topLeft*/
            ]),
        headline6: // Page Title, "Rozvrh" on ScheduleScreen
            TextStyle(letterSpacing: 1.0, fontFamily: "Poppins", fontSize: 32),
        bodyText2: TextStyle(fontSize: 15.0, color: AppColors.whiteFont),
      ),
      fontFamily: 'Quicksand',

      /// Colors
      scaffoldBackgroundColor: AppColors.blackBackground1,
      colorScheme: ColorScheme.fromSwatch(
        cardColor: AppColors.blackBackground1,
        backgroundColor: AppColors.blackBackground1,
        accentColor: AppColors.greenBackground,
        brightness: Brightness.dark,
        errorColor: AppColors.orange,
      ),

      /// Buttons
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)
        ),
        buttonColor: AppColors.greenBackground,
        disabledColor: AppColors.greenBackgroundVeryFaded,
      ),

      /// TextInputField
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 16,
              fontFamily: "Quicksand",
              color: AppColors.whiteFontFaded),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.greenBackgroundFaded),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.greenBackground)
          ),
          fillColor: AppColors.blackBackground1
      ),

      /// Card Widget
      cardTheme: CardTheme(
        elevation: 0.0,
        color: AppColors.blackBackground1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      cardColor: AppColors.blackBackground1,
    );
  }
}
