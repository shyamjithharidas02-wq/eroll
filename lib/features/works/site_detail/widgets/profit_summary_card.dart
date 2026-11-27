import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';
import '../../../../core/utils/utils.dart';

/// Received / wages / costs breakdown, profit, and the "still due" banner.
class ProfitSummaryCard extends StatelessWidget {
  final int received;
  final int wages;
  final int siteCosts;
  final int contractValue;
  final VoidCallback onRecord;

  const ProfitSummaryCard({
    super.key,
    required this.received,
    required this.wages,
    required this.siteCosts,
    required this.contractValue,
    required this.onRecord,
  });

  static const Color profitGreen = Color(0xFF2E7A4F);
  static const Color _dueBg = Color(0xFFF3E5D0);
  static const Color _dueText = Color(0xFF8A5A1C);
  static const Color _label = Color(0xFF4D5751);

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final profit = received - wages - siteCosts;
    final due = contractValue - received;

    Widget line(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
                color: _label,
              ),
            ),
          ),
          Text(value, style: bold.copyWith(fontSize: 15, color: AppColors.ink)),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(17, 12, 17, 17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          line('Received from client', Utils.formatRupee(received)),
          line('Wages (from attendance)', '– ${Utils.formatRupee(wages)}'),
          line('Site costs', '– ${Utils.formatRupee(siteCosts)}'),
          const Gap(8),
          const Divider(height: 1, thickness: 1, color: AppColors.canvas),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Profit so far',
                  style: bold.copyWith(fontSize: 17, color: AppColors.ink),
                ),
              ),
              Text(
                profit < 0
                    ? '– ${Utils.formatRupee(-profit)}'
                    : Utils.formatRupee(profit),
                style: bold.copyWith(
                  fontSize: 26,
                  letterSpacing: -0.3,
                  color: profit < 0 ? AppColors.red : profitGreen,
                ),
              ),
            ],
          ),
          const Gap(14),
          Material(
            color: _dueBg,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onRecord,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        due > 0
                            ? '${Utils.formatRupee(due)} still due of '
                                  '${Utils.formatRupee(contractValue)}'
                            : 'Fully paid · ${Utils.formatRupee(contractValue)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bold.copyWith(fontSize: 14, color: _dueText),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Record ›',
                      style: bold.copyWith(fontSize: 14, color: _dueText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
