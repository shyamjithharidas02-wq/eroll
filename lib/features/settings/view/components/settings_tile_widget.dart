import 'package:flutter/material.dart';

class SettingsTileWidget extends StatelessWidget {
  const SettingsTileWidget({
    super.key,
    required this.iconData,
    required this.iconText,
    this.onTap,
  });

  final IconData iconData;
  final String iconText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(iconText),
      onTap: onTap,
    );
  }
}
