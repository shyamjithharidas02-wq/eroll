import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/month_report.dart';
import 'report_summary.dart';

/// Green gradient card: month profit, change vs last month, and totals.
class MonthProfitCard extends StatelessWidget {
  final MonthReport report;

  const MonthProfitCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final s = report.summary;
    final change = report.profitChangePercent;
    final isLoss = s.profit < 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.pineLight, AppColors.pine, AppColors.forest],
          stops: [0, 0.45, 1],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoss ? 'Loss' : 'Profit',
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        color: AppColors.onDarkMuted,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${isLoss ? '– ' : ''}'
                        '${Utils.formatRupee(s.profit.abs())}',
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontSize: 40,
                          height: 1.2,
                          letterSpacing: -1,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (change != null && report.previous != null)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: change >= 0 ? AppColors.lime : AppColors.redTint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${change >= 0 ? '+' : ''}$change% vs '
                    '${DateFormat('MMM').format(report.previous!.start)}',
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontSize: 13,
                      color: change >= 0 ? AppColors.ink : AppColors.red,
                    ),
                  ),
                ),
            ],
          ),
          const Gap(20),
          Row(
            children: [
              for (final (i, (label, amount)) in [
                ('Received', s.received),
                ('Wages', s.wages),
                ('Costs', s.costs),
              ].indexed) ...[
                if (i > 0) const Gap(9),
                Expanded(
                  child: ReportStatTile(
                    label,
                    amount,
                    fill: AppColors.white.withValues(alpha: 0.06),
                    border: AppColors.white.withValues(alpha: 0.14),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
