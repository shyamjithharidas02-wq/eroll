import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';
import '../data/models/site_detail_model.dart';

/// Bottom sheet to record a client payment. Pops with the new transaction.
class RecordPaymentSheet extends StatefulWidget {
  const RecordPaymentSheet({super.key});

  static Future<SiteTransaction?> show(BuildContext context) {
    return showModalBottomSheet<SiteTransaction>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const RecordPaymentSheet(),
    );
  }

  @override
  State<RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends State<RecordPaymentSheet> {
  static const _modes = ['Cash', 'UPI', 'Bank'];

  final _amount = TextEditingController();
  String _mode = _modes.first;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  int get _value => int.tryParse(_amount.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Record client payment',
            style: bold.copyWith(fontSize: 20, color: AppColors.ink),
          ),
          const Gap(16),
          TextField(
            controller: _amount,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => setState(() {}),
            style: bold.copyWith(fontSize: 18, color: AppColors.ink),
            decoration: InputDecoration(
              prefixText: '₹ ',
              hintText: 'Amount',
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(12),
          Wrap(
            spacing: 8,
            children: [
              for (final m in _modes)
                ChoiceChip(
                  label: Text(m),
                  selected: m == _mode,
                  showCheckmark: false,
                  selectedColor: AppColors.lime,
                  backgroundColor: AppColors.white,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  labelStyle: bold.copyWith(fontSize: 14, color: AppColors.ink),
                  onSelected: (_) => setState(() => _mode = m),
                ),
            ],
          ),
          const Gap(20),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.forest,
              foregroundColor: AppColors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              textStyle: bold.copyWith(fontSize: 16),
            ),
            onPressed: _value <= 0
                ? null
                : () => Navigator.pop(
                    context,
                    SiteTransaction(
                      title: 'Client payment',
                      mode: _mode,
                      date: DateUtils.dateOnly(DateTime.now()),
                      amount: _value,
                    ),
                  ),
            child: const Text('Save payment'),
          ),
        ],
      ),
    );
  }
}
