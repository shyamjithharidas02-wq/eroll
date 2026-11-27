import 'package:eroll/core/widgets/custom_back_button_appbar.dart';
import 'package:eroll/core/widgets/custom_title_appbar.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/features/payroll/staff_payroll_report/components/conditions_apply_widget.dart';
import 'package:eroll/features/payroll/staff_payroll_report/components/salary_sheet_month_title_widget.dart';
import 'package:flutter/material.dart';

class StaffPayrollReportScreen extends StatefulWidget {
  const StaffPayrollReportScreen({super.key});

  @override
  State<StaffPayrollReportScreen> createState() =>
      _StaffPayrollReportScreenState();
}

class _StaffPayrollReportScreenState extends State<StaffPayrollReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButtonAppbar(),
        title: const CustomTitleAppbar(appBarTitle: 'Salary Sheet'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const ConditionsApplyWidget(),
                const SizedBox(height: 12),

                const SalarySheetMonthTitleWidget(),
                const SizedBox(height: 12),

                const Row(
                  children: [Text('Staff  name: '), Text('Shanid P P')],
                ),
                const Row(
                  children: [Text('Phone number: '), Text('9876543210')],
                ),
                const SizedBox(height: 30),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.strokeColor),
                    ),
                    headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors.grey.shade200,
                    ),
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('No Of Works')),
                      DataColumn(label: Text('Gross Sal')),
                      DataColumn(label: Text('Advance')),
                      DataColumn(label: Text('Net Sal')),
                    ],
                    rows: const <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('01-07')),
                          DataCell(Text('6')),
                          DataCell(Text('6000')),
                          DataCell(Text('2000')),
                          DataCell(Text('4000')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('08-14')),
                          DataCell(Text('6')),
                          DataCell(Text('6000')),
                          DataCell(Text('500')),
                          DataCell(Text('5500')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('15-21')),
                          DataCell(Text('6')),
                          DataCell(Text('6000')),
                          DataCell(Text('1000')),
                          DataCell(Text('5000')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('22-28')),
                          DataCell(Text('6')),
                          DataCell(Text('6000')),
                          DataCell(Text('1000')),
                          DataCell(Text('5000')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('29-30')),
                          DataCell(Text('2')),
                          DataCell(Text('2000')),
                          DataCell(Text('0')),
                          DataCell(Text('2000')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              'Total',
                              style: TextStyle(fontFamily: 'cabinBold'),
                            ),
                          ),
                          DataCell(
                            Text(
                              '26',
                              style: TextStyle(fontFamily: 'cabinBold'),
                            ),
                          ),
                          DataCell(
                            Text(
                              '26000',
                              style: TextStyle(fontFamily: 'cabinBold'),
                            ),
                          ),
                          DataCell(
                            Text(
                              '4500',
                              style: TextStyle(fontFamily: 'cabinBold'),
                            ),
                          ),
                          DataCell(
                            Text(
                              '21500',
                              style: TextStyle(fontFamily: 'cabinBold'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Advance Details
                const Text(
                  'Advance Details',
                  style: TextStyle(fontFamily: 'cabinBold'),
                ),

                ...List.generate(5, (index) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text('18-June-2025: '),
                        SizedBox(width: 40),
                        Text('2000'),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
