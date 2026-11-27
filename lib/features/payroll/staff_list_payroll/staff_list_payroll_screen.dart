import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/asset_path.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffListPayrollScreen extends StatefulWidget {
  const StaffListPayrollScreen({super.key, this.showBackButton = true});

  /// False when shown as a bottom-nav tab, where there is nothing to pop.
  final bool showBackButton;

  @override
  State<StaffListPayrollScreen> createState() => _StaffListPayrollScreenState();
}

class _StaffListPayrollScreenState extends State<StaffListPayrollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Staff Salary Statement',
          style: TextStyle(fontFamily: 'cabinBold'),
        ),
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.back),
              )
            : null,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouteNames.payrollMonthListScreen,
                  arguments: true,
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.strokeColor),
                ),
                child: Row(
                  spacing: 15,

                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(AssetPath.profile),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(fontFamily: 'cabinBold'),
                        ),
                        Text(
                          'Employee Type',
                          style: TextStyle(color: AppColors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
