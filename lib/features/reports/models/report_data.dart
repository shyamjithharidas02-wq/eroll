/// Money totals for one period (a month, a year or all time).
class PeriodReport {
  final DateTime start;
  final int received;
  final int wages;
  final int costs;
  final int sites;

  const PeriodReport({
    required this.start,
    required this.received,
    required this.wages,
    required this.costs,
    required this.sites,
  });

  int get out => wages + costs;
  int get profit => received - out;

  PeriodReport operator +(PeriodReport other) => PeriodReport(
    start: start.isBefore(other.start) ? start : other.start,
    received: received + other.received,
    wages: wages + other.wages,
    costs: costs + other.costs,
    sites: sites + other.sites,
  );

  static PeriodReport sum(Iterable<PeriodReport> items) =>
      items.reduce((a, b) => a + b);
}

/// Everything the Reports screen shows.
class ReportsData {
  /// This month so far.
  final PeriodReport currentMonth;

  /// Earlier months of the current year, newest first.
  final List<PeriodReport> pastMonths;

  /// Earlier years, newest first.
  final List<PeriodReport> pastYears;

  const ReportsData({
    required this.currentMonth,
    required this.pastMonths,
    required this.pastYears,
  });

  PeriodReport get currentYear =>
      PeriodReport.sum([currentMonth, ...pastMonths]);

  PeriodReport get allTime => PeriodReport.sum([currentYear, ...pastYears]);

  /// The month before [month] if we have it (for "+47% vs Sep").
  PeriodReport? previousOf(PeriodReport month) {
    final months = [currentMonth, ...pastMonths];
    final i = months.indexWhere((m) => m.start == month.start);
    return (i >= 0 && i + 1 < months.length) ? months[i + 1] : null;
  }

  /// The current year followed by earlier years, newest first.
  List<PeriodReport> get allYears => [currentYear, ...pastYears];

  // TODO: compute from Firestore site payments, wages and expenses.
  static final demo = ReportsData(
    currentMonth: PeriodReport(
      start: DateTime(2026, 11),
      received: 230000,
      wages: 105500,
      costs: 66500,
      sites: 3,
    ),
    pastMonths: [
      for (final (month, received, out, sites) in const [
        (10, 340000, 227600, 4),
        (9, 265000, 189000, 4),
        (8, 140000, 110000, 3),
        (7, 95000, 77000, 2),
        (6, 110000, 88000, 3),
        (5, 180000, 140000, 4),
        (4, 120000, 96000, 3),
        (3, 150000, 118000, 3),
        (2, 85000, 71000, 2),
        (1, 60000, 52000, 2),
      ])
        _split(
          DateTime(2026, month),
          received,
          out,
          sites,
          // October matches the month-report design exactly.
          wages: month == 10 ? 133700 : null,
        ),
    ],
    pastYears: [
      _split(DateTime(2025), 1480000, 1150000, 21),
      _split(DateTime(2024), 920000, 735000, 14),
    ],
  );

  /// Demo helper: splits total spend roughly 60/40 into wages and costs.
  static PeriodReport _split(
    DateTime start,
    int received,
    int out,
    int sites, {
    int? wages,
  }) {
    wages ??= (out * 0.6 / 100).round() * 100;
    return PeriodReport(
      start: start,
      received: received,
      wages: wages,
      costs: out - wages,
      sites: sites,
    );
  }
}
