import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color.fromRGBO(255, 255, 255, 1),
    onSurface: Color.fromRGBO(0, 0, 0, 1),
    primary: Color.fromRGBO(0, 51, 102, 1),
    onPrimary: Color.fromRGBO(255, 255, 255, 1),
    secondary: Color.fromRGBO(255, 255, 255, 1),
    onSecondary: Color.fromRGBO(0, 0, 0, 1),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color.fromRGBO(0, 51, 102, 0.05),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Color.fromRGBO(189, 189, 189, 1),
          width: 1.0,
          style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Color.fromRGBO(0, 51, 102, 1),
          width: 1.0,
          style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Colors.red, width: 1.0, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  ),
);
