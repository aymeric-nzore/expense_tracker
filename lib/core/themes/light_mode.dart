import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2196F3), // Blue
    secondary: Color(0xFF00BCD4), // Cyan
    tertiary: Color(0xFFF5F5F5), // Light grey background
    inversePrimary: Color(0xFF1565C0), // Dark blue
    surface: Colors.white,
    surfaceContainerHighest: Color(0xFFE0E0E0),
    error: Colors.red.shade600,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF2196F3),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF2196F3),
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF2196F3),
      foregroundColor: Colors.white,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Color(0xFFF5F5F5),
    selectedColor: Color(0xFFB3E5FC),
    labelStyle: TextStyle(color: Color(0xFF424242)),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF424242)),
    bodyMedium: TextStyle(color: Color(0xFF616161)),
    labelSmall: TextStyle(color: Color(0xFF757575)),
  ),
);