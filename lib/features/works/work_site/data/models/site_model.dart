enum SiteStatus { todo, ongoing, done }

class SiteModel {
  final String title;
  final String location;
  final DateTime startDate;
  final SiteStatus status;

  /// Amount earned today / this week, shown in the green chip.
  final int recentAmount;
  final int received;
  final int contractValue;

  /// Workers on site today; 0 means work is paused today.
  final int workersToday;

  final String? clientName;
  final String? clientPhone;

  /// e.g. "Borewell", "Open well".
  final String? workType;

  const SiteModel({
    required this.title,
    required this.location,
    required this.startDate,
    required this.status,
    required this.recentAmount,
    required this.received,
    required this.contractValue,
    required this.workersToday,
    this.clientName,
    this.clientPhone,
    this.workType,
  });

  SiteModel copyWith({SiteStatus? status}) => SiteModel(
    title: title,
    location: location,
    startDate: startDate,
    status: status ?? this.status,
    recentAmount: recentAmount,
    received: received,
    contractValue: contractValue,
    workersToday: status == SiteStatus.done ? 0 : workersToday,
    clientName: clientName,
    clientPhone: clientPhone,
    workType: workType,
  );

  double get progress =>
      contractValue <= 0 ? 0 : (received / contractValue).clamp(0.0, 1.0);

  // TODO: replace with Firestore-backed data.
  static final List<SiteModel> demo = [
    SiteModel(
      title: 'Kunjumon’s compound well',
      location: 'Ambalavayal',
      startDate: DateTime(2026, 11, 24),
      status: SiteStatus.todo,
      recentAmount: 0,
      received: 0,
      contractValue: 95000,
      workersToday: 0,
    ),
    SiteModel(
      title: 'Church borewell',
      location: 'Mananthavady',
      startDate: DateTime(2026, 11, 28),
      status: SiteStatus.todo,
      recentAmount: 0,
      received: 10000,
      contractValue: 140000,
      workersToday: 0,
    ),
    SiteModel(
      title: 'Rajeev’s borewell',
      location: 'Meppadi',
      startDate: DateTime(2026, 11, 3),
      status: SiteStatus.ongoing,
      recentAmount: 31200,
      received: 90000,
      contractValue: 150000,
      workersToday: 4,
      clientName: 'Rajeev K.',
      clientPhone: '98470 12345',
    ),
    SiteModel(
      title: 'Thomas’ open well',
      location: 'Kalpetta',
      startDate: DateTime(2026, 11, 12),
      status: SiteStatus.ongoing,
      recentAmount: 12800,
      received: 40000,
      contractValue: 85000,
      workersToday: 2,
      clientName: 'Thomas P.',
      clientPhone: '94460 55821',
    ),
    SiteModel(
      title: 'Panchayat ring well',
      location: 'Sulthan Bathery',
      startDate: DateTime(2026, 10, 28),
      status: SiteStatus.ongoing,
      recentAmount: 46500,
      received: 100000,
      contractValue: 210000,
      workersToday: 0,
    ),
    for (final (title, place, month, day, value) in [
      ('School tank', 'Pulpally', 9, 2, 120000),
      ('Anu’s borewell', 'Meenangadi', 9, 18, 90000),
      ('Temple pond', 'Vythiri', 10, 1, 175000),
      ('Joy’s open well', 'Kalpetta', 10, 6, 80000),
      ('Estate borewell', 'Chundale', 10, 12, 160000),
      ('Market ring well', 'Panamaram', 10, 20, 70000),
    ])
      SiteModel(
        title: title,
        location: place,
        startDate: DateTime(2026, month, day),
        status: SiteStatus.done,
        recentAmount: 0,
        received: value,
        contractValue: value,
        workersToday: 0,
      ),
  ];
}
