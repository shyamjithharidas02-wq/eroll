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
                iconColor: AppColors.primaryColor,
                iconBg: Color.fromARGB(255, 216, 216, 251),
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
                iconColor: Color(0xFF4A6D4C),
                iconBg: Color(0xFFE6F4E5),
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
                    padding: EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3D7),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    child: Icon(
                      Iconsax.document_cloud,
                      size: AppSizes.iconMd,
                      color: Color(0xFFC9904B),
                    ),
                  ),
                  Gap(AppSizes.md),

                  Column(
                    children: [
                      Text(
                        "Staff Payroll Report",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
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
