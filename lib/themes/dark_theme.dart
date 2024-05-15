import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Color.fromARGB(255, 118, 114, 114),
    secondary: Colors.grey[800]!,
    tertiary: Color(0xFFFD6456),
    surface: Color.fromARGB(255, 50, 22, 98),
    onSurface: Color.fromARGB(255, 255, 255, 255),
  ),
);
