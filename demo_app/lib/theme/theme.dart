import 'package:flutter/material.dart';

// In colorScheme, primary is for normal text, secondary is for sub text

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade100,
    primary: Colors.black,
    secondary: Colors.black26,
    outline: Colors.grey.shade900,
  ),
  useMaterial3: true,
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.white,
    secondary: Colors.white60,
    outline: Colors.grey.shade100,
  ),
  useMaterial3: true,
);
