import 'package:flutter/material.dart';

class SalarySheetMonthTitleWidget extends StatelessWidget {
  const SalarySheetMonthTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Salary Sheet of June 2025',
      style: TextStyle(fontFamily: 'cabinBold', fontSize: 20),
    );
  }
}
