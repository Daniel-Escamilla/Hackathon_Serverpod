import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../data/group_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({this.repository = const GroupRepository(), super.key});

  final GroupRepository repository;

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _codeController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final l10n = AppLocalizations.of(context);
    final code = _codeController.text.trim();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.repository.joinGroup(code);
      if (mounted) enterHome(context);
    } catch (e) {
      setState(
        () => _error = failureMessage(e, l10n, fallback: l10n.joinGroupError),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleFormPage(
      title: l10n.joinGroupHeadline,
      subtitle: l10n.joinGroupSubtitle,
      art: const RoundIcon(icon: Icons.groups_rounded, color: AppColors.sky),
      children: [
        TextField(
          controller: _codeController,
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          onSubmitted: (_) => _submit(),
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
          decoration: InputDecoration(hintText: l10n.joinGroupCodeHint),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.joinGroupCaseNote,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.coral),
          ),
        ],
        const SizedBox(height: 20),
        AppButton(
          label: l10n.joinGroupSubmit,
          loading: _loading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
