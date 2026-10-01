import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Light or dark mode, kept on this device only, like the language.
class ThemeController extends ChangeNotifier {
  ThemeController._(this._prefs, this._dark);

  /// Light mode with no preferences, for tests and for when they fail.
  ThemeController.light() : this._(null, false);

  static const _key = 'app_dark_mode';

  /// Never throws: if the preference cannot be read, the app starts light
  /// and simply does not remember a change.
  static Future<ThemeController> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return ThemeController._(prefs, prefs.getBool(_key) ?? false);
    } catch (error) {
      debugPrint('Theme preference unavailable: $error');
      return ThemeController.light();
    }
  }

  final SharedPreferences? _prefs;
  bool _dark;

  bool get dark => _dark;
  ThemeMode get mode => _dark ? ThemeMode.dark : ThemeMode.light;

  Future<void> setDark(bool dark) async {
    if (dark == _dark) return;
    _dark = dark;
    notifyListeners();
    await _prefs?.setBool(_key, dark);
  }
}
