import 'package:flutter/material.dart';

import '../client.dart';
import '../features/group/group_choice_screen.dart';
import '../home_shell.dart';

/// There is no endpoint yet to ask "does the signed-in user have a group" —
/// GroupEndpoint only has createGroup/joinGroup. Every member-scoped
/// endpoint throws a "No active group membership" StateError when there
/// isn't one, so this probes with the cheapest of those (getBalance) and
/// reads that error. Replace with a dedicated membership check once one
/// exists server-side.
class GroupGate extends StatefulWidget {
  const GroupGate({super.key});

  @override
  State<GroupGate> createState() => _GroupGateState();
}

class _GroupGateState extends State<GroupGate> {
  late Future<bool> _hasGroup = _checkMembership();

  Future<bool> _checkMembership() async {
    try {
      await client.wallet.getBalance();
      return true;
    } catch (e) {
      if (e.toString().contains('No active group membership')) return false;
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
                    const Text('No se pudo comprobar tu grupo.'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () =>
                          setState(() => _hasGroup = _checkMembership()),
                      child: const Text('Reintentar'),
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
