import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/report_data.dart';

/// White card for one past month or year: date badge, totals, profit.
class PeriodReportCard extends StatelessWidget {
  final PeriodReport report;

  /// Big line in the badge ("Oct" or "2025").
  final String badgeTop;

  /// Small line in the badge ("2026" or "Year").
  final String badgeBottom;

  /// Card title ("October" or "2025").
  final String title;
  final VoidCallback? onTap;

  const PeriodReportCard({
    super.key,
    required this.report,
    required this.badgeTop,
    required this.badgeBottom,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final profit = report.profit;
    final isLoss = profit < 0;
    final sites = '${report.sites} site${report.sites == 1 ? '' : 's'}';
    final muted = context.textTheme.bodyMedium!.copyWith(
      fontSize: 14,
      height: 1.3,
      color: AppColors.inkMuted,
    );

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        badgeTop,
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontSize: 16,
                          height: 1.1,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    Text(
                      badgeBottom,
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontSize: 11,
                        height: 1.1,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontSize: 16.5,
                        color: AppColors.ink,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      '${Utils.formatRupee(report.received)} in · '
                      '${Utils.formatRupee(report.out)} out · $sites',
                      style: muted,
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isLoss ? '– ' : '+ '}${Utils.formatRupee(profit.abs())}',
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontSize: 16.5,
                      color: isLoss ? AppColors.red : AppColors.profitGreen,
                    ),
                  ),
                  Text(isLoss ? 'loss' : 'profit', style: muted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
