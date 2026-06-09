import 'package:flutter/material.dart';

import '../../../app/theme/app_sizes.dart';

class QuickAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;

  const QuickAction({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.md,
            horizontal: AppSizes.md,
          ),
          child: Column(
            spacing: AppSizes.sm,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Icon(icon, size: AppSizes.iconMd, color: iconColor),
              ),

              Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
