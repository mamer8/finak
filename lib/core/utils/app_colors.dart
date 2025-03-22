import 'package:flutter/material.dart';

import 'hex_color.dart';

class AppColors {
  
  static Color primary = HexColor('#0F76BB');
  static Color primaryGrey = HexColor('#8E8E8E');
  static Color secondGrey = HexColor('#BEBEBE');
  static Color secondPrimary = HexColor('#39B44A');
  static Color red = HexColor('#E34A42');
  static Color grey2 = HexColor('#747474');
  static Color grey3 = HexColor('#DEDEDE');
  static Color grey4 = HexColor('#525252');
  static Color grey5 = HexColor('#EFEFEE');
  static Color grey6 = HexColor('#373737');
  static Color grey7 = HexColor('#979797');
  static Color notificationBorder = HexColor('#A9BCC0');
  static Color notificationBG = HexColor('#F5F5F5');
  static Color textFiledBG = HexColor('#F2F2F2');
  
  static Color black = Colors.black;
  static Color blackLite = Colors.black12;
  static Color success = Colors.green;
  static Color white = Colors.white;
  static Color error = Colors.red;
  static Color transparent = Colors.transparent;

  static Color gray = Colors.grey;

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lightens(String color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(HexColor(color));
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
