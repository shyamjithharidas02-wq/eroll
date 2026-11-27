import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/app_sizes.dart';
import 'package:flutter/material.dart';

class AppBarThemes {
  static AppBarTheme appBarTheme = const AppBarTheme(
    centerTitle: true,
    toolbarHeight: 70,
    backgroundColor: AppColors.primary,
    titleTextStyle: TextStyle(color: AppColors.white, fontSize: 20.0),
    actionsIconTheme: IconThemeData(
      size: AppSizes.iconMd,
      color: AppColors.white,
    ),
  );
}
