import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// A password field with an eye at the end that shows or hides what is
/// typed.
///
/// It starts hidden. The eye makes no sound: showing a password is a silent
/// action (docs/DESIGN.md).
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.hintText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextField(
      controller: widget.controller,
      obscureText: !_visible,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _visible = !_visible),
          tooltip: _visible ? l10n.hidePassword : l10n.showPassword,
          icon: Icon(
            _visible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          ),
        ),
      ),
    );
  }
}
