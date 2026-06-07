import 'package:eroll/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.btnText,
    required this.btnColor,
    required this.btnAction,
    required this.isLoading,
  });

  final String btnText;
  final Color btnColor;
  final VoidCallback? btnAction;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: btnAction,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(15),
        child:
            isLoading
                ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: AppColors.white),
                )
                : Text(
                  btnText,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
