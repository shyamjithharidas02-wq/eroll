import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/pay_models.dart';

/// Worker row: avatar, name, "6 days × ₹700 – adv ₹1,000", amount, action.
class PayRow extends StatelessWidget {
  final PayEntry entry;
  final PayStatus status;
  final int amount;
  final VoidCallback? onPay;
  final VoidCallback? onTap;

  const PayRow({
    super.key,
    required this.entry,
    required this.status,
    required this.amount,
    this.onPay,
    this.onTap,
  });

  static const Color _avatarBg = Color(0xFFDFEADC);
  static const Color _softBg = Color(0xFFE3EED9);

  String get _subtitle {
    if (entry.isDailyPaid) return 'Daily wage · paid each evening';
    final base = '${entry.daysLabel} × ${Utils.formatRupee(entry.dailyWage)}';
    return entry.advance > 0
        ? '$base – adv ${Utils.formatRupee(entry.advance)}'
        : base;
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _avatarBg,
                shape: BoxShape.circle,
              ),
              child: Text(
                entry.initial,
                style: bold.copyWith(fontSize: 14, color: AppColors.pine),
              ),
            ),
            const Gap(11),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bold.copyWith(
                      fontSize: 16,
                      height: 1.2,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    _subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontSize: 13,
                      height: 1.3,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Text(
              Utils.formatRupee(amount),
              style: bold.copyWith(fontSize: 16, color: AppColors.ink),
            ),
            const Gap(10),
            _ActionButton(status: status, onPay: onPay),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final PayStatus status;
  final VoidCallback? onPay;

  const _ActionButton({required this.status, this.onPay});

  @override
  Widget build(BuildContext context) {
    final isDue = status == PayStatus.due;
    final label = switch (status) {
      PayStatus.due => 'Pay',
      PayStatus.paid => 'Paid',
      PayStatus.daily => 'Daily',
    };

    return Material(
      color: isDue ? AppColors.lime : PayRow._softBg,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: isDue ? onPay : null,
        child: SizedBox(
          width: 60,
          height: 36,
          child: Center(
            child: Text(
              label,
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 14,
                color: isDue ? AppColors.ink : AppColors.pine,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
