import 'package:eroll/core/widgets/custom_back_button_appbar.dart';
import 'package:eroll/core/widgets/custom_tile_border_widget.dart';
import 'package:eroll/core/widgets/custom_title_appbar.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:flutter/material.dart';

class PayrollMonthScreen extends StatelessWidget {
  const PayrollMonthScreen({super.key, required this.isMonthlyLedgerReport});

  final bool? isMonthlyLedgerReport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButtonAppbar(),
        title: CustomTitleAppbar(appBarTitle: 'Months'),
      ),

      body: SafeArea(
        child: ListView.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (isMonthlyLedgerReport!) {
                  Navigator.pushNamed(
                    context,
                    AppRouteNames.staffPayrollReportScreen,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    AppRouteNames.monthlyLedgerReportScreen,
                  );
                }
              },
              child: CustomTileBorderWidget(child: Text('Month ${index + 1}')),
            );
          },
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
