import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../models/onboard_slide.dart';

/// White tilted pill with an emoji or avatar, a label and an optional tag.
class OnboardPill extends StatelessWidget {
  final OnboardPillData data;

  const OnboardPill({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final hasAvatar = data.avatarLetter != null;

    final (tagBg, tagFg) = switch (data.tagTone) {
      PillTagTone.present => (const Color(0xFFE3EED9), AppColors.pine),
      PillTagTone.half => (const Color(0xFFF3E5D0), const Color(0xFF8A5A1C)),
      PillTagTone.off => (const Color(0xFFECEEEB), AppColors.inkMuted),
    };

    return Transform.rotate(
      angle: data.angleDeg * math.pi / 180,
      child: Container(
        height: hasAvatar ? 58 : 54,
        padding: EdgeInsets.fromLTRB(hasAvatar ? 10 : 16, 0, 18, 0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.forest.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasAvatar)
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: data.avatarColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  data.avatarLetter!,
                  style: bold.copyWith(fontSize: 14, color: AppColors.ink),
                ),
              )
            else
              Text(data.emoji ?? '', style: const TextStyle(fontSize: 24)),
            Gap(hasAvatar ? 12 : 10),
            Text(
              data.label,
              style: bold.copyWith(fontSize: 16, color: AppColors.ink),
            ),
            if (data.tag != null) ...[
              const Gap(12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  data.tag!,
                  style: bold.copyWith(fontSize: 11, color: tagFg),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
