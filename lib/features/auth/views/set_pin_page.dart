import 'package:animate_do/animate_do.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:eroll/core/constants/asset_path.dart';
import 'package:eroll/core/security/app_lock_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../widgets/pin_keypad.dart';

/// First-launch PIN setup: enter a 4-digit PIN, confirm it, then enter the app.
class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  static const int _pinLength = 4;

  String _entered = '';
  String? _firstPin; // set once the first entry is complete
  bool _mismatch = false;
  bool _useFingerprint = true;
  int _shakeKey = 0;

  bool get _confirming => _firstPin != null;

  void _onDigit(int d) {
    if (_entered.length >= _pinLength) return;
    setState(() {
      _mismatch = false;
      _entered += '$d';
    });
    if (_entered.length == _pinLength) {
      // Let the last dot fill before moving on.
      Future.delayed(const Duration(milliseconds: 180), _onComplete);
    }
  }

  void _onBackspace() {
    if (_entered.isEmpty) return;
    setState(() {
      _mismatch = false;
      _entered = _entered.substring(0, _entered.length - 1);
    });
  }

  void _onComplete() {
    if (!mounted) return;
    if (!_confirming) {
      setState(() {
        _firstPin = _entered;
        _entered = '';
      });
      return;
    }

    if (_entered == _firstPin) {
      _save(_entered);
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() {
      _mismatch = true;
      _shakeKey++;
      _entered = '';
    });
  }

  void _restart() => setState(() {
    _firstPin = null;
    _entered = '';
    _mismatch = false;
  });

  Future<void> _save(String pin) async {
    final lock = AppLockService.instance;
    await lock.savePin(pin);

    // Only keep fingerprint on if the phone actually has one enrolled and
    // the owner passes the prompt once now.
    var biometric = false;
    if (_useFingerprint && await lock.canUseBiometrics()) {
      biometric = await lock.authenticate(
        reason: 'Use your fingerprint to unlock Kinar',
      );
    }
    await lock.setBiometricEnabled(biometric);

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouteNames.bottomNavScreen,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _confirming ? 'Confirm your PIN' : 'Set a 4-digit PIN';
    final subtitle = _mismatch
        ? 'PINs didn’t match. Enter it again.'
        : _confirming
        ? 'Enter the same 4 digits again to make sure.'
        : 'Only you use this app, so a quick PIN keeps the crew’s pay details private.';

    return PopScope(
      // Back while confirming returns to the first entry instead of leaving.
      canPop: !_confirming,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _restart();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppColors.canvas,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          const Gap(64),
                          Image.asset(AssetPath.kinarWordmark, height: 42),
                          const Gap(28),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: context.textTheme.headlineSmall!.copyWith(
                              fontSize: 26,
                              color: AppColors.ink,
                            ),
                          ),
                          const Gap(12),
                          SizedBox(
                            height: 48,
                            child: Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyMedium!.copyWith(
                                fontSize: 15.5,
                                height: 1.45,
                                color: _mismatch
                                    ? AppColors.red
                                    : AppColors.inkMuted,
                              ),
                            ),
                          ),
                          const Gap(38),
                          ShakeX(
                            key: ValueKey(_shakeKey),
                            animate: _shakeKey > 0,
                            duration: const Duration(milliseconds: 450),
                            from: 12,
                            child: PinDots(
                              length: _pinLength,
                              filled: _entered.length,
                              error: _mismatch && _entered.isEmpty,
                            ),
                          ),
                          const Gap(36),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: PinKeypad(
                              onDigit: _onDigit,
                              onBackspace: _onBackspace,
                            ),
                          ),
                          const Spacer(),
                          const Gap(24),
                          _FingerprintOption(
                            value: _useFingerprint,
                            onChanged: (v) =>
                                setState(() => _useFingerprint = v),
                          ),
                          const Gap(20),
                        ],
                      ),
                    ),
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

class _FingerprintOption extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FingerprintOption({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: value ? AppColors.pine : AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: value ? AppColors.pine : AppColors.pinDotBorder,
                    width: 2,
                  ),
                ),
                child: value
                    ? const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: AppColors.white,
                      )
                    : null,
              ),
              const Gap(16),
              const Icon(
                Iconsax.finger_scan_copy,
                size: 22,
                color: AppColors.ink,
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  'Also unlock with fingerprint',
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
