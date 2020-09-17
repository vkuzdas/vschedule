import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:logging/logging.dart';
import 'package:vseschedule_03/src/resources/credentials/credential_provider.dart';
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
  LoginBloc bloc;
  final _log = Logger('LoginScreen');
  CredentialProvider credProvider;
  DBProvider db;

  static final String _BGRND_IMG = "images/login_pixel2_960.jpg";

  @override
  void initState() {
    super.initState();
    credProvider = CredentialProvider.getInstance();
    db = DBProvider.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    bloc = LoginBlocProvider.of(context);
    bool notNull(Object o) => o != null;


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
            margin: EdgeInsets.fromLTRB(
                deviceWidth * 0.1, 0.0, deviceWidth * 0.1, 0.0),
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(), // no glow on the end
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
                            return (snapshot.data == true
                                ? progressIndicator()
                                : Container(/*EMPTY*/));
                          }),
                    ),
                    Container(height: deviceHeight * 0.05),
                    xnameField(bloc),
                    passwordField(bloc),
                    Container(height: deviceHeight * 0.05),
                    exceptionNotifier(bloc),
                    Container(height: deviceHeight * 0.05),
                    Container(
//                  height: 50, //6,64% width: 200, //47,225%
                      height: deviceHeight * 0.0664,
                      width: deviceWidth * 0.47225,
                      child: StreamBuilder(
                          stream: bloc.loading,
                          builder: (context, snapshot) {
                            return snapshot.data == false
                                ? submitButton(bloc, context)
                                : Container(/*EMPTY*/);
                          }),
                    ),
                    Container(height: deviceHeight * 0.01),
                  ]
                      .where(notNull)
                      .toList(), // since dart does not like null list members
                )),
          ),
        ));
  }

  Widget progressIndicator({double height}) {
    _log.info("ProgressIndicator rebuilt");
    return LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenBackground),
      backgroundColor: AppColors.blackBackground1,
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
  Widget xnameField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.xname,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.sinkXname,
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

  Widget submitButton(LoginBloc bloc, BuildContext buildContext) {
    _log.info("SubmitButton rebuilt");
    return FutureBuilder(
      future: db.isFirstLogin(),
      builder: (context, isFirstLogin) {
        if (isFirstLogin.connectionState == ConnectionState.done) {
          return StreamBuilder(
              stream: bloc.pwdXnmCombined,
              builder: (context, snapshot) {
                return RaisedButton(
                  onPressed: snapshot.hasData
                      ? () async {
                          bool switchScreen = await bloc.submit();
                          if (switchScreen) {
                            if (isFirstLogin.data) {
                              print("first login");
                            } else {
                              print("second login");
                            }
                            Navigator.pushNamed(buildContext, "/setPin");
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
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(100, 0, 0, 0))
                        ]),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  color: AppColors.greenBackground,
                  disabledColor: AppColors.greenBackgroundVeryFaded,
                );
              });
        } else {
          return Container();
        }
      },
    );
  }


}