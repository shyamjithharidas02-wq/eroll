import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/app_sizes.dart' show AppSizes;
import 'package:eroll/app/theme/custom_theme/app_text_styles.dart';
import 'package:eroll/app/theme/custom_theme/appbar_themes.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryTint,
      surface: AppColors.white,
    ),

    scaffoldBackgroundColor: AppColors.surface,
    textTheme: AppTextStyles.textTheme,
    appBarTheme: AppBarThemes.appBarTheme,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFEDF0F1),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
        borderSide: const BorderSide(color: Color(0xFFEDF0F1), width: 1),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
        borderSide: const BorderSide(color: Color(0xFFEDF0F1), width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
        borderSide: const BorderSide(color: Colors.black12, width: 1),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXxl),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),

      hintStyle: const TextStyle(color: AppColors.grey),
    ),
  );
}
