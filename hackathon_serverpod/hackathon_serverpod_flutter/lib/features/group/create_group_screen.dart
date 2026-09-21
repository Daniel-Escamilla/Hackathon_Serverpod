import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'group_success_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  GroupType _type = GroupType.couple;
  final _nameController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Ponle un nombre al grupo.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final group = await client.group.createGroup(name, _type);
      if (mounted) {
        pushPage(
          context,
          GroupSuccessScreen(
            groupName: group.name,
            inviteCode: group.inviteCode,
          ),
        );
      }
    } catch (e) {
      setState(() => _error = 'No se pudo crear el grupo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 30),
        children: [
          Text(
            'Crea vuestro grupo',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Elige cómo compartís casa',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _ProfileCard(
                  emoji: '🏠',
                  label: 'Piso compartido',
                  selected: _type == GroupType.sharedFlat,
                  onTap: () => setState(() => _type = GroupType.sharedFlat),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProfileCard(
                  emoji: '💜',
                  label: 'Pareja',
                  selected: _type == GroupType.couple,
                  onTap: () => setState(() => _type = GroupType.couple),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const FieldLabel('Nombre del grupo'),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Casa de Mayte y Juan'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: AppColors.coral)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _loading ? null : _submit,
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Crear grupo'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        height: 178,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.violet : const Color(0xFFE1DEE8),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected ? AppColors.violet : AppColors.muted,
              ),
            ),
            Text(emoji, style: const TextStyle(fontSize: 52)),
            const Spacer(),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
