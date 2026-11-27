import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';

/// Uppercase grey caption above a settings group ("BUSINESS", "SECURITY").
class SettingsSectionLabel extends StatelessWidget {
  final String text;

  const SettingsSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.headlineSmall!.copyWith(
          fontSize: 13,
          letterSpacing: 0.8,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

/// White rounded card holding settings rows separated by thin dividers.
class SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        items.add(
          const Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: AppColors.canvas,
          ),
        );
      }
      items.add(children[i]);
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: items),
    );
  }
}

/// Icon box + label, followed by either a value with a chevron or a switch.
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final VoidCallback? onTap;
  final bool showChevron;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.showChevron = true,
  }) : switchValue = null,
       onSwitchChanged = null;

  const SettingsRow.toggle({
    super.key,
    required this.icon,
    required this.label,
    required bool this.switchValue,
    required this.onSwitchChanged,
  }) : value = null,
       onTap = null,
       showChevron = false;

  /// Icon + label only, used as the heading of a custom row.
  const SettingsRow.plain({super.key, required this.icon, required this.label})
    : value = null,
      switchValue = null,
      onSwitchChanged = null,
      onTap = null,
      showChevron = false;

  @override
  Widget build(BuildContext context) {
    final isToggle = switchValue != null;

    return InkWell(
      onTap: isToggle ? () => onSwitchChanged?.call(!switchValue!) : onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          children: [
            SettingsIconBox(icon: icon),
            const Gap(13),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 16.5,
                  color: AppColors.ink,
                ),
              ),
            ),
            if (value != null) ...[
              const Gap(8),
              Text(
                value!,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontSize: 14.5,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
            if (showChevron) ...[
              const Gap(12),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: AppColors.inkMuted,
              ),
            ],
            if (isToggle)
              SettingsSwitch(value: switchValue!, onChanged: onSwitchChanged),
          ],
        ),
      ),
    );
  }
}

class SettingsIconBox extends StatelessWidget {
  final IconData icon;

  const SettingsIconBox({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 19, color: AppColors.ink),
    );
  }
}

/// Pill switch: pine track with a lime knob when on.
class SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SettingsSwitch({super.key, required this.value, this.onChanged});

  static const double _width = 52;
  static const double _height = 32;
  static const double _knob = 26;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: _width,
        height: _height,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColors.pine : AppColors.chip,
          borderRadius: BorderRadius.circular(_height / 2),
          border: value ? null : Border.all(color: AppColors.strokeColor),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: _knob - (value ? 0 : 2),
            height: _knob - (value ? 0 : 2),
            decoration: BoxDecoration(
              color: value ? AppColors.lime : AppColors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
