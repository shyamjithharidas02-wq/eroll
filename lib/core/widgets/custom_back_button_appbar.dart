import 'package:eroll/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBackButtonAppbar extends StatelessWidget {
  const CustomBackButtonAppbar({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.pop(context);
        }
      },
      icon: const Icon(CupertinoIcons.back, color: AppColors.white),
    );
  }
}
