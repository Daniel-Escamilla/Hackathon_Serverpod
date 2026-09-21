import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's visual language, as Mayte defined it in `prototype_app.dart`:
/// Fredoka for headings, Nunito Sans for everything else, violet on cream.
///
/// The prototype still carries its own copy of this so that file stays
/// untouched while she works on it. Once it stops changing, point it here and
/// delete the copy — two sources of truth for a theme only ever diverge.
const appInk = Color(0xFF12152A);
const appViolet = Color(0xFF6558F5);
const appLime = Color(0xFFDDFB69);
const appCoral = Color(0xFFFF776D);
const appSky = Color(0xFFA8D7FF);
const appCream = Color(0xFFF7F4EC);
const appMuted = Color(0xFF687086);

ThemeData buildAppTheme() {
  final body = GoogleFonts.nunitoSansTextTheme().apply(
    bodyColor: appInk,
    displayColor: appInk,
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: appCream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: appViolet,
      primary: appViolet,
      surface: appCream,
    ),
    textTheme: body.copyWith(
      displaySmall: GoogleFonts.fredoka(
        color: appInk,
        fontSize: 42,
        height: .98,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.fredoka(
        color: appInk,
        fontSize: 32,
        height: 1,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.fredoka(
        color: appInk,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.nunitoSans(
        color: appInk,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        color: appInk,
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
        borderSide: const BorderSide(color: appViolet, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(58),
        backgroundColor: appViolet,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: GoogleFonts.nunitoSans(
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        foregroundColor: appViolet,
        side: const BorderSide(color: appViolet, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: appCream,
      foregroundColor: appInk,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.fredoka(
        color: appInk,
        fontSize: 25,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
