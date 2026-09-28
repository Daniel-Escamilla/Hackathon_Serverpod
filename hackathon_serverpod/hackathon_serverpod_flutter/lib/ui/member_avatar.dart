import 'package:flutter/material.dart';

import '../app_theme.dart';

/// A member's picture: the emoji they picked, on the colour they picked, or
/// their initial on the default colour until they pick one.
class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    required this.name,
    this.emoji,
    this.color,
    this.radius = 20,
    super.key,
  });

  final String name;
  final String? emoji;

  /// A key of [colors]. Anything else — including null — is [defaultColor].
  final String? color;
  final double radius;

  /// What the server stores in `GroupMember.avatarColor`, and what it looks
  /// like. The server only keeps the name, so the palette can change here.
  static const colors = <String, Color>{
    'sky': AppColors.sky,
    'lime': AppColors.lime,
    'coral': AppColors.coral,
    'violet': AppColors.violet,
    'cream': AppColors.cream,
  };
  static const defaultColor = 'sky';

  static const emojis = [
    '🦊', '🐼', '🐸', '🐙', '🦄', '🐝', '🐱', '🐶', //
    '🌵', '🌻', '🍕', '🍩', '🎸', '🚀', '⚽', '🎨',
  ];

  @override
  Widget build(BuildContext context) {
    final key = colors.containsKey(color) ? color! : defaultColor;
    final background = colors[key]!;
    final picked = emoji;
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().characters.first.toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      child: picked != null && picked.isNotEmpty
          ? Text(picked, style: TextStyle(fontSize: radius))
          : Text(
              initial,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: radius * .8,
                color: key == 'violet' || key == 'coral'
                    ? Colors.white
                    : AppColors.ink,
              ),
            ),
    );
  }
}
