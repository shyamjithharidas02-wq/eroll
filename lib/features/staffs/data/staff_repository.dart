import 'package:flutter/foundation.dart';

import '../../pay/models/pay_models.dart';
import 'models/staff_member.dart';

/// App-wide crew list. In memory for now.
// TODO: back with Firestore (`staffs` collection).
class StaffRepository extends ChangeNotifier {
  StaffRepository() : _staff = _seed();

  final List<StaffMember> _staff;
  final List<StaffMember> _pastCrew = [];

  List<StaffMember> get staff => List.unmodifiable(_staff);

  /// Removed members. Their history stays in reports; they can be restored.
  List<StaffMember> get pastCrew => List.unmodifiable(_pastCrew);

  StaffMember? byId(String id) {
    for (final s in _staff) {
      if (s.id == id) return s;
    }
    return null;
  }

  void add(StaffMember member) {
    _staff.add(member);
    notifyListeners();
  }

  void update(StaffMember member) {
    final i = _staff.indexWhere((s) => s.id == member.id);
    if (i < 0) return;
    _staff[i] = member;
    notifyListeners();
  }

  /// Takes a member off the active crew (attendance and pay).
  void remove(String id) {
    final i = _staff.indexWhere((s) => s.id == id);
    if (i < 0) return;
    _pastCrew.insert(0, _staff.removeAt(i));
    notifyListeners();
  }

  /// Brings a past member back onto the active crew.
  void restore(String id) {
    final i = _pastCrew.indexWhere((s) => s.id == id);
    if (i < 0) return;
    _staff.add(_pastCrew.removeAt(i));
    notifyListeners();
  }

  void recordPayment(String id, int amount) {
    final i = _staff.indexWhere((s) => s.id == id);
    if (i < 0) return;
    final due = _staff[i].dueThisWeek - amount;
    _staff[i] = _staff[i].copyWith(dueThisWeek: due < 0 ? 0 : due);
    notifyListeners();
  }

  static List<StaffMember> _seed() {
    const order = [
      ('anil', StaffRole.driller, 'Meppadi'),
      ('sukumar', StaffRole.helper, 'Kalpetta'),
      ('biju', StaffRole.helper, 'Meppadi'),
      ('rajan', StaffRole.helper, 'Kalpetta'),
      ('vinod', StaffRole.helper, 'Ambalavayal'),
      ('suresh', StaffRole.helper, 'Kalpetta'),
      ('shaji', StaffRole.helper, 'Vythiri'),
      ('manoj', StaffRole.driver, 'Kalpetta'),
    ];
    return [
      for (final (id, role, place) in order)
        for (final e in PayEntry.demo)
          if (e.id == id)
            StaffMember(
              id: e.id,
              name: e.name,
              phone: e.phone,
              homePlace: place,
              role: role,
              dailyWage: e.dailyWage,
              payCycle: e.isDailyPaid ? PayCycle.daily : PayCycle.weekly,
              dueThisWeek: e.isDailyPaid || PayEntry.demoPaid.contains(e.id)
                  ? 0
                  : e.payable,
            ),
    ];
  }
}
