import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_sizes.dart';
import '../../../app/theme/extensions/theme_extensions.dart';

class OngoingWorksCard extends StatelessWidget {
  const OngoingWorksCard({super.key});

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
                Spacer(),

                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.xs,
                    horizontal: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 210, 210, 249),
                    borderRadius: BorderRadius.circular(AppSizes.md),
                  ),
                  child: Text(
                    "Ongoing",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Text("Kalpetta", style: TextStyle(color: AppColors.grey)),
            Text("⏰ June 9"),
          ],
        ),
      ),
    );
  }
}
