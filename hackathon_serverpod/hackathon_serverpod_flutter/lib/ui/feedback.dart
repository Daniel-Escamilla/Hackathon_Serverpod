import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'app_button.dart';
import 'sounds.dart';

/// A short message at the bottom of the screen. Every screen uses this one, so
/// a confirmation and an error look — and sound — the same wherever they
/// appear. An error plays the "bonk" on its own; pass [sound] for anything
/// else worth hearing.
void showMessage(
  BuildContext context,
  String message, {
  bool isError = false,
  AppSound? sound,
}) {
  final play = sound ?? (isError ? AppSound.error : null);
  if (play != null) {
    ProviderScope.containerOf(
      context,
      listen: false,
    ).read(uiSoundsProvider).play(play);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: isError ? appCoral : appInk,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
    ),
  );
}

/// Asks before doing something that cannot be undone, and resolves to whether
/// the person went ahead. [action] names what happens — "Expulsar", not "Sí" —
/// so the button says what pressing it does.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String body,
  required String action,
  bool destructive = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        AppButton(
          label: l10n.cancel,
          kind: AppButtonKind.quiet,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: action,
          kind: destructive ? AppButtonKind.danger : AppButtonKind.quiet,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
