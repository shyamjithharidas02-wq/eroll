import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/custom_theme/app_text_styles.dart';
import 'package:eroll/app/theme/custom_theme/appbar_themes.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primaryColor,
    // scaffoldBackgroundColor: Color.fromRGBO(248, 247, 251, 1),
    scaffoldBackgroundColor: AppColors.white,
    textTheme: AppTextStyles.textTheme,
    appBarTheme: AppBarThemes.appBarTheme,
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
