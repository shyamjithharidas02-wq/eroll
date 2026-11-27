import 'package:eroll/features/works/work_site/data/models/site_model.dart';

enum AttendanceStatus { present, halfDay, absent }

class Worker {
  final String id;
  final String name;
  final int dailyWage;

  const Worker({required this.id, required this.name, required this.dailyWage});

  String get initial => name.isEmpty ? '' : name[0].toUpperCase();

  // TODO: replace with Firestore-backed data.
  static const List<Worker> demo = [
    Worker(id: 'anil', name: 'Anil', dailyWage: 900),
    Worker(id: 'sukumar', name: 'Sukumar', dailyWage: 700),
    Worker(id: 'biju', name: 'Biju', dailyWage: 750),
    Worker(id: 'vinod', name: 'Vinod', dailyWage: 700),
    Worker(id: 'rajan', name: 'Rajan', dailyWage: 700),
    Worker(id: 'manoj', name: 'Manoj', dailyWage: 600),
    Worker(id: 'suresh', name: 'Suresh', dailyWage: 650),
    Worker(id: 'shaji', name: 'Shaji', dailyWage: 650),
  ];
}

/// A site group on the attendance screen. [site] is null for the
/// "No site today" group.
class AttendanceGroup {
  final SiteModel? site;
  final List<Worker> workers;

  const AttendanceGroup({required this.site, required this.workers});

  String get label =>
      site == null ? 'No site today' : '${site!.location} · ${site!.title}';
}
