import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';

enum MoreAction {
  profit,
  reports,
  newSite,
  addStaff,
  exportPdf,
  backup,
  settings,
}

/// "More" bottom sheet: month profit banner and a 3 × 2 grid of shortcuts.
/// Pops with the chosen [MoreAction].
class MoreSheet extends StatelessWidget {
  final int monthProfit;
  final DateTime month;

  const MoreSheet({super.key, required this.monthProfit, required this.month});

  static Future<MoreAction?> show(
    BuildContext context, {
    required int monthProfit,
    DateTime? month,
  }) {
    return showModalBottomSheet<MoreAction>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      barrierColor: AppColors.forest.withValues(alpha: 0.88),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) =>
          MoreSheet(monthProfit: monthProfit, month: month ?? DateTime.now()),
    );
  }

  static const _tiles = [
    (
      MoreAction.reports,
      Iconsax.chart_2_copy,
      'Reports',
      'Month, year, all time',
    ),
    (MoreAction.newSite, Iconsax.location_copy, 'New site', 'Add a well job'),
    (
      MoreAction.addStaff,
      Iconsax.profile_add_copy,
      'Add staff',
      'New crew member',
    ),
    (
      MoreAction.exportPdf,
      Iconsax.document_text_copy,
      'Export PDF',
      'Share a report',
    ),
    (MoreAction.backup, Icons.cloud_upload_outlined, 'Backup', 'Save to Drive'),
    (MoreAction.settings, Iconsax.sun_1_copy, 'Settings', 'PIN, pay day'),
  ];

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 10, 20, safeBottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD5DAD6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const Gap(18),
          Row(
            children: [
              Expanded(
                child: Text(
                  'More',
                  style: bold.copyWith(fontSize: 24, color: AppColors.ink),
                ),
              ),
              Semantics(
                button: true,
                label: 'Close',
                child: Material(
                  color: const Color(0xFFEDEFEC),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(
                        Icons.close_rounded,
                        size: 22,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(18),
          _ProfitBanner(
            label: '${DateFormat('MMMM').format(month)} so far',
            profit: monthProfit,
            onTap: () => Navigator.pop(context, MoreAction.profit),
          ),
          const Gap(18),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 110 / 146,
            children: [
              for (final (action, icon, title, subtitle) in _tiles)
                _MoreTile(
                  icon: icon,
                  title: title,
                  subtitle: subtitle,
                  style: switch (action) {
                    MoreAction.reports => _TileStyle.lime,
                    MoreAction.settings => _TileStyle.dark,
                    _ => _TileStyle.plain,
                  },
                  onTap: () => Navigator.pop(context, action),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfitBanner extends StatelessWidget {
  final String label;
  final int profit;
  final VoidCallback onTap;

  const _ProfitBanner({
    required this.label,
    required this.profit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(26);

    return Material(
      color: AppColors.forest,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: context.textTheme.bodyMedium!.copyWith(
                        fontSize: 13,
                        color: AppColors.onDarkMuted,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      profit < 0
                          ? '– ${Utils.formatRupee(-profit)} loss'
                          : '${Utils.formatRupee(profit)} profit',
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontSize: 22,
                        letterSpacing: -0.3,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.lime,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _TileStyle { plain, lime, dark }

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final _TileStyle style;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (circleBg, iconColor) = switch (style) {
      _TileStyle.lime => (AppColors.lime, AppColors.ink),
      _TileStyle.dark => (AppColors.forest, AppColors.lime),
      _TileStyle.plain => (const Color(0xFFEDEFEC), AppColors.ink),
    };
    final radius = BorderRadius.circular(22);

    return Material(
      color: const Color(0xFFF4F6F3),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 14, 4, 10),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: circleBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: iconColor),
              ),
              const Gap(10),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 15,
                  color: AppColors.ink,
                ),
              ),
              const Gap(2),
              Text(
                subtitle,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                  height: 1.3,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
