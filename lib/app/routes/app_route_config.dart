import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/attendance/report_attendance/view/attendance_report_screen.dart';
import 'package:eroll/features/create_staff/views/add_staff_page.dart';
import 'package:eroll/features/payroll/add_salary/add_salary_screen.dart';
import 'package:eroll/features/payroll/monthly_ledger_report/view/monthly_ledger_report.dart';
import 'package:eroll/features/settings/views/settings_page.dart';
import 'package:eroll/features/home/views/home_page.dart';
import 'package:eroll/features/leave/staff_leave_screen.dart';
import 'package:eroll/features/auth/views/onboard_page.dart';
import 'package:eroll/features/auth/views/set_pin_page.dart';
import 'package:eroll/features/auth/views/unlock_page.dart';
import 'package:eroll/features/auth/views/splash_page.dart';
import 'package:eroll/features/payroll/monthly_payroll/payroll_month_screen.dart';
import 'package:eroll/features/reports/models/month_report.dart';
import 'package:eroll/features/reports/views/month_report_page.dart';
import 'package:eroll/features/reports/views/reports_page.dart';
import 'package:eroll/features/payroll/staff_payroll_report/view/staff_payroll_report_screen.dart';
import 'package:eroll/features/payroll/staff_list_payroll/staff_list_payroll_screen.dart';
import 'package:eroll/features/staffs/views/staffs_page.dart';
import 'package:eroll/features/works/create_work/create_work_page.dart';
import 'package:eroll/features/works/site_detail/views/site_detail_page.dart';
import 'package:eroll/features/works/work_site/data/models/site_model.dart';
import 'package:eroll/features/works/work_site/views/work_site_page.dart';
import 'package:flutter/material.dart';

import '../../features/attendance/add_attendance/views/attendance_page.dart';
import '../../features/bottom_nav/bottom_nav_bar.dart';

class AppRouteConfig {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.splashPage:
        return MaterialPageRoute(builder: (context) => const SplashPage());

      case AppRouteNames.onboardPage:
        return MaterialPageRoute(builder: (context) => const OnboardPage());

      case AppRouteNames.setPinPage:
        return MaterialPageRoute(builder: (context) => const SetPinPage());

      case AppRouteNames.unlockPage:
        return MaterialPageRoute(builder: (context) => const UnlockPage());

      case AppRouteNames.bottomNavScreen:
        return MaterialPageRoute(builder: (context) => const BottomNavBar());

      case AppRouteNames.homePage:
        return MaterialPageRoute(builder: (context) => const HomePage());

      case AppRouteNames.attendanceScreen:
        return MaterialPageRoute(builder: (context) => const AttendancePage());

      case AppRouteNames.siteWorksScreen:
        final args = settings.arguments as int;
        return MaterialPageRoute(builder: (context) => const WorkSitePage());

      case AppRouteNames.siteDetailPage:
        final site = settings.arguments as SiteModel;
        return MaterialPageRoute(
          builder: (context) => SiteDetailPage(site: site),
        );

      case AppRouteNames.createWorkScreen:
        return MaterialPageRoute<SiteModel>(
          builder: (context) => const CreateWorkPage(),
        );

      // case AppRouteNames.updateWorksScreen:
      //   final modelArgs = settings.arguments as CreateWorkModel;
      //   return MaterialPageRoute(
      //     builder: (context) => UpdateWorkStatusScreen(workModel: modelArgs),
      //   );

      case AppRouteNames.staffsScreen:
        return MaterialPageRoute(builder: (context) => const StaffsPage());

      case AppRouteNames.staffOnLeaveScreen:
        return MaterialPageRoute(
          builder: (context) => const StaffLeaveScreen(),
        );

      case AppRouteNames.createStaffScreen:
        return MaterialPageRoute(builder: (context) => const AddStaffPage());

      case AppRouteNames.staffListPayrollScreen:
        return MaterialPageRoute(
          builder: (context) => const StaffListPayrollScreen(),
        );

      case AppRouteNames.staffPayrollReportScreen:
        return MaterialPageRoute(
          builder: (context) => const StaffPayrollReportScreen(),
        );

      case AppRouteNames.payrollMonthListScreen:
        final args = settings.arguments as bool;
        return MaterialPageRoute(
          builder: (context) => PayrollMonthScreen(isMonthlyLedgerReport: args),
        );

      case AppRouteNames.monthlyLedgerReportScreen:
        return MaterialPageRoute(
          builder: (context) => const MonthlyLedgerReport(),
        );

      case AppRouteNames.addSalaryScreen:
        return MaterialPageRoute(builder: (context) => AddSalaryScreen());

      case AppRouteNames.reportsScreen:
        return MaterialPageRoute(builder: (context) => const ReportsPage());

      case AppRouteNames.monthReportScreen:
        final report = settings.arguments as MonthReport;
        return MaterialPageRoute(
          builder: (context) => MonthReportPage(report: report),
        );

      case AppRouteNames.attendanceReportScreen:
        return MaterialPageRoute(
          builder: (context) => const AttendanceReportScreen(),
        );

      case AppRouteNames.settingsScreen:
        return MaterialPageRoute(builder: (context) => const SettingsScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return const Scaffold(body: Center(child: Text('No Routes Found..!')));
      },
    );
  }
}
