import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart'
    show ThemeExtensions;
import 'package:flutter/material.dart';

import '../../../app/theme/app_sizes.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Color(0xFFE8E5EF),
      color: Color.fromARGB(255, 220, 220, 255),
      elevation: .2,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.lg),
        child: Column(
          spacing: AppSizes.xs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back Admin! 👋", style: context.textTheme.titleLarge),
            Text(
              "Here's what's happening today.",
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
