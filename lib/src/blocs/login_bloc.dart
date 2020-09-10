import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vseschedule_03/src/models/schedule_event.dart';
import 'package:vseschedule_03/src/resources/db/db_provider.dart';
import 'package:vseschedule_03/src/resources/http/insis_client.dart';

/// BLoC stands for Business Logic Components. The gist of BLoC is that everything
/// in the app should be represented as stream of events: widgets submit events;
/// other widgets will respond. BLoC sits in the middle, managing the conversation.

class LoginBloc {
  final _log = Logger('LoginBloc');
  InsisClient api = InsisClient.getInstance();
  DBProvider db = DBProvider.getInstance();

  final _xname = BehaviorSubject<String>(seedValue: "");
  final _password = BehaviorSubject<String>(seedValue: "");
  final _exception = BehaviorSubject<String>(seedValue: "");
  final _loading = BehaviorSubject<bool>(seedValue: false);

  Stream<String> get xname => _xname.stream;

  Stream<String> get password => _password.stream;

  Stream<String> get exception => _exception.stream;

  Stream<bool> get pwdXnmCombined =>
      Observable.combineLatest2(xname, password, (e, p) => true);

  Stream<bool> get loading => _loading.stream;

  Function(String) get sinkXname => _xname.sink.add;

  Function(String) get sinkPassword => _password.sink.add;

  Function(String) get sinkException => _exception.sink.add;

  Future<bool> submit() async {
    _log.info("login submited");

    final String usr = _xname.value;
    final String pwd = _password.value;
    List<ScheduleEvent> list;

    _loading.add(true);
    _exception.drain();

    try {
      list = await api.downloadSchedule(usr, pwd);
    } on ClientException catch (ce) {
      _exception.add("Přihlášení se nepovedlo, zkontroluj údaje");
      _log.warning(ce.toString());
      _loading.add(false);
      return false;
    } on Exception catch (e) {
      _exception.add("Login se nepovedl");
      _log.warning(e.toString());
      _loading.add(false);
      return false;
    }

    await db.deleteAllEntries();
    await db.saveSchedule(list);

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