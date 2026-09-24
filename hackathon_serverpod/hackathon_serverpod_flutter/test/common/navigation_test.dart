import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/common/navigation.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/tasks_controller.dart';
import 'package:provider/provider.dart';

void main() {
  late TasksController tasks;

  setUp(() => tasks = TasksController());
  tearDown(() => tasks.dispose());

  /// A tab with the controller above it, like `HomeShell`, and a button that
  /// pushes [page] the way every tab does.
  Future<void> openFromTab(WidgetTester tester, Widget page) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: tasks,
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => pushPage(context, page),
              child: const Text('abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  testWidgets('a pushed screen sees the controllers of the tab', (
    tester,
  ) async {
    TasksController? seen;
    await openFromTab(
      tester,
      Builder(
        builder: (context) {
          seen = context.read<TasksController>();
          return const SizedBox();
        },
      ),
    );

    expect(seen, same(tasks));
  });

  testWidgets('and so does a screen pushed from that one', (tester) async {
    TasksController? seen;
    await openFromTab(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => pushPage(
            context,
            Builder(
              builder: (context) {
                seen = context.read<TasksController>();
                return const SizedBox();
              },
            ),
          ),
          child: const Text('siguiente'),
        ),
      ),
    );
    await tester.tap(find.text('siguiente'));
    await tester.pumpAndSettle();

    expect(seen, same(tasks));
  });

  testWidgets('outside HomeShell it pushes the page as it is', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => pushPage(context, const Text('bienvenida')),
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    expect(find.text('bienvenida'), findsOneWidget);
  });
}
