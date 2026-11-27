import 'package:flutter/cupertino.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../app/routes/app_route_names.dart';
import '../../../app/theme/app_colors.dart';
import 'quick_action.dart';

class QuickMenu extends StatelessWidget {
  const QuickMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          QuickAction(
            icon: Iconsax.calendar,
            iconBg: AppColors.primaryTint,
            iconColor: AppColors.primary,
            label: "Leaves",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.staffOnLeaveScreen);
            },
          ),
          QuickAction(
            icon: Iconsax.dollar_circle,
            iconBg: AppColors.amberTint,
            iconColor: AppColors.amber,
            label: "Payroll",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.addSalaryScreen);
            },
          ),
          QuickAction(
            icon: Iconsax.user_add_copy,
            iconBg: AppColors.greenTint,
            iconColor: AppColors.green,
            label: "Add Staff ",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.createStaffScreen);
            },
          ),
          QuickAction(
            icon: CupertinoIcons.hammer_fill,
            iconBg: AppColors.redTint,
            iconColor: AppColors.red,
            label: "Add Work",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.createWorkScreen);
            },
          ),
        ],
      ),
    );
  }
}
