import 'package:flutter/material.dart';

extension colors on ColorScheme {
  static MaterialColor primary_app = const MaterialColor(
    0xFF4D5B3F,
    <int, Color>{
      50: primary,
      100: primary,
      200: primary,
      300: primary,
      400: primary,
      500: primary,
      600: primary,
      700: primary,
      800: primary,
      900: primary,
    },
  );

  static const Color primary = Color(0xFF4D5B3F);
  static const Color backgroundColor = Color(0xFFF5DFD3);
  static const Color homeBackground = Color(0xFFDFCDB9);
  static const Color drawerColor = Color(0xFFD4AE6A);
  static const Color drawerColorVisibility = Color.fromRGBO(196, 145, 64, 1);
  static const Color eCommerceColor = Color(0xFFBC8069);
  static const Color serviceColor = Color(0xFF3D7081);
  static const Color secondary = Color(0xffFDC994);
  static const Color categoryDiscretion = Color(0xFFDDCEBC);
  static const Color categoryNewIn = Color(0xFFD8B678);
  static const Color newGoldColor = Color.fromRGBO(84, 71, 65, 1);

  Color get btnColor => brightness == Brightness.dark ? whiteTemp : primary;

  Color get changeablePrimary => brightness == Brightness.dark
      ? const Color.fromARGB(255, 77, 91, 63)
      : const Color(0xff4e5b40);

  Color get lightWhite =>
      brightness == Brightness.dark ? darkColor : const Color(0xffEEF2F9);

  Color get blue => brightness == Brightness.dark
      ? const Color(0xff8381d5)
      : const Color(0xff4543c1);

  Color get fontColor =>
      brightness == Brightness.dark ? whiteTemp : const Color(0xff222222);

  Color get gray =>
      brightness == Brightness.dark ? darkColor3 : const Color(0xfff0f0f0);

  Color get simmerBase =>
      brightness == Brightness.dark ? darkColor2 : Colors.grey[300]!;

  Color get simmerHigh =>
      brightness == Brightness.dark ? darkColor : Colors.grey[100]!;

  static Color darkIcon = const Color.fromARGB(255, 77, 91, 63);

  static const Color grad1Color = Color.fromARGB(255, 77, 91, 63);
  static const Color grad2Color = Color.fromARGB(255, 77, 91, 63);
  static const Color lightWhite2 = Color(0xffEEF2F3);

  static const Color yellow = Color(0xfffdd901);

  static const Color red = Colors.red;

  Color get lightBlack =>
      brightness == Brightness.dark ? whiteTemp : const Color(0xff52575C);

  Color get lightBlack2 =>
      brightness == Brightness.dark ? white70 : const Color(0xff999999);

  static const Color darkColor = Color(0xff181616);
  static const Color darkColor2 = Color(0xff252525);
  static const Color darkColor3 = Color(0xffa0a1a0);

  Color get white =>
      brightness == Brightness.dark ? darkColor2 : const Color(0xffFFFFFF);
  static const Color whiteTemp = Color(0xffFFFFFF);

  Color get black =>
      brightness == Brightness.dark ? whiteTemp : const Color(0xff000000);

  static const Color white10 = Colors.white10;
  static const Color white30 = Colors.white30;
  static const Color white70 = Colors.white70;

  static const Color black54 = Colors.black54;
  static const Color black12 = Colors.black12;
  static const Color disableColor = Color(0xffEEF2F9);

  static const Color blackTemp = Color(0xff000000);

  Color get black26 => brightness == Brightness.dark ? white30 : Colors.black54;
  static const Color cardColor = Color(0xffFFFFFF);
}
