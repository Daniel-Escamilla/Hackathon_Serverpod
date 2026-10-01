import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// The app's Lottie animations, one per moment, in `assets/animations/`.
/// Where each comes from is in that folder's `CREDITS.md`. Like the sounds,
/// each one always means the same thing.
enum AppAnimation {
  /// Coins come into the wallet. Goes with `AppSound.coin`.
  coins,

  /// A task claimed or a vote cast went through.
  approved,

  /// A fine takes coins. Goes with `AppSound.fine`.
  fine,

  /// Another member just did something (the live notice).
  notice,

  /// A purchase was delivered.
  celebrate,

  /// A reward was bought.
  reward,

  /// A list with nothing in it yet.
  empty,

  /// Choosing, creating or joining a home.
  home,

  /// Waiting for the server.
  loading;

  String get asset => 'assets/animations/$name.json';
}

/// Plays an [AppAnimation] at [size]. Once by default, then it rests on its
/// last frame and calls [onFinished]; with [repeat] it loops.
///
/// Whoever has animations reduced in their system sees a still frame, as
/// with the press bounce (DESIGN.md "Movimiento").
class AppLottie extends StatefulWidget {
  const AppLottie(
    this.animation, {
    this.size = 120,
    this.repeat = false,
    this.onFinished,
    super.key,
  });

  final AppAnimation animation;
  final double size;
  final bool repeat;
  final VoidCallback? onFinished;

  @override
  State<AppLottie> createState() => _AppLottieState();
}

class _AppLottieState extends State<AppLottie>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start(LottieComposition composition) {
    _controller.duration = composition.duration;
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (still) {
      _controller.value = widget.repeat ? .5 : 1;
      widget.onFinished?.call();
    } else if (widget.repeat) {
      _controller.repeat();
    } else {
      _controller.forward().whenComplete(() {
        if (mounted) widget.onFinished?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.size,
        child: Lottie.asset(
          widget.animation.asset,
          controller: _controller,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          onLoaded: _start,
        ),
      ),
    );
  }
}

/// A whole page waiting for the server: the loading animation, centred.
/// Small inline waits (a button, the header) keep their spinner.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: AppLottie(AppAnimation.loading, size: 96, repeat: true),
  );
}

/// Confetti over the whole app, once. It lives in the root overlay, so the
/// screen that asked for it can close straight away, and it never takes a
/// tap. For a purchase delivered: the end of the shop's cycle.
void showCelebration(BuildContext context) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final width = MediaQuery.sizeOf(context).width;
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: AppLottie(
          AppAnimation.celebrate,
          size: width,
          onFinished: () {
            if (entry.mounted) entry.remove();
          },
        ),
      ),
    ),
  );
  overlay.insert(entry);
}
