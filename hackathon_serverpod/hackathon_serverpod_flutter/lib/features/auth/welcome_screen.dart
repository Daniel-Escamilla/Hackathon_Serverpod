import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../l10n/generated/app_localizations.dart';
import 'create_account_email_screen.dart';
import 'sign_in_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const _HouseHero(),
              const SizedBox(height: 38),
              Text(
                l10n.welcomeHeadline,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 14),
              Text(
                l10n.welcomeSubtitle,
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
                onPressed: () => pushPage(context, const SignInScreen()),
                icon: const Icon(Icons.mail_outline_rounded),
                label: Text(l10n.welcomeSignIn),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () =>
                    pushPage(context, const CreateAccountEmailScreen()),
                child: Text(l10n.welcomeCreateAccount),
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
