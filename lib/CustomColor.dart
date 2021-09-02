import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColor
{
  static Color darkBackgroundBack = HexColor("#121212");
  static Color darkBackgroundFront = HexColor("#32ae85").withOpacity(0.08);
  static Color neonGreen = HexColor("#32AE85");
  static Color textGreen = Colors.greenAccent;
  static Color formCardColor = HexColor("#7A7171").withOpacity(0.15);
  static Color borderWhite = HexColor("#ffffff").withOpacity(0.15);
}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}