import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF64B5F6), // Light blue
    secondary: Color(0xFF4DD0E1), // Light cyan
    tertiary: Color(0xFF1E1E1E), // Dark surface
    inversePrimary: Color(0xFF1E88E5), // Medium blue
    surface: Color(0xFF1E1E1E),
    surfaceContainerHighest: Color(0xFF424242),
    error: Colors.red.shade400,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF64B5F6),
    foregroundColor: Color(0xFF121212),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF64B5F6),
      foregroundColor: Color(0xFF121212),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Color(0xFF424242),
    selectedColor: Color(0xFF0277BD),
    labelStyle: TextStyle(color: Color(0xFFE0E0E0)),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
    bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
    labelSmall: TextStyle(color: Color(0xFF9E9E9E)),
  ),
);
