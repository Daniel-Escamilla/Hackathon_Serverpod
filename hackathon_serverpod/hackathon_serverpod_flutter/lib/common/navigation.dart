import 'package:flutter/material.dart';

import '../home_shell.dart';

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

void enterHome(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const HomeShell()),
    (_) => false,
  );
}
