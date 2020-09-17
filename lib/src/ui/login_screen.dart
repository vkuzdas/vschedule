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
  double deviceWidth;
  double deviceHeight;

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
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    bloc = LoginBlocProvider.of(context);

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
            margin: EdgeInsets.fromLTRB(deviceWidth * 0.1, 0.0, deviceWidth * 0.1, 0.0),
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(), // no glow on the end
                child: Column(
                  children: <Widget>[
                    Container(height: deviceHeight * 0.2),
                    logo(context),
                    Container(height: deviceHeight * 0.01),
                    progressIndicator(bloc.isLoading),
                    Container(height: deviceHeight * 0.05),
                    xnameField(bloc),
                    passwordField(bloc),
                    Container(height: deviceHeight * 0.05),
                    exceptionNotifier(bloc),
                    Container(height: deviceHeight * 0.05),
                    submitButton(bloc, context),
                    Container(height: deviceHeight * 0.01),
                  ]
                )
            ),
          ),
        )
    );
  }

  Widget progressIndicator(Stream<bool> loading) {
    return Container(
        height: 3,
        child: StreamBuilder(
          stream: loading,
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
  Widget xnameField(LoginBloc bloc) {
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
  }

  Widget passwordField(LoginBloc bloc) {
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
    return Container(
      height: deviceHeight * 0.0664,
      width: deviceWidth * 0.47225,
      child: FutureBuilder(
        future: db.isFirstLogin(),
        builder: (context, isFirstLogin) {
          if (isFirstLogin.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: bloc.pwdXnmCombined,
                builder: (context, snapshot) {
                  return RaisedButton(
                    onPressed: snapshot.hasData ? () async {
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