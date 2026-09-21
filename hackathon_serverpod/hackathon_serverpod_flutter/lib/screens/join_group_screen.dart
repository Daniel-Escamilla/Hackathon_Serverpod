import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/group_repository.dart';
import '../l10n/app_localizations.dart';
import '../ui/failure_messages.dart';
import '../ui/feedback.dart';

/// Joins a group with its invite code, against `GroupEndpoint.joinGroup`.
/// Entry is direct, with no approval to wait for (PRODUCT.md §7).
class JoinGroupScreen extends ConsumerStatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  ConsumerState<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends ConsumerState<JoinGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);

    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);

    try {
      await ref.read(groupRepositoryProvider).joinWithCode(_code.text.trim());
      if (!mounted) return;
      navigator.pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      showMessage(context, failureMessage(error, l10n), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.joinGroupTitle)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              Text(l10n.joinGroupCodeLabel, style: text.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _code,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.done,
                // The server generates codes from an alphabet with no 0/O or
                // 1/I/L, upper case, six characters long.
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                  TextInputFormatter.withFunction(
                    (_, next) => next.copyWith(text: next.text.toUpperCase()),
                  ),
                ],
                style: text.headlineMedium?.copyWith(letterSpacing: 8),
                validator: (value) => (value ?? '').trim().isEmpty
                    ? l10n.joinGroupCodeEmpty
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.joinGroupSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
