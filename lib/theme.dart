import 'package:flutter/material.dart';

class AppTheme {
  static const Color deepOrange = Color(0xFFD85210);
  static const Color darkOrange = Color(0xFFA33A00);
  static const Color lightOrange = Color(0xFFFDE6D9);
  static const Color backgroundGrey = Color(0xFFF8F8F8);

  static ThemeData get theme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      primaryColor: deepOrange,
      colorScheme: ColorScheme.fromSwatch(brightness: brightness).copyWith(
        primary: deepOrange,
        secondary: darkOrange,
        surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      cardColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: deepOrange,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepOrange,
          side: const BorderSide(color: deepOrange),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
      listTileTheme: ListTileThemeData(
        textColor: isDark ? Colors.white : Colors.black,
      ),
      dividerColor: isDark ? Colors.white12 : Colors.black12,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
      ),
    );
  }
}
