import 'package:flutter/material.dart';

import 'app_theme.dart';

class PrototypeApp extends StatelessWidget {
  const PrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prototipo de tareas',
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}

void _push(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

void _enterPrototype(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const HomeShell()),
    (_) => false,
  );
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.ink,
    ),
  );
}

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
                  onPressed: () => _enterPrototype(context),
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
                onPressed: () => _push(context, const EmailScreen()),
                icon: const Icon(Icons.mail_outline_rounded),
                label: const Text('Entrar con email'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _push(context, const EmailScreen()),
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
                Icons.handshake_rounded,
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

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleFormPage(
      title: 'Entra en tu cuenta',
      art: const _RoundIcon(
        icon: Icons.alternate_email_rounded,
        color: AppColors.sky,
      ),
      children: [
        const _FieldLabel('Email'),
        const TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: 'mayte@email.com'),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: () => _push(context, const VerificationScreen()),
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleFormPage(
      title: 'Revisa tu email',
      subtitle: 'Hemos enviado un código de 6 dígitos.',
      art: const _RoundIcon(
        icon: Icons.mark_email_read_rounded,
        color: AppColors.lime,
      ),
      children: [
        const TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 14,
            fontWeight: FontWeight.w800,
          ),
          decoration: InputDecoration(hintText: '284619'),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: () => _push(context, const GroupChoiceScreen()),
          child: const Text('Verificar'),
        ),
        TextButton(onPressed: () {}, child: const Text('Reenviar código')),
      ],
    );
  }
}

