import 'dart:ui';

class AppColors {
  static Color blackBackground1 = Color(0xFF212325);
  static Color blackBackground2 = Color(0xFF27292B);
  static Color greenBackground = Color(0xFF2C8F4E);
  static Color greenBackgroundFaded = Color(0x882C8F4E);
  static Color greenBackgroundVeryFaded = Color(0xFF508964);
  static Color whiteFont = Color(0xFFB9B9B9);
  static Color whiteFontFaded = Color(0x88B9B9B9);
  static Color orange = Color(0xFFFBAF3F);
  static Color cyan = Color(0xFF27AAE0);
  static Color darkBlue = Color(0xFF3E5BA7);

  static Color colorFromString(String str) {
    //    String str = "4EK101";
    int hash = 0;
    for (var i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
    }
    String colour = '#';
    for (var i = 0; i < 3; i++) {
      int value = (hash >> (i * 8)) & 0xFF;
      if (value < 16) {
        colour += '0';
      }
      colour += value.toRadixString(16);
    }
    return Color(int.parse(colour.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
