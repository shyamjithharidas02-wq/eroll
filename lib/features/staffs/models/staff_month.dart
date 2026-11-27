import 'package:flutter/material.dart';

import '../../pay/models/pay_models.dart';
import '../data/models/staff_member.dart';

enum WeekPayState { paid, due, upcoming, daily, none }

/// One Mon–Sat pay week as shown on the staff profile.
class StaffWeek {
  final DateTime start; // Monday
  final double days;
  final int dailyWage;
  final int advance;
  final WeekPayState state;

  /// Paid so far for this week.
  final int paid;

  /// Still owed for this week.
  final int due;

  const StaffWeek({
    required this.start,
    required this.days,
    required this.dailyWage,
    required this.advance,
    required this.state,
    required this.paid,
    required this.due,
  });

  DateTime get end => DateTime(start.year, start.month, start.day + 5);

  int get earned => (days * dailyWage).round();

  /// Earned minus advance: what the week settles for.
  int get net => earned - advance;
}

class StaffAdvance {
  final DateTime date;
  final int amount;

  const StaffAdvance(this.date, this.amount);
}

/// A member's month: the weeks whose pay day (Saturday) falls in it.
class StaffMonth {
  final DateTime month;
  final List<StaffWeek> weeks;
  final List<StaffAdvance> advances;

  const StaffMonth({
    required this.month,
    required this.weeks,
    required this.advances,
  });

  Iterable<StaffWeek> get _worked =>
      weeks.where((w) => w.state != WeekPayState.upcoming);

  double get days => _worked.fold(0, (sum, w) => sum + w.days);
  int get earned => _worked.fold(0, (sum, w) => sum + w.earned);
  int get advanceTotal => advances.fold(0, (sum, a) => sum + a.amount);
  int get paid => _worked.fold(0, (sum, w) => sum + w.paid);
  int get due => _worked.fold(0, (sum, w) => sum + w.due);

  /// Demo days for weeks older than the pay record keeps.
  static const _olderWeeks = [6, 5, 6, 4, 6, 5, 6];

  // TODO: build from Firestore attendance, advances and payments.
  static StaffMonth build(StaffMember member, DateTime month, {DateTime? now}) {
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    final thisWeek = DateTime(
      today.year,
      today.month,
      today.day - (today.weekday - 1),
    );
    final entry = member.toPayEntry();
    final daily = member.payCycle == PayCycle.daily;

    // First Monday whose Saturday lands in this month.
    final firstOfMonth = DateTime(month.year, month.month);
    final firstSaturday = DateTime(
      month.year,
      month.month,
      1 + (DateTime.saturday - firstOfMonth.weekday + 7) % 7,
    );

    final weeks = <StaffWeek>[];
    final advances = <StaffAdvance>[];
    for (
      var sat = firstSaturday;
      sat.month == month.month;
      sat = DateTime(sat.year, sat.month, sat.day + 7)
    ) {
      final start = DateTime(sat.year, sat.month, sat.day - 5);
      final weeksAgo = (thisWeek.difference(start).inHours / (24 * 7)).round();

      if (weeksAgo < 0) {
        weeks.add(
          StaffWeek(
            start: start,
            days: 0,
            dailyWage: member.dailyWage,
            advance: 0,
            state: WeekPayState.upcoming,
            paid: 0,
            due: 0,
          ),
        );
        continue;
      }

      final days = _daysFor(entry, weeksAgo);
      final advance = weeksAgo == 0 ? entry.advance : 0;
      if (advance > 0) {
        advances.add(
          StaffAdvance(
            DateTime(start.year, start.month, start.day + entry.advanceDay),
            advance,
          ),
        );
      }
      final earned = (days * member.dailyWage).round();
      final net = earned - advance;

      final WeekPayState state;
      final int due;
      if (days == 0) {
        state = WeekPayState.none;
        due = 0;
      } else if (daily) {
        state = WeekPayState.daily;
        due = 0;
      } else if (weeksAgo == 0 && member.dueThisWeek > 0) {
        state = WeekPayState.due;
        due = member.dueThisWeek;
      } else {
        state = WeekPayState.paid;
        due = 0;
      }

      weeks.add(
        StaffWeek(
          start: start,
          days: days,
          dailyWage: member.dailyWage,
          advance: advance,
          state: state,
          paid: daily ? earned : (net - due).clamp(0, net),
          due: due,
        ),
      );
    }

    return StaffMonth(month: month, weeks: weeks, advances: advances);
  }

  static double _daysFor(PayEntry entry, int weeksAgo) {
    if (weeksAgo == 0) return entry.days;
    if (weeksAgo <= entry.pastDays.length) return entry.pastDays[weeksAgo - 1];
    // New members have no history before what the pay record shows.
    if (entry.pastDays.isEmpty) return 0;
    return _olderWeeks[weeksAgo % _olderWeeks.length].toDouble();
  }
}
