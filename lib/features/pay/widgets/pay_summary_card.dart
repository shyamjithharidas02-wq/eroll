import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';

/// Dark green card: Earned / Advances / Still to pay.
class PaySummaryCard extends StatelessWidget {
  final int earned;
  final int advances;
  final int stillToPay;

  const PaySummaryCard({
    super.key,
    required this.earned,
    required this.advances,
    required this.stillToPay,
  });

  @override
  Widget build(BuildContext context) {
    Widget stat(String label, String value, Color color) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium!.copyWith(
              fontSize: 13,
              color: AppColors.onDarkMuted,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 19,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [AppColors.forest, AppColors.pine, AppColors.pineLight],
          stops: [0.0, 0.65, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          stat('Earned', Utils.formatRupee(earned), AppColors.white),
          stat(
            'Advances',
            advances > 0 ? '– ${Utils.formatRupee(advances)}' : '₹0',
            AppColors.sand,
          ),
          stat('Still to pay', Utils.formatRupee(stillToPay), AppColors.lime),
        ],
      ),
    );
  }
}
