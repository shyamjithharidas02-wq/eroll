import 'package:eroll/features/attendance/add_attendance/provider/add_attendance_provider.dart';
import 'package:eroll/features/works/create_work/provider/create_work_provider.dart';
import 'package:eroll/features/works/update_work/provider/update_work_provider.dart';
import 'package:eroll/features/works/work_site/provider/view_work_site_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/create_staff/provider/create_staff_provider.dart';
import '../features/staffs/provider/view_staff_provider.dart';

class AppProviders {
  static List<SingleChildWidget> buildProviders() {
    return [
      ChangeNotifierProvider(create: (_) => CreateStaffProvider()),
      ChangeNotifierProvider(create: (_) => ViewStaffProvider()),
      ChangeNotifierProvider(create: (_) => CreateWorkProvider()),
      ChangeNotifierProvider(create: (_) => ViewWorkSiteProvider()),
      ChangeNotifierProvider(create: (_) => UpdateWorkProvider()),
      ChangeNotifierProvider(create: (_) => AddAttendanceProvider()),
    ];
  }
}
