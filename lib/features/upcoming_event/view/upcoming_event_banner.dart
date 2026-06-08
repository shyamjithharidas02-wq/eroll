import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/constants/resource_path.dart';
import 'package:flutter/cupertino.dart';

class UpcomingEventBanner extends StatelessWidget {
  const UpcomingEventBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AssetPath.bannerImage),
        ),
      ),
    );
  }
}
