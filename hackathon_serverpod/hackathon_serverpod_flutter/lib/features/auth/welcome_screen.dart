import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import 'email_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => enterHome(context),
                  child: const Text('Ver prototipo'),
                ),
              ),
              const Spacer(),
              const _HouseHero(),
              const SizedBox(height: 38),
              Text(
                'Las tareas,\npor fin justas.',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 14),
              Text(
                'Los acuerdos de casa se deciden entre todos.',
                style:
                    Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(
                      color: AppColors.muted,
                      fontSize: 18,
                    ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => pushPage(context, const EmailScreen()),
                icon: const Icon(Icons.mail_outline_rounded),
                label: const Text('Entrar con email'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => pushPage(context, const EmailScreen()),
                child: const Text('Crear una cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HouseHero extends StatelessWidget {
  const _HouseHero();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 238,
        height: 238,
        decoration: BoxDecoration(
          color: AppColors.sky.withValues(alpha: .45),
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 136,
              height: 122,
              margin: const EdgeInsets.only(top: 38),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 22,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: AppColors.violet,
                size: 64,
              ),
            ),
            const Positioned(
              top: 33,
              child: Icon(
                Icons.roofing_rounded,
                color: AppColors.coral,
                size: 150,
              ),
            ),
            const Positioned(
              right: 20,
              top: 28,
              child: Icon(Icons.auto_awesome, color: AppColors.lime, size: 42),
            ),
          ],
        ),
      ),
    );
  }
}
