import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/onboarding_screen.dart';
import 'screens/car_selection_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/profile_screen.dart';
import 'models/car.dart';
import 'theme.dart';
import 'theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://eaozufwcnvfuxddfceyv.supabase.co',
    anonKey: 'sb_publishable_9L-c2W6F1RPBXw8Ru8FGIQ_7yaBWBkr',
  );
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
  final carJson = prefs.getString('selected_car');

  Car? savedCar;
  if (carJson != null) {
    savedCar = Car.fromJson(jsonDecode(carJson));
  }

  await ThemeNotifier().load();

  runApp(MyApp(seenOnboarding: seenOnboarding, savedCar: savedCar));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final Car? savedCar;

  const MyApp({super.key, required this.seenOnboarding, this.savedCar});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (!seenOnboarding) {
      home = const OnboardingScreen();
    } else if (savedCar != null) {
      home = CategoriesScreen(car: savedCar!);
    } else {
      home = CarSelectionScreen();
    }

    return AnimatedBuilder(
      animation: ThemeNotifier(),
      builder: (context, _) => MaterialApp(
        title: 'AutoGuidePro',
        theme: AppTheme.theme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeNotifier().mode,
        home: home,
        routes: {
          '/car_selection': (context) => CarSelectionScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
