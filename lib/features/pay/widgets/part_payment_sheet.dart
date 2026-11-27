import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../../works/work_site/widgets/site_status_switcher.dart';

enum PayMethod { cash, upi }

/// What the owner chose in [PartPaymentSheet].
class PartPayment {
  final int amount;
  final PayMethod method;

  const PartPayment({required this.amount, required this.method});
}

/// "Pay part now": pick an amount, see what carries to the next pay day,
/// choose Cash / UPI. Pops with a [PartPayment], or null.
class PartPaymentSheet extends StatefulWidget {
  final String name;
  final int balance;

  /// The next pay day, where the unpaid rest carries to.
  final DateTime nextPayDay;

  const PartPaymentSheet({
    super.key,
    required this.name,
    required this.balance,
    required this.nextPayDay,
  });

  static Future<PartPayment?> show(
    BuildContext context, {
    required String name,
    required int balance,
    required DateTime nextPayDay,
  }) {
    return showModalBottomSheet<PartPayment>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      barrierColor: AppColors.forest.withValues(alpha: 0.88),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => PartPaymentSheet(
        name: name,
        balance: balance,
        nextPayDay: nextPayDay,
      ),
    );
  }

  @override
  State<PartPaymentSheet> createState() => _PartPaymentSheetState();
}

class _PartPaymentSheetState extends State<PartPaymentSheet> {
  static final _grouping = NumberFormat.decimalPattern('en_IN');
  static const Color _carry = Color(0xFF8A5A1C);
  static const Color _avatarBg = Color(0xFFAECBBB);

  late final List<int> _quick = _quickAmounts(widget.balance);
  late final _amount = TextEditingController(
    text: _quick.isEmpty ? '' : _grouping.format(_quick.last),
  );
  PayMethod _method = PayMethod.cash;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  int get _value =>
      int.tryParse(_amount.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  bool get _valid => _value > 0 && _value <= widget.balance;

  int get _carryAmount => (widget.balance - _value).clamp(0, widget.balance);

  void _select(int amount) => setState(() {
    _amount.text = _grouping.format(amount);
    _amount.selection = TextSelection.collapsed(offset: _amount.text.length);
  });

  /// About a third, a half and two thirds of the balance, rounded down to
  /// ₹500 (₹100 for small balances), e.g. ₹3,200 -> 1,000 / 1,500 / 2,000.
  static List<int> _quickAmounts(int balance) {
    final step = balance >= 1500 ? 500 : 100;
    final out = <int>{
      for (final f in const [1 / 3, 1 / 2, 2 / 3])
        (balance * f / step).floor() * step,
    };
    return (out.where((a) => a > 0 && a < balance).toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final regular = context.textTheme.bodyMedium!;
    final label = bold.copyWith(fontSize: 14, color: AppColors.inkMuted);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        22,
        10,
        22,
        MediaQuery.viewInsetsOf(context).bottom +
            MediaQuery.paddingOf(context).bottom +
            20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.fieldBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const Gap(18),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _avatarBg,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    widget.name.isEmpty ? '' : widget.name[0].toUpperCase(),
                    style: bold.copyWith(fontSize: 18, color: AppColors.ink),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pay ${widget.name} part now',
                        style: bold.copyWith(
                          fontSize: 20,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        'Balance this week ${Utils.formatRupee(widget.balance)}',
                        style: regular.copyWith(
                          fontSize: 14.5,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(24),
            Text('Paying now', style: label),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              inputFormatters: [_GroupingFormatter()],
              onChanged: (_) => setState(() {}),
              cursorColor: AppColors.pine,
              style: bold.copyWith(
                fontSize: 36,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    '₹',
                    style: bold.copyWith(
                      fontSize: 36,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0),
                hintText: '0',
                hintStyle: bold.copyWith(
                  fontSize: 36,
                  color: AppColors.fieldBorder,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.pine, width: 1.5),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.pine, width: 2),
                ),
              ),
            ),
            const Gap(18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final a in _quick)
                  _AmountChip(
                    label: Utils.formatRupee(a),
                    selected: _value == a,
                    onTap: () => _select(a),
                  ),
                _AmountChip(
                  label: 'Full ${Utils.formatRupee(widget.balance)}',
                  selected: _value == widget.balance,
                  onTap: () => _select(widget.balance),
                ),
              ],
            ),
            const Gap(18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.fieldFill,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Paying now',
                    value: Utils.formatRupee(_valid ? _value : 0),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.fieldBorder,
                  ),
                  _SummaryRow(
                    label:
                        'Carries to next '
                        '${DateFormat('EEEE').format(widget.nextPayDay)}',
                    value: Utils.formatRupee(_carryAmount),
                    valueColor: _carryAmount > 0 ? _carry : AppColors.ink,
                  ),
                ],
              ),
            ),
            if (_value > widget.balance) ...[
              const Gap(8),
              Text(
                'That’s more than the balance of '
                '${Utils.formatRupee(widget.balance)}.',
                style: regular.copyWith(fontSize: 13.5, color: AppColors.red),
              ),
            ],
            const Gap(18),
            Text('Paid by', style: label),
            const Gap(10),
            SiteStatusSwitcher(
              labels: const ['Cash', 'UPI'],
              selectedIndex: _method.index,
              onChanged: (i) => setState(() => _method = PayMethod.values[i]),
            ),
            const Gap(18),
            _PayButton(
              label: _valid ? 'Pay ${Utils.formatRupee(_value)}' : 'Pay',
              onTap: _valid
                  ? () => Navigator.pop(
                      context,
                      PartPayment(amount: _value, method: _method),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AmountChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.forest : AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? AppColors.forest : AppColors.fieldBorder,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: context.textTheme.headlineSmall!.copyWith(
            fontSize: 14.5,
            color: selected ? AppColors.lime : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.ink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodyMedium!.copyWith(
                fontSize: 15,
                color: AppColors.inkMuted,
              ),
            ),
          ),
          Text(
            value,
            style: context.textTheme.headlineSmall!.copyWith(
              fontSize: 15.5,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _PayButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          if (enabled)
            BoxShadow(
              color: AppColors.lime.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
        ],
      ),
      child: Material(
        color: enabled ? AppColors.lime : AppColors.chip,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: SizedBox(
            height: 56,
            child: Center(
              child: Text(
                label,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 17,
                  color: enabled ? AppColors.ink : AppColors.inkMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Keeps the amount grouped Indian-style while typing: 120000 -> 1,20,000.
class _GroupingFormatter extends TextInputFormatter {
  static final _format = NumberFormat.decimalPattern('en_IN');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue();
    final text = _format.format(
      int.parse(digits.substring(0, digits.length.clamp(0, 9))),
    );
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
