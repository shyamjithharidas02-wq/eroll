import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

/// Mon–Sat day cards. Swipe horizontally to change week.
class WeekStrip extends StatelessWidget {
  final List<DateTime> days;
  final DateTime selected;
  final bool Function(DateTime day) hasMarks;
  final ValueChanged<DateTime> onSelect;
  final ValueChanged<int> onShiftWeek;

  const WeekStrip({
    super.key,
    required this.days,
    required this.selected,
    required this.hasMarks,
    required this.onSelect,
    required this.onShiftWeek,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v.abs() < 200) return;
        onShiftWeek(v < 0 ? 1 : -1);
      },
      child: Row(
        children: [
          for (var i = 0; i < days.length; i++) ...[
            if (i > 0) const Gap(7),
            Expanded(
              child: _DayCard(
                day: days[i],
                isSelected: DateUtils.isSameDay(days[i], selected),
                hasMarks: hasMarks(days[i]),
                onTap: () => onSelect(days[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool hasMarks;
  final VoidCallback onTap;

  const _DayCard({
    required this.day,
    required this.isSelected,
    required this.hasMarks,
    required this.onTap,
  });

  static const Color _dot = Color(0xFF2E7A4F);
  static const Color _border = Color(0xFFE4E8E3);

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;

    return Semantics(
      button: true,
      selected: isSelected,
      label: DateFormat('EEEE d MMMM').format(day),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lime : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? AppColors.lime : _border),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.lime.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('EEE').format(day).toUpperCase(),
                style: context.textTheme.bodyMedium!.copyWith(
                  fontSize: 11,
                  height: 1.1,
                  color: AppColors.ink,
                ),
              ),
              const Gap(2),
              Text(
                DateFormat('d').format(day),
                style: bold.copyWith(
                  fontSize: 18,
                  height: 1.1,
                  color: AppColors.ink,
                ),
              ),
              const Gap(4),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: !hasMarks
                      ? Colors.transparent
                      : isSelected
                      ? AppColors.ink
                      : _dot,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
