import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../attendance/add_attendance/models/attendance_models.dart';
import '../models/pay_models.dart';

/// Six day tiles (MON–SAT) with a P / ½ / A badge and the site name.
class WeekDaysRow extends StatelessWidget {
  final DateTime weekStart;
  final List<DayMark> days;

  const WeekDaysRow({super.key, required this.weekStart, required this.days});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < days.length; i++) ...[
          if (i > 0) const Gap(7),
          Expanded(
            child: _DayTile(
              day: DateTime(weekStart.year, weekStart.month, weekStart.day + i),
              mark: days[i],
            ),
          ),
        ],
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  final DateTime day;
  final DayMark mark;

  const _DayTile({required this.day, required this.mark});

  @override
  Widget build(BuildContext context) {
    final (badge, badgeBg, badgeFg, word) = switch (mark.status) {
      AttendanceStatus.present => (
        'P',
        AppColors.lime,
        AppColors.ink,
        'present',
      ),
      AttendanceStatus.halfDay => (
        '½',
        AppColors.sand,
        AppColors.ink,
        'half day',
      ),
      AttendanceStatus.absent => (
        'A',
        AppColors.canvas,
        AppColors.inkMuted,
        'absent',
      ),
    };
    final small = context.textTheme.bodyMedium!.copyWith(
      fontSize: 11,
      height: 1.2,
    );

    return Semantics(
      label:
          '${DateFormat('EEEE').format(day)}, $word'
          '${mark.site == null ? '' : ' at ${mark.site}'}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE4E8E3)),
        ),
        child: Column(
          children: [
            Text(
              DateFormat('EEE').format(day).toUpperCase(),
              style: small.copyWith(color: AppColors.ink),
            ),
            const Gap(5),
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
              child: Text(
                badge,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 13,
                  color: badgeFg,
                ),
              ),
            ),
            const Gap(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                mark.site ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: small.copyWith(color: AppColors.inkMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
