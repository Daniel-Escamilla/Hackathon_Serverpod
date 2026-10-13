import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'pressable.dart';

/// The round bin on a card whose proposal can be withdrawn. Sits inside the
/// card's own tap area and takes the tap for itself.
class TrashButton extends StatelessWidget {
  const TrashButton({super.key, required this.tooltip, required this.onTap});

  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Pressable(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.delete_outline_rounded,
              color: context.palette.danger,
            ),
          ),
        ),
      ),
    );
  }
}
