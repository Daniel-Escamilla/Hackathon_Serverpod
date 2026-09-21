import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';

class AvailableTaskScreen extends StatelessWidget {
  const AvailableTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(label: 'Disponible', color: AppColors.lime),
      title: 'Sacar la basura',
      content: const [
        Center(child: Text('🗑️', style: TextStyle(fontSize: 110))),
        BigValueCard(
          color: AppColors.lime,
          value: '5',
          label: 'monedas',
          icon: '🪙',
        ),
        SizedBox(height: 16),
        InfoRow(
          icon: Icons.description_rounded,
          text: 'Lleva la bolsa al contenedor de la calle',
        ),
        SizedBox(height: 12),
        InfoRow(
          icon: Icons.info_outline_rounded,
          text: 'No se reserva: reclama cuando esté hecha',
        ),
      ],
      actions: [
        FilledButton.icon(
          onPressed: () => pushPage(
            context,
            const ResultScreen(
              emoji: '✅',
              title: '¡Reclamada!',
              message: 'Ahora el grupo debe confirmar que está hecha.',
              value: 'En validación · 5 monedas',
              button: 'Volver a tareas',
            ),
          ),
          icon: const Icon(Icons.check_rounded),
          label: const Text('Ya está hecha'),
        ),
      ],
    );
  }
}
