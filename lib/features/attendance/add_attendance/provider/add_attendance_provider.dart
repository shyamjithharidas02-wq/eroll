import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eroll/features/attendance/add_attendance/model/add_attendance_model.dart';
import 'package:eroll/features/create_staff/model/create_staff_model.dart';
import 'package:flutter/material.dart';

class AddAttendanceProvider extends ChangeNotifier {
  final _fireStore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isMarkedToday = false;
  bool get isMarkedToday => _isMarkedToday;

  List<AddAttendanceModel> _attendanceList = [];
  List<AddAttendanceModel> get attendanceList => _attendanceList;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void initializeAttendance(List<CreateStaffModel> staff) async {
    DateTime today = DateTime.now();
    String dateId =
        "${today.year}-${today.month.toString().padLeft(2, "0")}-${today.year.toString().padLeft(2, "0")}";

    // check if today's attendance already exists
    final snapshot =
        await _fireStore
            .collection("attendance")
            .doc(dateId)
            .collection("staffs")
            .get();

    if (snapshot.docs.isNotEmpty) {
      // load attendance
      _attendanceList =
          snapshot.docs
              .map((doc) => AddAttendanceModel.fromMap(doc.data()))
              .toList();
      _isMarkedToday = true;
    } else {
      _attendanceList =
          staff.map((e) {
            return AddAttendanceModel(
              empId: e.staffId,
              name: e.name,
              mobile: e.mobile,
              date: today,
              isPresent: true,
            );
          }).toList();
      _isMarkedToday = false;
    }
    notifyListeners();
  }

  void toggleAttendance(String empId, bool val) {
    if (_isMarkedToday) return;

    final index = _attendanceList.indexWhere(
      (element) => element.empId == empId,
    );

    if (index != -1) {
      _attendanceList[index].isPresent = val;
      notifyListeners();
    }
  }

  Future<void> saveAttendace() async {
    try {
      if (_isMarkedToday) return;
      _setLoading(true);

      DateTime today = DateTime.now();
      String dateId =
          "${today.year}-${today.month.toString().padLeft(2, "0")}-${today.year.toString().padLeft(2, "0")}";

      WriteBatch batch = _fireStore.batch();
      for (var record in _attendanceList) {
        DocumentReference docRef = _fireStore
            .collection("attendance")
            .doc(dateId)
            .collection("staffs")
            .doc(record.empId);

        batch.set(docRef, record.toMap());
      }
      await batch.commit();
      _isMarkedToday = true;
      await Future.delayed(Duration(seconds: 2));
    } catch (error) {
      log('Error while marking attendance: $error');
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }
}
