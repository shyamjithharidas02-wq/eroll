import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../data/models/staff_member.dart';

enum RemoveStaffChoice { remove, settleFirst }

/// Confirms taking someone off the crew; warns if pay is still due.
class RemoveStaffSheet extends StatelessWidget {
  final StaffMember member;

  const RemoveStaffSheet({super.key, required this.member});

  static const Color _warnBg = Color(0xFFF2E4CF);
  static const Color _warnText = Color(0xFF7A4E14);

  static Future<RemoveStaffChoice?> show(
    BuildContext context,
    StaffMember member,
  ) {
    return showModalBottomSheet<RemoveStaffChoice>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      barrierColor: AppColors.forest.withValues(alpha: 0.88),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => RemoveStaffSheet(member: member),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final regular = context.textTheme.bodyMedium!;
    final due = member.dueThisWeek;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        10,
        22,
        MediaQuery.paddingOf(context).bottom + 18,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.fieldBorder,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const Gap(20),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.redTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.profile_remove_copy,
                color: AppColors.red,
                size: 24,
              ),
            ),
          ),
          const Gap(20),
          Text(
            'Remove ${member.name} from the crew?',
            style: bold.copyWith(
              fontSize: 22,
              height: 1.25,
              color: AppColors.ink,
            ),
          ),
          const Gap(8),
          Text(
            '${member.name} won’t show in attendance or pay any more. '
            'Past days, advances and payments stay in your reports.',
            style: regular.copyWith(
              fontSize: 15.5,
              height: 1.45,
              color: AppColors.inkMuted,
            ),
          ),
          if (due > 0) ...[
            const Gap(18),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                color: _warnBg,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Iconsax.warning_2_copy,
                    color: _warnText,
                    size: 22,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Utils.formatRupee(due)} still due this week',
                          style: bold.copyWith(
                            fontSize: 15.5,
                            color: _warnText,
                          ),
                        ),
                        const Gap(4),
                        GestureDetector(
                          onTap: () => Navigator.pop(
                            context,
                            RemoveStaffChoice.settleFirst,
                          ),
                          child: Text(
                            'Settle the pay first ›',
                            style: bold.copyWith(
                              fontSize: 14.5,
                              color: _warnText,
                              decoration: TextDecoration.underline,
                              decorationColor: _warnText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Gap(20),
          _SheetButton(
            label: 'Remove from crew',
            color: AppColors.red,
            textColor: AppColors.white,
            onTap: () => Navigator.pop(context, RemoveStaffChoice.remove),
          ),
          const Gap(12),
          _SheetButton(
            label: 'Keep ${member.name}',
            color: AppColors.canvas,
            textColor: AppColors.ink,
            onTap: () => Navigator.pop(context),
          ),
          const Gap(16),
          Text(
            'You can bring ${member.name} back anytime from Staff › Past crew.',
            textAlign: TextAlign.center,
            style: regular.copyWith(fontSize: 13.5, color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _SheetButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: SizedBox(
          height: 54,
          child: Center(
            child: Text(
              label,
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 16.5,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
