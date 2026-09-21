import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../data/group_repository.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../ui/failure_messages.dart';
import '../ui/feedback.dart';

/// Creates a group against `GroupEndpoint.createGroup` and shows the invite
/// code it comes back with.
///
/// Only the shared-flat and couple profiles are offered: family is out of the
/// MVP (PLAN.md §1), and the enum keeps `family` for when it returns.
class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  GroupType _type = GroupType.sharedFlat;
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);

    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);

    try {
      final group = await ref
          .read(groupRepositoryProvider)
          .create(name: _name.text.trim(), type: _type);
      if (!mounted) return;
      await navigator.push<void>(
        MaterialPageRoute(builder: (_) => _InviteCodeScreen(group: group)),
      );
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
      appBar: AppBar(title: Text(l10n.createGroupTitle)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              Text(l10n.createGroupNameLabel, style: text.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: l10n.createGroupNameHint),
                validator: (value) => (value ?? '').trim().isEmpty
                    ? l10n.createGroupNameEmpty
                    : null,
              ),
              const SizedBox(height: 28),
              Text(l10n.createGroupTypeLabel, style: text.titleMedium),
              const SizedBox(height: 8),
              _TypeChoice(
                selected: _type,
                onChanged: (type) => setState(() => _type = type),
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
                    : Text(l10n.createGroupSubmit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeChoice extends StatelessWidget {
  const _TypeChoice({required this.selected, required this.onChanged});

  final GroupType selected;
  final ValueChanged<GroupType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SegmentedButton<GroupType>(
      segments: [
        ButtonSegment(
          value: GroupType.sharedFlat,
          label: Text(l10n.groupTypeSharedFlat),
        ),
        ButtonSegment(
          value: GroupType.couple,
          label: Text(l10n.groupTypeCouple),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

/// The code the others need to get in, shown once right after creating the
/// group. Anyone in the group can read it again later through
/// `GroupRepository.myGroup`.
class _InviteCodeScreen extends StatelessWidget {
  const _InviteCodeScreen({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.groupReadyTitle, style: text.headlineMedium),
              const SizedBox(height: 12),
              Text(
                l10n.groupReadyBody,
                style: text.bodyLarge?.copyWith(color: appMuted),
              ),
              const SizedBox(height: 28),
              SelectableText(
                group.inviteCode,
                textAlign: TextAlign.center,
                style: text.displaySmall?.copyWith(letterSpacing: 8),
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.groupReadyDone),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
