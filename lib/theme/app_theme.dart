import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // New Palette
  static const Color beige = Color(0xFFFCF5EE);
  static const Color pink = Color(0xFFFFC4C4);
  static const Color warmPink = Color(0xFFEE6983);
  static const Color maroon = Color(0xFF850E35);

  // Semantic Colors
  static const Color primaryColor = maroon;
  static const Color secondaryColor = warmPink;
  static const Color accentColor = pink;
  static const Color backgroundColor = beige;
  static const Color cardColor = Colors.white;
  static const Color textPrimary = maroon;
  static const Color textSecondary = Color(0xFF5D4037); // Brownish grey for softer contrast

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [maroon, warmPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [beige, Color(0xFFFFF0F5)], // Beige to very light pink
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Text Styles - for light backgrounds (cards, forms)
  static TextStyle get titleLarge => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.lato(
        fontSize: 16,
        color: textSecondary,
      );

  static TextStyle get bodyMedium => GoogleFonts.lato(
        fontSize: 14,
        color: textSecondary,
      );

  // Text Styles - for gradient/dark backgrounds (high contrast)
  static TextStyle get titleLargeLight => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get titleMediumLight => GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get bodyLargeLight => GoogleFonts.lato(
        fontSize: 16,
        color: Colors.white.withOpacity(0.9),
      );

  static TextStyle get bodyMediumLight => GoogleFonts.lato(
        fontSize: 14,
        color: Colors.white.withOpacity(0.8),
      );

  // Theme Data
  static ThemeData get warmTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        background: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 8,
        shadowColor: maroon.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16),
          elevation: 4,
          shadowColor: maroon.withOpacity(0.3),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        hintStyle: GoogleFonts.lato(color: textSecondary.withOpacity(0.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        prefixIconColor: secondaryColor,
      ),
      iconTheme: const IconThemeData(color: maroon),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: maroon,
        selectionColor: pink,
        selectionHandleColor: maroon,
      ),
    );
  }
}
