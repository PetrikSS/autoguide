import 'package:flutter/material.dart';

class AppTheme {

  static const Color deepOrange = Color(0xFFD85210); // Основной терракотовый
  static const Color darkOrange = Color(0xFFA33A00); // Для нажатий
  static const Color lightOrange = Color(0xFFFDE6D9); // Для подложек
  static const Color backgroundGrey = Color(0xFFF8F8F8); // Светло-серый фон

  static ThemeData get theme {
    return ThemeData(
      primaryColor: deepOrange,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: deepOrange,
        secondary: darkOrange,
      ),
      scaffoldBackgroundColor: Colors.white,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: deepOrange,
          side: const BorderSide(color: deepOrange),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}