import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/common/group_gate.dart';
import 'package:hackathon_serverpod_flutter/data/app_failure.dart';
import 'package:hackathon_serverpod_flutter/data/membership_repository.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_choice_screen.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';

/// Answers from a queue: each call to [hasGroup] takes the next answer, and
/// an [AppFailure] in it is thrown instead.
class FakeMembershipRepository extends MembershipRepository {
  FakeMembershipRepository(this.answers);

  final List<Object> answers;

  @override
  Future<bool> hasGroup() async {
    final answer = answers.removeAt(0);
    if (answer is AppFailure) throw AppException(answer);
    return answer as bool;
  }
}

Future<void> openGate(WidgetTester tester, List<Object> answers) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: GroupGate(
        membership: FakeMembershipRepository(answers),
        home: const Text('casa'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('without a group, it offers to create or join one', (
    tester,
  ) async {
    await openGate(tester, [false]);

    expect(find.byType(GroupChoiceScreen), findsOneWidget);
  });

  testWidgets('with a group, it goes home', (tester) async {
    await openGate(tester, [true]);

    expect(find.text('casa'), findsOneWidget);
  });

  testWidgets('a failed check can be retried', (tester) async {
    await openGate(tester, [AppFailure.unknown, false]);

    expect(find.text('No se pudo comprobar tu grupo.'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.byType(GroupChoiceScreen), findsOneWidget);
  });
}
