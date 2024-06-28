import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    surface: Colors.white,
    onSurface: Colors.black,
    brightness: Brightness.light,
    primary: const Color(0xFF00C22B),
    onPrimary: Colors.white,
    onPrimaryFixed: Colors.grey.shade900,
    secondary: Colors.white,
    onSecondary: Colors.black,
    tertiary: Colors.white,
    onTertiary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    outline: Colors.white,
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    //background color
    surface: Colors.grey.shade900,
    onSurface: Colors.white,
    //main color
    primary: Colors.grey.shade800,
    onPrimary: Colors.white,
    onPrimaryFixed: Colors.white70,
    //color of textboxes
    secondary: Colors.white60,
    onSecondary: Colors.black87,
    //color of buttons mostly
    tertiary: const Color(0xFF00C22B),
    onTertiary: Colors.white,
    //error
    error: Colors.red,
    onError: Colors.white,
    //highlight color
    outline: Colors.white,
  ),
);
