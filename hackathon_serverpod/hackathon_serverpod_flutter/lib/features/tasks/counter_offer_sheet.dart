import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';

class CounterOfferSheet extends StatefulWidget {
  const CounterOfferSheet({required this.initialValue, super.key});

  final int initialValue;

  @override
  State<CounterOfferSheet> createState() => _CounterOfferSheetState();
}

class _CounterOfferSheetState extends State<CounterOfferSheet> {
  late int _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFD3CFD8),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Haz una contraoferta',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            '¿Cuántas monedas te parecerían justas?',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: _value > 1 ? () => setState(() => _value--) : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '$_value',
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                    fontFeatures: AppFonts.tabularFigures,
                  ),
                ),
              ),
              IconButton.filled(
                onPressed: () => setState(() => _value++),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const InfoRow(
            icon: Icons.pause_circle_rounded,
            text: 'La votación se pausará hasta que el autor responda',
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.pop(context, _value),
            child: const Text('Enviar contraoferta'),
          ),
        ],
      ),
    );
  }
}
