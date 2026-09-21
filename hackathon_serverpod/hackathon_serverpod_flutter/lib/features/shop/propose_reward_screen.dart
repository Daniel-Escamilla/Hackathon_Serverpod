import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'shop_controller.dart';

class ProposeRewardScreen extends StatefulWidget {
  const ProposeRewardScreen({super.key});

  @override
  State<ProposeRewardScreen> createState() => _ProposeRewardScreenState();
}

class _ProposeRewardScreenState extends State<ProposeRewardScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _price = 40;
  bool _loading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showSnack(context, 'Ponle un título a la recompensa.');
      return;
    }
    setState(() => _loading = true);
    final controller = context.read<ShopController>();
    try {
      await controller.proposeReward(
        title,
        _descriptionController.text.trim(),
        _price,
      );
      if (mounted) {
        showSnack(context, 'Recompensa enviada a votación');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) showSnack(context, 'No se pudo enviar la recompensa');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'Nueva recompensa',
      fields: [
        const FieldLabel('Título'),
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(hintText: 'Desayuno en la cama'),
        ),
        const SizedBox(height: 18),
        const FieldLabel('Descripción'),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Café, tostadas y fruta'),
        ),
        const SizedBox(height: 18),
        const FieldLabel('Precio'),
        StepperValue(
          value: _price,
          onChanged: (v) => setState(() => _price = v),
        ),
        const SizedBox(height: 18),
        const InfoRow(
          icon: Icons.how_to_vote_rounded,
          text: 'El grupo votará antes de publicarla',
        ),
      ],
      button: _loading ? 'Enviando…' : 'Enviar a votación',
      onSubmit: _submit,
    );
  }
}
