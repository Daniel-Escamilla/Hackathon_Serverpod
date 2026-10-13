import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/propose_task_screen.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/schedule_screen.dart';

import '../../helpers/harness.dart';

Task mission({
  int id = 9,
  List<int> weekdays = const [2, 4],
  TaskStatus status = TaskStatus.scheduled,
  int proposedById = 1,
}) => Task(
  id: id,
  groupId: 1,
  title: 'Sacar la basura',
  description: '',
  reward: 5,
  kind: TaskKind.mission,
  weekdays: weekdays,
  status: status,
  proposedById: proposedById,
);

void main() {
  late FakeTasksController tasks;

  setUp(() {
    tasks = FakeTasksController()
      ..hasLoaded = true
      ..tasks = [mission()];
  });

  Future<void> open(WidgetTester tester, {required int me}) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await openScreen(
      tester,
      const ScheduleScreen(),
      tasks: tasks,
      group: FakeGroupController(
        me: me,
        members: [member(1, 'Ana'), member(2, 'Leo')],
      ),
    );
  }

  testWidgets('a set task shows under each of its days', (tester) async {
    await open(tester, me: 2);

    // Tuesday and Thursday; the other five say there is nothing.
    expect(find.text('Sacar la basura'), findsNWidgets(2));
    expect(find.text('Nada'), findsNWidgets(5));
    // Leo did not propose it and is not the admin: no bin.
    expect(find.byTooltip('Quitar'), findsNothing);
  });

  testWidgets('its proposer takes it off the schedule', (tester) async {
    await open(tester, me: 1);

    await tester.tap(find.byTooltip('Quitar').first);
    await tester.pumpAndSettle();
    expect(find.text('¿Quitar de la agenda?'), findsOneWidget);
    await tester.tap(find.text('Quitar').last);
    await tester.pumpAndSettle();

    expect(tasks.calls, ['withdraw 9']);
  });

  testWidgets('one still being voted on waits apart', (tester) async {
    tasks.tasks = [mission(status: TaskStatus.proposed)];

    await open(tester, me: 1);

    expect(find.text('Esperando la votación'), findsOneWidget);
    expect(find.text('Sacar la basura'), findsOneWidget);
  });

  testWidgets('a new set task opens the form with the days first', (
    tester,
  ) async {
    await open(tester, me: 1);

    await tapLabel(tester, 'Nueva tarea fija');

    expect(find.byType(ProposeTaskScreen), findsOneWidget);
    expect(find.text('Repetir cada semana (opcional)'), findsOneWidget);
  });
}
