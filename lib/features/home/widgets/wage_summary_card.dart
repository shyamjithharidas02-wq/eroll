import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/home_dashboard_data.dart';

/// Hero card: earned vs advances for the pay week, with settle CTA.
class WageSummaryCard extends StatelessWidget {
  final WageSummary summary;
  final VoidCallback? onSettleTap;

  const WageSummaryCard({super.key, required this.summary, this.onSettleTap});

  static const double _radius = 30;

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final regular = context.textTheme.bodyMedium!;

    return Stack(
      children: [
        // Sand tab peeking out behind the card.
        Positioned(
          top: 0,
          left: 18,
          right: 18,
          height: 48,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.sand,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: [
              BoxShadow(
                color: AppColors.forest.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: Column(
              children: [_buildTop(bold, regular), _buildBottom(bold, regular)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTop(TextStyle bold, TextStyle regular) {
    return CustomPaint(
      painter: _WavePainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
        child: Column(
          children: [
            Row(
              children: [
                const _OverlappingDots(),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lime,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${summary.paidCount} of ${summary.totalCount} paid',
                    style: bold.copyWith(fontSize: 13, color: AppColors.ink),
                  ),
                ),
              ],
            ),
            const Gap(52),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _AmountLabel(
                    label: 'Earned',
                    amount: Utils.formatRupee(summary.earned),
                    bold: bold,
                    regular: regular,
                  ),
                ),
                Expanded(
                  child: _AmountLabel(
                    label: 'Advances',
                    amount: '– ${Utils.formatRupee(summary.advances)}',
                    bold: bold,
                    regular: regular,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom(TextStyle bold, TextStyle regular) {
    final sameMonth = summary.weekStart.month == summary.weekEnd.month;
    final range = sameMonth
        ? '${summary.weekStart.day} – ${DateFormat('d MMM').format(summary.weekEnd)}'
        : '${DateFormat('d MMM').format(summary.weekStart)} – ${DateFormat('d MMM').format(summary.weekEnd)}';
    final labelStyle = regular.copyWith(fontSize: 12, color: AppColors.ink);
    final valueStyle = bold.copyWith(fontSize: 18, color: AppColors.ink);

    return Material(
      color: AppColors.lime,
      child: InkWell(
        onTap: onSettleTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pay week', style: labelStyle),
                  const Gap(2),
                  Text(range, style: valueStyle),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Settle by', style: labelStyle),
                  const Gap(2),
                  Text('${summary.settleBy} ›', style: valueStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountLabel extends StatelessWidget {
  final String label;
  final String amount;
  final TextStyle bold;
  final TextStyle regular;
  final bool alignEnd;

  const _AmountLabel({
    required this.label,
    required this.amount,
    required this.bold,
    required this.regular,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: regular.copyWith(
            fontSize: 12,
            color: AppColors.white.withValues(alpha: 0.85),
          ),
        ),
        const Gap(4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            amount,
            style: bold.copyWith(fontSize: 22, color: AppColors.white),
          ),
        ),
      ],
    );
  }
}

class _OverlappingDots extends StatelessWidget {
  const _OverlappingDots();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 34,
      child: Stack(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.lime,
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 22,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.sand.withValues(alpha: 0.92),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints the pine background with two soft lighter waves.
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.pine);

    final back = Path()
      ..moveTo(0, h * 0.42)
      ..cubicTo(w * 0.18, h * 0.22, w * 0.36, h * 0.3, w * 0.5, h * 0.62)
      ..cubicTo(w * 0.62, h * 0.9, w * 0.82, h * 0.8, w, h * 0.38)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      back,
      Paint()..color = AppColors.pineLight.withValues(alpha: 0.45),
    );

    final front = Path()
      ..moveTo(0, h * 0.7)
      ..cubicTo(w * 0.25, h * 0.6, w * 0.45, h * 1.0, w * 0.7, h * 0.92)
      ..cubicTo(w * 0.85, h * 0.88, w * 0.95, h * 0.72, w, h * 0.64)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      front,
      Paint()..color = AppColors.pineLight.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
