import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'task_review_screen.dart';

class ProposeTaskScreen extends StatefulWidget {
  const ProposeTaskScreen({super.key});

  @override
  State<ProposeTaskScreen> createState() => _ProposeTaskScreenState();
}

class _ProposeTaskScreenState extends State<ProposeTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _reward = 10;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showSnack(context, 'Ponle un título a la tarea.');
      return;
    }
    pushPage(
      context,
      TaskReviewScreen(
        title: title,
        description: _descriptionController.text.trim(),
        reward: _reward,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'Nueva tarea',
      fields: [
        const FieldLabel('Título'),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(hintText: 'Limpiar el baño'),
        ),
        const SizedBox(height: 18),
        const FieldLabel('Descripción'),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Ducha, lavabo, espejo y suelo',
          ),
        ),
        const SizedBox(height: 18),
        const FieldLabel('Recompensa'),
        StepperValue(
          value: _reward,
          onChanged: (v) => setState(() => _reward = v),
        ),
        const SizedBox(height: 8),
        const Text(
          'Una tarea normal suele valer 10',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
      ],
      button: 'Revisar propuesta',
      onSubmit: _submit,
    );
  }
}
