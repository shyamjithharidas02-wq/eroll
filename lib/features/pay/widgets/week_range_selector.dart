import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';

/// "‹ 16 – 21 Nov ›" pill for a Monday–Saturday pay week.
class WeekRangeSelector extends StatelessWidget {
  final DateTime weekStart;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const WeekRangeSelector({
    super.key,
    required this.weekStart,
    this.onPrevious,
    this.onNext,
  });

  static String formatRange(DateTime start) {
    final end = start.add(const Duration(days: 5));
    if (start.month == end.month) {
      return '${start.day} – ${DateFormat('d MMM').format(end)}';
    }
    return '${DateFormat('d MMM').format(start)} – '
        '${DateFormat('d MMM').format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    Widget arrow(IconData icon, String label, VoidCallback? onTap) =>
        IconButton(
          tooltip: label,
          onPressed: onTap,
          icon: Icon(icon, size: 24),
          color: AppColors.ink,
          disabledColor: AppColors.ink.withValues(alpha: 0.25),
          visualDensity: VisualDensity.compact,
        );

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xFFE4E8E3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          arrow(Icons.chevron_left_rounded, 'Previous week', onPrevious),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              formatRange(weekStart),
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 15,
                color: AppColors.ink,
              ),
            ),
          ),
          arrow(Icons.chevron_right_rounded, 'Next week', onNext),
        ],
      ),
    );
  }
}
