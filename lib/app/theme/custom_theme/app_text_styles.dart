import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._internal();

  static TextTheme textTheme = TextTheme(
    bodyMedium: TextStyle(
      fontSize: 16,
      fontFamily: 'cabinRegular',
      fontWeight: FontWeight.w200,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontFamily: 'cabinBold',
      fontWeight: FontWeight.w800,
    ),
    headlineLarge: TextStyle(
      fontSize: 30,
      fontFamily: 'cabinBold',
      fontWeight: FontWeight.w800,
    ),
  );
}
