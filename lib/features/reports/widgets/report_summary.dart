import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/report_data.dart';

/// Big profit figure with Received / Wages / Costs tiles, on the dark header.
class ReportSummary extends StatelessWidget {
  final String caption;
  final PeriodReport report;

  const ReportSummary({super.key, required this.caption, required this.report});

  @override
  Widget build(BuildContext context) {
    final profit = report.profit;
    final isLoss = profit < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          caption,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!.copyWith(
            fontSize: 16,
            color: AppColors.onDarkMuted,
          ),
        ),
        const Gap(4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${isLoss ? '– ' : ''}${Utils.formatRupee(profit.abs())}',
            style: context.textTheme.headlineSmall!.copyWith(
              fontSize: 46,
              height: 1.15,
              letterSpacing: -1,
              color: AppColors.white,
            ),
          ),
        ),
        const Gap(4),
        Text(
          isLoss
              ? 'loss after wages and costs'
              : 'profit after wages and costs',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!.copyWith(
            fontSize: 14.5,
            color: isLoss ? AppColors.wrongPinOnDark : AppColors.lime,
          ),
        ),
        const Gap(18),
        Row(
          children: [
            Expanded(child: ReportStatTile('Received', report.received)),
            const Gap(9),
            Expanded(child: ReportStatTile('Wages', report.wages)),
            const Gap(9),
            Expanded(child: ReportStatTile('Costs', report.costs)),
          ],
        ),
      ],
    );
  }
}

/// Small outlined label + amount tile used on dark report headers.
class ReportStatTile extends StatelessWidget {
  final String label;
  final int amount;
  final Color fill;
  final Color border;

  const ReportStatTile(
    this.label,
    this.amount, {
    super.key,
    this.fill = AppColors.reportTile,
    this.border = AppColors.reportTileBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium!.copyWith(
              fontSize: 12.5,
              color: AppColors.onDarkMuted,
            ),
          ),
          const Gap(2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              Utils.formatRupee(amount),
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 16.5,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
