import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepOrangeAccent,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        bodyMedium: TextStyle(fontSize: 16),
      ),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    );
  }
}
