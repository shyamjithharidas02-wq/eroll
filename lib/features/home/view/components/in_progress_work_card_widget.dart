import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/features/works/create_work/model/create_work_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InProgressWorkCardWidget extends StatelessWidget {
  final CreateWorkModel inProgressWorks;
  const InProgressWorkCardWidget({super.key, required this.inProgressWorks});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.calendar_badge_plus, size: 30),
              SizedBox(width: 10),
              Text(
                UtilityFile.formatDateMonthYear(
                  inProgressWorks.startDate,
                ), // Date
                style: TextStyle(
                  fontFamily: 'cabinBold',
                  color: AppColors.white,
                ),
              ),
              Spacer(),
              Text(
                UtilityFile.currentDay(inProgressWorks.startDate),
                style: TextStyle(
                  fontFamily: 'cabinBold',
                  color: AppColors.white,
                ),
              ), // Day
            ],
          ),
          SizedBox(height: 20),

          Text(
            inProgressWorks.workSiteName,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              fontSize: 20,
              color: AppColors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  Icon(CupertinoIcons.group, size: 30),
                  Text(
                    '${inProgressWorks.assignedEmployeesList.length} Staffs',
                    style: TextStyle(
                      color: AppColors.white,
                      fontFamily: 'cabinBold',
                    ),
                  ),
                ],
              ),

              Text(
                '${UtilityFile.workDuration(inProgressWorks.startDate).toString()} Day',
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: 'cabinBold',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
