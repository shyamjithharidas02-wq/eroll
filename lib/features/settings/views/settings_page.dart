import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/core/utils/utils.dart';
import 'package:eroll/core/widgets/circle_back_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../widgets/language_selector.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const double _hPad = 20;

  // TODO: load from and persist to the business profile / local prefs.
  bool _fingerprintUnlock = true;
  bool _autoBackup = true;
  AppLanguage _language = AppLanguage.english;

  void _comingSoon() => Utils.showSnackBar('Coming soon', context);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(bottom: media.padding.bottom + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                  _hPad,
                  media.padding.top + 12,
                  _hPad,
                  48,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.forest,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(44),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CircleBackTopBar(title: 'Settings', onDark: true),
                    const Gap(24),
                    SettingsBusinessCard(
                      businessName: '[Your business name]',
                      summary: 'Owner · 8 crew · 3 active sites',
                      onEdit: _comingSoon,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(_hPad, 0, _hPad, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(24),
                    const SettingsSectionLabel('Business'),
                    SettingsGroup(
                      children: [
                        SettingsRow(
                          icon: Iconsax.shop_copy,
                          label: 'Business name',
                          value: 'Edit',
                          onTap: _comingSoon,
                        ),
                        SettingsRow(
                          icon: Iconsax.calendar_1_copy,
                          label: 'Pay day',
                          value: 'Saturday',
                          onTap: _comingSoon,
                        ),
                        SettingsRow(
                          icon: Iconsax.clock_copy,
                          label: 'Work week',
                          value: 'Mon – Sat',
                          onTap: _comingSoon,
                        ),
                      ],
                    ),
                    const Gap(28),
                    const SettingsSectionLabel('Security'),
                    SettingsGroup(
                      children: [
                        SettingsRow(
                          icon: Iconsax.lock_copy,
                          label: 'Change PIN',
                          value: '4 digits',
                          onTap: _comingSoon,
                        ),
                        SettingsRow.toggle(
                          icon: Iconsax.finger_scan_copy,
                          label: 'Fingerprint unlock',
                          switchValue: _fingerprintUnlock,
                          onSwitchChanged: (v) =>
                              setState(() => _fingerprintUnlock = v),
                        ),
                        SettingsRow(
                          icon: Iconsax.clock_copy,
                          label: 'Auto-lock',
                          value: 'After 1 min',
                          onTap: _comingSoon,
                        ),
                      ],
                    ),
                    const Gap(28),
                    const SettingsSectionLabel('Data'),
                    SettingsGroup(
                      children: [
                        SettingsRow.toggle(
                          icon: Iconsax.cloud_add_copy,
                          label: 'Auto backup',
                          switchValue: _autoBackup,
                          onSwitchChanged: (v) =>
                              setState(() => _autoBackup = v),
                        ),
                        SettingsRow(
                          icon: Iconsax.cloud_add_copy,
                          label: 'Back up now',
                          value: 'Today, 9:14 pm',
                          onTap: _comingSoon,
                        ),
                        SettingsRow(
                          icon: Iconsax.document_text_copy,
                          label: 'Export everything',
                          value: 'Excel',
                          onTap: _comingSoon,
                        ),
                      ],
                    ),
                    const Gap(28),
                    const SettingsSectionLabel('App'),
                    SettingsGroup(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SettingsRow.plain(
                                icon: Iconsax.translate_copy,
                                label: 'Language',
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: LanguageSelector(
                                  value: _language,
                                  onChanged: (v) =>
                                      setState(() => _language = v),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    SettingsGroup(
                      children: [
                        SettingsRow(
                          icon: Iconsax.info_circle_copy,
                          label: 'About Kinar',
                          value: 'Version 1.0',
                          onTap: _comingSoon,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
