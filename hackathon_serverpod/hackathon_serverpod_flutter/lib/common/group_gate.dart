import 'package:flutter/material.dart';

import '../data/membership_repository.dart';
import '../features/group/group_choice_screen.dart';
import '../home_shell.dart';
import '../l10n/generated/app_localizations.dart';
import '../ui/app_button.dart';

/// Sends a signed-in user to their group, or to the screen that creates or
/// joins one when they have none yet.
class GroupGate extends StatefulWidget {
  const GroupGate({
    this.membership = const MembershipRepository(),
    this.home = const HomeShell(),
    super.key,
  });

  final MembershipRepository membership;

  /// Where a member of a group lands. A test swaps it for something that
  /// needs no server.
  final Widget home;

  @override
  State<GroupGate> createState() => _GroupGateState();
}

class _GroupGateState extends State<GroupGate> {
  late Future<bool> _hasGroup = widget.membership.hasGroup();

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
                      // A block body: an arrow would hand the Future back
                      // to setState, which asserts.
                      onPressed: () => setState(() {
                        _hasGroup = widget.membership.hasGroup();
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return snapshot.data! ? widget.home : const GroupChoiceScreen();
      },
    );
  }
}
