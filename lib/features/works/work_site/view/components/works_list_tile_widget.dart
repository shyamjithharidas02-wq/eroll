import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/enums.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/works/create_work/model/create_work_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorksListTileWidget extends StatelessWidget {
  final List<CreateWorkModel> works;
  final String workType;

  const WorksListTileWidget({
    super.key,
    required this.tabIndex,
    required this.works,
    required this.workType,
  });

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    Color statusColor;

    switch (tabIndex) {
      case 0:
        statusColor = AppColors.red;
        break;
      case 1:
        statusColor = AppColors.deepPurple;
        break;
      case 2:
        statusColor = AppColors.green;
        break;
      default:
        statusColor = Colors.black;
    }

    if (works.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/empty-list.jpg', height: 250),
              Text(
                'No $workType Works, Complete some works to see them here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: works.length,
      itemBuilder: (context, index) {
        final work = works[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouteNames.updateWorksScreen,
              arguments: work,
            );
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 15),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.strokeColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left Side Color Strip
                  Container(
                    width: 15,
                    decoration: BoxDecoration(color: AppColors.primaryColor),
                  ),

                  // Right Side
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.calendar_badge_plus,
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                UtilityFile.formatDateMonthYear(
                                  work.startDate,
                                ), // Date
                                style: TextStyle(fontFamily: 'cabinBold'),
                              ),
                              Spacer(),
                              Text(UtilityFile.currentDay(work.startDate)),
                              // Day
                            ],
                          ),
                          SizedBox(height: 10),

                          // Work Site name
                          Text(
                            work.workSiteName,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineLarge!.copyWith(fontSize: 20),
                          ),
                          SizedBox(height: 10),

                          // Work Status
                          Row(
                            spacing: 10,
                            children: [
                              Text('Status:'),
                              Text(
                                work.status.label,
                                style: TextStyle(
                                  fontFamily: 'cabinBold',
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
    );
  }
}
