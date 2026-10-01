import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'app_animation.dart';

/// A list with nothing in it yet: the empty animation and a sentence that
/// says what will appear here.
class EmptyState extends StatelessWidget {
  const EmptyState(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLottie(AppAnimation.empty, size: 140),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
