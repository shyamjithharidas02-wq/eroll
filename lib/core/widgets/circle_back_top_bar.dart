import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/extensions/theme_extensions.dart';

/// Round back button on the left with a centred title.
/// [onDark] switches between the dark-header and light-canvas look.
class CircleBackTopBar extends StatelessWidget {
  final String title;
  final bool onDark;
  final VoidCallback? onBack;

  const CircleBackTopBar({
    super.key,
    required this.title,
    this.onDark = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final fg = onDark ? AppColors.white : AppColors.ink;

    return SizedBox(
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: onDark ? AppColors.forestSoft : AppColors.white,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBack ?? () => Navigator.of(context).maybePop(),
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: Icon(Icons.chevron_left_rounded, color: fg, size: 26),
                ),
              ),
            ),
          ),
          Text(
            title,
            style: context.textTheme.headlineSmall!.copyWith(
              fontSize: 20,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
