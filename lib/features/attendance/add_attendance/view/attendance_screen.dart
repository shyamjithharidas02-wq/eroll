import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:eroll/components/button_widget.dart';
import 'package:eroll/core/constants/app_colors.dart';
import 'package:eroll/core/constants/app_texts.dart';
import 'package:eroll/core/constants/resource_path.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/features/attendance/add_attendance/provider/add_attendance_provider.dart';
import 'package:eroll/features/attendance/add_attendance/view/components/attendance_marked_widget.dart';
import 'package:eroll/features/staffs/provider/view_staff_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime? selectedDate;
  bool showAttendanceCard = false;

  static const WidgetStateProperty<Icon> thumbIcon =
      WidgetStateProperty<Icon>.fromMap(<WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      });

  static WidgetStateProperty<Color> trackOutlineColor =
      WidgetStateProperty.fromMap(<WidgetStatesConstraint, Color>{
        WidgetState.selected: AppColors.primaryColor,
        WidgetState.any: AppColors.red,
      });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final staffProvider = Provider.of<ViewStaffProvider>(
        context,
        listen: false,
      );
      await staffProvider.fetchStaffs();

      final employees = staffProvider.viewStaffList;
      if (mounted) {
        Provider.of<AddAttendanceProvider>(
          context,
          listen: false,
        ).initializeAttendance(employees);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTexts.attendaceText,
          style: TextStyle(fontFamily: 'cabinBold'),
        ),

        elevation: 1,
        scrolledUnderElevation: 5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                // Calender
                EasyDateTimeLine(
                  activeColor: AppColors.primaryColor,
                  initialDate: DateTime.now(),
                  onDateChange: (date) {
                    selectedDate = date;
                  },
                  dayProps: const EasyDayProps(
                    todayHighlightStyle: TodayHighlightStyle.withBackground,
                    todayHighlightColor: Colors.black26,
                    borderColor: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),

                // List of Employees - Attendance
                Consumer<AddAttendanceProvider>(
                  builder: (context, attendanceProvider, _) {
                    if (attendanceProvider.attendanceList.isEmpty) {
                      return Center(child: Text('No Active Staffs Available'));
                    }

                    return Column(
                      children: [
                        if (attendanceProvider.isMarkedToday)
                          AttendanceMarkedWidget(),

                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: attendanceProvider.attendanceList.length,
                          itemBuilder: (context, index) {
                            final staffs =
                                attendanceProvider.attendanceList[index];

                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.strokeColor,
                                ),
                              ),
                              child: Row(
                                spacing: 15,
                                children: [
                                  // Profile
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                      ResourcePath.profileCircleVector,
                                    ),
                                  ),

                                  // Staffs name
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      staffs.name,
                                      style: TextStyle(fontFamily: 'cabinBold'),
                                      softWrap: true,
                                    ),
                                  ),
                                  Spacer(),

                                  // Toggle
                                  Switch(
                                    activeColor: AppColors.primaryColor,
                                    inactiveThumbColor: AppColors.grey,
                                    value: staffs.isPresent,
                                    thumbIcon: thumbIcon,
                                    trackOutlineColor: trackOutlineColor,
                                    onChanged:
                                        attendanceProvider.isMarkedToday
                                            ? null
                                            : (value) {
                                              attendanceProvider
                                                  .toggleAttendance(
                                                    staffs.empId,
                                                    value,
                                                  );
                                            },
                                  ),
                                ],
                              ),
                            );
                          },
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),

                // Button
                Consumer<AddAttendanceProvider>(
                  builder: (context, attendanceProvider, _) {
                    return ButtonWidget(
                      btnText:
                          attendanceProvider.isMarkedToday
                              ? 'Attendance Already Marked'
                              : AppTexts.submitText,
                      btnColor:
                          attendanceProvider.isMarkedToday
                              ? AppColors.grey
                              : AppColors.primaryColor,
                      isLoading: attendanceProvider.isLoading,
                      btnAction:
                          attendanceProvider.isMarkedToday
                              ? null
                              : () async {
                                await attendanceProvider.saveAttendace();

                                if (!mounted) {
                                  UtilityFile.showSnackBar(
                                    "Attendance marked",
                                    context,
                                  );
                                }
                              },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
