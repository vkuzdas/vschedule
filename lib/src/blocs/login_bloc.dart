import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

/// BLoC stands for Business Logic Components. The gist of BLoC is that everything
/// in the app should be represented as stream of events: widgets submit events;
/// other widgets will respond. BLoC sits in the middle, managing the conversation.

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

    /// empty
    if (usr == "" || pwd == "") {
      _exception.add("Poskytni InSIS přihlašovací údaje.");
      _loading.add(false);
      return false;
    }

    _log.info("login submited");
    repository.setCredentials(usr, pwd);
    repository.saveCredentials();

    if (!await repository.checkNetwork()) {
      _exception.add("Zkontroluj připojení k internetu.");
      _loading.add(false);
      return false;
    }

    if (!await repository.checkInsis()) {
      _exception.add("Vypadá to, že Insis je offline.");
      _loading.add(false);
      return false;
    }

    if (!await repository.validateInsisCredentials(usr, pwd)) {
      _exception.add("Špatné přihlašovací údaje.");
      _loading.add(false);
      return false;
    }

    /// download schedule with each sign in again
    /// app there for works only with internet connection
    repository.deleteSchedule();
    repository.downloadSchedule();

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