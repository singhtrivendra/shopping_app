import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.pink,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
