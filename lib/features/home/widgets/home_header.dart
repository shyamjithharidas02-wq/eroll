import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';

/// Greeting row + "Wages due this week" total, drawn on the dark header.
class HomeHeader extends StatelessWidget {
  final String adminName;
  final int wagesDue;
  final bool hasNotifications;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    required this.adminName,
    required this.wagesDue,
    this.hasNotifications = false,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final bold = context.textTheme.headlineSmall!;
    final regular = context.textTheme.bodyMedium!;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.pine,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.forestSoft, width: 3),
              ),
              child: Text(
                adminName.isEmpty ? '' : adminName[0].toUpperCase(),
                style: bold.copyWith(fontSize: 20, color: AppColors.lime),
              ),
            ),
            const Gap(13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Utils.greetingText(now)}, $adminName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: regular.copyWith(
                      fontSize: 14,
                      color: AppColors.onDarkMuted,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    Utils.formatLongDay(now),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bold.copyWith(fontSize: 19, color: AppColors.white),
                  ),
                ],
              ),
            ),
            _NotificationButton(
              showDot: hasNotifications,
              onTap: onNotificationTap,
            ),
          ],
        ),
        const Gap(38),
        Text(
          'Wages due this week',
          style: regular.copyWith(fontSize: 15, color: AppColors.onDarkMuted),
        ),
        const Gap(6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            Utils.formatRupee(wagesDue),
            style: bold.copyWith(
              fontSize: 46,
              height: 1.1,
              letterSpacing: -1,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final bool showDot;
  final VoidCallback? onTap;

  const _NotificationButton({required this.showDot, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.forestSoft,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Iconsax.notification_copy,
                color: AppColors.white,
                size: 22,
              ),
              if (showDot)
                Positioned(
                  top: 13,
                  right: 14,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
