import 'report_data.dart';

/// One site's result for the month.
class SiteMonthResult {
  final String name;
  final String location;

  /// null while the job is still running.
  final DateTime? finishedOn;
  final int profit;

  const SiteMonthResult({
    required this.name,
    required this.location,
    required this.profit,
    this.finishedOn,
  });

  bool get ongoing => finishedOn == null;
}

/// Wages paid to one crew member in the month.
class StaffMonthResult {
  final String name;
  final int days;
  final int dailyWage;

  /// Overtime / bonus on top of the daily wage (can be negative for cuts).
  final int extra;

  const StaffMonthResult({
    required this.name,
    required this.days,
    required this.dailyWage,
    this.extra = 0,
  });

  int get total => days * dailyWage + extra;
}

enum CostCategory { diesel, materials, transport, food, equipment, other }

/// Spending in one cost category for the month.
class CostMonthResult {
  final CostCategory category;
  final int entries;
  final int amount;

  const CostMonthResult({
    required this.category,
    required this.entries,
    required this.amount,
  });

  String get label => switch (category) {
    CostCategory.diesel => 'Diesel',
    CostCategory.materials => 'Materials',
    CostCategory.transport => 'Transport',
    CostCategory.food => 'Food & tea',
    CostCategory.equipment => 'Equipment hire',
    CostCategory.other => 'Other',
  };
}

/// Everything on the month report screen.
class MonthReport {
  final PeriodReport summary;

  /// Same totals for the month before, for the "vs Sep" badge.
  final PeriodReport? previous;
  final List<SiteMonthResult> sites;
  final List<StaffMonthResult> staff;
  final List<CostMonthResult> costs;

  const MonthReport({
    required this.summary,
    required this.previous,
    required this.sites,
    required this.staff,
    required this.costs,
  });

  /// Whole-percent change in profit vs the previous month, or null when
  /// there's nothing sensible to compare against.
  int? get profitChangePercent {
    final before = previous?.profit;
    if (before == null || before <= 0) return null;
    return ((summary.profit - before) * 100 / before).truncate();
  }

  // TODO: build from Firestore site payments, attendance and expenses.
  static MonthReport demoFor(PeriodReport summary, {PeriodReport? previous}) {
    final m = summary.start;
    if (m.year == 2026 && m.month == 10) {
      return MonthReport(
        summary: summary,
        previous: previous,
        sites: [
          const SiteMonthResult(
            name: 'Mathai’s borewell',
            location: 'Kambalakkad',
            profit: 49500,
          ),
          SiteMonthResult(
            name: 'Joseph’s borewell',
            location: 'Pozhuthana',
            finishedOn: DateTime(2026, 10, 30),
            profit: 38000,
          ),
          SiteMonthResult(
            name: 'Church well deepening',
            location: 'Mananthavady',
            finishedOn: DateTime(2026, 10, 9),
            profit: 27300,
          ),
          SiteMonthResult(
            name: 'Ravi’s well repair',
            location: 'Kalpetta',
            finishedOn: DateTime(2026, 10, 22),
            profit: -2400,
          ),
        ],
        staff: const [
          StaffMonthResult(name: 'Babu', days: 26, dailyWage: 1000),
          StaffMonthResult(name: 'Suresh', days: 26, dailyWage: 900),
          StaffMonthResult(name: 'Anil', days: 26, dailyWage: 850),
          StaffMonthResult(name: 'Manoj', days: 25, dailyWage: 800),
          StaffMonthResult(name: 'Rajan', days: 24, dailyWage: 800),
          StaffMonthResult(name: 'Vinod', days: 20, dailyWage: 700),
          StaffMonthResult(name: 'Shaji', days: 8, dailyWage: 675),
          StaffMonthResult(name: 'Pradeep', days: 6, dailyWage: 600),
        ],
        costs: const [
          CostMonthResult(
            category: CostCategory.diesel,
            entries: 14,
            amount: 38600,
          ),
          CostMonthResult(
            category: CostCategory.materials,
            entries: 9,
            amount: 27400,
          ),
          CostMonthResult(
            category: CostCategory.equipment,
            entries: 3,
            amount: 15000,
          ),
          CostMonthResult(
            category: CostCategory.transport,
            entries: 7,
            amount: 8200,
          ),
          CostMonthResult(
            category: CostCategory.food,
            entries: 21,
            amount: 4700,
          ),
        ],
      );
    }
    return _generated(summary, previous);
  }

  /// Splits a month's totals over demo sites, crew and costs so every
  /// month has something believable to show.
  static MonthReport _generated(PeriodReport s, PeriodReport? previous) {
    const siteNames = [
      ('Rajeev’s borewell', 'Meppadi'),
      ('Thomas’ open well', 'Kalpetta'),
      ('Panchayat ring well', 'Sulthan Bathery'),
      ('School tank', 'Pulpally'),
      ('Anu’s borewell', 'Meenangadi'),
    ];
    const siteWeights = [0.42, 0.28, 0.18, 0.08, 0.04];
    const crew = [
      ('Babu', 1000),
      ('Suresh', 900),
      ('Anil', 850),
      ('Manoj', 800),
      ('Rajan', 800),
      ('Vinod', 700),
    ];
    const costWeights = {
      CostCategory.diesel: 0.42,
      CostCategory.materials: 0.30,
      CostCategory.transport: 0.16,
      CostCategory.food: 0.12,
    };

    final siteCount = s.sites.clamp(1, siteNames.length);
    final weights = siteWeights.take(siteCount).toList();
    final profits = _distribute(s.profit, weights);
    final sites = [
      for (var i = 0; i < siteCount; i++)
        SiteMonthResult(
          name: siteNames[i].$1,
          location: siteNames[i].$2,
          profit: profits[i],
          finishedOn: i == 0
              ? null
              : DateTime(s.start.year, s.start.month, 28 - i * 6),
        ),
    ];

    // Hand out working days, heaviest first, until wages are covered.
    final staff = <StaffMonthResult>[];
    var left = s.wages;
    for (final (name, wage) in crew) {
      if (left < wage) break;
      final days = (left ~/ wage).clamp(1, 26);
      staff.add(StaffMonthResult(name: name, days: days, dailyWage: wage));
      left -= days * wage;
    }
    // Whatever doesn't fit a full day goes down as extra on the last person,
    // so the rows always add up to the month's wages.
    if (left != 0 && staff.isNotEmpty) {
      final last = staff.removeLast();
      staff.add(
        StaffMonthResult(
          name: last.name,
          days: last.days,
          dailyWage: last.dailyWage,
          extra: left,
        ),
      );
    }

    final costAmounts = _distribute(s.costs, costWeights.values.toList());
    final costs = [
      for (final (i, c) in costWeights.keys.indexed)
        CostMonthResult(
          category: c,
          entries: 3 + (costAmounts[i] ~/ 4000),
          amount: costAmounts[i],
        ),
    ];

    return MonthReport(
      summary: s,
      previous: previous,
      sites: sites,
      staff: staff,
      costs: costs,
    );
  }

  /// Splits [total] by [weights], rounded to ₹100, remainder on the first.
  static List<int> _distribute(int total, List<double> weights) {
    final sum = weights.fold<double>(0, (a, b) => a + b);
    final parts = [
      for (final w in weights) (total * w / sum / 100).round() * 100,
    ];
    parts[0] += total - parts.fold(0, (a, b) => a + b);
    return parts;
  }
}
