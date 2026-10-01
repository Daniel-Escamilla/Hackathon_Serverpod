import 'package:flutter/material.dart';

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

/// The colours that change with light and dark mode: page, cards, text,
/// secondary text and borders. Brand colours stay in [AppColors]; ink stays
/// there too for text on the pastel pills, which keep a light background in
/// both modes. Read it with `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.card,
    required this.ink,
    required this.muted,
    required this.border,
  });

  static const light = AppPalette(
    background: AppColors.cream,
    card: Color(0xFFFFFFFF),
    ink: AppColors.ink,
    muted: AppColors.muted,
    border: Color(0xFFE4E1EA),
  );

  /// Dark, but a soft grey rather than black.
  static const dark = AppPalette(
    background: Color(0xFF3B3E47),
    card: Color(0xFF4A4E59),
    ink: Color(0xFFF4F1EA),
    muted: Color(0xFFBEC2CE),
    border: Color(0xFF5C6170),
  );

  final Color background;
  final Color card;
  final Color ink;
  final Color muted;
  final Color border;

  @override
  AppPalette copyWith({
    Color? background,
    Color? card,
    Color? ink,
    Color? muted,
    Color? border,
  }) => AppPalette(
    background: background ?? this.background,
    card: card ?? this.card,
    ink: ink ?? this.ink,
    muted: muted ?? this.muted,
    border: border ?? this.border,
  );

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}

/// Font family names, matching the `family:` entries in pubspec.yaml. Both
/// fonts are bundled as variable-weight .ttf files under assets/fonts so the
/// first frame never flashes the system font while google_fonts would still
/// be fetching them.
class AppFonts {
  const AppFonts._();

  static const display = 'Fredoka';
  static const body = 'Nunito Sans';

  /// For any amount of coins, so a column of numbers lines up — digits get
  /// a fixed width instead of proportional spacing.
  static const tabularFigures = [FontFeature.tabularFigures()];
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final typography = Typography.material2021();
    final body =
        (brightness == Brightness.dark ? typography.white : typography.black)
            .apply(
              fontFamily: AppFonts.body,
              bodyColor: p.ink,
              displayColor: p.ink,
            );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: [p],
      scaffoldBackgroundColor: p.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.violet,
        brightness: brightness,
        primary: AppColors.violet,
        surface: p.background,
        onSurface: p.ink,
      ),
      textTheme: body.copyWith(
        displaySmall: TextStyle(
          fontFamily: AppFonts.display,
          color: p.ink,
          fontSize: 42,
          height: .98,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.display,
          color: p.ink,
          fontSize: 32,
          height: 1,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          fontFamily: AppFonts.display,
          color: p.ink,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: AppFonts.body,
          color: p.ink,
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.body,
          color: p.ink,
          fontSize: 16,
          height: 1.35,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: p.border),
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
          textStyle: const TextStyle(
            fontFamily: AppFonts.body,
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
          textStyle: const TextStyle(
            fontFamily: AppFonts.body,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.display,
          color: p.ink,
          fontSize: 25,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
