import 'package:flutter/material.dart';

/// Placeholder screen showing a single group and its members.
class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  static const _members = ['Daniel', 'Juan', 'Dani', 'Mayte'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: colors.primaryContainer,
              child: Icon(Icons.group, color: colors.onPrimaryContainer),
            ),
            title: const Text('Grupo de prueba'),
            subtitle: Text('${_members.length} miembros'),
          ),
        ),
        const SizedBox(height: 16),
        for (final member in _members)
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(member),
          ),
      ],
    );
  }
}
