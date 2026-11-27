import '../../../attendance/add_attendance/models/attendance_models.dart';
import '../../../pay/models/pay_models.dart';

enum StaffRole {
  driller('Driller'),
  helper('Helper'),
  driver('Driver'),
  other('Other');

  const StaffRole(this.label);
  final String label;
}

enum PayCycle {
  daily('Daily'),
  weekly('Weekly');

  const PayCycle(this.label);
  final String label;
}

class StaffMember {
  final String id;
  final String name;
  final String phone;
  final String homePlace;
  final StaffRole role;
  final int dailyWage;
  final PayCycle payCycle;

  /// Still owed for the current week; 0 means settled.
  final int dueThisWeek;

  const StaffMember({
    required this.id,
    required this.name,
    required this.role,
    required this.dailyWage,
    required this.payCycle,
    this.phone = '',
    this.homePlace = '',
    this.dueThisWeek = 0,
  });

  String get initial => name.isEmpty ? '' : name[0].toUpperCase();

  /// "9847012345" -> "98470 12345"; other formats are left as typed.
  String get phoneDisplay {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length != 10) return phone;
    return '${digits.substring(0, 5)} ${digits.substring(5)}';
  }

  StaffMember copyWith({
    String? name,
    String? phone,
    String? homePlace,
    StaffRole? role,
    int? dailyWage,
    PayCycle? payCycle,
    int? dueThisWeek,
  }) => StaffMember(
    id: id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    homePlace: homePlace ?? this.homePlace,
    role: role ?? this.role,
    dailyWage: dailyWage ?? this.dailyWage,
    payCycle: payCycle ?? this.payCycle,
    dueThisWeek: dueThisWeek ?? this.dueThisWeek,
  );

  /// This week's pay record, used by the pay detail page.
  PayEntry toPayEntry() {
    for (final e in PayEntry.demo) {
      if (e.id == id) return e;
    }
    // New crew member: no days marked yet.
    return PayEntry(
      id: id,
      name: name,
      phone: phone.replaceAll(' ', ''),
      dailyWage: dailyWage,
      week: List.filled(6, const DayMark(AttendanceStatus.absent)),
      isDailyPaid: payCycle == PayCycle.daily,
      pastDays: const [],
    );
  }
}
