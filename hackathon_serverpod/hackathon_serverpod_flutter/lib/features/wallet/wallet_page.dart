import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Cartera', showBalance: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.violet,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '120',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              fontFeatures: AppFonts.tabularFigures,
                            ),
                          ),
                          const Text(
                            'monedas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lime,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '+20 esta semana',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('🪙', style: TextStyle(fontSize: 88)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Últimos movimientos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const _MovementRow(
                emoji: '🧼',
                title: 'Limpiar el baño',
                date: '12 mar, 18:20',
                amount: '+20',
                positive: true,
              ),
              const _MovementRow(
                emoji: '📺',
                title: 'Serie esta noche',
                date: '12 mar, 18:35',
                amount: '−20',
                positive: false,
              ),
              const _MovementRow(
                emoji: '⚠️',
                title: 'Multa por validación',
                date: '11 mar, 16:10',
                amount: '−4',
                positive: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({
    required this.emoji,
    required this.title,
    required this.date,
    required this.amount,
    required this.positive,
  });

  final String emoji;
  final String title;
  final String date;
  final String amount;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 34)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: positive ? const Color(0xFF16853C) : AppColors.coral,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFeatures: AppFonts.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
