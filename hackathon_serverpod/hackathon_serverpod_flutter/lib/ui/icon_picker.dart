import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'pressable.dart';

/// A grid of emoji, eight to a row and as wide as the form, to pick the icon
/// of a task or a reward from. The picked one sits on a violet tile.
class IconPicker extends StatelessWidget {
  const IconPicker({
    super.key,
    required this.icons,
    required this.selected,
    required this.onPicked,
  });

  final List<String> icons;
  final String? selected;
  final ValueChanged<String> onPicked;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return GridView.count(
      crossAxisCount: 8,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        for (final icon in icons)
          Pressable(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onPicked(icon),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: icon == selected ? AppColors.violet : palette.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: icon == selected ? AppColors.violet : palette.border,
                  width: 1.5,
                ),
              ),
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
      ],
    );
  }
}
