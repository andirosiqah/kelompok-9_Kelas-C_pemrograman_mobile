
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';
import 'providers/water_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WaterProvider(),
      child: const WeatherSipApp(),
    ),
  );
}

class WeatherSipApp extends StatelessWidget {
  const WeatherSipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherSip',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
