import 'package:flutter/cupertino.dart';

class CustomTitleAppbar extends StatelessWidget {
  const CustomTitleAppbar({super.key, required this.appBarTitle});

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Text(appBarTitle, style: TextStyle(fontFamily: 'cabinBold'));
  }
}
