import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('Success', ()  {
    String str = "4EK101";
    int hash = 0;
    for (var i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
    }
    String colour = '#';
    for (var i = 0; i < 3; i++) {
      int value = (hash >> (i * 8)) & 0xFF;
      colour += value.toRadixString(16);
    }
    Color(int.parse(colour.substring(1, 7), radix: 16) + 0xFF000000);
  });

  test('hex test', ()  {
    int a = 1;
    int b = 2;
    int c = 3;
    int de = 15;
    int d = 16;
    int e = 17;
    print(a.toRadixString(16));
    print(b.toRadixString(16));
    print(c.toRadixString(16));
    print(de.toRadixString(16));
    print(d.toRadixString(16));
    print(e.toRadixString(16));
  });

}