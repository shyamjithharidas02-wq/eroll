import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';
import '../../../../core/utils/utils.dart';
import '../data/models/site_detail_model.dart';
import 'profit_summary_card.dart';

/// "Money in & out" list, newest first.
class MoneyListCard extends StatelessWidget {
  final List<SiteTransaction> transactions;

  const MoneyListCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          for (var i = 0; i < sorted.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, thickness: 1, color: AppColors.canvas),
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sorted[i].label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: bold.copyWith(
                            fontSize: 15,
                            height: 1.25,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          DateFormat('d MMM').format(sorted[i].date),
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontSize: 13,
                            height: 1.3,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${sorted[i].isIncome ? '+' : '–'} '
                    '${Utils.formatRupee(sorted[i].amount.abs())}',
                    style: bold.copyWith(
                      fontSize: 15,
                      color: sorted[i].isIncome
                          ? ProfitSummaryCard.profitGreen
                          : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
