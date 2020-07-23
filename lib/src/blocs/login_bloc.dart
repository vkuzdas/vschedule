import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';



class LoginBloc {

  final _log = Logger('LoginBloc');
  Repository repository = Repository.getInstance();

  final _xname = BehaviorSubject<String>(seedValue: "");
  final _password = BehaviorSubject<String>(seedValue: "");
  final _exception = BehaviorSubject<String>(seedValue: "");
  final _loading = BehaviorSubject<bool>(seedValue: false);

  Stream<String> get xname => _xname.stream;
  Stream<String> get password => _password.stream;
  Stream<String> get exception => _exception.stream;
  Stream<bool> get pwdXnmCombined => Observable.combineLatest2(xname, password, (e, p) => true );
  Stream<bool> get loading => _loading.stream;

  Function(String) get sinkXname => _xname.sink.add;
  Function(String) get sinkPassword => _password.sink.add;
  Function(String) get sinkException => _exception.sink.add;




  Future<bool> submit() async {
    final String usr = _xname.value;
    final String pwd = _password.value;

    _loading.add(true);
    _exception.drain();

    if (usr == "" || pwd == "") {
      _exception.add("Poskytni InSIS přihlašovací údaje.");
      _loading.add(false);
      return false;
    }

    _log.info("login submited");
    repository.setCredentials(usr, pwd);
    repository.saveCredentials();
//    List<ScheduleEvent> schedule;

// TODO: solve "no-schedule" problem,

//    try {
//      schedule = await repository.getDaySchedule(Day.Mon);
//    } on SocketException catch(networkExc) {
//      // no internet
//      _exception.add("Zkontroluj připojení k internetu.");
//      _loading.add(false);
//      return false;
//    } on ClientException catch(loginExc) {
//      // wrong credentials
//      _exception.add("Špatné přihlašovací údaje.");
//      _loading.add(false);
//      return false;
//    } catch (e) {
//      _exception.add("Něco se nepovedlo, zkus to za chvíli.");
//      _loading.add(false);
//      return false;
//    }

    _loading.add(false);
    _exception.drain();
    return true;
  }


  // To not leave sink opened forever
  dispose () {
    _xname.close();
    _password.close();
    _exception.close();
  }



}