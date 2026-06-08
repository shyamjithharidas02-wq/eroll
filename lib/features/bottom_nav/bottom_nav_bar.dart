import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/features/home/view/home_screen.dart';
import 'package:eroll/features/staffs/view/staffs_screen.dart';
import 'package:eroll/features/works/work_site/view/works_site_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../attendance/add_attendance/view/attendance_screen.dart';
import 'components/bottom_nav_icon_widget.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    AttendanceScreen(),
    StaffsScreen(),
    WorksSiteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.strokeColor)),
        ),
        child: BottomAppBar(
          color: AppColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavIconWidget(
                icons: CupertinoIcons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
              ),
              BottomNavIconWidget(
                icons: CupertinoIcons.calendar_badge_plus,
                label: 'Attendance',
                isActive: currentIndex == 1,
                onTap: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
              ),
              BottomNavIconWidget(
                icons: CupertinoIcons.person_2_square_stack,
                label: 'Staffs',
                isActive: currentIndex == 2,
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
              ),
              BottomNavIconWidget(
                icons: CupertinoIcons.building_2_fill,
                label: 'Works',
                isActive: currentIndex == 3,
                onTap: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
