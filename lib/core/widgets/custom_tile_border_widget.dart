import 'package:eroll/app/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';

class CustomTileBorderWidget extends StatelessWidget {
  const CustomTileBorderWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.strokeColor),
      ),
      child: child,
    );
  }
}
