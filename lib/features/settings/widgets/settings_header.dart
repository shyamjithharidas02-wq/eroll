import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/constants/asset_path.dart';

/// Business profile card: logo, name, summary line and edit button.
class SettingsBusinessCard extends StatelessWidget {
  final String businessName;
  final String summary;
  final VoidCallback? onEdit;

  const SettingsBusinessCard({
    super.key,
    required this.businessName,
    required this.summary,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.pine,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lime,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(AssetPath.kinarWordmark, fit: BoxFit.contain),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  businessName.toUpperCase(),
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontSize: 18,
                    height: 1.25,
                    color: AppColors.white,
                  ),
                ),
                const Gap(4),
                Text(
                  summary,
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 14,
                    height: 1.3,
                    color: AppColors.settingsOnPine,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          _CircleButton(
            size: 44,
            color: AppColors.settingsPineDark,
            onTap: onEdit,
            child: const Icon(Iconsax.edit_2, color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final double size;
  final Color color;
  final VoidCallback? onTap;
  final Widget child;

  const _CircleButton({
    required this.size,
    required this.color,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: size, height: size, child: Center(child: child)),
      ),
    );
  }
}
