import 'package:flutter/material.dart';
import 'package:food_it_flutter/ui/theme/colors.dart';

var lightTheme = ThemeData.light().copyWith(
  colorScheme: const ColorScheme.light().copyWith(
    primary: primary,
  ),
  appBarTheme: const AppBarTheme(backgroundColor: primary, elevation: 4),
  scaffoldBackgroundColor: const Color(0xFFFFF5E4),
);

var darkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark().copyWith(
    primary: primaryAccent,
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[300]!),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red[300]!),
    ),
    errorStyle: TextStyle(color: Colors.red[300]!),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFEE3E38),
    elevation: 4,
  ),
  scaffoldBackgroundColor: const Color(0xFFFFF5E4),
);