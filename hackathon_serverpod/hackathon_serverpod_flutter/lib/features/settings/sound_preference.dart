import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Whether the UI sounds are switched off, kept on this device. `main` applies
/// it to `uiSounds` before the first frame; the settings screen changes it.
class SoundPreference {
  const SoundPreference._();

  static const _key = 'sounds_muted';

  /// Never throws: an unreadable preference just leaves the sounds on.
  static Future<bool> loadMuted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_key) ?? false;
    } catch (error) {
      debugPrint('Sound preference unavailable: $error');
      return false;
    }
  }

  /// Never throws: the switch still works for this run if it cannot be saved.
  static Future<void> saveMuted(bool muted) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, muted);
    } catch (error) {
      debugPrint('Sound preference not saved: $error');
    }
  }
}
