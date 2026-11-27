import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

import '../models/attendance_models.dart';

/// Three-way P / ½ / A segmented control with a sliding indicator.
class AttendanceToggle extends StatelessWidget {
  final AttendanceStatus value;
  final ValueChanged<AttendanceStatus>? onChanged;

  const AttendanceToggle({super.key, required this.value, this.onChanged});

  static const double width = 130;
  static const double height = 46;
  static const double _pad = 3;

  static const _labels = {
    AttendanceStatus.present: ('P', 'Present'),
    AttendanceStatus.halfDay: ('½', 'Half day'),
    AttendanceStatus.absent: ('A', 'Absent'),
  };

  Color _indicatorColor(AttendanceStatus s) => switch (s) {
    AttendanceStatus.present => AppColors.lime,
    AttendanceStatus.halfDay => AppColors.sand,
    AttendanceStatus.absent => AppColors.forest,
  };

  Color _textColor(AttendanceStatus s, bool selected) {
    if (!selected) return AppColors.inkMuted;
    return s == AttendanceStatus.absent ? AppColors.white : AppColors.ink;
  }

  @override
  Widget build(BuildContext context) {
    const values = AttendanceStatus.values;
    final index = values.indexOf(value);
    final style = context.textTheme.headlineSmall!.copyWith(fontSize: 15);
    final enabled = onChanged != null;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(_pad),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              alignment: Alignment(-1 + index * 1.0, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: (width - _pad * 2) / 3,
                decoration: BoxDecoration(
                  color: _indicatorColor(value),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              children: [
                for (final s in values)
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: s == value,
                      label: _labels[s]!.$2,
                      excludeSemantics: true,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: enabled ? () => onChanged!(s) : null,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 220),
                            style: style.copyWith(
                              color: _textColor(s, s == value),
                            ),
                            child: Text(_labels[s]!.$1),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
