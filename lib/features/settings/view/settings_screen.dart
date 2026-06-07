import 'package:eroll/components/custom_back_button_appbar.dart';
import 'package:eroll/components/custom_title_appbar.dart';
import 'package:eroll/core/constants/utility_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/settings_tile_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButtonAppbar(),
        title: CustomTitleAppbar(appBarTitle: 'Settings'),
      ),

      body: ListView(
        // padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SettingsTileWidget(
            iconData: CupertinoIcons.arrow_up_doc,
            iconText: 'Backup Data',
            onTap: () {
              // TODO: R&D :: How to backup data, save?
              UtilityFile.showSnackBar(
                'Stay tuned! This feature is on its way.',
                context,
              );
            },
          ),
          SettingsTileWidget(
            iconData: CupertinoIcons.doc_on_doc,
            iconText: 'Export to excel',
            onTap: () {
              // TODO: R&D :: How to export data to excel format
              UtilityFile.showSnackBar(
                'Stay tuned! This feature is on its way.',
                context,
              );
            },
          ),
          SettingsTileWidget(
            iconData: CupertinoIcons.doc_text,
            iconText: 'Terms and Conditions',
            onTap: () {
              // TODO: terms and conditions
              UtilityFile.showSnackBar(
                'Stay tuned! This feature is on its way.',
                context,
              );
            },
          ),
          SettingsTileWidget(
            iconData: CupertinoIcons.doc_text,
            iconText: 'Privacy Policy',
            onTap: () {
              // TODO: privacy policy
              UtilityFile.showSnackBar(
                'Stay tuned! This feature is on its way.',
                context,
              );
            },
          ),
          SettingsTileWidget(
            iconData: CupertinoIcons.info_circle,
            iconText: '1.0.0(1)',
          ),
        ],
      ),
    );
  }
}
