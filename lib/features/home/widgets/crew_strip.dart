import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../models/home_dashboard_data.dart';

/// Horizontal list of today's crew avatars with a status badge.
class CrewStrip extends StatelessWidget {
  final List<CrewMember> crew;
  final EdgeInsets padding;
  final ValueChanged<CrewMember>? onMemberTap;

  const CrewStrip({
    super.key,
    required this.crew,
    this.padding = EdgeInsets.zero,
    this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: crew.length,
        separatorBuilder: (_, _) => const Gap(8),
        itemBuilder: (context, index) {
          final member = crew[index];
          return GestureDetector(
            onTap: onMemberTap == null ? null : () => onMemberTap!(member),
            child: _CrewAvatar(member: member),
          );
        },
      ),
    );
  }
}

class _CrewAvatar extends StatelessWidget {
  final CrewMember member;

  const _CrewAvatar({required this.member});

  @override
  Widget build(BuildContext context) {
    final badgeColor = member.status == CrewStatus.present
        ? AppColors.pine
        : AppColors.sand;

    return SizedBox(
      width: 64,
      child: Column(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: member.avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    member.name.isEmpty ? '' : member.name[0].toUpperCase(),
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontSize: 21,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: 2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.canvas, width: 2.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          Text(
            member.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium!.copyWith(
              fontSize: 14,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}
