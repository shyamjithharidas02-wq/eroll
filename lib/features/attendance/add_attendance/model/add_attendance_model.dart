class AddAttendanceModel {
  final String empId;
  final String name;
  final String mobile;
  final DateTime date;
  bool isPresent;

  AddAttendanceModel({
    required this.empId,
    required this.name,
    required this.mobile,
    required this.date,
    this.isPresent = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'empId': empId,
      'name': name,
      'mobile': mobile,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
    };
  }

  factory AddAttendanceModel.fromMap(Map<String, dynamic> map) {
    return AddAttendanceModel(
      empId: map['empId'],
      name: map['name'],
      mobile: map['mobile'],
      date: DateTime.parse(map['date']),
      isPresent: map['isPresent'] ?? true,
    );
  }
}
