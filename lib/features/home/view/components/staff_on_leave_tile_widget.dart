import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/resource_path.dart';
import 'package:flutter/material.dart';

class StaffOnLeaveTileWidget extends StatelessWidget {
  const StaffOnLeaveTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.strokeColor),
      ),
      child: Row(
        spacing: 15,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(AssetPath.profileCircleVector),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('John Doe', style: TextStyle(fontFamily: 'cabinBold')),
              Text(
                'Sick Leave Request',
                style: TextStyle(color: AppColors.grey),
              ),
            ],
          ),
          Spacer(),
          Text(
            'Full Day',
            style: TextStyle(color: AppColors.red, fontFamily: 'cabinBold'),
          ),
        ],
      ),
    );
  }
}
