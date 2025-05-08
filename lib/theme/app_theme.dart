import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData appTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: kPrimary,
    colorScheme: base.colorScheme.copyWith(
      primary: kPrimary,
      secondary: kAccent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccent,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kAccent,
        side: const BorderSide(color: kAccent),
      ),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    progressIndicatorTheme:
    const ProgressIndicatorThemeData(color: kAccent),
    snackBarTheme: const SnackBarThemeData(backgroundColor: kAccent),
  );
}
