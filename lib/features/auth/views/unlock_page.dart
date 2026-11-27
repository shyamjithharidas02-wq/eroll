import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/app/theme/app_colors.dart';
import 'package:eroll/app/theme/extensions/theme_extensions.dart';
import 'package:eroll/core/constants/asset_path.dart';
import 'package:eroll/core/security/app_lock_service.dart';
import 'package:eroll/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../home/models/home_dashboard_data.dart';
import '../widgets/pin_keypad.dart';

/// Shown on every launch once a PIN exists: PIN pad + fingerprint unlock.
class UnlockPage extends StatefulWidget {
  const UnlockPage({super.key});

  @override
  State<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends State<UnlockPage> {
  static const int _pinLength = 4;
  static const int _maxAttempts = 5;
  static const Duration _lockout = Duration(seconds: 30);

  final _lock = AppLockService.instance;

  String _entered = '';
  bool _wrong = false;
  bool _checking = false;
  int _shakeKey = 0;
  int _failed = 0;
  bool _biometricAvailable = false;

  Timer? _lockTimer;
  int _lockSecondsLeft = 0;

  bool get _locked => _lockSecondsLeft > 0;

  @override
  void initState() {
    super.initState();
    _initBiometrics();
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    super.dispose();
  }

  Future<void> _initBiometrics() async {
    final enabled = await _lock.isBiometricEnabled();
    final available = enabled && await _lock.canUseBiometrics();
    if (!mounted) return;
    setState(() => _biometricAvailable = available);
    // Prompt straight away so the owner can just touch the sensor.
    if (available) _unlockWithBiometrics();
  }

  Future<void> _unlockWithBiometrics() async {
    final ok = await _lock.authenticate(reason: 'Unlock Kinar');
    if (ok && mounted) _openApp();
  }

  void _onDigit(int d) {
    if (_checking || _locked || _entered.length >= _pinLength) return;
    setState(() {
      _wrong = false;
      _entered += '$d';
    });
    if (_entered.length == _pinLength) _check();
  }

  void _onBackspace() {
    if (_checking || _entered.isEmpty) return;
    setState(() {
      _wrong = false;
      _entered = _entered.substring(0, _entered.length - 1);
    });
  }

  Future<void> _check() async {
    setState(() => _checking = true);
    final ok = await _lock.verifyPin(_entered);
    if (!mounted) return;
    if (ok) return _openApp();

    HapticFeedback.heavyImpact();
    _failed++;
    setState(() {
      _checking = false;
      _wrong = true;
      _shakeKey++;
      _entered = '';
    });
    if (_failed >= _maxAttempts) _startLockout();
  }

  void _startLockout() {
    _failed = 0;
    setState(() => _lockSecondsLeft = _lockout.inSeconds);
    _lockTimer?.cancel();
    _lockTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _lockSecondsLeft--);
      if (_lockSecondsLeft <= 0) {
        t.cancel();
        setState(() => _wrong = false);
      }
    });
  }

  void _openApp() => Navigator.pushNamedAndRemoveUntil(
    context,
    AppRouteNames.bottomNavScreen,
    (_) => false,
  );

  /// Confirms identity with the phone's own lock, then lets the owner set a
  /// new PIN. App data lives in Firestore, so nothing is lost.
  Future<void> _forgotPin() async {
    final secured = await _lock.isDeviceSecured();
    if (!mounted) return;
    if (!secured) {
      Utils.showSnackBar(
        'Set a screen lock on this phone first, then try again.',
        context,
      );
      return;
    }
    final ok = await _lock.authenticate(
      reason: 'Confirm it’s you to reset your Kinar PIN',
      biometricOnly: false,
    );
    if (!ok || !mounted) return;
    await _lock.clearPin();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRouteNames.setPinPage,
      (_) => false,
    );
  }

  String get _message {
    if (_locked) return 'Too many tries. Wait ${_lockSecondsLeft}s.';
    if (_wrong) return 'Wrong PIN. Try again.';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use the signed-in owner's name once profiles exist.
    final name = HomeDashboardData.demo.adminName;
    final muted = context.textTheme.bodyMedium!.copyWith(
      fontSize: 16,
      color: AppColors.onDarkMuted,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.forest,
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
                        _Avatar(initial: name.isEmpty ? '' : name[0]),
                        const Gap(22),
                        Text(
                          'Welcome back',
                          style: context.textTheme.headlineSmall!.copyWith(
                            fontSize: 26,
                            color: AppColors.white,
                          ),
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Enter your PIN to open ', style: muted),
                            Image.asset(
                              AssetPath.kinarWordmark,
                              height: 24,
                              color: AppColors.lime,
                              colorBlendMode: BlendMode.srcIn,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 34,
                          child: Center(
                            child: Text(
                              _message,
                              style: muted.copyWith(
                                fontSize: 14,
                                color: AppColors.wrongPinOnDark,
                              ),
                            ),
                          ),
                        ),
                        ShakeX(
                          key: ValueKey(_shakeKey),
                          animate: _shakeKey > 0,
                          duration: const Duration(milliseconds: 450),
                          from: 12,
                          child: PinDots(
                            length: _pinLength,
                            filled: _entered.length,
                            style: PinPadStyle.dark,
                          ),
                        ),
                        const Gap(36),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: PinKeypad(
                            style: PinPadStyle.dark,
                            enabled: !_locked,
                            onDigit: _onDigit,
                            onBackspace: _onBackspace,
                          ),
                        ),
                        const Spacer(),
                        const Gap(16),
                        if (_biometricAvailable) ...[
                          _FingerprintButton(onTap: _unlockWithBiometrics),
                          const Gap(14),
                        ],
                        TextButton(
                          onPressed: _forgotPin,
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.onDarkMuted,
                          ),
                          child: Text('Forgot PIN?', style: muted),
                        ),
                        const Gap(12),
                      ],
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

class _Avatar extends StatelessWidget {
  final String initial;

  const _Avatar({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.pine,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.forestSoft, width: 3),
      ),
      child: Text(
        initial.toUpperCase(),
        style: context.textTheme.headlineSmall!.copyWith(
          fontSize: 26,
          color: AppColors.lime,
        ),
      ),
    );
  }
}

class _FingerprintButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FingerprintButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.lime,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Iconsax.finger_scan_copy,
                color: AppColors.ink,
                size: 22,
              ),
              const Gap(12),
              Text(
                'Use fingerprint',
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 17,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
