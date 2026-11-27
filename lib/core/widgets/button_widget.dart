import 'package:eroll/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.btnText,
    required this.btnColor,
    required this.btnAction,
    required this.isLoading,
    this.btnRadius = 12,
  });

  final String btnText;
  final Color btnColor;
  final VoidCallback? btnAction;
  final bool isLoading;
  final double btnRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: btnAction,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(btnRadius),
        ),
        padding: const EdgeInsets.all(15),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: AppColors.white),
              )
            : Text(
                btnText,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
