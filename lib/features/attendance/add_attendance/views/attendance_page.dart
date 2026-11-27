import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_controller.dart';
import '../models/attendance_models.dart';
import '../widgets/attendance_summary_chips.dart';
import '../widgets/move_workers_sheet.dart';
import '../widgets/site_attendance_section.dart';
import '../widgets/week_strip.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceController(),
      child: const _AttendanceView(),
    );
  }
}

class _AttendanceView extends StatelessWidget {
  const _AttendanceView();

  static const double _hPad = 20;

  Future<void> _pickDate(BuildContext context, AttendanceController c) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: c.selectedDate,
      firstDate: DateTime(c.today.year - 1),
      lastDate: c.today,
      selectableDayPredicate: (d) => d.weekday != DateTime.sunday,
    );
    if (picked != null) c.selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<AttendanceController>();
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isFuture = c.isFuture(c.selectedDate);
    final groups = c.groups;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(_hPad, 26, _hPad, bottomInset + 110),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'Attendance',
                      style: context.textTheme.headlineLarge!.copyWith(
                        fontSize: 34,
                        letterSpacing: -0.5,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _pickDate(context, c),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 4, 0, 4),
                      child: Text(
                        DateFormat('MMM y').format(c.selectedDate),
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontSize: 16,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(18),
              WeekStrip(
                days: c.weekDays,
                selected: c.selectedDate,
                hasMarks: c.hasMarks,
                onSelect: c.selectDate,
                onShiftWeek: (w) {
                  final target = c.weekStart.add(Duration(days: 7 * w));
                  if (!c.isFuture(target)) c.shiftWeek(w);
                },
              ),
              const Gap(16),
              AttendanceSummaryChips(
                present: isFuture ? 0 : c.count(AttendanceStatus.present),
                halfDay: isFuture ? 0 : c.count(AttendanceStatus.halfDay),
                absent: isFuture ? 0 : c.count(AttendanceStatus.absent),
              ),
              if (isFuture) ...[
                const Gap(12),
                Text(
                  'Attendance can’t be marked for a future day.',
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
              for (final group in groups) ...[
                const Gap(18),
                SiteAttendanceSection(
                  group: group,
                  statusOf: c.statusOf,
                  onMark: isFuture ? null : c.mark,
                  onMove: () => MoveWorkersSheet.show(
                    context,
                    group: group,
                    sites: c.sites,
                    onMove: c.moveWorker,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
