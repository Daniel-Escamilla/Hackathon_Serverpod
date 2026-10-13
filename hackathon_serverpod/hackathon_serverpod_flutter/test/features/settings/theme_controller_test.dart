import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/app_theme.dart';
import 'package:hackathon_serverpod_flutter/features/settings/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('starts light and remembers dark mode', () async {
    final theme = await ThemeController.load();
    expect(theme.mode, ThemeMode.light);

    await theme.setDark(true);
    expect(theme.mode, ThemeMode.dark);

    final reloaded = await ThemeController.load();
    expect(reloaded.dark, isTrue);
  });

  test('dark mode is a soft grey, never black', () {
    final palette = AppTheme.dark.extension<AppPalette>()!;

    expect(AppTheme.dark.brightness, Brightness.dark);
    expect(AppTheme.dark.scaffoldBackgroundColor, palette.background);
    expect(palette.background, isNot(Colors.black));
    expect(palette.background.computeLuminance(), greaterThan(0.04));
  });

  test('light mode keeps the cream page and white cards', () {
    final palette = AppTheme.light.extension<AppPalette>()!;

    expect(palette.background, AppColors.cream);
    expect(palette.card, const Color(0xFFFFFFFF));
  });
}
