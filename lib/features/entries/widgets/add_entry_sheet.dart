import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../../attendance/add_attendance/models/attendance_models.dart';
import '../../works/work_site/data/models/site_model.dart';
import '../../works/work_site/widgets/site_status_switcher.dart';

enum EntryType { advance, expense, clientPaid }

/// What the sheet returns on save.
class EntryResult {
  final EntryType type;
  final int amount;

  /// Worker name (advance) or site title (expense / client paid).
  final String target;
  final DateTime date;
  final String note;

  const EntryResult({
    required this.type,
    required this.amount,
    required this.target,
    required this.date,
    required this.note,
  });

  String get summary {
    final amt = Utils.formatRupee(amount);
    return switch (type) {
      EntryType.advance => 'Advance of $amt saved for $target',
      EntryType.expense => 'Expense of $amt saved for $target',
      EntryType.clientPaid => 'Client payment of $amt saved for $target',
    };
  }
}

/// "Add entry" bottom sheet with Advance / Expense / Client paid tabs.
class AddEntrySheet extends StatefulWidget {
  final EntryType initialType;

  const AddEntrySheet({super.key, this.initialType = EntryType.advance});

  static Future<EntryResult?> show(
    BuildContext context, {
    EntryType initialType = EntryType.advance,
  }) {
    return showModalBottomSheet<EntryResult>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      barrierColor: AppColors.forest.withValues(alpha: 0.88),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AddEntrySheet(initialType: initialType),
    );
  }

  @override
  State<AddEntrySheet> createState() => _AddEntrySheetState();
}

class _AddEntrySheetState extends State<AddEntrySheet> {
  static const Color _label = Color(0xFF55635B);

  late EntryType _type = widget.initialType;
  final _amount = TextEditingController();
  final _note = TextEditingController();
  final Map<EntryType, String> _selected = {};
  DateTime _date = DateUtils.dateOnly(DateTime.now());

  final List<String> _workers = [for (final w in Worker.demo) w.name];
  final List<String> _sites = [
    for (final s in SiteModel.demo)
      if (s.status == SiteStatus.ongoing) s.title,
  ];

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  int get _value => int.tryParse(_amount.text.replaceAll(',', '')) ?? 0;

  bool get _canSave => _value > 0 && _selected[_type] != null;

  List<String> get _options => _type == EntryType.advance ? _workers : _sites;

  String get _optionsLabel => switch (_type) {
    EntryType.advance => 'Given to',
    EntryType.expense => 'For site',
    EntryType.clientPaid => 'From site',
  };

  String get _noteHint => switch (_type) {
    EntryType.advance => 'Optional',
    EntryType.expense => 'e.g. Diesel',
    EntryType.clientPaid => 'e.g. UPI',
  };

  String get _saveLabel => switch (_type) {
    EntryType.advance => 'Save advance',
    EntryType.expense => 'Save expense',
    EntryType.clientPaid => 'Save payment',
  };

  String get _dateLabel {
    final today = DateUtils.dateOnly(DateTime.now());
    final d = DateFormat('d MMM').format(_date);
    if (_date == today) return 'Today, $d';
    if (_date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, $d';
    }
    return DateFormat('EEE, d MMM').format(_date);
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(today.year - 1),
      lastDate: today,
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    Navigator.pop(
      context,
      EntryResult(
        type: _type,
        amount: _value,
        target: _selected[_type]!,
        date: _date,
        note: _note.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final labelStyle = bold.copyWith(fontSize: 13, color: _label);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        (bottom > 0 ? bottom : safeBottom) + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD5DAD6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const Gap(26),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Add entry',
                  style: bold.copyWith(fontSize: 24, color: AppColors.ink),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.pine,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  textStyle: bold.copyWith(fontSize: 16),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
          const Gap(20),
          SiteStatusSwitcher(
            labels: const ['Advance', 'Expense', 'Client paid'],
            selectedIndex: _type.index,
            onChanged: (i) => setState(() => _type = EntryType.values[i]),
          ),
          const Gap(24),
          Text('Amount', style: labelStyle),
          _AmountField(controller: _amount, onChanged: () => setState(() {})),
          const Gap(24),
          Text(_optionsLabel, style: labelStyle),
          const Gap(10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Wrap(
              key: ValueKey(_type == EntryType.advance),
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in _options)
                  _ChoicePill(
                    label: option,
                    selected: _selected[_type] == option,
                    onTap: () => setState(() => _selected[_type] = option),
                  ),
              ],
            ),
          ),
          const Gap(24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date', style: labelStyle),
                    const Gap(8),
                    _BoxField(
                      onTap: _pickDate,
                      child: Text(
                        _dateLabel,
                        style: context.textTheme.bodyMedium!.copyWith(
                          fontSize: 16,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Note', style: labelStyle),
                    const Gap(8),
                    _BoxField(
                      child: TextField(
                        controller: _note,
                        textCapitalization: TextCapitalization.sentences,
                        style: context.textTheme.bodyMedium!.copyWith(
                          fontSize: 16,
                          color: AppColors.ink,
                        ),
                        decoration: InputDecoration.collapsed(
                          hintText: _noteHint,
                          hintStyle: context.textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            color: AppColors.inkMuted.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(18),
          _SaveButton(label: _saveLabel, onTap: _canSave ? _save : null),
        ],
      ),
    );
  }
}

/// Big "₹ 1,000" input with a pine underline. Groups digits Indian-style.
class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _AmountField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineLarge!;

    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.pine, width: 2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '₹',
            style: bold.copyWith(fontSize: 30, color: const Color(0xFF55635B)),
          ),
          const Gap(10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
                _IndianGroupingFormatter(),
              ],
              onChanged: (_) => onChanged(),
              style: bold.copyWith(
                fontSize: 34,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
              cursorColor: AppColors.pine,
              decoration: InputDecoration.collapsed(
                hintText: '0',
                hintStyle: bold.copyWith(
                  fontSize: 34,
                  color: AppColors.ink.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndianGroupingFormatter extends TextInputFormatter {
  static final _format = NumberFormat('#,##,##0', 'en_IN');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    final text = _format.format(int.parse(digits));
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: selected ? AppColors.lime : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.lime : const Color(0xFFDDE1DC),
            ),
          ),
          child: Center(
            widthFactor: 1,
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

class _BoxField extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _BoxField({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: Color(0xFFDDE1DC)),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: child,
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SaveButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final radius = BorderRadius.circular(18);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.lime.withValues(alpha: 0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: AppColors.lime,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: SizedBox(
              height: 52,
              child: Center(
                child: Text(
                  label,
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontSize: 17,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
