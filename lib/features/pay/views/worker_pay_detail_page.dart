import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/pay_models.dart';
import '../widgets/part_payment_sheet.dart';
import '../widgets/week_days_row.dart';
import '../widgets/week_range_selector.dart';

/// One worker's week: attendance, advance, balance and payment actions.
/// Pops with the amount paid now (int), or null if nothing was paid.
class WorkerPayDetailPage extends StatelessWidget {
  final PayEntry entry;
  final DateTime weekStart;

  /// Already paid this week (e.g. an earlier part payment).
  final int alreadyPaid;

  const WorkerPayDetailPage({
    super.key,
    required this.entry,
    required this.weekStart,
    this.alreadyPaid = 0,
  });

  static const double _hPad = 20;
  static const Color _advance = Color(0xFF8A5A1C);
  static const Color _balance = Color(0xFF2B5E4E);
  static const Color _phoneBg = Color(0xFFE3EED9);

  int get _balanceDue => entry.payable - alreadyPaid;

  Future<void> _call(BuildContext context) async {
    final ok = await launchUrl(Uri(scheme: 'tel', path: entry.phone));
    if (!ok && context.mounted) {
      Utils.showSnackBar('Could not open the dialer', context);
    }
  }

  Future<void> _payPart(BuildContext context) async {
    // Week runs Mon–Sat and is settled on Saturday; the rest carries to the
    // following Saturday.
    final nextPayDay = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day + 12,
    );
    final payment = await PartPaymentSheet.show(
      context,
      name: entry.name,
      balance: _balanceDue,
      nextPayDay: nextPayDay,
    );
    // TODO: record payment.method (Cash / UPI) with the payment.
    if (payment != null && context.mounted) {
      Navigator.pop(context, payment.amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final regular = context.textTheme.bodyMedium!;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final advanceDate = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day + entry.advanceDay,
    );

    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 10),
      child: Text(
        title.toUpperCase(),
        style: bold.copyWith(
          fontSize: 13,
          letterSpacing: 0.4,
          color: AppColors.inkMuted,
        ),
      ),
    );

    Widget line(String label, String value, [Color color = AppColors.ink]) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: regular.copyWith(
                    fontSize: 15,
                    color: const Color(0xFF4D5751),
                  ),
                ),
              ),
              Text(value, style: bold.copyWith(fontSize: 15, color: color)),
            ],
          ),
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(_hPad, 20, _hPad, bottomInset + 24),
            children: [
              Row(
                children: [
                  _CircleButton(
                    label: 'Back',
                    color: AppColors.white,
                    icon: Icons.chevron_left_rounded,
                    iconColor: AppColors.ink,
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const Spacer(),
                  _CircleButton(
                    label: 'Call ${entry.name}',
                    color: _phoneBg,
                    icon: Icons.phone_outlined,
                    iconColor: AppColors.pine,
                    onTap: () => _call(context),
                  ),
                ],
              ),
              const Gap(14),
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDFEADC),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      entry.initial,
                      style: bold.copyWith(fontSize: 22, color: AppColors.pine),
                    ),
                  ),
                  const Gap(14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          style: context.textTheme.headlineLarge!.copyWith(
                            fontSize: 24,
                            letterSpacing: -0.3,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          '${Utils.formatRupee(entry.dailyWage)} / day · '
                          '${entry.isDailyPaid ? 'paid daily each evening' : 'paid weekly on Saturday'}',
                          style: regular.copyWith(
                            fontSize: 14,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(22),
              section(WeekRangeSelector.formatRange(weekStart)),
              WeekDaysRow(weekStart: weekStart, days: entry.week),
              const Gap(16),
              if (entry.isDailyPaid)
                _NoteCard(
                  text:
                      '${entry.name} is paid ${Utils.formatRupee(entry.dailyWage)} '
                      'each evening, so there is nothing to settle this week.',
                )
              else ...[
                Container(
                  padding: const EdgeInsets.fromLTRB(17, 12, 17, 18),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      line(
                        '${entry.daysLabel} × ${Utils.formatRupee(entry.dailyWage)}',
                        Utils.formatRupee(entry.earned),
                      ),
                      if (entry.advance > 0)
                        line(
                          'Advance · ${DateFormat('EEE d MMM').format(advanceDate)}',
                          '– ${Utils.formatRupee(entry.advance)}',
                          _advance,
                        ),
                      if (alreadyPaid > 0)
                        line(
                          'Already paid',
                          '– ${Utils.formatRupee(alreadyPaid)}',
                          _advance,
                        ),
                      const Gap(8),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.canvas,
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Balance to pay',
                              style: bold.copyWith(
                                fontSize: 17,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          Text(
                            Utils.formatRupee(_balanceDue),
                            style: bold.copyWith(
                              fontSize: 28,
                              letterSpacing: -0.3,
                              color: _balance,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                if (_balanceDue > 0) ...[
                  _PrimaryButton(
                    label: 'Mark ${Utils.formatRupee(_balanceDue)} as paid',
                    onTap: () => Navigator.pop(context, _balanceDue),
                  ),
                  const Gap(10),
                  _OutlineButton(
                    label: 'Pay part now, carry rest',
                    onTap: () => _payPart(context),
                  ),
                ] else
                  _NoteCard(
                    text: entry.earned == 0
                        ? 'No days marked this week yet.'
                        : 'Settled for this week.',
                  ),
              ],
              if (entry.pastDays.isNotEmpty) ...[
                const Gap(22),
                section('Past weeks'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      for (final (i, w)
                          in entry.pastWeeks(weekStart).indexed) ...[
                        if (i > 0)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.canvas,
                          ),
                        SizedBox(
                          height: 52,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${WeekRangeSelector.formatRange(w.weekStart)} · '
                                  '${PayEntry.formatDays(w.days)} days',
                                  style: regular.copyWith(
                                    fontSize: 15,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                              Text(
                                entry.isDailyPaid
                                    ? 'Paid daily'
                                    : '${Utils.formatRupee(w.paid)} paid',
                                style: bold.copyWith(
                                  fontSize: 15,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: 24, color: iconColor),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.lime.withValues(alpha: 0.45),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: SizedBox(
            height: 52,
            child: Center(
              child: Text(
                label,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 16,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Color(0xFFDDE1DC)),
    );
    return Material(
      color: AppColors.white,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Center(
            child: Text(
              label,
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 15,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String text;

  const _NoteCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EED9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: context.textTheme.bodyMedium!.copyWith(
          fontSize: 14,
          color: AppColors.pine,
        ),
      ),
    );
  }
}
