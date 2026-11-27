import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/features/home/views/home_page.dart';
import 'package:eroll/features/pay/views/pay_page.dart';
import 'package:eroll/features/staffs/views/staffs_page.dart';
import 'package:eroll/features/works/work_site/views/work_site_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../attendance/add_attendance/views/attendance_page.dart';
import 'components/bottom_nav_icon_widget.dart';

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int currentIndex = widget.initialIndex;

  static const _items = [
    _NavItem(Iconsax.home_2_copy, 'Home'),
    _NavItem(Iconsax.location_copy, 'Sites'),
    _NavItem(Iconsax.calendar_tick_copy, 'Attendance'),
    _NavItem(Iconsax.empty_wallet_copy, 'Pay'),
    _NavItem(Iconsax.people_copy, 'Staff'),
  ];

  void _select(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);
  }

  Widget _screenFor(int index) {
    switch (index) {
      case 1:
        return const WorkSitePage();
      case 2:
        return const AttendancePage();
      case 3:
        return const PayPage();
      case 4:
        return const StaffsPage();
      default:
        return HomePage(onOpenTab: _select);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.canvas,
      body: _screenFor(currentIndex),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: AppColors.forest,
              borderRadius: BorderRadius.circular(34),
              boxShadow: [
                BoxShadow(
                  color: AppColors.forest.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < _items.length; i++)
                  BottomNavIconWidget(
                    icons: _items[i].icon,
                    label: _items[i].label,
                    isActive: currentIndex == i,
                    onTap: () => _select(i),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
