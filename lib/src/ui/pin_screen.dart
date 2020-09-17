import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vseschedule_03/src/resources/credentials/credential_provider.dart';
import 'package:vseschedule_03/src/resources/db/db_provider.dart';
import 'package:vseschedule_03/src/resources/http/insis_client.dart';
import 'package:vseschedule_03/src/ui/app_colors.dart';

class PinScreen extends StatefulWidget {
  bool isFirstLogin;

  PinScreen({this.isFirstLogin}) : assert(isFirstLogin != null);

  @override
  State<StatefulWidget> createState() {
    return PinScreenState();
  }
}

class PinScreenState extends State<PinScreen> {
  String statusText = "";
  static final String _CHOOSE_PIN = "Zvol si pin pro rychlé přihlášení";
  static final String _ENTER_PIN = "Zadej svůj pin";
  static final String _WRONG_PIN = "Neplatný pin";
  static const String _BGRND_IMG = "images/login_pixel2_960.jpg";
  CredentialProvider credentialProvider = CredentialProvider.getInstance();
  InsisClient api = InsisClient.getInstance();
  DBProvider db = DBProvider.getInstance();

  Widget loading = LinearProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenBackground),
    backgroundColor: AppColors.blackBackground1,
  );
  Widget maybeLoading = Container();

  @override
  void initState() {
    super.initState();
    statusText = widget.isFirstLogin ? _CHOOSE_PIN : _ENTER_PIN;
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

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
                child: Column(children: <Widget>[
                  Container(height: deviceHeight * 0.2),
                  logo(context),
                  Container(height: deviceHeight * 0.01),
//                    Container(
//                      height: 3,
//                      child: StreamBuilder(
//                          stream: bloc.loading,
//                          builder: (context, snapshot) {
//                            return (snapshot.data == true
//                                ? progressIndicator()
//                                : Container(/*EMPTY*/));
//                          }),
//                    ),
                  Container(height: deviceHeight * 0.05),
                  maybeLoading,
                  Container(height: deviceHeight * 0.05),
                  Container(
                    width: deviceWidth * 0.5,
                    child: PinCodeTextField(
                      onCompleted: (value) {
                        widget.isFirstLogin
                            ? setPin(value, context)
                            : checkPin(value, context);
                      },
                      autoFocus: true,
                      enableActiveFill: true,
                      textInputType: TextInputType.number,
                      appContext: context,
                      length: 4,
                      backgroundColor: AppColors.blackBackground1,
                      obsecureText: true,
                      textStyle:
                          TextStyle(color: AppColors.whiteFont, fontSize: 26),
                      pinTheme: PinTheme(
                          selectedFillColor: Colors.white.withOpacity(0.1),
                          inactiveFillColor: Colors.transparent,
                          disabledColor: Colors.transparent,
                          selectedColor: Colors.transparent,
                          activeFillColor: Colors.transparent,
                          activeColor: AppColors.greenBackground,
                          inactiveColor: AppColors.greenBackground
                              .withOpacity(0.8) // underline clr
                          ),
                      onChanged: (value) {
                        print("value: " + value);

                        if (value.isEmpty) {
                          setState(() {
                            statusText =
                                widget.isFirstLogin ? _CHOOSE_PIN : _ENTER_PIN;
                          });
                        } else {
                          setState(() {
                            statusText = "";
                          });
                        }
                      },
                    ),
                  ),
//                    xnameField(bloc),
//                    passwordField(bloc),
                  Container(height: deviceHeight * 0.02),
                  exceptionNotifier(),
                  Container(height: deviceHeight * 0.05),
//                    Container(
//                      height: deviceHeight * 0.0664, width: deviceWidth * 0.47225,
//                      child: StreamBuilder(
//                          stream: bloc.loading,
//                          builder: (context, snapshot) {
//                            return snapshot.data == false
//                                ? submitButton(bloc, context)
//                                : Container(/*EMPTY*/);
//                          }
//                      ),
//                    ),
                  Container(height: deviceHeight * 0.01),
                ])),
          ),
        ));
  }

  Widget logo(BuildContext context) {
    return Text(
      "vschedule",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget exceptionNotifier() {
    return Text(statusText,
        style: TextStyle(
          fontFamily: "Quicksand",
          fontSize: 14.0,
          color: AppColors.whiteFont,
        ));
  }

  setPin(String value, BuildContext context) {
    credentialProvider.encodeCredentials(value);
    db.setIsFirstLogin(false);
    Navigator.pushNamed(context, "/schedule");
  }

  checkPin(String value, BuildContext context) async {
    setState(() {
      maybeLoading = loading;
    });
    if (await credentialProvider.canDecodeCredentials(value)) {
      credentialProvider.setDecodedCredentials(value);

      /// SLOWS DOWN schedule page loading
//      List<ScheduleEvent> list;
//      try {
//        list = await api.downloadSchedule(credentialProvider.getUsr(), credentialProvider.getPwd());
//        await db.deleteAllEntries();
//        await db.saveSchedule(list);
//      } on Exception catch (e) {
//        Navigator.pushNamed(
//            context,
//            "/schedule"
//        );
//      } finally {
      Navigator.pushNamed(context, "/schedule");
//      }
    } else {
      setState(() {
        statusText = _WRONG_PIN;
        maybeLoading = Container();
      });
      return;
    }
    return;
  }
}
