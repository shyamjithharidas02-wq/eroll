import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:eroll/core/widgets/button_widget.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/app_texts.dart';
import 'package:eroll/core/constants/resource_path.dart';
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
                Column(
                  children: [
                    // if (attendanceProvider.isMarkedToday)
                    //   AttendanceMarkedWidget(),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.strokeColor),
                          ),
                          child: Row(
                            spacing: 15,
                            children: [
                              // Profile
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  AssetPath.profileCircleVector,
                                ),
                              ),

                              // Staffs name
                              SizedBox(
                                width: 150,
                                child: Text(
                                  "demo name",
                                  style: TextStyle(fontFamily: 'cabinBold'),
                                  softWrap: true,
                                ),
                              ),
                              Spacer(),

                              // Toggle
                              Switch(
                                activeThumbColor: AppColors.primaryColor,
                                inactiveThumbColor: AppColors.grey,
                                value: false,
                                thumbIcon: thumbIcon,
                                trackOutlineColor: trackOutlineColor,
                                onChanged: (newValue) {},
                              ),
                            ],
                          ),
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Button
                ButtonWidget(
                  btnText: AppTexts.submitText,
                  btnColor: AppColors.primaryColor,
                  isLoading: false,
                  btnAction: () async {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



/*

Center(
                        child: Column(
                          children: [
                            Image.asset(AssetPath.emptyListImage),
                            Text(
                              'No Active Staffs Available',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      )
*/