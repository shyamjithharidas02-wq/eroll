import 'package:eroll/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.strokeColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        spacing: 10,
        children: [
          Icon(CupertinoIcons.search, color: AppColors.grey),
          Expanded(
            child: TextField(
              //readOnly: true,
              cursorColor: AppColors.primaryColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search staff, task',
                hintStyle: TextStyle(color: AppColors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
