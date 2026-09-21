import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Grupo'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            children: [
              const InfoRow(
                icon: Icons.construction_rounded,
                text:
                    'Datos de ejemplo: falta un endpoint para pedir tu grupo '
                    'y sus miembros al servidor.',
              ),
              const SizedBox(height: 14),
              SoftCard(
                color: AppColors.lime,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🏠', style: TextStyle(fontSize: 48)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Casa de Mayte y Juan',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const StatusPill(label: 'Pareja', color: Colors.white),
                      ],
                    ),
                    const Divider(height: 28),
                    const Text(
                      'Código del grupo',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'NIDO-482',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: () => showSnack(context, 'Código copiado'),
                          icon: const Icon(Icons.copy_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Text('Miembros', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              const _MemberRow(emoji: '👩🏽', name: 'Mayte', badge: 'Admin'),
              const _MemberRow(emoji: '👨🏽', name: 'Juan'),
              const SizedBox(height: 16),
              const SoftCard(
                child: Row(
                  children: [
                    Icon(Icons.settings_rounded),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Configuración del grupo',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.emoji, required this.name, this.badge});

  final String emoji;
  final String name;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        child: Row(
          children: [
            CircleAvatar(backgroundColor: AppColors.sky, child: Text(emoji)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            if (badge != null)
              StatusPill(label: badge!, color: const Color(0xFFE2DCFF)),
          ],
        ),
      ),
    );
  }
}
