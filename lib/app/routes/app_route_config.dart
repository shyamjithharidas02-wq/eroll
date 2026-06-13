import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/attendance/report_attendance/view/attendance_report_screen.dart';
import 'package:eroll/features/create_staff/model/create_staff_model.dart';
import 'package:eroll/features/create_staff/views/create_staff_screen.dart';
import 'package:eroll/features/payroll/add_salary/add_salary_screen.dart';
import 'package:eroll/features/payroll/monthly_ledger_report/view/monthly_ledger_report.dart';
import 'package:eroll/features/settings/view/settings_screen.dart';
import 'package:eroll/features/works/create_work/model/create_work_model.dart';
import 'package:eroll/features/works/create_work/view/create_work_screen.dart';
import 'package:eroll/features/home/views/home_page.dart';
import 'package:eroll/features/leave/staff_leave_screen.dart';
import 'package:eroll/features/onboarding/onboard_screen.dart';
import 'package:eroll/features/onboarding/splash_screen.dart';
import 'package:eroll/features/payroll/monthly_payroll/payroll_month_screen.dart';
import 'package:eroll/features/payroll/staff_payroll_report/view/staff_payroll_report_screen.dart';
import 'package:eroll/features/payroll/staff_list_payroll/staff_list_payroll_screen.dart';
import 'package:eroll/features/staffs/view/staffs_screen.dart';
import 'package:eroll/features/works/update_work/view/update_work_status_screen.dart';
import 'package:eroll/features/works/work_site/view/works_site_screen.dart';
import 'package:flutter/material.dart';

import '../../features/attendance/add_attendance/view/attendance_screen.dart';
import '../../features/bottom_nav/bottom_nav_bar.dart';

class AppRouteConfig {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case AppRouteNames.onboardScreen:
        return MaterialPageRoute(builder: (context) => OnboardScreen());

      case AppRouteNames.bottomNavScreen:
        return MaterialPageRoute(builder: (context) => BottomNavBar());

      case AppRouteNames.HomePage:
        return MaterialPageRoute(builder: (context) => HomePage());

      case AppRouteNames.attendanceScreen:
        return MaterialPageRoute(builder: (context) => AttendanceScreen());

      case AppRouteNames.siteWorksScreen:
        final args = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => WorksSiteScreen(activeIndex: args),
        );

      case AppRouteNames.createWorkScreen:
        return MaterialPageRoute(builder: (context) => CreateWorkScreen());

      case AppRouteNames.updateWorksScreen:
        final modelArgs = settings.arguments as CreateWorkModel;
        return MaterialPageRoute(
          builder: (context) => UpdateWorkStatusScreen(workModel: modelArgs),
        );

      case AppRouteNames.staffsScreen:
        return MaterialPageRoute(builder: (context) => StaffsScreen());

      case AppRouteNames.staffOnLeaveScreen:
        return MaterialPageRoute(builder: (context) => StaffLeaveScreen());

      case AppRouteNames.createStaffScreen:
        // Completely safe approach - handle all possible cases
        final arguments = settings.arguments;

        return MaterialPageRoute(
          builder: (context) {
            // Check if we have valid staff data for editing
            if (arguments != null && arguments is CreateStaffModel) {
              return CreateStaffScreen(isEditMode: true, staffData: arguments);
            }

            // Default to create mode (new staff)
            return CreateStaffScreen(isEditMode: false, staffData: null);
          },
        );

      case AppRouteNames.staffListPayrollScreen:
        return MaterialPageRoute(
          builder: (context) => StaffListPayrollScreen(),
        );

      case AppRouteNames.staffPayrollReportScreen:
        return MaterialPageRoute(
          builder: (context) => StaffPayrollReportScreen(),
        );

      case AppRouteNames.payrollMonthListScreen:
        final args = settings.arguments as bool;
        return MaterialPageRoute(
          builder: (context) => PayrollMonthScreen(isMonthlyLedgerReport: args),
        );

      case AppRouteNames.monthlyLedgerReportScreen:
        return MaterialPageRoute(builder: (context) => MonthlyLedgerReport());

      case AppRouteNames.addSalaryScreen:
        return MaterialPageRoute(builder: (context) => AddSalaryScreen());

      case AppRouteNames.attendanceReportScreen:
        return MaterialPageRoute(
          builder: (context) => AttendanceReportScreen(),
        );

      case AppRouteNames.settingsScreen:
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(body: Center(child: Text('No Routes Found..!')));
      },
    );
  }
}
