import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

class ConfidexApp extends StatelessWidget {
  const ConfidexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confidex',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
