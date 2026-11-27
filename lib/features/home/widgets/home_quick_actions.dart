import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';

class HomeQuickActionItem {
  final IconData icon;
  final String label;
  final bool highlighted;
  final VoidCallback? onTap;

  const HomeQuickActionItem({
    required this.icon,
    required this.label,
    this.highlighted = false,
    this.onTap,
  });
}

/// White rounded panel with four circular quick actions.
class HomeQuickActions extends StatelessWidget {
  final VoidCallback? onAdvance;
  final VoidCallback? onExpense;
  final VoidCallback? onClientPaid;
  final VoidCallback? onMore;

  const HomeQuickActions({
    super.key,
    this.onAdvance,
    this.onExpense,
    this.onClientPaid,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      HomeQuickActionItem(
        icon: Icons.south_west_rounded,
        label: 'Advance',
        highlighted: true,
        onTap: onAdvance,
      ),
      HomeQuickActionItem(
        icon: Icons.north_east_rounded,
        label: 'Expense',
        onTap: onExpense,
      ),
      HomeQuickActionItem(
        icon: Iconsax.arrow_swap_horizontal_copy,
        label: 'Client paid',
        onTap: onClientPaid,
      ),
      HomeQuickActionItem(
        icon: Icons.more_horiz_rounded,
        label: 'More',
        onTap: onMore,
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          for (final item in items) Expanded(child: _ActionButton(item: item)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final HomeQuickActionItem item;

  const _ActionButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: item.highlighted ? AppColors.lime : AppColors.chip,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: item.onTap,
            child: SizedBox(
              width: 62,
              height: 62,
              child: Icon(item.icon, size: 22, color: AppColors.ink),
            ),
          ),
        ),
        const Gap(10),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium!.copyWith(
            fontSize: 14,
            color: item.highlighted ? AppColors.ink : AppColors.inkMuted,
          ),
        ),
      ],
    );
  }
}
