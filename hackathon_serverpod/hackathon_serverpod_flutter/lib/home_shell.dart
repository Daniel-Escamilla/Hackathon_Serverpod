import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'common/navigation.dart';
import 'features/group/group_controller.dart';
import 'features/group/group_page.dart';
import 'features/shop/shop_controller.dart';
import 'features/shop/shop_page.dart';
import 'features/tasks/propose_task_screen.dart';
import 'features/tasks/tasks_controller.dart';
import 'features/tasks/tasks_page.dart';
import 'features/wallet/wallet_controller.dart';
import 'features/wallet/wallet_page.dart';
import 'l10n/generated/app_localizations.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _index = widget.initialIndex;
  final _tasksController = TasksController()..load();
  final _shopController = ShopController()..load();
  final _walletController = WalletController()..load();
  final _groupController = GroupController()..load();

  @override
  void dispose() {
    _tasksController.dispose();
    _shopController.dispose();
    _walletController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _tasksController),
        ChangeNotifierProvider.value(value: _shopController),
        ChangeNotifierProvider.value(value: _walletController),
        ChangeNotifierProvider.value(value: _groupController),
      ],
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          const pages = [
            TasksPage(),
            ShopPage(),
            WalletPage(),
            GroupPage(),
          ];
          return Scaffold(
            body: SafeArea(
              child: IndexedStack(index: _index, children: pages),
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              backgroundColor: Colors.white,
              indicatorColor: AppColors.violet.withValues(alpha: .14),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.task_alt_rounded),
                  label: l10n.navTasks,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.storefront_rounded),
                  label: l10n.navShop,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.account_balance_wallet_rounded),
                  label: l10n.navWallet,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.groups_rounded),
                  label: l10n.navGroup,
                ),
              ],
            ),
            floatingActionButton: _index == 0
                ? FloatingActionButton.extended(
                    onPressed: () =>
                        pushPage(context, const ProposeTaskScreen()),
                    backgroundColor: AppColors.violet,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.proposeTask),
                  )
                : null,
          );
        },
      ),
    );
  }
}
