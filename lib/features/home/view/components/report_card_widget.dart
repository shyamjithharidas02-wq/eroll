import 'package:eroll/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ReportCardWidget extends StatelessWidget {
  const ReportCardWidget({
    super.key,
    required this.imagePath,
    required this.labelText,
    required this.onTap,
  });

  final String imagePath;
  final String labelText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.strokeColor, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          spacing: 10,
          children: [
            Image.asset(imagePath, height: 40, fit: BoxFit.cover),

            Text(labelText),
          ],
        ),
      ),
    );
  }
}
