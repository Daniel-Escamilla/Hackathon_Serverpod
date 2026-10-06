import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/propose_task_screen.dart';

import '../../helpers/harness.dart';

void main() {
  testWidgets('a typical chore fills the title and its price', (tester) async {
    await openScreen(tester, const ProposeTaskScreen());

    await tester.tap(find.text('Limpiar el baño · 25'));
    await tester.pumpAndSettle();

    final title = tester.widget<TextField>(find.byType(TextField).first);
    expect(title.controller!.text, 'Limpiar el baño');
    // The price stepper sits below the chips.
    await tester.scrollUntilVisible(
      find.text('25 karmas'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('25 karmas'), findsOneWidget);
  });

  testWidgets('every typical chore is offered', (tester) async {
    await openScreen(tester, const ProposeTaskScreen());

    expect(find.text('Sacar la basura · 5'), findsOneWidget);
    expect(find.text('Hacer la cena · 20'), findsOneWidget);
  });
}
