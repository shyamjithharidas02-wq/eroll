import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/resource_path.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffListPayrollScreen extends StatefulWidget {
  const StaffListPayrollScreen({super.key});

  @override
  State<StaffListPayrollScreen> createState() => _StaffListPayrollScreenState();
}

class _StaffListPayrollScreenState extends State<StaffListPayrollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Staff Salary Statement',
          style: TextStyle(fontFamily: 'cabinBold'),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(CupertinoIcons.back),
        ),
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
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.strokeColor),
                ),
                child: Row(
                  spacing: 15,

                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        AssetPath.profileCircleVector,
                      ),
                    ),
                    Column(
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
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
