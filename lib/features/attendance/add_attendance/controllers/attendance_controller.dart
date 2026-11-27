import 'package:eroll/features/works/work_site/data/models/site_model.dart';
import 'package:flutter/foundation.dart';

import '../models/attendance_models.dart';

/// Holds the selected day, which site each worker is on, and the
/// attendance marks per day.
class AttendanceController extends ChangeNotifier {
  AttendanceController({DateTime? today})
    : today = _dateOnly(today ?? DateTime.now()) {
    // The strip has no Sunday card, so fall back to Saturday.
    _selectedDate = this.today.weekday == DateTime.sunday
        ? this.today.subtract(const Duration(days: 1))
        : this.today;
    _seedDemo();
  }

  final DateTime today;
  late DateTime _selectedDate;

  final List<Worker> workers = Worker.demo;

  /// Sites workers can be assigned to (ongoing only).
  final List<SiteModel> sites = SiteModel.demo
      .where((s) => s.status == SiteStatus.ongoing)
      .toList();

  /// workerId -> site title (null = no site).
  final Map<String, String?> _assignment = {};

  /// day -> workerId -> status.
  final Map<DateTime, Map<String, AttendanceStatus>> _marks = {};

  DateTime get selectedDate => _selectedDate;

  /// Monday of the week containing the selected date.
  DateTime get weekStart =>
      _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));

  /// Working days shown in the strip: Monday to Saturday.
  List<DateTime> get weekDays => List.generate(
    6,
    (i) => DateTime(weekStart.year, weekStart.month, weekStart.day + i),
  );

  bool isFuture(DateTime day) => _dateOnly(day).isAfter(today);

  bool hasMarks(DateTime day) => _marks[_dateOnly(day)]?.isNotEmpty ?? false;

  void selectDate(DateTime date) {
    final d = _dateOnly(date);
    if (d == _selectedDate) return;
    _selectedDate = d;
    notifyListeners();
  }

  void shiftWeek(int weeks) =>
      selectDate(_selectedDate.add(Duration(days: 7 * weeks)));

  SiteModel? siteOf(Worker worker) {
    final title = _assignment[worker.id];
    if (title == null) return null;
    for (final s in sites) {
      if (s.title == title) return s;
    }
    return null;
  }

  /// Status for the selected day. Unmarked workers default to present when
  /// they are on a site, absent otherwise.
  AttendanceStatus statusOf(Worker worker) =>
      _marks[_selectedDate]?[worker.id] ??
      (siteOf(worker) == null
          ? AttendanceStatus.absent
          : AttendanceStatus.present);

  void mark(Worker worker, AttendanceStatus status) {
    _marks.putIfAbsent(_selectedDate, () => {})[worker.id] = status;
    notifyListeners();
  }

  void moveWorker(Worker worker, SiteModel? site) {
    _assignment[worker.id] = site?.title;
    final current = _marks[_selectedDate];
    if (current != null) {
      current[worker.id] = site == null
          ? AttendanceStatus.absent
          : AttendanceStatus.present;
    }
    notifyListeners();
  }

  /// Sites with at least one worker, in site order, then "No site today".
  List<AttendanceGroup> get groups {
    final result = <AttendanceGroup>[];
    for (final site in sites) {
      final onSite = workers.where((w) => siteOf(w) == site).toList();
      if (onSite.isNotEmpty) {
        result.add(AttendanceGroup(site: site, workers: onSite));
      }
    }
    final unassigned = workers.where((w) => siteOf(w) == null).toList();
    if (unassigned.isNotEmpty) {
      result.add(AttendanceGroup(site: null, workers: unassigned));
    }
    return result;
  }

  int count(AttendanceStatus status) =>
      workers.where((w) => statusOf(w) == status).length;

  void _seedDemo() {
    const assignment = {
      'anil': 'Rajeev’s borewell',
      'sukumar': 'Rajeev’s borewell',
      'biju': 'Rajeev’s borewell',
      'vinod': 'Rajeev’s borewell',
      'rajan': 'Thomas’ open well',
      'manoj': 'Thomas’ open well',
    };
    for (final w in workers) {
      _assignment[w.id] = assignment[w.id];
    }
    // Every working day of the current week up to today is already marked.
    for (final day in weekDays.where((d) => !isFuture(d))) {
      _marks[day] = {for (final w in workers) w.id: statusOf(w)};
    }
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
