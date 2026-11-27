import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_sizes.dart';
import '../../../app/theme/extensions/theme_extensions.dart';

class OngoingWorksCard extends StatelessWidget {
  final String workStatus;
  final Color fontColor;
  final Color bgColor;

  const OngoingWorksCard({
    super.key,
    this.workStatus = 'Ongoing',
    this.fontColor = AppColors.primary,
    this.bgColor = AppColors.primaryTint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          spacing: AppSizes.xs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Website redesign",
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSizes.xs,
                    horizontal: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppSizes.md),
                  ),
                  child: Text(
                    workStatus,
                    style: TextStyle(fontSize: 14, color: fontColor),
                  ),
                ),
              ],
            ),
            const Text("📍 Kalpetta", style: TextStyle(color: AppColors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("⏰ June 9"),
                Text(
                  "3 staffs",
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
