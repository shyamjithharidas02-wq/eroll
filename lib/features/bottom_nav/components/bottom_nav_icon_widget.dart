import 'package:eroll/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BottomNavIconWidget extends StatelessWidget {
  const BottomNavIconWidget({
    super.key,
    required this.icons,
    required this.onTap,
    required this.label,
    required this.isActive,
  });

  final IconData icons;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icons,
            color: isActive ? AppColors.primaryColor : AppColors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primaryColor : AppColors.grey,
              fontWeight: isActive ? FontWeight.w800 : null,
            ),
          ),
        ],
      ),
    );
  }
}
