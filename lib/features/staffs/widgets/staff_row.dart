import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../data/models/staff_member.dart';

/// "Anil · Driller · ₹900/day · Weekly        ₹3,900 due this week"
class StaffRow extends StatelessWidget {
  final StaffMember member;
  final VoidCallback? onTap;

  const StaffRow({super.key, required this.member, this.onTap});

  static const Color _avatarBg = Color(0xFFDFEADC);
  static const Color _settled = Color(0xFF2E7A4F);

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final meta = context.textTheme.bodyMedium!.copyWith(
      fontSize: 13,
      height: 1.3,
      color: AppColors.inkMuted,
    );
    final settled = member.dueThisWeek <= 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 63,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _avatarBg,
                shape: BoxShape.circle,
              ),
              child: Text(
                member.initial,
                style: bold.copyWith(fontSize: 15, color: AppColors.pine),
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bold.copyWith(
                      fontSize: 16,
                      height: 1.25,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    '${member.role.label} · '
                    '${Utils.formatRupee(member.dailyWage)}/day · '
                    '${member.payCycle.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: meta,
                  ),
                ],
              ),
            ),
            const Gap(8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  settled ? 'Settled' : Utils.formatRupee(member.dueThisWeek),
                  style: bold.copyWith(
                    fontSize: 15,
                    height: 1.25,
                    color: settled ? _settled : AppColors.ink,
                  ),
                ),
                Text(
                  settled ? 'nothing due' : 'due this week',
                  style: meta.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
