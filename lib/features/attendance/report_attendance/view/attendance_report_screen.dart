import 'package:eroll/core/widgets/custom_back_button_appbar.dart';
import 'package:eroll/core/widgets/custom_title_appbar.dart';
import 'package:flutter/material.dart';

class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButtonAppbar(),
        title: CustomTitleAppbar(appBarTitle: 'Attendance Report'),
      ),

      body: Column(children: <Widget>[]),
    );
  }
}
