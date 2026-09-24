import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/available_task_screen.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/counter_offer_decision_screen.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/task_vote_screen.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/validation_screen.dart';

import '../../helpers/harness.dart';

Task task({TaskStatus status = TaskStatus.proposed, int? doneById}) => Task(
  id: 7,
  groupId: 1,
  title: 'Limpiar el baño',
  description: 'Ducha y lavabo',
  reward: 12,
  status: status,
  proposedById: 1,
  doneById: doneById,
);

void main() {
  late FakeTasksController tasks;

  setUp(() => tasks = FakeTasksController());

  group('proposal vote', () {
    testWidgets('approving votes yes and goes back', (tester) async {
      await openScreen(tester, TaskVoteScreen(task: task()), tasks: tasks);

      await tapLabel(tester, 'Aprobar');

      expect(tasks.calls, ['proposal 7 true']);
      expect(find.text('pestaña'), findsOneWidget);
    });

    testWidgets('rejecting votes no', (tester) async {
      await openScreen(tester, TaskVoteScreen(task: task()), tasks: tasks);

      await tapLabel(tester, 'Rechazar');

      expect(tasks.calls, ['proposal 7 false']);
    });

    testWidgets('a failed vote stays on the screen and says so', (
      tester,
    ) async {
      tasks.failWith = Exception('boom');
      await openScreen(tester, TaskVoteScreen(task: task()), tasks: tasks);

      await tapLabel(tester, 'Aprobar');

      expect(find.text('No se pudo registrar tu voto'), findsOneWidget);
      expect(find.text('Limpiar el baño'), findsOneWidget);
    });
  });

  group('counter-offer decision', () {
    testWidgets('accepting the new price answers yes', (tester) async {
      await openScreen(
        tester,
        CounterOfferDecisionScreen(task: task()),
        tasks: tasks,
      );

      await tapLabel(tester, 'Aceptar la contraoferta');

      expect(tasks.calls, ['counter 7 true']);
    });
  });

  group('available task', () {
    testWidgets('claiming it shows the result screen', (tester) async {
      await openScreen(
        tester,
        AvailableTaskScreen(task: task(status: TaskStatus.open)),
        tasks: tasks,
      );

      await tapLabel(tester, 'Ya está hecha');

      expect(tasks.calls, ['done 7']);
      expect(find.text('✅'), findsOneWidget);
    });

    testWidgets('losing the race says someone else took it', (tester) async {
      tasks.failWith = Exception('taken');
      await openScreen(
        tester,
        AvailableTaskScreen(task: task(status: TaskStatus.open)),
        tasks: tasks,
      );

      await tapLabel(tester, 'Ya está hecha');

      expect(
        find.text(
          'No se pudo reclamar. Puede que ya la haya cogido otra persona.',
        ),
        findsOneWidget,
      );
    });
  });

  group('completion vote', () {
    Task claimed() => task(status: TaskStatus.inValidation, doneById: 2);

    testWidgets('confirming it was done votes yes', (tester) async {
      await openScreen(
        tester,
        ValidationScreen(task: claimed(), myMemberId: 3),
        tasks: tasks,
      );

      await tapLabel(tester, 'Sí, está hecha');

      expect(tasks.calls, ['completion 7 true']);
      expect(find.text('pestaña'), findsOneWidget);
    });

    testWidgets('denying asks first, since it fines the claimant', (
      tester,
    ) async {
      await openScreen(
        tester,
        ValidationScreen(task: claimed(), myMemberId: 3),
        tasks: tasks,
      );

      await tapLabel(tester, 'No está hecha');
      expect(find.text('¿Seguro que no está hecha?'), findsOneWidget);
      expect(tasks.calls, isEmpty);

      await tapLabel(tester, 'No está hecha');
      expect(tasks.calls, ['completion 7 false']);
    });

    testWidgets('backing out of the denial votes nothing', (tester) async {
      await openScreen(
        tester,
        ValidationScreen(task: claimed(), myMemberId: 3),
        tasks: tasks,
      );

      await tapLabel(tester, 'No está hecha');
      await tapLabel(tester, 'Cancelar');

      expect(tasks.calls, isEmpty);
    });

    testWidgets('the claimant sees a notice and no buttons', (tester) async {
      await openScreen(
        tester,
        ValidationScreen(task: claimed(), myMemberId: 2),
        tasks: tasks,
      );

      expect(
        find.text('La has reclamado tú: ahora el grupo decide si está hecha.'),
        findsOneWidget,
      );
      expect(find.text('Sí, está hecha'), findsNothing);
      expect(find.text('No está hecha'), findsNothing);
    });
  });
}
