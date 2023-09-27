import 'package:flutter/material.dart';

class TAppTheme {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFFFE200,
    <int, Color>{
      50: Color(0xFFFFE200),
    },
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: primarySwatch,
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 20),
    ),
    iconTheme: IconThemeData(
      color: Colors.blue,
      size: 24,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: primarySwatch,
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 20),
    ),
    iconTheme: IconThemeData(
      color: Colors.blue,
      size: 24,
    ),
  );
}
