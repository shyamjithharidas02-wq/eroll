import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:eroll/features/works/update_work/provider/update_work_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkStartDateWidget extends StatelessWidget {
  final String dateLabel;
  final DateTime startDate;

  const WorkStartDateWidget({
    super.key,
    required this.dateLabel,
    required this.startDate,
  });

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
          Text(dateLabel),
          Spacer(),
          Consumer<UpdateWorkProvider>(
            builder: (context, value, _) {
              final dateToShow = value.startDate ?? startDate;
              return GestureDetector(
                onTap: () async {
                  final DateTime? dateObject = await showDatePicker(
                    context: context,
                    initialDate: dateToShow,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2100),
                  );

                  if (dateObject != null) {
                    value.changeStartDate(dateObject);
                  }
                },
                child: Text(
                  UtilityFile.formatDateMonthYear(dateToShow),
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
