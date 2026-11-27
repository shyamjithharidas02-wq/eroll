import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';

/// Dark pill segmented control with a sliding lime indicator.
class SiteStatusSwitcher extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  /// Track colour; defaults to forest (on light backgrounds).
  final Color backgroundColor;

  const SiteStatusSwitcher({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.backgroundColor = AppColors.forest,
  });

  static const double _height = 48;
  static const double _inset = 4;

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme.headlineSmall!.copyWith(fontSize: 15);

    return Container(
      height: _height,
      padding: const EdgeInsets.all(_inset),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(_height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segment = constraints.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                left: segment * selectedIndex,
                top: 0,
                bottom: 0,
                width: segment,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    borderRadius: BorderRadius.circular(_height / 2),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: Semantics(
                        button: true,
                        selected: i == selectedIndex,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onChanged(i),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: style.copyWith(
                                color: i == selectedIndex
                                    ? AppColors.ink
                                    : AppColors.navIcon,
                              ),
                              child: Text(
                                labels[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
