import 'package:eroll/core/widgets/custom_back_button_appbar.dart';
import 'package:eroll/core/widgets/custom_title_appbar.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/features/payroll/staff_payroll_report/components/conditions_apply_widget.dart';
import 'package:eroll/features/payroll/staff_payroll_report/components/salary_sheet_month_title_widget.dart';
import 'package:flutter/material.dart';

class MonthlyLedgerReport extends StatelessWidget {
  const MonthlyLedgerReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButtonAppbar(),
        title: CustomTitleAppbar(appBarTitle: 'Monthly Ledger Report'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),

              ConditionsApplyWidget(),
              SizedBox(height: 12),

              SalarySheetMonthTitleWidget(),
              SizedBox(height: 12),

              Text('Created by admin'),
              SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.strokeColor),
                  ),
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => Colors.grey.shade200,
                  ),
                  columns: <DataColumn>[
                    DataColumn(label: Text('Staff Name')),
                    DataColumn(label: Text('Total Works')),
                    DataColumn(label: Text('Total Leaves')),
                    DataColumn(label: Text('Net Salary')),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Shanid')),
                        DataCell(Text('22')),
                        DataCell(Text('9')),
                        DataCell(Text('22000')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Shanid')),
                        DataCell(Text('22')),
                        DataCell(Text('9')),
                        DataCell(Text('22000')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Shanid')),
                        DataCell(Text('22')),
                        DataCell(Text('9')),
                        DataCell(Text('22000')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Shanid')),
                        DataCell(Text('22')),
                        DataCell(Text('9')),
                        DataCell(Text('22000')),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        DataCell(Text('Shanid')),
                        DataCell(Text('22')),
                        DataCell(Text('9')),
                        DataCell(Text('22000')),
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
                          Text('26', style: TextStyle(fontFamily: 'cabinBold')),
                        ),
                        DataCell(
                          Text('45', style: TextStyle(fontFamily: 'cabinBold')),
                        ),

                        DataCell(
                          Text(
                            '100000',
                            style: TextStyle(fontFamily: 'cabinBold'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
