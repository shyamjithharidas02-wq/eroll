import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

/// "6 present · 0 half day · 2 absent" pills.
class AttendanceSummaryChips extends StatelessWidget {
  final int present;
  final int halfDay;
  final int absent;

  const AttendanceSummaryChips({
    super.key,
    required this.present,
    required this.halfDay,
    required this.absent,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _Chip(
          label: '$present present',
          background: const Color(0xFFDDE9DB),
          foreground: const Color(0xFF2E6B4C),
        ),
        _Chip(
          label: '$halfDay half day',
          background: const Color(0xFFF5E1C6),
          foreground: const Color(0xFF8A5A1C),
        ),
        _Chip(
          label: '$absent absent',
          background: const Color(0xFFE1E5E0),
          foreground: const Color(0xFF243329),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: context.textTheme.headlineSmall!.copyWith(
          fontSize: 13,
          height: 1.2,
          color: foreground,
        ),
      ),
    );
  }
}
