import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The language the app is shown in, kept on this device only. Null follows
/// the phone's own language.
class LocaleController extends ChangeNotifier {
  LocaleController._(this._prefs, this._locale);

  static const _key = 'app_locale';

  /// Never throws: if the preference cannot be read, the app starts in the
  /// phone's language and simply does not remember a change.
  static Future<LocaleController> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_key);
      return LocaleController._(prefs, code == null ? null : Locale(code));
    } catch (error) {
      debugPrint('Language preference unavailable: $error');
      return LocaleController._(null, null);
    }
  }

  final SharedPreferences? _prefs;
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> setLocale(Locale? locale) async {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = _prefs;
    if (prefs == null) return;
    if (locale == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, locale.languageCode);
    }
  }
}
