import 'package:eroll/app/routes/app_route_config.dart';
import 'package:eroll/app/routes/app_route_names.dart';
import 'package:eroll/app/theme/app_themes.dart';
import 'package:eroll/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.buildProviders(),
      child: MaterialApp(
        // Shown in the Android recent-apps switcher.
        title: 'Kinar',
        theme: AppThemes.lightTheme,
        //showPerformanceOverlay: true,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouteNames.splashPage,
        onGenerateRoute: AppRouteConfig.onGenerateRoute,
      ),
    );
  }
}
