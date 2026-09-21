import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme.dart';
import 'pressable.dart';
import 'sounds.dart';

/// What a button is for, which decides how loud it is.
enum AppButtonKind {
  /// The one thing this screen is for. Filled violet. At most one per screen.
  primary,

  /// A real alternative to the primary. Outlined.
  secondary,

  /// Low-stakes: "Cancelar", "Volver a intentarlo", "Copiar". Text only, and
  /// silent — a sound on every small tap stops being fun fast.
  quiet,

  /// Destroys something: expelling a member. Coral text. It always sits
  /// behind a confirmation, so it does not make a sound of its own; the
  /// outcome does.
  danger,
}

/// Every button in the app. It carries the Playful UI press — sink and bounce —
/// a light haptic, and a sound, so no screen has to remember any of them.
/// Never build a `FilledButton`, `OutlinedButton` or `TextButton` in a screen;
/// use this.
///
/// The look still comes from the theme (`lib/theme.dart`), so changing a
/// button's shape or colour there changes it everywhere.
class AppButton extends ConsumerWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
    this.loading = false,
    this.sound,
    this.silent = false,
    this.onBrand = false,
    this.compact = false,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;

  final AppButtonKind kind;

  /// Swaps the label for a spinner and ignores presses, for the time a request
  /// is in flight.
  final bool loading;

  /// Overrides the kind's usual sound.
  final AppSound? sound;

  /// No sound at all, whatever the kind.
  final bool silent;

  /// The button sits on a violet surface — a card in the brand colour — so it
  /// turns white instead of violet to stay visible.
  final bool onBrand;

  /// Sized to its label instead of the theme's full width, for a button that
  /// sits in a row with others.
  final bool compact;

  AppSound? get _sound {
    if (silent) return null;
    return sound ??
        switch (kind) {
          AppButtonKind.primary || AppButtonKind.secondary => AppSound.tap,
          AppButtonKind.quiet || AppButtonKind.danger => null,
        };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = onPressed;
    final enabled = action != null && !loading;

    void press() {
      kind == AppButtonKind.primary
          ? HapticFeedback.lightImpact()
          : HapticFeedback.selectionClick();
      if (_sound case final s?) ref.read(uiSoundsProvider).play(s);
      action!();
    }

    final onTap = enabled ? press : null;
    final minimumSize = compact ? const Size(0, 44) : null;
    final child = loading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: kind == AppButtonKind.primary && !onBrand
                  ? Colors.white
                  : appViolet,
            ),
          )
        : Text(label);

    return PressScale(
      enabled: enabled,
      child: switch (kind) {
        AppButtonKind.primary => FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            minimumSize: minimumSize,
            backgroundColor: onBrand ? Colors.white : null,
            foregroundColor: onBrand ? appViolet : null,
          ),
          child: child,
        ),
        AppButtonKind.secondary => OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            minimumSize: minimumSize,
            foregroundColor: onBrand ? Colors.white : null,
            side: onBrand
                ? const BorderSide(color: Colors.white, width: 1.5)
                : null,
          ),
          child: child,
        ),
        AppButtonKind.quiet => TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            minimumSize: minimumSize,
            foregroundColor: onBrand ? Colors.white : null,
          ),
          child: child,
        ),
        AppButtonKind.danger => TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            minimumSize: minimumSize,
            foregroundColor: appCoral,
          ),
          child: child,
        ),
      },
    );
  }
}
