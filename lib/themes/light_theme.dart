import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Color.fromARGB(255, 118, 114, 114),
    secondary: const Color.fromARGB(255, 119, 116, 116)!,
    tertiary: Color(0xFFFD6456),
    surface: Color.fromARGB(255, 134, 86, 216),
    onSurface: Color.fromARGB(255, 0, 0, 0),
  ),
);
