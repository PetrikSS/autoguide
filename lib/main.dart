import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/car_selection_screen.dart';
import 'screens/profile_screen.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoGuidePro',
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/car_selection': (context) => CarSelectionScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}