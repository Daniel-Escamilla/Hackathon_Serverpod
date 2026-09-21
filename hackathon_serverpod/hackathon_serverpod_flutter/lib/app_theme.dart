import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Named color tokens for the app. Nothing outside this file should hold a
/// [Color] literal that stands for one of these — reference the token
/// instead so the palette can change in one place.
class AppColors {
  const AppColors._();

  static const ink = Color(0xFF12152A);
  static const violet = Color(0xFF6558F5);
  static const lime = Color(0xFFDDFB69);
  static const coral = Color(0xFFFF776D);
  static const sky = Color(0xFFA8D7FF);
  static const cream = Color(0xFFF7F4EC);
  static const muted = Color(0xFF687086);
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final body = GoogleFonts.nunitoSansTextTheme().apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.violet,
        primary: AppColors.violet,
        surface: AppColors.cream,
      ),
      textTheme: body.copyWith(
        displaySmall: GoogleFonts.fredoka(
          color: AppColors.ink,
          fontSize: 42,
          height: .98,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.fredoka(
          color: AppColors.ink,
          fontSize: 32,
          height: 1,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.fredoka(
          color: AppColors.ink,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.nunitoSans(
          color: AppColors.ink,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: GoogleFonts.nunitoSans(
          color: AppColors.ink,
          fontSize: 16,
          height: 1.35,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE4E1EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.violet, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(58),
          backgroundColor: AppColors.violet,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: AppColors.violet,
          side: const BorderSide(color: AppColors.violet, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fredoka(
          color: AppColors.ink,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
