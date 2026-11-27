import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';
import '../data/models/site_detail_model.dart';

/// "Anil · 16 days", "Sukumar · 14" pills.
class CrewDaysChips extends StatelessWidget {
  final List<CrewDays> crew;

  const CrewDaysChips({super.key, required this.crew});

  static const Color _avatarBg = Color(0xFFDFEADC);
  static const Color _border = Color(0xFFE4E8E3);

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;

    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: [
        for (var i = 0; i < crew.length; i++)
          Container(
            padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _avatarBg,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    crew[i].initial,
                    style: bold.copyWith(fontSize: 12, color: AppColors.pine),
                  ),
                ),
                const Gap(9),
                Text(
                  // Only the first chip spells out "days", like the design.
                  '${crew[i].name} · ${crew[i].days}${i == 0 ? ' days' : ''}',
                  style: bold.copyWith(fontSize: 14, color: AppColors.ink),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
