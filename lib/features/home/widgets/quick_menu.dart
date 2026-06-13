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
            iconBg: Color.fromARGB(255, 216, 216, 251),
            iconColor: AppColors.primaryColor,
            label: "Leaves",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.staffOnLeaveScreen);
            },
          ),
          QuickAction(
            icon: Iconsax.dollar_circle,
            iconBg: Color(0xFFFFF3D7),
            iconColor: Color(0xFFC9904B),
            label: "Payroll",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.addSalaryScreen);
            },
          ),
          QuickAction(
            icon: Iconsax.user_add_copy,
            iconBg: Color(0xFFE6F4E5),
            iconColor: Color(0xFF4A6D4C),
            label: "Add Staff ",
            onTap: () {
              Navigator.pushNamed(context, AppRouteNames.createStaffScreen);
            },
          ),
          QuickAction(
            icon: CupertinoIcons.hammer_fill,
            iconBg: Color(0xFFF8E1E7),
            iconColor: Color(0xFFA33842),
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
