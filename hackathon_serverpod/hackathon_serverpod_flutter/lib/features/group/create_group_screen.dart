import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'group_success_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String _type = 'Pareja';

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
                  selected: _type == 'Piso compartido',
                  onTap: () => setState(() => _type = 'Piso compartido'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProfileCard(
                  emoji: '💜',
                  label: 'Pareja',
                  selected: _type == 'Pareja',
                  onTap: () => setState(() => _type = 'Pareja'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const FieldLabel('Nombre del grupo'),
          const TextField(
            decoration: InputDecoration(hintText: 'Casa de Mayte y Juan'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => pushPage(context, const GroupSuccessScreen()),
            child: const Text('Crear grupo'),
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
