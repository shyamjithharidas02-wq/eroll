import 'dart:async';

import 'package:eroll/core/constants/resource_path.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    splashFunction();
    super.initState();
  }

  void splashFunction() {
    Timer(
      const Duration(seconds: 3),
      () =>
          Navigator.pushReplacementNamed(context, AppRouteNames.onboardScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieBuilder.asset(AssetPath.splashJsonPath, height: 250),
      ),
    );
  }
}
