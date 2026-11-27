import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../models/pay_models.dart';
import '../widgets/pay_row.dart';
import '../widgets/pay_summary_card.dart';
import '../widgets/week_range_selector.dart';
import 'worker_pay_detail_page.dart';

/// Weekly settlement: what each worker earned, minus advances, and who is
/// still to be paid.
class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  static const double _hPad = 20;

  final List<PayEntry> _entries = PayEntry.demo;

  late final DateTime _currentWeek = _mondayOf(DateTime.now());
  late DateTime _weekStart = _currentWeek;

  /// weekStart -> workerId -> amount paid that week.
  final Map<DateTime, Map<String, int>> _paid = {};

  static DateTime _mondayOf(DateTime d) {
    final day = DateUtils.dateOnly(d);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  Map<String, int> get _paidThisWeek => _paid.putIfAbsent(
    _weekStart,
    // Demo: earlier weeks are fully settled.
    () => {
      for (final e in _entries)
        if (_weekStart.isBefore(_currentWeek) ||
            PayEntry.demoPaid.contains(e.id))
          e.id: e.payable,
    },
  );

  int _paidOf(PayEntry e) => _paidThisWeek[e.id] ?? 0;

  int _remainingOf(PayEntry e) => e.payable - _paidOf(e);

  PayStatus _statusOf(PayEntry e) {
    if (e.isDailyPaid) return PayStatus.daily;
    return _remainingOf(e) <= 0 ? PayStatus.paid : PayStatus.due;
  }

  void _shiftWeek(int weeks) => setState(
    () => _weekStart = DateTime(
      _weekStart.year,
      _weekStart.month,
      _weekStart.day + 7 * weeks,
    ),
  );

  void _recordPayment(PayEntry e, int amount) {
    final week = _weekStart;
    final before = _paidOf(e);
    setState(() => _paidThisWeek[e.id] = before + amount);
    final rest = _remainingOf(e);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          content: Text(
            'Paid ${Utils.formatRupee(amount)} to ${e.name}'
            '${rest > 0 ? ' · ${Utils.formatRupee(rest)} carried' : ''}',
          ),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => setState(() => _paid[week]?[e.id] = before),
          ),
        ),
      );
  }

  Future<void> _openDetail(PayEntry e) async {
    // Root navigator so the detail page covers the bottom nav bar.
    final amount = await Navigator.of(context, rootNavigator: true).push<int>(
      MaterialPageRoute(
        builder: (_) => WorkerPayDetailPage(
          entry: e,
          weekStart: _weekStart,
          alreadyPaid: _paidOf(e),
        ),
      ),
    );
    if (amount != null && amount > 0 && mounted) _recordPayment(e, amount);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final earned = _entries.fold(0, (sum, e) => sum + e.earned);
    final advances = _entries.fold(0, (sum, e) => sum + e.advance);
    final stillToPay = _entries
        .where((e) => _statusOf(e) == PayStatus.due)
        .fold(0, (sum, e) => sum + _remainingOf(e));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(_hPad, 26, _hPad, bottomInset + 110),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pay',
                      style: context.textTheme.headlineLarge!.copyWith(
                        fontSize: 34,
                        letterSpacing: -0.5,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  WeekRangeSelector(
                    weekStart: _weekStart,
                    onPrevious: () => _shiftWeek(-1),
                    onNext: _weekStart.isBefore(_currentWeek)
                        ? () => _shiftWeek(1)
                        : null,
                  ),
                ],
              ),
              const Gap(16),
              PaySummaryCard(
                earned: earned,
                advances: advances,
                stillToPay: stillToPay,
              ),
              const Gap(14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < _entries.length; i++) ...[
                      if (i > 0)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.canvas,
                        ),
                      PayRow(
                        entry: _entries[i],
                        status: _statusOf(_entries[i]),
                        amount: _statusOf(_entries[i]) == PayStatus.due
                            ? _remainingOf(_entries[i])
                            : _entries[i].payable,
                        onPay: () => _recordPayment(
                          _entries[i],
                          _remainingOf(_entries[i]),
                        ),
                        onTap: () => _openDetail(_entries[i]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
