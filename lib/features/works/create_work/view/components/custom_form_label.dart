import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

class CustomFormLabel extends StatelessWidget {
  final String labelText;
  final bool isMandatory;

  const CustomFormLabel({
    super.key,
    required this.labelText,
    this.isMandatory = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(labelText, style: TextStyle(fontFamily: 'cabinBold')),
        if (isMandatory) ...[
          Text(
            "*",
            style: TextStyle(fontFamily: 'cabinBold', color: AppColors.red),
          ),
        ],
      ],
    );
  }
}