class _SimpleFormPage extends StatelessWidget {
  const _SimpleFormPage({
    required this.title,
    required this.children,
    required this.art,
    this.subtitle,
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

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

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

class GroupChoiceScreen extends StatelessWidget {
  const GroupChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, Mayte!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '¿Cómo quieres\nempezar?',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 34),
              _ChoiceCard(
                color: AppColors.lime,
                icon: Icons.home_rounded,
                title: 'Crear un grupo',
                subtitle: 'Prepara vuestro espacio',
                onTap: () => _push(context, const CreateGroupScreen()),
              ),
              const SizedBox(height: 16),
              _ChoiceCard(
                color: AppColors.sky,
                icon: Icons.confirmation_number_rounded,
                title: 'Unirme con un código',
                subtitle: 'Entra en un grupo existente',
                onTap: () => _push(context, const JoinGroupScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.violet, size: 42),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String _type = 'Pareja';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 30),
        children: [
          Text(
            'Crea vuestro grupo',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Elige cómo compartís casa',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _ProfileCard(
                  emoji: '🏠',
                  label: 'Piso compartido',
                  selected: _type == 'Piso compartido',
                  onTap: () => setState(() => _type = 'Piso compartido'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ProfileCard(
                  emoji: '💜',
                  label: 'Pareja',
                  selected: _type == 'Pareja',
                  onTap: () => setState(() => _type = 'Pareja'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const _FieldLabel('Nombre del grupo'),
          const TextField(
            decoration: InputDecoration(hintText: 'Casa de Mayte y Juan'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => _push(context, const GroupSuccessScreen()),
            child: const Text('Crear grupo'),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        height: 178,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.violet : const Color(0xFFE1DEE8),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected ? AppColors.violet : AppColors.muted,
              ),
            ),
            Text(emoji, style: const TextStyle(fontSize: 52)),
            const Spacer(),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleFormPage(
      title: 'Únete a tu gente',
      subtitle: 'Introduce el código que te han compartido.',
      art: const _RoundIcon(icon: Icons.groups_rounded, color: AppColors.sky),
      children: [
        const TextField(
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
          decoration: InputDecoration(hintText: 'NIDO-482'),
        ),
        const SizedBox(height: 8),
        const Text(
          'El código no distingue mayúsculas',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => _enterPrototype(context),
          child: const Text('Entrar al grupo'),
        ),
      ],
    );
  }
}

class GroupSuccessScreen extends StatelessWidget {
  const GroupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const _RoundIcon(icon: Icons.home_rounded, color: AppColors.lime),
              const SizedBox(height: 30),
              Text(
                '¡Ya tenéis casa!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Casa de Mayte y Juan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 28),
              _SoftCard(
                child: Column(
                  children: [
                    const Text(
                      'Código del grupo',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIDO-482',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded),
                label: const Text('Compartir código'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _enterPrototype(context),
                child: const Text('Ir a las tareas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    const pages = [TasksPage(), ShopPage(), WalletPage(), GroupPage()];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.violet.withValues(alpha: .14),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_alt_rounded),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_rounded),
            label: 'Tienda',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Cartera',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_rounded),
            label: 'Grupo',
          ),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _push(context, const ProposeTaskScreen()),
              backgroundColor: AppColors.violet,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Proponer'),
            )
          : null,
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    this.subtitle,
    this.showBalance = true,
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
          if (showBalance) const _CoinPill(value: 120),
          IconButton(
            onPressed: () => _push(context, const ActivityScreen()),
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

class _CoinPill extends StatelessWidget {
  const _CoinPill({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🪙', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 5),
          Text(
            '$value',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontFeatures: AppFonts.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({
    required this.child,
    this.color = Colors.white,
    this.onTap,
    this.padding,
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _PageHeader(title: 'Tareas', subtitle: 'Buenas, Mayte'),
        SizedBox(
          height: 44,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: const [
              _FilterChip('Todas', selected: true),
              _FilterChip('Tu voto'),
              _FilterChip('Disponibles'),
              _FilterChip('Validación'),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            children: [
              _ActionBanner(
                color: AppColors.coral,
                icon: Icons.notifications_active_rounded,
                title: '1 tarea espera tu voto',
                subtitle: 'Tu opinión cuenta',
                onTap: () => _push(context, const TaskVoteScreen()),
              ),
              const SizedBox(height: 14),
              _TaskCard(
                emoji: '🧼',
                title: 'Limpiar el baño',
                coins: 20,
                status: 'Tu voto',
                statusColor: AppColors.sky,
                detail: '23 h 42 min',
                onTap: () => _push(context, const TaskVoteScreen()),
              ),
              const SizedBox(height: 12),
              _TaskCard(
                emoji: '🗑️',
                title: 'Sacar la basura',
                coins: 5,
                status: 'Disponible',
                statusColor: AppColors.lime,
                onTap: () => _push(context, const AvailableTaskScreen()),
              ),
              const SizedBox(height: 12),
              _TaskCard(
                emoji: '✨',
                title: 'Fregar los platos',
                coins: 10,
                status: 'Validación',
                statusColor: AppColors.coral.withValues(alpha: .35),
                onTap: () => _push(context, const ValidationScreen()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(this.label, {this.selected = false});

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

class _ActionBanner extends StatelessWidget {
  const _ActionBanner({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 42, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    Text(subtitle, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.emoji,
    required this.title,
    required this.coins,
    required this.status,
    required this.statusColor,
    required this.onTap,
    this.detail,
  });

  final String emoji;
  final String title;
  final int coins;
  final String status;
  final Color statusColor;
  final String? detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.sky.withValues(alpha: .36),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 35)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  '🪙 $coins monedas',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFeatures: AppFonts.tabularFigures,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    _StatusPill(label: status, color: statusColor),
                    if (detail != null)
                      Text(
                        detail!,
                        style: const TextStyle(color: AppColors.muted),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class TaskVoteScreen extends StatelessWidget {
  const TaskVoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      status: const _StatusPill(
        label: 'Esperando tu voto',
        color: Color(0xFFE2DCFF),
      ),
      title: 'Limpiar el baño',
      content: [
        const _PersonRow(name: 'Propuesta por Juan', emoji: '👨🏽'),
        const SizedBox(height: 20),
        const _BigValueCard(
          color: AppColors.lime,
          value: '25',
          label: 'monedas',
          icon: '🪙',
        ),
        const SizedBox(height: 16),
        const _InfoRow(
          icon: Icons.description_rounded,
          text: 'Ducha, lavabo, espejo y suelo',
        ),
        const SizedBox(height: 12),
        const _InfoRow(
          icon: Icons.schedule_rounded,
          text: 'Quedan 23 h 42 min',
        ),
        const SizedBox(height: 20),
        const Text(
          'Votos · 0 de 1',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        const LinearProgressIndicator(
          value: 0,
          minHeight: 8,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ],
      actions: [
        FilledButton.icon(
          onPressed: () => _showMessage(context, 'Has aprobado la propuesta'),
          icon: const Icon(Icons.thumb_up_alt_rounded),
          label: const Text('Aprobar'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _counterOffer(context),
          icon: const Icon(Icons.swap_horiz_rounded),
          label: const Text('Contraofertar'),
        ),
        TextButton(
          onPressed: () => _showMessage(context, 'Propuesta rechazada'),
          style: TextButton.styleFrom(foregroundColor: AppColors.coral),
          child: const Text('Rechazar'),
        ),
      ],
    );
  }

  Future<void> _counterOffer(BuildContext context) async {
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CounterOfferSheet(),
    );
    if (sent == true && context.mounted) {
      _push(context, const CounterOfferDecisionScreen());
    }
  }
}

class CounterOfferSheet extends StatelessWidget {
  const CounterOfferSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFD3CFD8),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Haz una contraoferta',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            '¿Cuántas monedas te parecerían justas?',
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 26),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.remove_rounded),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '20',
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900),
                ),
              ),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _InfoRow(
            icon: Icons.pause_circle_rounded,
            text: 'La votación se pausará hasta que Juan responda',
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Enviar contraoferta'),
          ),
        ],
      ),
    );
  }
}

class CounterOfferDecisionScreen extends StatelessWidget {
  const CounterOfferDecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      status: const _StatusPill(
        label: 'Votación pausada',
        color: Color(0xFFFFDFA0),
      ),
      title: 'Nueva contraoferta',
      content: const [
        _PersonRow(name: 'Mayte propone', emoji: '👩🏽'),
        SizedBox(height: 22),
        _BigValueCard(
          color: AppColors.sky,
          value: '20',
          label: 'monedas',
          icon: '🪙',
        ),
        SizedBox(height: 18),
        _InfoRow(
          icon: Icons.restart_alt_rounded,
          text: 'Si aceptas, la votación empezará de cero',
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => _showMessage(context, 'Contraoferta aceptada'),
          child: const Text('Aceptar 20 monedas'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Retirar sin multa'),
        ),
      ],
    );
  }
}

class AvailableTaskScreen extends StatelessWidget {
  const AvailableTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      status: const _StatusPill(label: 'Disponible', color: AppColors.lime),
      title: 'Sacar la basura',
      content: const [
        Center(child: Text('🗑️', style: TextStyle(fontSize: 110))),
        _BigValueCard(
          color: AppColors.lime,
          value: '5',
          label: 'monedas',
          icon: '🪙',
        ),
        SizedBox(height: 16),
        _InfoRow(
          icon: Icons.description_rounded,
          text: 'Lleva la bolsa al contenedor de la calle',
        ),
        SizedBox(height: 12),
        _InfoRow(
          icon: Icons.info_outline_rounded,
          text: 'No se reserva: reclama cuando esté hecha',
        ),
      ],
      actions: [
        FilledButton.icon(
          onPressed: () => _push(
            context,
            const ResultScreen(
              emoji: '✅',
              title: '¡Reclamada!',
              message: 'Ahora el grupo debe confirmar que está hecha.',
              value: 'En validación · 5 monedas',
              button: 'Volver a tareas',
            ),
          ),
          icon: const Icon(Icons.check_rounded),
          label: const Text('Ya está hecha'),
        ),
      ],
    );
  }
}

class ValidationScreen extends StatelessWidget {
  const ValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      status: const _StatusPill(label: 'Validación', color: AppColors.lime),
      title: '¿Está bien hecha?',
      content: [
        Text(
          'Limpiar el baño',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const _PersonRow(name: 'Juan dice que la ha terminado', emoji: '👨🏽'),
        const SizedBox(height: 20),
        const Center(child: Text('🛁✨', style: TextStyle(fontSize: 90))),
        const SizedBox(height: 12),
        const _InfoRow(
          icon: Icons.paid_rounded,
          text: 'Tu voto confirma el pago de 20 monedas',
        ),
      ],
      actions: [
        FilledButton.icon(
          onPressed: () => _push(
            context,
            const ResultScreen(
              emoji: '🪙✨',
              title: '¡Buen trabajo!',
              message: 'El grupo ha validado “Limpiar el baño”.',
              value: '+20 monedas',
              button: 'Ver mi cartera',
              homeIndex: 2,
            ),
          ),
          icon: const Icon(Icons.check_rounded),
          label: const Text('Sí, está hecha'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _push(
            context,
            const ResultScreen(
              emoji: '↩️',
              title: 'Vuelve a estar disponible',
              message: 'El grupo indicó que todavía falta algo.',
              value: 'Multa · −4 monedas',
              button: 'Entendido',
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.coral,
            side: const BorderSide(color: AppColors.coral),
          ),
          icon: const Icon(Icons.close_rounded),
          label: const Text('No, falta algo'),
        ),
      ],
    );
  }
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({
    required this.status,
    required this.title,
    required this.content,
    required this.actions,
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

class _PersonRow extends StatelessWidget {
  const _PersonRow({required this.name, required this.emoji});

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

class _BigValueCard extends StatelessWidget {
  const _BigValueCard({
    required this.color,
    required this.value,
    required this.label,
    required this.icon,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
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

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.emoji,
    required this.title,
    required this.message,
    required this.value,
    required this.button,
    this.homeIndex = 0,
  });

  final String emoji;
  final String title;
  final String message;
  final String value;
  final String button;
  final int homeIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Text(emoji, style: const TextStyle(fontSize: 100)),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, fontSize: 17),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => HomeShell(initialIndex: homeIndex),
                    ),
                    (_) => false,
                  );
                },
                child: Text(button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProposeTaskScreen extends StatelessWidget {
  const ProposeTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Nueva tarea',
      fields: const [
        _FieldLabel('Título'),
        TextField(decoration: InputDecoration(hintText: 'Limpiar el baño')),
        SizedBox(height: 18),
        _FieldLabel('Descripción'),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Ducha, lavabo, espejo y suelo',
          ),
        ),
        SizedBox(height: 18),
        _FieldLabel('Recompensa'),
        _StepperValue(value: 25),
        SizedBox(height: 8),
        Text(
          'Una tarea normal suele valer 10',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
      ],
      button: 'Revisar propuesta',
      onSubmit: () => _push(context, const TaskReviewScreen()),
    );
  }
}

class TaskReviewScreen extends StatelessWidget {
  const TaskReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      status: const _StatusPill(label: 'Revisa el trato', color: AppColors.sky),
      title: 'Limpiar el baño',
      content: const [
        _BigValueCard(
          color: AppColors.lime,
          value: '25',
          label: 'monedas',
          icon: '🪙',
        ),
        SizedBox(height: 16),
        _InfoRow(
          icon: Icons.schedule_rounded,
          text: 'El grupo tendrá 24 horas para votar',
        ),
        SizedBox(height: 10),
        _InfoRow(
          icon: Icons.warning_amber_rounded,
          text: 'Si la rechazan, recibirás una multa de 5 monedas',
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => _push(
            context,
            const ResultScreen(
              emoji: '🗳️',
              title: 'Enviada a votación',
              message: 'Avisaremos al grupo para que decida el trato.',
              value: '25 monedas · 24 horas',
              button: 'Volver a tareas',
            ),
          ),
          child: const Text('Enviar a votación'),
        ),
      ],
    );
  }
}

class _FormScaffold extends StatelessWidget {
  const _FormScaffold({
    required this.title,
    required this.fields,
    required this.button,
    required this.onSubmit,
  });

  final String title;
  final List<Widget> fields;
  final String button;
  final VoidCallback onSubmit;

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
              child: FilledButton(onPressed: onSubmit, child: Text(button)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperValue extends StatelessWidget {
  const _StepperValue({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.remove_rounded),
          ),
          Expanded(
            child: Text(
              '$value monedas',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFeatures: AppFonts.tabularFigures,
              ),
            ),
          ),
          IconButton.filled(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _PageHeader(
          title: 'Tienda',
          subtitle: 'Convierte tus monedas en planes',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
            children: [
              Row(
                children: [
                  const _FilterChip('Todo', selected: true),
                  const _FilterChip('Mis compras'),
                  const Spacer(),
                  IconButton.filled(
                    onPressed: () =>
                        _push(context, const ProposeRewardScreen()),
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _RewardCard(
                color: const Color(0xFFE9E3FF),
                emoji: '🍿',
                title: 'Elijo yo la serie esta noche',
                price: 20,
                onTap: () => _push(context, const BuyRewardScreen()),
              ),
              const SizedBox(height: 14),
              _RewardCard(
                color: AppColors.sky.withValues(alpha: .55),
                emoji: '💆🏽',
                title: 'Un masaje',
                price: 50,
                onTap: () => _push(context, const BuyRewardScreen()),
              ),
              const SizedBox(height: 14),
              _RewardCard(
                color: AppColors.coral.withValues(alpha: .25),
                emoji: '🍝',
                title: 'Cena fuera, pago yo',
                price: 150,
                onTap: () => _push(context, const BuyRewardScreen()),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () => _push(context, const PendingPurchaseScreen()),
                icon: const Icon(Icons.redeem_rounded),
                label: const Text('Ver compra pendiente'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.color,
    required this.emoji,
    required this.title,
    required this.price,
    required this.onTap,
  });

  final Color color;
  final String emoji;
  final String title;
  final int price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      color: color,
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 55)),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '🪙 $price monedas',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFeatures: AppFonts.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class BuyRewardScreen extends StatefulWidget {
  const BuyRewardScreen({super.key});

  @override
  State<BuyRewardScreen> createState() => _BuyRewardScreenState();
}

class _BuyRewardScreenState extends State<BuyRewardScreen> {
  String _selected = 'Mayte';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        children: [
          Text(
            '¿Quién la cumplirá?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 22),
          _SoftCard(
            color: const Color(0xFFE9E3FF),
            child: Row(
              children: [
                const Text('🍿', style: TextStyle(fontSize: 54)),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Elijo yo la serie esta noche',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Text(
                  '🪙 20',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _FieldLabel('Selecciona a una persona'),
          Row(
            children: [
              Expanded(
                child: _PersonChoice(
                  name: 'Mayte',
                  emoji: '👩🏽',
                  selected: _selected == 'Mayte',
                  onTap: () => setState(() => _selected = 'Mayte'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PersonChoice(
                  name: 'Daniel',
                  emoji: '👨🏻',
                  selected: _selected == 'Daniel',
                  onTap: () => setState(() => _selected = 'Daniel'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const _SoftCard(
            child: Column(
              children: [
                _BalanceRow(label: 'Tu saldo', value: '120'),
                Divider(),
                _BalanceRow(label: 'Después', value: '100'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: () => _push(
              context,
              const ResultScreen(
                emoji: '🎁',
                title: 'Compra enviada',
                message: 'Mayte debe aceptar antes de cumplirla.',
                value: '−20 monedas',
                button: 'Volver a la tienda',
                homeIndex: 1,
              ),
            ),
            child: const Text('Comprar por 20'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mayte tendrá que aceptar',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _PersonChoice extends StatelessWidget {
  const _PersonChoice({
    required this.name,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.violet : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? AppColors.violet : AppColors.muted,
              ),
            ),
            Text(emoji, style: const TextStyle(fontSize: 54)),
            Text(name, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            '🪙 $value',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontFeatures: AppFonts.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class ProposeRewardScreen extends StatelessWidget {
  const ProposeRewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _FormScaffold(
      title: 'Nueva recompensa',
      fields: const [
        _FieldLabel('Título'),
        TextField(decoration: InputDecoration(hintText: 'Desayuno en la cama')),
        SizedBox(height: 18),
        _FieldLabel('Descripción'),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(hintText: 'Café, tostadas y fruta'),
        ),
        SizedBox(height: 18),
        _FieldLabel('Precio'),
        _StepperValue(value: 40),
        SizedBox(height: 18),
        _InfoRow(
          icon: Icons.how_to_vote_rounded,
          text: 'El grupo votará antes de publicarla',
        ),
      ],
      button: 'Enviar a votación',
      onSubmit: () => _push(context, const RewardVoteScreen()),
    );
  }
}

class RewardVoteScreen extends StatelessWidget {
  const RewardVoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      status: const _StatusPill(
        label: 'Espera tu voto',
        color: Color(0xFFE2DCFF),
      ),
      title: 'Desayuno en la cama',
      content: const [
        Center(child: Text('☕🥐', style: TextStyle(fontSize: 90))),
        _BigValueCard(
          color: AppColors.sky,
          value: '40',
          label: 'monedas',
          icon: '🪙',
        ),
        SizedBox(height: 14),
        _PersonRow(name: 'Propuesta por Mayte', emoji: '👩🏽'),
        SizedBox(height: 14),
        _InfoRow(icon: Icons.schedule_rounded, text: 'Quedan 23 h 42 min'),
      ],
      actions: [
        FilledButton(
          onPressed: () => _showMessage(context, 'Recompensa aprobada'),
          child: const Text('Aprobar recompensa'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => _showMessage(context, 'Recompensa rechazada'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.coral,
            side: const BorderSide(color: AppColors.coral),
          ),
          child: const Text('Rechazar'),
        ),
      ],
    );
  }
}

class PendingPurchaseScreen extends StatelessWidget {
  const PendingPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      status: const _StatusPill(
        label: 'Necesita tu respuesta',
        color: AppColors.coral,
      ),
      title: 'Mayte te ha elegido',
      content: [
        const Center(child: Text('📺🍿', style: TextStyle(fontSize: 90))),
        Text(
          'Elijo yo la serie esta noche',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Center(child: _CoinPill(value: 20)),
        const SizedBox(height: 18),
        const _InfoRow(
          icon: Icons.info_outline_rounded,
          text: 'Si aceptas, queda pendiente hasta que la entregues',
        ),
        const SizedBox(height: 10),
        const _InfoRow(
          icon: Icons.warning_amber_rounded,
          text: 'Si te niegas, pagarás una multa de 4 monedas',
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => _push(context, const AcceptedPurchaseScreen()),
          child: const Text('Aceptar'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () =>
              _showMessage(context, 'Compra rechazada y monedas devueltas'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.coral,
            side: const BorderSide(color: AppColors.coral),
          ),
          child: const Text('No puedo cumplirla'),
        ),
      ],
    );
  }
}

class AcceptedPurchaseScreen extends StatelessWidget {
  const AcceptedPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold(
      status: const _StatusPill(
        label: 'Pendiente de entrega',
        color: Color(0xFFFFDFA0),
      ),
      title: 'Elijo yo la serie esta noche',
      content: const [
        Center(child: Text('📺', style: TextStyle(fontSize: 100))),
        _InfoRow(
          icon: Icons.person_rounded,
          text: 'La cumple Juan · para Mayte',
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TimelineStep(label: 'Comprada', done: true),
            _TimelineStep(label: 'Aceptada', done: true),
            _TimelineStep(label: 'Entregada', done: false),
          ],
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => _showMessage(context, 'Recompensa entregada'),
          child: const Text('Marcar como entregada'),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: done ? AppColors.violet : const Color(0xFFD8D5DE),
          child: Icon(
            done ? Icons.check : Icons.more_horiz,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ],
    );
  }
}

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _PageHeader(title: 'Cartera', showBalance: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.violet,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '120',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              fontFeatures: AppFonts.tabularFigures,
                            ),
                          ),
                          const Text(
                            'monedas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lime,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '+20 esta semana',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('🪙', style: TextStyle(fontSize: 88)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Últimos movimientos',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              const _MovementRow(
                emoji: '🧼',
                title: 'Limpiar el baño',
                date: '12 mar, 18:20',
                amount: '+20',
                positive: true,
              ),
              const _MovementRow(
                emoji: '📺',
                title: 'Serie esta noche',
                date: '12 mar, 18:35',
                amount: '−20',
                positive: false,
              ),
              const _MovementRow(
                emoji: '⚠️',
                title: 'Multa por validación',
                date: '11 mar, 16:10',
                amount: '−4',
                positive: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({
    required this.emoji,
    required this.title,
    required this.date,
    required this.amount,
    required this.positive,
  });

  final String emoji;
  final String title;
  final String date;
  final String amount;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _SoftCard(
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 34)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: positive ? const Color(0xFF16853C) : AppColors.coral,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFeatures: AppFonts.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _PageHeader(title: 'Grupo'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
            children: [
              _SoftCard(
                color: AppColors.lime,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('🏠', style: TextStyle(fontSize: 48)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Casa de Mayte y Juan',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const _StatusPill(label: 'Pareja', color: Colors.white),
                      ],
                    ),
                    const Divider(height: 28),
                    const Text(
                      'Código del grupo',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'NIDO-482',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              _showMessage(context, 'Código copiado'),
                          icon: const Icon(Icons.copy_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Text('Miembros', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              const _MemberRow(emoji: '👩🏽', name: 'Mayte', badge: 'Admin'),
              const _MemberRow(emoji: '👨🏽', name: 'Juan'),
              const SizedBox(height: 16),
              const _SoftCard(
                child: Row(
                  children: [
                    Icon(Icons.settings_rounded),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Configuración del grupo',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.emoji, required this.name, this.badge});

  final String emoji;
  final String name;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _SoftCard(
        child: Row(
          children: [
            CircleAvatar(backgroundColor: AppColors.sky, child: Text(emoji)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            if (badge != null)
              _StatusPill(label: badge!, color: const Color(0xFFE2DCFF)),
          ],
        ),
      ),
    );
  }
}

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          _ActivityCard(
            emoji: '👨🏽',
            title: 'Juan ha contraofertado 20 monedas',
            time: 'Ahora',
            action: 'Responder',
            onTap: () => _push(context, const CounterOfferDecisionScreen()),
          ),
          _ActivityCard(
            emoji: '✅',
            title: 'Tu tarea está disponible',
            time: 'Hace 8 min',
            action: 'Ver tarea',
            onTap: () => _push(context, const AvailableTaskScreen()),
          ),
          _ActivityCard(
            emoji: '🪙',
            title: 'Has ganado 20 monedas',
            time: 'Ayer',
            action: 'Ver cartera',
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) => const HomeShell(initialIndex: 2),
                ),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.emoji,
    required this.title,
    required this.time,
    required this.action,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String time;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _SoftCard(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onTap, child: Text(action)),
          ],
        ),
      ),
    );
  }
}
