import 'package:flutter_test/flutter_test.dart';
import 'package:vseschedule_03/src/resources/http/insis_client.dart';

void main() {
  test('test', () async {
    print("hello");
    InsisClient ic = InsisClient.getInstance();
    if (!await ic.checkNetwork()) {
      print("not connected");
    } else {
      print("connected");
    }
  });

  test('test2', () async {
    print("hello");
    InsisClient ic = InsisClient.getInstance();
    if (!await ic.checkInsis()) {
      print("not connected");
    } else {
      print("connected");
    }
  });

  test('test3', () async {
    print("hello");
    InsisClient ic = InsisClient.getInstance();
    if (!await ic.validateInsisCredentials("a", "a")) {
      print("wrong credentials");
    } else {
      print("good credentials");
    }
  });
}
