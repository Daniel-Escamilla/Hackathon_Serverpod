import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/feedback.dart';
import '../../ui/sounds.dart';
import 'group_controller.dart';

/// The admin's settings for [group]: its name and fine percentage
/// (PRODUCT.md §7, §4.4). The profile is not here because it never changes.
///
/// Takes [controller] directly: a pushed route sits beside `HomeShell`, not
/// under it, so the shell's providers are out of reach from here.
class GroupSettingsScreen extends StatefulWidget {
  const GroupSettingsScreen({
    super.key,
    required this.group,
    required this.controller,
  });

  final Group group;
  final GroupController controller;

  @override
  State<GroupSettingsScreen> createState() => _GroupSettingsScreenState();
}

class _GroupSettingsScreenState extends State<GroupSettingsScreen> {
  late final _nameController = TextEditingController(text: widget.group.name);
  late int _finePercent = widget.group.finePercent;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.createGroupErrorEmpty);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.controller.updateSettings(
        name: name,
        finePercent: _finePercent,
      );
      if (!mounted) return;
      showMessage(context, l10n.groupSettingsSaved, sound: AppSound.success);
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = failureMessage(e, l10n));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 30),
        children: [
          Text(
            l10n.groupSettings,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 28),
          FieldLabel(l10n.groupNameLabel),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: l10n.groupNameHint),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(child: FieldLabel(l10n.groupSettingsFineLabel)),
              Text(
                l10n.groupSettingsFineValue(_finePercent),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Text(
            l10n.groupSettingsFineHint,
            style: const TextStyle(color: AppColors.muted),
          ),
          Slider(
            value: _finePercent.toDouble(),
            max: 100,
            divisions: 20,
            label: l10n.groupSettingsFineValue(_finePercent),
            onChanged: (value) => setState(() => _finePercent = value.round()),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.coral)),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: l10n.groupSettingsSave,
            loading: _saving,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
