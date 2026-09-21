import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'accepted_purchase_screen.dart';

class PendingPurchaseScreen extends StatelessWidget {
  const PendingPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(
        label: 'Necesita tu respuesta',
        color: AppColors.coral,
      ),
      title: 'Mayte te ha elegido',
      content: [
        const Center(child: Text('📺🍿', style: TextStyle(fontSize: 90))),
        Text(
          'Elijo yo la serie esta noche',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Center(child: CoinPill(value: 20)),
        const SizedBox(height: 18),
        const InfoRow(
          icon: Icons.info_outline_rounded,
          text: 'Si aceptas, queda pendiente hasta que la entregues',
        ),
        const SizedBox(height: 10),
        const InfoRow(
          icon: Icons.warning_amber_rounded,
          text: 'Si te niegas, pagarás una multa de 4 monedas',
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => pushPage(context, const AcceptedPurchaseScreen()),
          child: const Text('Aceptar'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () =>
              showSnack(context, 'Compra rechazada y monedas devueltas'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.coral,
            side: const BorderSide(color: AppColors.coral),
          ),
          child: const Text('No puedo cumplirla'),
        ),
      ],
    );
  }
}
