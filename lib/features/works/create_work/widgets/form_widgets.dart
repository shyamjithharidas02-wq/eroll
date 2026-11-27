import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/extensions/theme_extensions.dart';

/// Uppercase grey caption above a form card ("JOB", "CLIENT").
class FormSectionLabel extends StatelessWidget {
  final String text;

  const FormSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
      child: Text(
        text.toUpperCase(),
        style: context.textTheme.headlineSmall!.copyWith(
          fontSize: 13,
          letterSpacing: 0.8,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

/// White rounded card that groups form fields.
class FormCard extends StatelessWidget {
  final List<Widget> children;

  const FormCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Small bold caption above a field ("Site name").
class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: context.textTheme.headlineSmall!.copyWith(
          fontSize: 13.5,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

/// Field label + grey rounded input, the building block of the form.
class FormInputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool boldValue;
  final TextCapitalization textCapitalization;

  const FormInputField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.boldValue = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle =
        (boldValue
                ? context.textTheme.headlineSmall!
                : context.textTheme.bodyMedium!)
            .copyWith(fontSize: 16.5, color: AppColors.ink);

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: color, width: width),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(label),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          validator: validator,
          onTap: onTap,
          readOnly: readOnly,
          style: valueStyle,
          cursorColor: AppColors.pine,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: valueStyle.copyWith(
              color: AppColors.inkMuted.withValues(alpha: 0.6),
              fontFamily: context.textTheme.bodyMedium!.fontFamily,
            ),
            filled: true,
            fillColor: AppColors.fieldFill,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child: prefixIcon,
                  ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
            enabledBorder: border(AppColors.fieldBorder),
            focusedBorder: border(AppColors.pine, 1.4),
            errorBorder: border(AppColors.red),
            focusedErrorBorder: border(AppColors.red, 1.4),
          ),
        ),
      ],
    );
  }
}

/// Wrap of pill chips; the selected one is dark with lime text.
class ChoiceChips extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  const ChoiceChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          _Chip(
            label: option,
            selected: option == selected,
            onTap: () => onSelected(option),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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

/// Space between two stacked fields inside a card.
class FieldGap extends StatelessWidget {
  const FieldGap({super.key});

  @override
  Widget build(BuildContext context) => const Gap(18);
}

/// Formats digits as Indian rupees while typing: "120000" -> "₹1,20,000".
class RupeeInputFormatter extends TextInputFormatter {
  static final _format = NumberFormat.decimalPattern('en_IN');

  static int parse(String text) =>
      int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue();
    final text = '₹${_format.format(int.parse(digits))}';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
