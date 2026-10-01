import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../data/password_reset_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/feedback.dart';
import '../../ui/member_avatar.dart';
import '../../ui/pressable.dart';
import '../../ui/sounds.dart';
import '../auth/reset_password_email_screen.dart';
import '../group/group_controller.dart';
import 'locale_controller.dart';
import 'theme_controller.dart';
import 'sound_preference.dart';

/// The member's own settings: how the group sees them, their password, the
/// sounds and the app's language. Opened from the group tab.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    this.passwordReset = const PasswordResetRepository(),
    super.key,
  });

  /// Handed down the password steps, so a test can swap in a fake.
  final PasswordResetRepository passwordReset;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final GroupController _group = context.read<GroupController>();
  late final _nameController = TextEditingController(
    text: _group.myMember?.displayName ?? '',
  );
  late String? _emoji = _group.myMember?.avatarEmoji;
  late String _color =
      _group.myMember?.avatarColor ?? MemberAvatar.defaultColor;
  bool _saving = false;
  bool _soundsOn = !uiSounds.muted;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _setSounds(bool on) {
    setState(() => _soundsOn = on);
    uiSounds.muted = !on;
    unawaited(SoundPreference.saveMuted(!on));
  }

  Future<void> _save() async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showMessage(context, l10n.displayNameEmptyError, isError: true);
      return;
    }
    setState(() => _saving = true);
    try {
      await _group.updateMyProfile(
        displayName: name,
        avatarEmoji: _emoji,
        avatarColor: _color,
      );
      if (mounted) {
        showMessage(context, l10n.profileSaved, sound: AppSound.success);
      }
    } catch (e) {
      if (mounted) {
        showMessage(
          context,
          failureMessage(e, l10n, fallback: l10n.profileSaveError),
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = context.watch<LocaleController>();
    final colorNames = {
      'sky': l10n.avatarColorSky,
      'lime': l10n.avatarColorLime,
      'coral': l10n.avatarColorCoral,
      'violet': l10n.avatarColorViolet,
      'cream': l10n.avatarColorCream,
    };

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        children: [
          Text(
            l10n.mySettings,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 22),
          _SectionTitle(l10n.profileSection),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ValueListenableBuilder(
                    valueListenable: _nameController,
                    builder: (context, name, _) => MemberAvatar(
                      name: name.text,
                      emoji: _emoji,
                      color: _color,
                      radius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                FieldLabel(l10n.avatarEmojiLabel),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final emoji in MemberAvatar.emojis)
                      _Choice(
                        selected: _emoji == emoji,
                        onTap: () => setState(() => _emoji = emoji),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                FieldLabel(l10n.avatarColorLabel),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final entry in MemberAvatar.colors.entries)
                      Semantics(
                        label: colorNames[entry.key],
                        selected: _color == entry.key,
                        button: true,
                        child: _Choice(
                          selected: _color == entry.key,
                          color: entry.value,
                          onTap: () => setState(() => _color = entry.key),
                          child: _color == entry.key
                              ? Icon(
                                  Icons.check_rounded,
                                  color:
                                      entry.key == 'violet' ||
                                          entry.key == 'coral'
                                      ? Colors.white
                                      : AppColors.ink,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                FieldLabel(l10n.displayNameLabel),
                TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: l10n.displayNameHint),
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: l10n.saveProfile,
                  loading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          _SectionTitle(l10n.accountSection),
          AppButton(
            label: l10n.changePassword,
            kind: AppButtonKind.secondary,
            onPressed: () => pushPage(
              context,
              ResetPasswordEmailScreen(
                repository: widget.passwordReset,
                signedIn: true,
                auth: _group.auth,
              ),
            ),
          ),
          const SizedBox(height: 26),
          _SectionTitle(l10n.soundSection),
          _SoundRow(on: _soundsOn, onChanged: _setSounds),
          // Null only in tests that build this screen without the app root.
          if (context.watch<ThemeController?>() case final theme?) ...[
            const SizedBox(height: 12),
            _SoundRow(
              title: l10n.darkModeToggle,
              hint: l10n.darkModeToggleHint,
              on: theme.dark,
              onChanged: theme.setDark,
            ),
          ],
          const SizedBox(height: 26),
          _SectionTitle(l10n.languageSection),
          for (final (option, label) in [
            (null, l10n.languageSystem),
            (const Locale('es'), l10n.languageSpanish),
            (const Locale('en'), l10n.languageEnglish),
          ])
            _LanguageRow(
              label: label,
              selected: locale.locale?.languageCode == option?.languageCode,
              onTap: () => locale.setLocale(option),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

/// One square of the emoji grid or one dot of the colour row: a ring shows
/// the one picked.
class _Choice extends StatelessWidget {
  const _Choice({
    required this.selected,
    required this.onTap,
    required this.child,
    this.color,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      sound: null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? context.palette.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.violet
                : AppColors.muted.withValues(alpha: .25),
            width: selected ? 3 : 1.5,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// The switch for every UI sound at once. The whole card toggles it, not only
/// the switch itself.
class _SoundRow extends StatelessWidget {
  const _SoundRow({
    required this.on,
    required this.onChanged,
    this.title,
    this.hint,
  });

  final bool on;

  /// Defaults to the sound switch's own wording; the dark mode switch
  /// reuses this row with its own.
  final String? title;
  final String? hint;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MergeSemantics(
      child: Pressable(
        onTap: () => onChanged(!on),
        sound: null,
        borderRadius: BorderRadius.circular(20),
        child: SoftCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? l10n.soundsToggle,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hint ?? l10n.soundsToggleHint,
                      style: TextStyle(color: context.palette.muted),
                    ),
                  ],
                ),
              ),
              Switch(value: on, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Semantics(
        selected: selected,
        button: true,
        child: Pressable(
          onTap: onTap,
          sound: null,
          borderRadius: BorderRadius.circular(20),
          child: SoftCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected ? AppColors.violet : context.palette.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
