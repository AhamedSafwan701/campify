import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF808A50), // Olive green for light mode
        foregroundColor: Colors.white, // White text/icon
      ),
    ),
    cardColor: Colors.white, // For containers like search bar
    shadowColor: Colors.black, // For shadows
    hintColor: Colors.black54, // For hint text
    iconTheme: const IconThemeData(color: Colors.black), // Default icon color
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: Colors.grey[900], // Dark background
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey, // Darker grey for AppBar
      foregroundColor: Colors.white, // White text/icon
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(
          0xFF808A50,
        ), // Same olive green for dark mode
        foregroundColor: Colors.white, // White text/icon
      ),
    ),
    cardColor: Colors.grey[800], // Dark card color for containers
    shadowColor: Colors.black, // Darker shadows
    hintColor: Colors.white70, // Hint text in dark mode
    iconTheme: const IconThemeData(color: Colors.white), // Default icon color
  );
}
