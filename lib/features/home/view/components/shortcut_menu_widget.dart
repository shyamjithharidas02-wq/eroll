import 'package:eroll/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ShortcutMenuWidget extends StatelessWidget {
  const ShortcutMenuWidget({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        spacing: 5,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.strokeColor, width: 1),
              //borderRadius: BorderRadius.circular(20),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, size: 30, color: AppColors.primaryColor),
          ),

          Text(text),
        ],
      ),
    );
  }
}
