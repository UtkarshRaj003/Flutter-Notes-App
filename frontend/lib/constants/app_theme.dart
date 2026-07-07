import 'package:flutter/material.dart';

class AppTheme {
  // Aapka main theme color jo aap har jagah chahte hain
  static const _primaryColor = Colors.blue;

  // LIGHT THEME
  static final lightTheme = ThemeData(
    useMaterial3:
        true, // Material 3 ko explicitly properly configure karne ke liye
    brightness: Brightness.light,

    // FIX: primarySwatch ki jagah colorScheme Seed diya, jo sabhi components (FAB, Buttons) ko blue karega
    colorSchemeSeed: _primaryColor,

    scaffoldBackgroundColor: Colors.grey.shade100,

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors
          .transparent, // Material 3 mein background transparent rakhna clean lagta hai
    ),

    // Global FAB Theme for Light Mode
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );

  // DARK THEME
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Dark mode ke liye bhi lightBlue se matching shades generate honge
    colorSchemeSeed: _primaryColor,

    scaffoldBackgroundColor: const Color(0xFF121212),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
    ),

    // Global FAB Theme for Dark Mode
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor:
          Colors.black, // Dark mode mein text/icon black accha dikhega
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      color: Colors
          .grey
          .shade900, // Dark mode mein cards ka background dark hona chahiye
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade900,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
