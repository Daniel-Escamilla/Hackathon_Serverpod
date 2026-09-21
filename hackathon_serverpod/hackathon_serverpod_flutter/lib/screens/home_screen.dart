import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../client.dart';
import '../theme.dart';

/// What a signed-in member sees. Everything here comes from the server: the
/// balance is `WalletEndpoint.getBalance`, not a number typed into the widget.
///
/// The three tabs (Tareas, Tienda, Grupo) land next, each against its own
/// endpoint. Until then this screen shows what is already real rather than
/// standing in for it with invented data.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<int> _balance;

  @override
  void initState() {
    super.initState();
    _balance = client.wallet.getBalance();
  }

  void _reload() {
    setState(() {
      _balance = client.wallet.getBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tareas de casa')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FutureBuilder<int>(
            future: _balance,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // The server refuses every call from someone without an active
              // membership, so a failure here almost always means "no group
              // yet". Once GroupEndpoint can answer that question directly,
              // ask it instead of reading it off an error.
              if (snapshot.hasError) {
                return _NoGroupYet(onRetry: _reload);
              }
              return _Balance(coins: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

class _Balance extends StatelessWidget {
  const _Balance({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/coin.svg', width: 40, height: 40),
            const SizedBox(width: 12),
            Text('$coins', style: text.displaySmall),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          coins < 0
              ? 'Estás en números rojos. Haz una tarea para salir.'
              : 'monedas en tu cartera',
          style: text.bodyLarge?.copyWith(color: appMuted),
        ),
      ],
    );
  }
}

class _NoGroupYet extends StatelessWidget {
  const _NoGroupYet({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Todavía no estás en ningún grupo', style: text.headlineMedium),
        const SizedBox(height: 12),
        Text(
          'Crea uno para tu casa o entra en el de alguien con su código.',
          style: text.bodyLarge?.copyWith(color: appMuted),
        ),
        const SizedBox(height: 28),
        FilledButton(onPressed: null, child: const Text('Crear un grupo')),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: null,
          child: const Text('Entrar con un código'),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: onRetry,
          child: const Text('Volver a intentarlo'),
        ),
      ],
    );
  }
}
