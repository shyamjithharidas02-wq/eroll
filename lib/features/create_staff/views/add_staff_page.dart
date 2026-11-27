import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';
import '../../../core/utils/utils.dart';
import '../../staffs/data/models/staff_member.dart';
import '../../staffs/data/staff_repository.dart';
import '../../works/work_site/widgets/site_status_switcher.dart';

/// Add a crew member. Adds to [StaffRepository] and pops with the member.
class AddStaffPage extends StatefulWidget {
  /// When set, the form edits this member instead of adding a new one.
  final StaffMember? initial;

  const AddStaffPage({super.key, this.initial});

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  static const double _hPad = 20;
  static const Color _fieldBg = Color(0xFFF4F6F3);
  static const Color _fieldBorder = Color(0xFFE2E6E1);
  static const Color _label = Color(0xFF55635B);

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _place = TextEditingController();
  final _wage = TextEditingController();

  StaffRole _role = StaffRole.helper;
  PayCycle _cycle = PayCycle.weekly;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final m = widget.initial;
    if (m != null) {
      _name.text = m.name;
      _phone.text = m.phoneDisplay;
      _place.text = m.homePlace;
      _wage.text = '${m.dailyWage}';
      _role = m.role;
      _cycle = m.payCycle;
    }
    for (final c in [_name, _phone, _wage]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _place, _wage]) {
      c.dispose();
    }
    super.dispose();
  }

  int get _wageValue => int.tryParse(_wage.text) ?? 0;

  String get _phoneDigits => _phone.text.replaceAll(' ', '');

  bool get _phoneValid => _phoneDigits.isEmpty || _phoneDigits.length == 10;

  bool get _canSave =>
      _name.text.trim().isNotEmpty && _wageValue > 0 && _phoneValid;

  String get _payNote {
    final wage = _wageValue;
    if (_cycle == PayCycle.daily) {
      return wage > 0
          ? 'Paid each evening, ${Utils.formatRupee(wage)} a day. '
                'Nothing carries to Saturday.'
          : 'Paid each evening. Nothing carries to Saturday.';
    }
    return wage > 0
        ? 'Paid every Saturday. A full 6-day week comes to '
              '${Utils.formatRupee(wage * 6)}.'
        : 'Paid every Saturday, days × rate minus advances.';
  }

  void _save() {
    final initial = widget.initial;
    if (initial != null) {
      final updated = initial.copyWith(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        homePlace: _place.text.trim(),
        role: _role,
        dailyWage: _wageValue,
        payCycle: _cycle,
      );
      context.read<StaffRepository>().update(updated);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${updated.name} updated')));
      Navigator.pop(context, updated);
      return;
    }
    final member = StaffMember(
      id: 'staff-${DateTime.now().microsecondsSinceEpoch}',
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      homePlace: _place.text.trim(),
      role: _role,
      dailyWage: _wageValue,
      payCycle: _cycle,
    );
    context.read<StaffRepository>().add(member);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${member.name} added to crew')));
    Navigator.pop(context, member);
  }

  @override
  Widget build(BuildContext context) {
    final bold = context.textTheme.headlineSmall!;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final initial = _name.text.trim().isEmpty
        ? null
        : _name.text.trim()[0].toUpperCase();

    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 0, 10),
      child: Text(
        title.toUpperCase(),
        style: bold.copyWith(
          fontSize: 13,
          letterSpacing: 0.4,
          color: AppColors.inkMuted,
        ),
      ),
    );

    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: bold.copyWith(fontSize: 13, color: _label)),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  _hPad,
                  20,
                  _hPad,
                  bottomInset + 110,
                ),
                children: [
                  SizedBox(
                    height: 46,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _BackButton(
                            onTap: () => Navigator.maybePop(context),
                          ),
                        ),
                        Text(
                          _editing ? 'Edit staff' : 'Add staff',
                          style: bold.copyWith(
                            fontSize: 20,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(18),
                  Center(child: _Avatar(initial: initial)),
                  Center(
                    child: TextButton(
                      onPressed: () => Utils.showSnackBar(
                        'Photo upload is coming soon',
                        context,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.pine,
                        textStyle: bold.copyWith(fontSize: 15),
                      ),
                      child: const Text('Add photo'),
                    ),
                  ),
                  const Gap(16),
                  section('Details'),
                  _Card(
                    children: [
                      label('Full name'),
                      _Field(
                        controller: _name,
                        hint: 'e.g. Dineshan',
                        capitalization: TextCapitalization.words,
                        action: TextInputAction.next,
                      ),
                      const Gap(16),
                      label('Phone'),
                      _Field(
                        controller: _phone,
                        hint: '98470 00000',
                        keyboard: TextInputType.phone,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                          _PhoneFormatter(),
                        ],
                        action: TextInputAction.next,
                        error: _phoneValid ? null : 'Enter a 10-digit number',
                      ),
                      const Gap(16),
                      label('Home place'),
                      _Field(
                        controller: _place,
                        hint: 'e.g. Meenangadi',
                        capitalization: TextCapitalization.words,
                        action: TextInputAction.done,
                      ),
                      const Gap(16),
                      label('Role'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final r in StaffRole.values)
                            _RolePill(
                              label: r.label,
                              selected: r == _role,
                              onTap: () => setState(() => _role = r),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(22),
                  section('Pay'),
                  _Card(
                    children: [
                      label('Daily wage'),
                      _Field(
                        controller: _wage,
                        hint: '700',
                        prefix: '₹',
                        bold: true,
                        keyboard: TextInputType.number,
                        formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                      ),
                      const Gap(16),
                      label('Paid'),
                      SiteStatusSwitcher(
                        labels: [for (final c in PayCycle.values) c.label],
                        selectedIndex: _cycle.index,
                        onChanged: (i) =>
                            setState(() => _cycle = PayCycle.values[i]),
                      ),
                      const Gap(14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F6EA),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _payNote,
                          style: context.textTheme.bodyMedium!.copyWith(
                            fontSize: 14,
                            height: 1.4,
                            color: AppColors.pine,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Pinned "Add to crew" with a fade behind it.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  _hPad,
                  24,
                  _hPad,
                  bottomInset > 0 ? bottomInset : 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.canvas.withValues(alpha: 0),
                      AppColors.canvas,
                    ],
                    stops: const [0, 0.4],
                  ),
                ),
                child: _SaveButton(
                  label: _editing ? 'Save changes' : 'Add to crew',
                  onTap: _canSave ? _save : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: AppColors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 46,
            height: 46,
            child: Icon(
              Icons.chevron_left_rounded,
              size: 26,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? initial;

  const _Avatar({this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFABC9B7),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: initial == null
          ? const Icon(Icons.person_rounded, size: 40, color: AppColors.ink)
          : Text(
              initial!,
              style: context.textTheme.headlineLarge!.copyWith(
                fontSize: 34,
                color: AppColors.ink,
              ),
            ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;

  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? prefix;
  final bool bold;
  final TextInputType? keyboard;
  final List<TextInputFormatter>? formatters;
  final TextCapitalization capitalization;
  final TextInputAction? action;
  final String? error;

  const _Field({
    required this.controller,
    required this.hint,
    this.prefix,
    this.bold = false,
    this.keyboard,
    this.formatters,
    this.capitalization = TextCapitalization.none,
    this.action,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final base = bold
        ? context.textTheme.headlineSmall!.copyWith(fontSize: 17)
        : context.textTheme.bodyMedium!.copyWith(fontSize: 17);
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: c),
    );

    return TextField(
      controller: controller,
      keyboardType: keyboard,
      inputFormatters: formatters,
      textCapitalization: capitalization,
      textInputAction: action,
      cursorColor: AppColors.pine,
      style: base.copyWith(color: AppColors.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: context.textTheme.bodyMedium!.copyWith(
          fontSize: 17,
          color: AppColors.inkMuted.withValues(alpha: 0.7),
        ),
        prefixText: prefix,
        prefixStyle: base.copyWith(color: AppColors.ink),
        errorText: error,
        filled: true,
        fillColor: _AddStaffPageState._fieldBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder: border(_AddStaffPageState._fieldBorder),
        focusedBorder: border(AppColors.pine),
        errorBorder: border(AppColors.red),
        focusedErrorBorder: border(AppColors.red),
      ),
    );
  }
}

/// Formats 10 digits as "98470 00000".
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final d = newValue.text.replaceAll(' ', '');
    final text = d.length > 5 ? '${d.substring(0, 5)} ${d.substring(5)}' : d;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _RolePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RolePill({
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.forest : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.forest : const Color(0xFFDDE1DC),
            ),
          ),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 15,
                color: selected ? AppColors.lime : AppColors.ink,
              ),
            ),
          ),
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
    final radius = BorderRadius.circular(28);

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
                    blurRadius: 18,
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
              height: 56,
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
