import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'task_review_screen.dart';

class ProposeTaskScreen extends StatelessWidget {
  const ProposeTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'Nueva tarea',
      fields: const [
        FieldLabel('Título'),
        TextField(decoration: InputDecoration(hintText: 'Limpiar el baño')),
        SizedBox(height: 18),
        FieldLabel('Descripción'),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Ducha, lavabo, espejo y suelo',
          ),
        ),
        SizedBox(height: 18),
        FieldLabel('Recompensa'),
        StepperValue(value: 25),
        SizedBox(height: 8),
        Text(
          'Una tarea normal suele valer 10',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
      ],
      button: 'Revisar propuesta',
      onSubmit: () => pushPage(context, const TaskReviewScreen()),
    );
  }
}
