import '../../../work_site/data/models/site_model.dart';

/// A money movement on a site. Positive = money in, negative = money out.
class SiteTransaction {
  final String title;
  final String? mode;
  final DateTime date;
  final int amount;

  const SiteTransaction({
    required this.title,
    required this.date,
    required this.amount,
    this.mode,
  });

  bool get isIncome => amount > 0;

  String get label => mode == null ? title : '$title · $mode';
}

class CrewDays {
  final String name;
  final int days;

  const CrewDays({required this.name, required this.days});

  String get initial => name.isEmpty ? '' : name[0].toUpperCase();
}

class SiteDetail {
  /// Total wages earned on this site, from attendance.
  final int wages;
  final List<CrewDays> crew;
  final List<SiteTransaction> transactions;

  const SiteDetail({
    required this.wages,
    required this.crew,
    required this.transactions,
  });

  int get received =>
      transactions.where((t) => t.isIncome).fold(0, (sum, t) => sum + t.amount);

  int get siteCosts => transactions
      .where((t) => !t.isIncome)
      .fold(0, (sum, t) => sum - t.amount);

  int get profit => received - wages - siteCosts;

  SiteDetail copyWith({List<SiteTransaction>? transactions}) => SiteDetail(
    wages: wages,
    crew: crew,
    transactions: transactions ?? this.transactions,
  );

  // TODO: replace with Firestore-backed data.
  static SiteDetail demoFor(SiteModel site) => switch (site.title) {
    'Rajeev’s borewell' => SiteDetail(
      wages: 42300,
      crew: const [
        CrewDays(name: 'Anil', days: 16),
        CrewDays(name: 'Sukumar', days: 14),
        CrewDays(name: 'Biju', days: 12),
        CrewDays(name: 'Vinod', days: 13),
      ],
      transactions: [
        SiteTransaction(
          title: 'Client payment',
          mode: 'UPI',
          date: DateTime(2026, 11, 18),
          amount: 40000,
        ),
        SiteTransaction(
          title: 'Diesel for rig',
          date: DateTime(2026, 11, 17),
          amount: -6500,
        ),
        SiteTransaction(
          title: 'PVC casing pipes',
          date: DateTime(2026, 11, 12),
          amount: -10000,
        ),
        SiteTransaction(
          title: 'Client advance',
          mode: 'Cash',
          date: DateTime(2026, 11, 5),
          amount: 50000,
        ),
      ],
    ),
    'Thomas’ open well' => SiteDetail(
      wages: 18200,
      crew: const [
        CrewDays(name: 'Rajan', days: 9),
        CrewDays(name: 'Manoj', days: 8),
      ],
      transactions: [
        SiteTransaction(
          title: 'Ring cement',
          date: DateTime(2026, 11, 16),
          amount: -9000,
        ),
        SiteTransaction(
          title: 'Client advance',
          mode: 'UPI',
          date: DateTime(2026, 11, 12),
          amount: 40000,
        ),
      ],
    ),
    _ => SiteDetail(
      wages: 0,
      crew: const [],
      transactions: [
        if (site.received > 0)
          SiteTransaction(
            title: 'Client payment',
            date: site.startDate,
            amount: site.received,
          ),
      ],
    ),
  };
}
