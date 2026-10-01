import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app_theme.dart';

/// A member's picture: the house character they picked, on the colour they
/// picked, or their initial on the default colour until they pick one.
class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    required this.name,
    this.avatar,
    this.color,
    this.radius = 20,
    super.key,
  });

  final String name;

  /// A key of [avatars], as the server keeps it in `GroupMember.avatarEmoji`.
  /// A member who picked before the characters existed has an emoji there,
  /// which is still shown as it is.
  final String? avatar;

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

  /// The house characters, drawn for the app in `assets/avatars/`.
  static const avatars = [
    'taza', 'planta', 'calcetin', 'esponja', //
    'tetera', 'tostada', 'cubo', 'bombilla',
  ];

  static String assetOf(String avatar) => 'assets/avatars/$avatar.svg';

  @override
  Widget build(BuildContext context) {
    final key = colors.containsKey(color) ? color! : defaultColor;
    final background = colors[key]!;
    final picked = avatar;
    final initial = name.trim().isEmpty
        ? '?'
        : name.trim().characters.first.toUpperCase();
    final Widget child;
    if (picked != null && avatars.contains(picked)) {
      child = SvgPicture.asset(
        assetOf(picked),
        width: radius * 2,
        height: radius * 2,
        excludeFromSemantics: true,
      );
    } else if (picked != null && picked.isNotEmpty) {
      child = Text(picked, style: TextStyle(fontSize: radius));
    } else {
      child = Text(
        initial,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: radius * .8,
          color: key == 'violet' || key == 'coral'
              ? Colors.white
              : AppColors.ink,
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      child: ClipOval(child: child),
    );
  }
}
