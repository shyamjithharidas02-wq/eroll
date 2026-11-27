import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../app/routes/app_route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_sizes.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import 'report_card.dart';

class ReportsMenu extends StatelessWidget {
  const ReportsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.md,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: AppSizes.md,
          children: [
            // Payroll
            Expanded(
              child: ReportCard(
                icon: Iconsax.document_1_copy,
                iconColor: AppColors.primary,
                iconBg: AppColors.primaryTint,
                title: "Payroll Ledger",
                subTitle: "Monthly overview",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouteNames.payrollMonthListScreen,
                    arguments: false,
                  );
                },
              ),
            ),

            // Attendance
            Expanded(
              child: ReportCard(
                icon: Iconsax.profile_2user_copy,
                iconColor: AppColors.green,
                iconBg: AppColors.greenTint,
                title: "Attendance",
                subTitle: "Daily & monthly",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouteNames.attendanceReportScreen,
                  );
                },
              ),
            ),
          ],
        ),

        // Staff Payroll
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRouteNames.staffListPayrollScreen);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.md,
                horizontal: AppSizes.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(
                      color: AppColors.amberTint,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    child: const Icon(
                      Iconsax.document_cloud,
                      size: AppSizes.iconMd,
                      color: AppColors.amber,
                    ),
                  ),
                  const Gap(AppSizes.md),

                  Column(
                    children: [
                      Text(
                        "Staff Payroll Report",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        "Pre-staff salary breakdown",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
