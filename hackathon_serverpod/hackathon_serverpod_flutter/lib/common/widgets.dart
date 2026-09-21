import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../features/wallet/wallet_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../ui/app_button.dart';
import 'activity_screen.dart';
import 'navigation.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    this.subtitle,
    this.showBalance = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool showBalance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    subtitle!,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ],
              ],
            ),
          ),
          if (showBalance) const _BalancePill(),
          IconButton(
            onPressed: () => pushPage(context, const ActivityScreen()),
            tooltip: AppLocalizations.of(context).activityTitle,
            icon: const Badge(
              backgroundColor: AppColors.coral,
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

/// The balance pill in the app bar. Waits for [WalletController]'s first
/// load instead of flashing a wrong number, since it's shown on tabs other
/// than Cartera where nothing else would trigger that load.
class _BalancePill extends StatelessWidget {
  const _BalancePill();

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletController>();
    if (!wallet.hasLoaded) {
      return const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return CoinPill(value: wallet.balance);
  }
}

class CoinPill extends StatelessWidget {
  const CoinPill({required this.value, super.key});

  final int value;

  @override
  Widget build(BuildContext context) {
    final negative = value < 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: negative ? AppColors.coral : AppColors.lime,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 5),
          Text(
            '$value',
            style: TextStyle(
              color: negative ? Colors.white : AppColors.ink,
              fontWeight: FontWeight.w900,
              fontFeatures: AppFonts.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    required this.child,
    this.color = Colors.white,
    this.onTap,
    this.padding,
    super.key,
  });

  final Widget child;
  final Color color;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Row(
        children: [
          Icon(icon, color: AppColors.violet),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class BigValueCard extends StatelessWidget {
  const BigValueCard({
    required this.color,
    required this.value,
    required this.label,
    required this.icon,
    super.key,
  });

  final Color color;
  final String value;
  final String label;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 45)),
          const SizedBox(width: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              fontFeatures: AppFonts.tabularFigures,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class PersonRow extends StatelessWidget {
  const PersonRow({required this.name, required this.emoji, super.key});

  final String name;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(backgroundColor: AppColors.sky, child: Text(emoji)),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class DetailScaffold extends StatelessWidget {
  const DetailScaffold({
    required this.status,
    required this.title,
    required this.content,
    required this.actions,
    super.key,
  });

  final Widget status;
  final String title;
  final List<Widget> content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                children: [
                  Center(child: status),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 22),
                  ...content,
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 22),
              color: AppColors.cream,
              child: Column(mainAxisSize: MainAxisSize.min, children: actions),
            ),
          ],
        ),
      ),
    );
  }
}

class FormScaffold extends StatelessWidget {
  const FormScaffold({
    required this.title,
    required this.fields,
    required this.button,
    required this.onSubmit,
    this.loading = false,
    super.key,
  });

  final String title;
  final List<Widget> fields;
  final String button;
  final VoidCallback onSubmit;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 28),
                  ...fields,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 22),
              child: AppButton(
                label: button,
                loading: loading,
                onPressed: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepperValue extends StatelessWidget {
  const StepperValue({
    required this.value,
    this.onChanged,
    this.step = 5,
    super.key,
  });

  final int value;
  final ValueChanged<int>? onChanged;
  final int step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SoftCard(
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: onChanged == null || value <= step
                ? null
                : () => onChanged!(value - step),
            tooltip: l10n.decreaseAmount,
            icon: const Icon(Icons.remove_rounded),
          ),
          Expanded(
            child: Text(
              l10n.rewardAmount(value),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFeatures: AppFonts.tabularFigures,
              ),
            ),
          ),
          IconButton.filled(
            onPressed: onChanged == null
                ? null
                : () => onChanged!(value + step),
            tooltip: l10n.increaseAmount,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class RoundIcon extends StatelessWidget {
  const RoundIcon({required this.icon, required this.color, super.key});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, size: 76, color: AppColors.ink),
      ),
    );
  }
}

class FilterPill extends StatelessWidget {
  const FilterPill(this.label, {this.selected = false, super.key});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.violet : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppColors.ink,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class SimpleFormPage extends StatelessWidget {
  const SimpleFormPage({
    required this.title,
    required this.children,
    required this.art,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget art;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          children: [
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle!,
                style: const TextStyle(color: AppColors.muted, fontSize: 16),
              ),
            ],
            const SizedBox(height: 42),
            art,
            const SizedBox(height: 48),
            ...children,
          ],
        ),
      ),
    );
  }
}
