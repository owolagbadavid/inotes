import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  cardColor: const Color.fromARGB(255, 195, 193, 193), // Light grey background
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.blueAccent,
    error: Color(0xFFFE4A49), // Custom error color
    onError: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // For main text
    bodySmall: TextStyle(color: Colors.grey), // For subtitle text
  ),
  dividerColor: Colors.grey, // Text/icon colo
  useMaterial3: true,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  cardColor: const Color(0xFF333333), // Dark background for cards
  colorScheme: const ColorScheme.dark(
    primary: Colors.teal,
    secondary: Colors.tealAccent,
    error: Color(0xFFFF6961), // Custom error color for dark mode
    onError: Colors.black, // Text/icon color for error states in dark mode
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Main text color for dark mode
    bodySmall: TextStyle(color: Colors.grey), // Subtitle text for dark mode
  ),
  dividerColor: Colors.grey.shade700,
  useMaterial3: true,
  // Customize more properties for dark mode as needed
);
