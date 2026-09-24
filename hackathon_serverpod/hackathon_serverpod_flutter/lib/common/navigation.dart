import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/group/group_controller.dart';
import '../features/shop/shop_controller.dart';
import '../features/tasks/tasks_controller.dart';
import '../features/wallet/wallet_controller.dart';
import '../home_shell.dart';

/// Opens [page] on top of the current screen.
///
/// The page lands on the root navigator, a sibling of [HomeShell] rather than
/// a child of it, so it cannot see the controllers `HomeShell` provides. The
/// ones the caller can see are handed over, which lets a screen pushed from a
/// tab — or from another pushed screen — use `context.read<TasksController>()`
/// like the tab itself.
void pushPage(BuildContext context, Widget page) {
  final providers = _homeProviders(context);
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => providers.isEmpty
          ? page
          : MultiProvider(providers: providers, child: page),
    ),
  );
}

void enterHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const HomeShell()),
    (_) => false,
  );
}

/// Empty outside [HomeShell], as in the sign-in and group set-up flows.
List<SingleChildWidget> _homeProviders(BuildContext context) => [
  ?_forward<HomeTabController>(context),
  ?_forward<TasksController>(context),
  ?_forward<ShopController>(context),
  ?_forward<WalletController>(context),
  ?_forward<GroupController>(context),
];

SingleChildWidget? _forward<T extends ChangeNotifier>(BuildContext context) {
  try {
    return ChangeNotifierProvider<T>.value(value: context.read<T>());
  } on ProviderNotFoundException {
    return null;
  }
}
