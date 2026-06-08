import 'package:eroll/features/works/update_work/provider/update_work_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/constants/utility_file.dart';

class WorkEndDateWidget extends StatelessWidget {
  const WorkEndDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey400)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_month_outlined),
          SizedBox(width: 10),
          Text('End Date'),
          Spacer(),
          Consumer<UpdateWorkProvider>(
            builder: (context, value, _) {
              return GestureDetector(
                onTap: () async {
                  final DateTime? dateObject = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2100),
                  );

                  if (dateObject != null) {
                    value.setWorkEndDate(dateObject);
                  }
                },
                child: Text(
                  value.endDate != null
                      ? UtilityFile.formatDateMonthYear(value.endDate!)
                      : UtilityFile.formatDateMonthYear(DateTime.now()),
                  style: TextStyle(
                    fontFamily: 'cabinBold',
                    color: AppColors.blue600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
