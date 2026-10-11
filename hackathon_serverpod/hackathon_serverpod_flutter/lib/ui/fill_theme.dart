import 'package:flutter/material.dart';

import '../app_theme.dart';

/// Whatever is drawn on [color] — a lime card, a sky pill — in the theme
/// that reads on it.
///
/// The pastel fills stay pastel in dark mode, but the text and icons under
/// them would follow dark mode and turn near-white, light on light. On a
/// fill where dark ink reads better than the dark palette's light ink, this
/// puts its [child] back in the light theme. In light mode, and on a dark
/// fill, it changes nothing.
class FillTheme extends StatelessWidget {
  const FillTheme({required this.color, required this.child, super.key});

  final Color color;
  final Widget child;

  /// Whether dark ink reads better than light ink on [color], once a
  /// translucent fill is laid over the card it usually sits on.
  static bool wantsDarkInk(BuildContext context, Color color) {
    final fill = Color.alphaBlend(
      color,
      context.palette.card,
    ).computeLuminance();
    double contrast(double a, double b) =>
        (a > b ? a + .05 : b + .05) / (a > b ? b + .05 : a + .05);
    return contrast(fill, AppColors.ink.computeLuminance()) >
        contrast(fill, AppPalette.dark.ink.computeLuminance());
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light ||
        !wantsDarkInk(context, color)) {
      return child;
    }
    return Theme(
      data: AppTheme.light,
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: AppColors.ink),
        child: IconTheme.merge(
          data: const IconThemeData(color: AppColors.ink),
          child: child,
        ),
      ),
    );
  }
}
