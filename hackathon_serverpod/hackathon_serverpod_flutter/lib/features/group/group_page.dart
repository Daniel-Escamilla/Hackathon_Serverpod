import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        PageHeader(title: l10n.navGroup),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            children: [
              InfoRow(
                icon: Icons.construction_rounded,
                text: l10n.groupPendingNotice,
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
                        StatusPill(
                          label: l10n.profileCouple,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    Text(
                      l10n.groupCodeLabel,
                      style: const TextStyle(color: AppColors.muted),
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
                          onPressed: () => showSnack(context, l10n.codeCopied),
                          icon: const Icon(Icons.copy_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Text(
                l10n.membersTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              const _MemberRow(emoji: '👩🏽', name: 'Mayte', badge: 'Admin'),
              const _MemberRow(emoji: '👨🏽', name: 'Juan'),
              const SizedBox(height: 16),
              SoftCard(
                child: Row(
                  children: [
                    const Icon(Icons.settings_rounded),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.groupSettings,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
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
