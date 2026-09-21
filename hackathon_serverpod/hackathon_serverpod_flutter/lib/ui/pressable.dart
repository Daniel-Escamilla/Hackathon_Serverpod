import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'sounds.dart';

/// The Playful UI press: the child sinks a little under the finger and springs
/// back with a small overshoot when released. It only handles the look — the
/// child keeps doing its own tapping — so it can wrap a Material button without
/// fighting it for the gesture.
///
/// People who asked their system for reduced motion get no bounce at all.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.enabled = true});

  final Widget child;

  /// A disabled control does not react to the finger.
  final bool enabled;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  static const _pressedScale = .94;
  bool _down = false;

  void _set(bool down) {
    if (_down != down) setState(() => _down = down);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? _pressedScale : 1,
        // Quick and flat going down, slower with an overshoot coming back up:
        // that difference is what reads as a bounce rather than a blink.
        duration: Duration(milliseconds: _down ? 80 : 280),
        curve: _down ? Curves.easeOut : Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}

/// Anything tappable that is not a button — a task card, a reward tile — with
/// the same press, haptic and sound a button has.
class Pressable extends StatelessWidget {
  const Pressable({
    super.key,
    required this.child,
    required this.onTap,
    this.sound = AppSound.tap,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Null for a tap that should stay silent.
  final AppSound? sound;

  /// Shapes the ink splash to match the card underneath.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final tap = onTap;

    return PressScale(
      enabled: tap != null,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: tap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  if (sound case final s?) uiSounds.play(s);
                  tap();
                },
          child: child,
        ),
      ),
    );
  }
}
