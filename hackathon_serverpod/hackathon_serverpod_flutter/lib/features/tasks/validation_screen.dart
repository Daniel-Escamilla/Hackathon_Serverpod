import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';

class ValidationScreen extends StatelessWidget {
  const ValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(label: 'Validación', color: AppColors.lime),
      title: '¿Está bien hecha?',
      content: [
        Text(
          'Limpiar el baño',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const PersonRow(name: 'Juan dice que la ha terminado', emoji: '👨🏽'),
        const SizedBox(height: 20),
        const Center(child: Text('🛁✨', style: TextStyle(fontSize: 90))),
        const SizedBox(height: 12),
        const InfoRow(
          icon: Icons.paid_rounded,
          text: 'Tu voto confirma el pago de 20 monedas',
        ),
      ],
      actions: [
        FilledButton.icon(
          onPressed: () => pushPage(
            context,
            const ResultScreen(
              emoji: '🪙✨',
              title: '¡Buen trabajo!',
              message: 'El grupo ha validado “Limpiar el baño”.',
              value: '+20 monedas',
              button: 'Ver mi cartera',
              homeIndex: 2,
            ),
          ),
          icon: const Icon(Icons.check_rounded),
          label: const Text('Sí, está hecha'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => pushPage(
            context,
            const ResultScreen(
              emoji: '↩️',
              title: 'Vuelve a estar disponible',
              message: 'El grupo indicó que todavía falta algo.',
              value: 'Multa · −4 monedas',
              button: 'Entendido',
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.coral,
            side: const BorderSide(color: AppColors.coral),
          ),
          icon: const Icon(Icons.close_rounded),
          label: const Text('No, falta algo'),
        ),
      ],
    );
  }
}
