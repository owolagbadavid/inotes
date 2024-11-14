import 'package:flutter/cupertino.dart';
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

// CupertinoThemeData cupertionThemeBuilder(context) {
//   return CupertinoThemeData(
//     brightness: MediaQuery.platformBrightnessOf(context),
//     primaryColor: MediaQuery.platformBrightnessOf(context) == Brightness.dark
//         ? Colors.teal
//         : Colors.blue,
//     scaffoldBackgroundColor:
//         MediaQuery.platformBrightnessOf(context) == Brightness.dark
//             ? const Color(0xFF333333)
//             : const Color.fromARGB(255, 195, 193, 193),
//     barBackgroundColor:
//         MediaQuery.platformBrightnessOf(context) == Brightness.dark
//             ? const Color(0xFF1E1E1E)
//             : Colors.white,
//     textTheme: CupertinoTextThemeData(
//       primaryColor: MediaQuery.platformBrightnessOf(context) == Brightness.dark
//           ? Colors.teal
//           : Colors.blue,
//       textStyle: TextStyle(
//         color: MediaQuery.platformBrightnessOf(context) == Brightness.dark
//             ? Colors.white
//             : Colors.black,
//       ),
//       navTitleTextStyle: TextStyle(
//         color: MediaQuery.platformBrightnessOf(context) == Brightness.dark
//             ? Colors.white
//             : Colors.black,
//         fontSize: 17,
//       ),
//       navLargeTitleTextStyle: TextStyle(
//         color: MediaQuery.platformBrightnessOf(context) == Brightness.dark
//             ? Colors.white
//             : Colors.black,
//         fontSize: 34,
//       ),
//       tabLabelTextStyle: TextStyle(
//         color: MediaQuery.platformBrightnessOf(context) == Brightness.dark
//             ? Colors.white
//             : Colors.black,
//         fontSize: 10,
//       ),
//       actionTextStyle: TextStyle(
//         color: MediaQuery.platformBrightnessOf(context) == Brightness.dark
//             ? Colors.tealAccent
//             : Colors.blueAccent,
//       ),
//     ),
//     primaryContrastingColor:
//         MediaQuery.platformBrightnessOf(context) == Brightness.dark
//             ? Colors.tealAccent
//             : Colors.blueAccent,
//   );
// }
