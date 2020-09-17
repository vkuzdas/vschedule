import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/resources/db/db_provider.dart';

import '../blocs/login_bloc.dart';
import '../blocs/login_bloc_provider.dart';
import 'app_colors.dart';

class LoginScreen extends StatefulWidget {
  // stateful since we will be showing progressIndicator and fade a button
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  static final String _SET_PIN_ROUTE = "/setPin";
  LoginBloc _bloc;
  final _log = Logger('LoginScreen');
  DBProvider _db;
  Size _devSize;

  static final String _BGRND_IMG = "images/login_pixel2_960.jpg";

  @override
  void initState() {
    super.initState();
    _db = DBProvider.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _devSize = MediaQuery.of(context).size;
    _bloc = LoginBlocProvider.of(context);

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_BGRND_IMG),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          // TODO: using Material messes up scrolling
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.fromLTRB(_devSize.width * 0.1, 0.0, _devSize.width * 0.1, 0.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(), // no glow on the end
              child: Column(
                children: <Widget>[
                  Container(height: _devSize.height * 0.2),
                  logo(context),
                  Container(height: _devSize.height * 0.01),
                  progressIndicator(),
                  Container(height: _devSize.height * 0.05),
                  xnameField(),
                  passwordField(),
                  Container(height: _devSize.height * 0.05),
                  exceptionNotifier(),
                  Container(height: _devSize.height * 0.05),
                  submitButton(context),
                  Container(height: _devSize.height * 0.01),
                ]
              )
            ),
          ),
        )
    );
  }

  Widget progressIndicator() {
    return Container(
        height: 3,
        child: StreamBuilder(
          stream: _bloc.isLoading,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data) {
              return LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenBackground),
                backgroundColor: AppColors.blackBackground1,
              );
            } else {
              return Container();
            }
          }
        )
    );
  }

  Widget logo(BuildContext context) {
    return Text(
      "vschedule",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  /// Every change is sinked to the email stream.
  /// Alternative method onSubmitted and onEditing do not trigger in this use case.
  /// Feasible might be Form's onSaved method.
  /// onSaved does not trigger with every change, only on Form.save
  /// this unfortunately introduces Key besides already used Bloc.
  ///   ==>> using Bloc with onChange
  Widget xnameField() {
    return TextField(
      onChanged: _bloc.sinkXname,
      style: TextStyle(
          fontSize: 15,
          color: AppColors.whiteFont
      ),
      decoration: InputDecoration(
        hintText: "xname",
        hintStyle: TextStyle(fontSize: 16,
            fontFamily: "Quicksand",
            color: AppColors.whiteFontFaded),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.greenBackgroundFaded),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.greenBackground),
        ),
      ),
    );
  }

  Widget passwordField() {
    return TextField(
      onChanged: _bloc.sinkPassword,
      style: TextStyle(
        fontSize: 15,
          color: AppColors.whiteFont
      ),
      obscureText: true,
      decoration: InputDecoration(
        hintText: "heslo",
        hintStyle: TextStyle(fontSize: 16,
            fontFamily: "Quicksand",
            color: AppColors.whiteFontFaded),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.greenBackgroundFaded),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.greenBackground),
        ),
      ),
    );
  }

  Widget exceptionNotifier() {
    return StreamBuilder(
      stream: _bloc.exception,
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

  Widget submitButton(BuildContext buildContext) {
    return Container(
      height: _devSize.height * 0.0664,
      width: _devSize.width * 0.47225,
      child: FutureBuilder(
        future: _db.isFirstLogin(),
        builder: (context, isFirstLogin) { /// No need for it in HERE!!! ommit
          if (isFirstLogin.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: _bloc.pwdXnmCombined,
                builder: (context, snapshot) {
                  return RaisedButton(
                    onPressed: snapshot.hasData ? () async {
                            bool switchScreen = await _bloc.submit();
                            if (switchScreen) {
                              if (isFirstLogin.data) {
                                print("first login");
                              } else {
                                print("second login");
                              }
                              _log.info("Navigating to $_SET_PIN_ROUTE");
                              Navigator.pushNamed(buildContext, _SET_PIN_ROUTE);
                            }
                          }
                        : null,
                    child: Text(
                      "Přihlásit se",
                      style: TextStyle(
                          fontFamily: "Quicksand",
                          color: AppColors.whiteFont,
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          shadows: [Shadow(offset: Offset(2.0, 2.0), blurRadius: 5.0, color: Color.fromARGB(100, 0, 0, 0))]
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: AppColors.greenBackground,
                    disabledColor: AppColors.greenBackgroundVeryFaded,
                  );
                }
            );
          } else {
            return Container();
          }
        },
      )
    );
  }
}