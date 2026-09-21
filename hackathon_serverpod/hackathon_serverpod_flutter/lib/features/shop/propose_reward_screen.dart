import 'package:flutter/material.dart';

import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'reward_vote_screen.dart';

class ProposeRewardScreen extends StatelessWidget {
  const ProposeRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      title: 'Nueva recompensa',
      fields: const [
        FieldLabel('Título'),
        TextField(decoration: InputDecoration(hintText: 'Desayuno en la cama')),
        SizedBox(height: 18),
        FieldLabel('Descripción'),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(hintText: 'Café, tostadas y fruta'),
        ),
        SizedBox(height: 18),
        FieldLabel('Precio'),
        StepperValue(value: 40),
        SizedBox(height: 18),
        InfoRow(
          icon: Icons.how_to_vote_rounded,
          text: 'El grupo votará antes de publicarla',
        ),
      ],
      button: 'Enviar a votación',
      onSubmit: () => pushPage(context, const RewardVoteScreen()),
    );
  }
}
