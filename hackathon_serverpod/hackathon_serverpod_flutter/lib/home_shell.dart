import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'common/navigation.dart';
import 'features/group/group_page.dart';
import 'features/shop/shop_page.dart';
import 'features/tasks/propose_task_screen.dart';
import 'features/tasks/tasks_page.dart';
import 'features/wallet/wallet_page.dart';

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
              onPressed: () => pushPage(context, const ProposeTaskScreen()),
              backgroundColor: AppColors.violet,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Proponer'),
            )
          : null,
    );
  }
}
