import 'dart:async';

import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/core/constants/asset_path.dart';
import 'package:eroll/core/security/app_lock_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  /// Exact colours sampled from the design.
  static const Color background = Color(0xFF13261E);
  static const Color foreground = Color(0xFFF2F5F1);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Read the lock state while the splash plays.
    final hasPin = AppLockService.instance.hasPin().catchError((_) => false);
    _timer = Timer(const Duration(seconds: 3), () async {
      // First launch: onboarding -> set PIN. Afterwards: unlock.
      final next = await hasPin
          ? AppRouteNames.unlockPage
          : AppRouteNames.onboardPage;
      if (mounted) Navigator.pushReplacementNamed(context, next);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: SplashPage.background,
        body: Stack(
          children: [
            // Wordmark sits just below the vertical centre, as in the design.
            Align(
              alignment: const Alignment(0.03, 0.025),
              child: Semantics(
                label: 'Kinar',
                image: true,
                child: Image.asset(
                  AssetPath.kinarLogo,
                  width: 201,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: (bottomInset > 0 ? bottomInset : 0) + 20,
              child: Text(
                'Crew · Wages · Sites',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 16,
                  letterSpacing: -0.2,
                  color: SplashPage.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
