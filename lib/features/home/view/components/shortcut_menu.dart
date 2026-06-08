import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/features/home/view/components/shortcut_menu_widget.dart';
import 'package:flutter/cupertino.dart';

class ShortcutMenu extends StatelessWidget {
  const ShortcutMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShortcutMenuWidget(
          icon: CupertinoIcons.person_crop_circle_fill_badge_minus,
          text: 'Leaves',
          onTap: () {
            Navigator.pushNamed(context, AppRouteNames.staffOnLeaveScreen);
          },
        ),
        ShortcutMenuWidget(
          icon: CupertinoIcons.money_dollar_circle,
          text: 'Payroll',
          onTap: () {
            Navigator.pushNamed(context, AppRouteNames.addSalaryScreen);
          },
        ),
        ShortcutMenuWidget(
          icon: CupertinoIcons.person_crop_circle_badge_plus,
          text: 'Add Staff',
          onTap: () {
            Navigator.pushNamed(context, AppRouteNames.createStaffScreen);
          },
        ),
        ShortcutMenuWidget(
          icon: CupertinoIcons.hammer_fill,
          text: 'Create Work',
          onTap: () {
            Navigator.pushNamed(context, AppRouteNames.createWorkScreen);
          },
        ),
      ],
    );
  }
}
