import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../client.dart';
import '../features/group/group_choice_screen.dart';
import '../home_shell.dart';
import '../l10n/generated/app_localizations.dart';
import '../ui/app_button.dart';

class GroupGate extends StatefulWidget {
  const GroupGate({super.key});

  @override
  State<GroupGate> createState() => _GroupGateState();
}

class _GroupGateState extends State<GroupGate> {
  late Future<bool> _hasGroup = _checkMembership();

  Future<bool> _checkMembership() async {
    try {
      await client.group.myGroup();
      return true;
    } on GroupException catch (e) {
      if (e.reason == GroupErrorReason.noMembership) return false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasGroup,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context).groupCheckError),
                    const SizedBox(height: 12),
                    AppButton(
                      label: AppLocalizations.of(context).retry,
                      kind: AppButtonKind.secondary,
                      onPressed: () =>
                          setState(() => _hasGroup = _checkMembership()),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return snapshot.data! ? const HomeShell() : const GroupChoiceScreen();
      },
    );
  }
}
