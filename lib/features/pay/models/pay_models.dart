import '../../attendance/add_attendance/models/attendance_models.dart';

enum PayStatus { due, paid, daily }

/// Attendance for one day of the pay week.
class DayMark {
  final AttendanceStatus status;
  final String? site;

  const DayMark(this.status, [this.site]);

  double get dayValue => switch (status) {
    AttendanceStatus.present => 1,
    AttendanceStatus.halfDay => 0.5,
    AttendanceStatus.absent => 0,
  };
}

/// A settled earlier week.
class PastWeek {
  final DateTime weekStart;
  final double days;
  final int paid;

  const PastWeek({
    required this.weekStart,
    required this.days,
    required this.paid,
  });
}

/// One worker's settlement for a week.
class PayEntry {
  final String id;
  final String name;
  final String phone;
  final int dailyWage;

  /// Monday–Saturday attendance for the week.
  final List<DayMark> week;
  final int advance;

  /// Index into [week] of the day the advance was taken.
  final int advanceDay;

  /// Paid each evening, so nothing is settled weekly.
  final bool isDailyPaid;

  /// Days worked in earlier weeks, most recent first.
  final List<double> pastDays;

  const PayEntry({
    required this.id,
    required this.name,
    required this.phone,
    required this.dailyWage,
    required this.week,
    this.advance = 0,
    this.advanceDay = 0,
    this.isDailyPaid = false,
    this.pastDays = const [6, 5],
  });

  String get initial => name.isEmpty ? '' : name[0].toUpperCase();

  double get days => week.fold(0, (sum, d) => sum + d.dayValue);

  /// Wages earned in the week (before advances).
  int get earned => isDailyPaid ? 0 : (days * dailyWage).round();

  /// What is handed over at settlement.
  int get payable => earned - advance;

  String get daysLabel => '${formatDays(days)} days';

  static String formatDays(double d) =>
      d == d.roundToDouble() ? d.toInt().toString() : d.toString();

  List<PastWeek> pastWeeks(DateTime weekStart) => [
    for (var i = 0; i < pastDays.length; i++)
      PastWeek(
        weekStart: DateTime(
          weekStart.year,
          weekStart.month,
          weekStart.day - 7 * (i + 1),
        ),
        days: pastDays[i],
        paid: isDailyPaid ? 0 : (pastDays[i] * dailyWage).round(),
      ),
  ];

  // TODO: replace with attendance + advances from Firestore.
  static final List<PayEntry> demo = [
    PayEntry(
      id: 'sukumar',
      name: 'Sukumar',
      phone: '9847012001',
      dailyWage: 700,
      week: _week('Meppadi', present: 6),
      advance: 1000,
      advanceDay: 2,
    ),
    PayEntry(
      id: 'anil',
      name: 'Anil',
      phone: '9847012002',
      dailyWage: 900,
      week: _week('Meppadi', present: 6),
      advance: 1500,
      advanceDay: 1,
    ),
    PayEntry(
      id: 'biju',
      name: 'Biju',
      phone: '9847012003',
      dailyWage: 750,
      week: _week('Meppadi', present: 5, half: 1),
    ),
    PayEntry(
      id: 'rajan',
      name: 'Rajan',
      phone: '9847012004',
      dailyWage: 700,
      week: _week('Kalpetta', present: 6),
      advance: 500,
      advanceDay: 3,
    ),
    PayEntry(
      id: 'vinod',
      name: 'Vinod',
      phone: '9847012005',
      dailyWage: 700,
      week: _week('Meppadi', present: 6),
      advance: 500,
      advanceDay: 0,
    ),
    PayEntry(
      id: 'suresh',
      name: 'Suresh',
      phone: '9847012006',
      dailyWage: 650,
      week: _week('Kalpetta', present: 5),
    ),
    PayEntry(
      id: 'shaji',
      name: 'Shaji',
      phone: '9847012007',
      dailyWage: 650,
      week: _week('Kalpetta', present: 4),
      pastDays: const [5, 6],
    ),
    PayEntry(
      id: 'manoj',
      name: 'Manoj',
      phone: '9847012008',
      dailyWage: 600,
      week: _week('Kalpetta', present: 6),
      isDailyPaid: true,
    ),
  ];

  /// Already settled in the demo week.
  static const Set<String> demoPaid = {'rajan'};

  static List<DayMark> _week(
    String site, {
    required int present,
    int half = 0,
  }) => [
    for (var i = 0; i < 6; i++)
      if (i < present)
        DayMark(AttendanceStatus.present, site)
      else if (i < present + half)
        DayMark(AttendanceStatus.halfDay, site)
      else
        const DayMark(AttendanceStatus.absent),
  ];
}
