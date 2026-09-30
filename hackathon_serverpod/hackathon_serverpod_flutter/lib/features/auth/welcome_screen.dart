import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import 'create_account_email_screen.dart';
import 'google_sign_in_button.dart';
import 'sign_in_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        // Scrolls on a short screen instead of overflowing; on a tall one the
        // spacers still push the buttons to the bottom.
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 42,
              ),
              child: IntrinsicHeight(
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
                    AppButton(
                      label: l10n.welcomeSignIn,
                      onPressed: () => pushPage(context, const SignInScreen()),
                    ),
                    const SizedBox(height: 8),
                    const GoogleSignInButton(),
                    const SizedBox(height: 8),
                    AppButton(
                      label: l10n.welcomeCreateAccount,
                      kind: AppButtonKind.quiet,
                      onPressed: () =>
                          pushPage(context, const CreateAccountEmailScreen()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The app's logo on the sky circle the screen always had. flutter_svg skips
/// the SVG's drop-shadow filters, so the shadow is drawn here instead.
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
        alignment: Alignment.center,
        child: Transform.rotate(
          angle: -0.07,
          child: Container(
            width: 168,
            height: 168,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x552E22A0),
                  blurRadius: 28,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/brand/logo.svg',
              semanticsLabel: 'Logo',
            ),
          ),
        ),
      ),
    );
  }
}
