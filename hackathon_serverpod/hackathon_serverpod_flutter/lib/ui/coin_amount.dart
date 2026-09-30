import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A number of coins with the coin mark beside it.
///
/// Every amount in the app goes through this so they all read the same: the
/// wallet, a task's reward, a reward's price and a line in the history.
class CoinAmount extends StatelessWidget {
  const CoinAmount({
    super.key,
    required this.coins,
    this.style,
    this.size = 24,
  });

  final int coins;

  /// Defaults to the theme's `headlineMedium`, the size used for a balance.
  final TextStyle? style;

  /// Width and height of the coin mark, in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    final resolved = style ?? Theme.of(context).textTheme.headlineMedium;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/icons/coin.svg', width: size, height: size),
        SizedBox(width: size * .3),
        Text(
          '$coins',
          style: resolved?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
