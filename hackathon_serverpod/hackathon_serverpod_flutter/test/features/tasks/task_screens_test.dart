import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/available_task_screen.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/counter_offer_decision_screen.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/task_vote_screen.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/validation_screen.dart';

import 'package:hackathon_serverpod_flutter/features/tasks/tasks_page.dart';
import 'package:hackathon_serverpod_flutter/features/wallet/wallet_controller.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_controller.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/tasks_controller.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/harness.dart';

Task task({
  TaskStatus status = TaskStatus.proposed,
  int? doneById,
  int id = 7,
  String title = 'Limpiar el baño',
}) => Task(
  id: id,
  groupId: 1,
  title: title,
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
      await openScreen(
        tester,
        TaskVoteScreen(task: task(), myMemberId: 3),
        tasks: tasks,
      );

      await tapLabel(tester, 'Aprobar');

      expect(tasks.calls, ['proposal 7 true']);
      expect(find.text('pestaña'), findsOneWidget);
    });

    testWidgets('rejecting votes no', (tester) async {
      await openScreen(
        tester,
        TaskVoteScreen(task: task(), myMemberId: 3),
        tasks: tasks,
      );

      await tapLabel(tester, 'Rechazar');

      expect(tasks.calls, ['proposal 7 false']);
    });

    testWidgets('a vote that closed meanwhile says the task changed', (
      tester,
    ) async {
      tasks.failWith = TaskException(reason: TaskErrorReason.notOpen);
      await openScreen(
        tester,
        TaskVoteScreen(task: task(), myMemberId: 3),
        tasks: tasks,
      );

      await tapLabel(tester, 'Aprobar');

      expect(
        find.text(
          'Esta tarea ya ha cambiado. Vuelve a la lista para verla al día.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('a failed vote stays on the screen and says so', (
      tester,
    ) async {
      tasks.failWith = Exception('boom');
      await openScreen(
        tester,
        TaskVoteScreen(task: task(), myMemberId: 3),
        tasks: tasks,
      );

      await tapLabel(tester, 'Aprobar');

      expect(find.text('No se pudo registrar tu voto'), findsOneWidget);
      expect(find.text('Limpiar el baño'), findsOneWidget);
    });
  });

  group('counter-offer decision', () {
    testWidgets('accepting the new price answers yes', (tester) async {
      await openScreen(
        tester,
        CounterOfferDecisionScreen(task: task(), myMemberId: 1),
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

    testWidgets('a claim the server refused as taken says so plainly', (
      tester,
    ) async {
      tasks.failWith = TaskException(reason: TaskErrorReason.notOpen);
      await openScreen(
        tester,
        AvailableTaskScreen(task: task(status: TaskStatus.open)),
        tasks: tasks,
      );

      await tapLabel(tester, 'Ya está hecha');

      expect(
        find.text('Alguien se te ha adelantado: ya la ha cogido otra persona.'),
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

  group('who can vote', () {
    late FakeGroupController members;

    setUp(
      () => members = FakeGroupController(
        me: 3,
        members: [member(1, 'Ana'), member(2, 'Bea'), member(3, 'Carla')],
      ),
    );

    TaskVote vote(int memberId, {bool approve = true, int? counter}) =>
        TaskVote(
          taskId: 7,
          memberId: memberId,
          phase: TaskVotePhase.proposal,
          approve: approve,
          counterReward: counter,
        );

    testWidgets('your own proposal has no vote buttons', (tester) async {
      await openScreen(
        tester,
        TaskVoteScreen(task: task(), myMemberId: 1),
        tasks: tasks,
        group: members,
      );

      expect(
        find.text('La has propuesto tú: vota el resto del grupo.'),
        findsOneWidget,
      );
      expect(find.text('Aprobar'), findsNothing);
    });

    testWidgets('once you have voted the buttons go away', (tester) async {
      tasks.votes = [vote(3)];
      await openScreen(
        tester,
        TaskVoteScreen(task: task(), myMemberId: 3),
        tasks: tasks,
        group: members,
      );

      expect(find.text('Ya has votado. Falta que vote el resto.'), findsOne);
      expect(find.text('Aprobar'), findsNothing);
    });

    testWidgets('the detail lists who voted and how', (tester) async {
      tasks.votes = [vote(2), vote(3, approve: false, counter: 15)];
      await openScreen(
        tester,
        TaskVoteScreen(task: task(), myMemberId: 1),
        tasks: tasks,
        group: members,
      );

      expect(find.text('Quién ha votado'), findsOneWidget);
      expect(find.text('Bea'), findsOneWidget);
      expect(find.text('A favor'), findsOneWidget);
      expect(find.text('Carla'), findsOneWidget);
      expect(find.text('Contraoferta: 15'), findsOneWidget);
    });

    testWidgets('with no votes yet it says so', (tester) async {
      await openScreen(
        tester,
        TaskVoteScreen(task: task(), myMemberId: 3),
        tasks: tasks,
        group: members,
      );

      expect(find.text('Todavía no ha votado nadie.'), findsOneWidget);
    });

    testWidgets('only the proposer answers a counter-offer', (tester) async {
      await openScreen(
        tester,
        CounterOfferDecisionScreen(
          task: task(status: TaskStatus.counterOffered),
          myMemberId: 2,
        ),
        tasks: tasks,
        group: members,
      );

      expect(
        find.text(
          'Quien la propuso está decidiendo si acepta la contraoferta.',
        ),
        findsOneWidget,
      );
      expect(find.text('Aceptar la contraoferta'), findsNothing);
    });
  });

  testWidgets('the tab puts first what is waiting for you', (tester) async {
    final members = FakeGroupController(
      me: 3,
      members: [member(1, 'Ana'), member(2, 'Bea'), member(3, 'Carla')],
    );
    tasks
      ..hasLoaded = true
      ..tasks = [
        task(id: 1, title: 'Para votar'),
        task(id: 2, title: 'Ya votada'),
        task(id: 3, title: 'Libre', status: TaskStatus.open),
        task(
          id: 4,
          title: 'Mía en validación',
          status: TaskStatus.inValidation,
          doneById: 3,
        ),
        task(id: 5, title: 'Terminada', status: TaskStatus.done),
      ]
      ..votes = [
        TaskVote(
          taskId: 2,
          memberId: 3,
          phase: TaskVotePhase.proposal,
          approve: true,
        ),
      ];

    // Tall enough for every section: ListView only builds what is on screen.
    tester.view
      ..physicalSize = const Size(800, 3000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TasksController>.value(value: tasks),
          ChangeNotifierProvider<GroupController>.value(value: members),
          ChangeNotifierProvider(create: (_) => WalletController()),
        ],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: TasksPage()),
        ),
      ),
    );
    // The wallet pill in the header never loads here, so its spinner keeps
    // animating: a plain pump, not pumpAndSettle.
    await tester.pump();

    double y(String text) => tester.getTopLeft(find.text(text)).dy;
    expect(y('Esperan tu voto'), lessThan(y('Para votar')));
    expect(y('Para votar'), lessThan(y('Disponibles')));
    expect(y('Disponibles'), lessThan(y('Libre')));
    expect(y('Tuyas en validación'), lessThan(y('Mía en validación')));
    expect(y('En votación'), lessThan(y('Ya votada')));
    expect(find.text('Terminada'), findsNothing);
  });
}
