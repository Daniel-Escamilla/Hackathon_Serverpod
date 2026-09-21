import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';

class BuyRewardScreen extends StatefulWidget {
  const BuyRewardScreen({super.key});

  @override
  State<BuyRewardScreen> createState() => _BuyRewardScreenState();
}

class _BuyRewardScreenState extends State<BuyRewardScreen> {
  String _selected = 'Mayte';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        children: [
          Text(
            '¿Quién la cumplirá?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 22),
          SoftCard(
            color: const Color(0xFFE9E3FF),
            child: Row(
              children: [
                const Text('🍿', style: TextStyle(fontSize: 54)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Elijo yo la serie esta noche',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Text(
                  '🪙 20',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const FieldLabel('Selecciona a una persona'),
          Row(
            children: [
              Expanded(
                child: _PersonChoice(
                  name: 'Mayte',
                  emoji: '👩🏽',
                  selected: _selected == 'Mayte',
                  onTap: () => setState(() => _selected = 'Mayte'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PersonChoice(
                  name: 'Daniel',
                  emoji: '👨🏻',
                  selected: _selected == 'Daniel',
                  onTap: () => setState(() => _selected = 'Daniel'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const SoftCard(
            child: Column(
              children: [
                _BalanceRow(label: 'Tu saldo', value: '120'),
                Divider(),
                _BalanceRow(label: 'Después', value: '100'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () => pushPage(
              context,
              const ResultScreen(
                emoji: '🎁',
                title: 'Compra enviada',
                message: 'Mayte debe aceptar antes de cumplirla.',
                value: '−20 monedas',
                button: 'Volver a la tienda',
                homeIndex: 1,
              ),
            ),
            child: const Text('Comprar por 20'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mayte tendrá que aceptar',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _PersonChoice extends StatelessWidget {
  const _PersonChoice({
    required this.name,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.violet : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? AppColors.violet : AppColors.muted,
              ),
            ),
            Text(emoji, style: const TextStyle(fontSize: 54)),
            Text(name, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            '🪙 $value',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontFeatures: AppFonts.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
