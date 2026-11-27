import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/extensions/theme_extensions.dart';

/// Colours for the PIN dots and keypad on a light or dark background.
class PinPadStyle {
  final Color keyColor;
  final Color keyText;
  final Color keyShadow;
  final Color dotEmptyBorder;
  final Color dotFilled;

  const PinPadStyle({
    required this.keyColor,
    required this.keyText,
    required this.keyShadow,
    required this.dotEmptyBorder,
    required this.dotFilled,
  });

  /// White keys on the light canvas (Set PIN).
  static const light = PinPadStyle(
    keyColor: AppColors.white,
    keyText: AppColors.ink,
    keyShadow: Color(0x1214241D),
    dotEmptyBorder: AppColors.pinDotBorder,
    dotFilled: AppColors.pine,
  );

  /// Soft green keys on the dark forest background (Unlock).
  static const dark = PinPadStyle(
    keyColor: AppColors.pinKeyDark,
    keyText: AppColors.white,
    keyShadow: Colors.transparent,
    dotEmptyBorder: AppColors.pinDotBorderDark,
    dotFilled: AppColors.lime,
  );
}

/// Row of PIN dots: outlined when empty, filled when entered.
class PinDots extends StatelessWidget {
  final int length;
  final int filled;
  final bool error;
  final PinPadStyle style;

  const PinDots({
    super.key,
    required this.length,
    required this.filled,
    this.error = false,
    this.style = PinPadStyle.light,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < length; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            margin: const EdgeInsets.symmetric(horizontal: 9),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: error
                  ? AppColors.red
                  : (i < filled ? style.dotFilled : Colors.transparent),
              border: Border.all(
                color: error
                    ? AppColors.red
                    : (i < filled ? style.dotFilled : style.dotEmptyBorder),
                width: 2,
              ),
            ),
          ),
      ],
    );
  }
}

/// 3x4 number pad with round keys and a backspace key.
class PinKeypad extends StatelessWidget {
  final ValueChanged<int> onDigit;
  final VoidCallback onBackspace;
  final PinPadStyle style;
  final bool enabled;

  const PinKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.style = PinPadStyle.light,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget row(List<Widget> keys) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: keys,
      ),
    );

    Widget digit(int d) => _DigitKey(
      digit: d,
      style: style,
      onTap: enabled ? () => onDigit(d) : null,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        row([digit(1), digit(2), digit(3)]),
        row([digit(4), digit(5), digit(6)]),
        row([digit(7), digit(8), digit(9)]),
        row([
          const SizedBox(width: _DigitKey.size),
          digit(0),
          SizedBox(
            width: _DigitKey.size,
            height: _DigitKey.size,
            child: IconButton(
              onPressed: enabled
                  ? () {
                      HapticFeedback.selectionClick();
                      onBackspace();
                    }
                  : null,
              tooltip: 'Delete',
              icon: Icon(
                Icons.backspace_outlined,
                color: style.keyText,
                size: 26,
              ),
            ),
          ),
        ]),
      ],
    );
  }
}

class _DigitKey extends StatelessWidget {
  static const double size = 76;

  final int digit;
  final PinPadStyle style;
  final VoidCallback? onTap;

  const _DigitKey({required this.digit, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: style.keyShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: style.keyColor,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: Text(
                '$digit',
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 28,
                  color: style.keyText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
