import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class AddAttendanceProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool isLoad) {
    _isLoading = isLoad;
    notifyListeners();
  }

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Future<void> saveAttendance() async {}
}
