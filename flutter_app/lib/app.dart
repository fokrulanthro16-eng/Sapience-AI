import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'navigation/app_routes.dart';

class SapienceApp extends StatelessWidget {
  const SapienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sapience AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.welcome,
      routes: AppRoutes.routes,
    );
  }
}
