import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/data/app_failure.dart';
import 'package:hackathon_serverpod_flutter/data/group_repository.dart';
import 'package:hackathon_serverpod_flutter/features/group/join_group_screen.dart';

import '../../helpers/harness.dart';

/// Refuses every code with [failure].
class RefusingGroupRepository extends GroupRepository {
  RefusingGroupRepository(this.failure);

  final AppFailure failure;
  final codes = <String>[];

  @override
  Future<GroupMember> joinGroup(String inviteCode) async {
    codes.add(inviteCode);
    throw AppException(failure);
  }
}

void main() {
  Future<RefusingGroupRepository> tryCode(
    WidgetTester tester,
    AppFailure failure,
  ) async {
    final repository = RefusingGroupRepository(failure);
    await openScreen(tester, JoinGroupScreen(repository: repository));
    await tester.enterText(find.byType(TextField), ' nido-482 ');
    await tapLabel(tester, 'Entrar al grupo');
    return repository;
  }

  testWidgets('an unknown code says so and stays', (tester) async {
    final repository = await tryCode(tester, AppFailure.inviteCodeNotFound);

    expect(repository.codes, ['nido-482']);
    expect(
      find.text('Ese código no existe. Compruébalo con quien te lo pasó.'),
      findsOneWidget,
    );
  });

  testWidgets('already being in a group says so', (tester) async {
    await tryCode(tester, AppFailure.alreadyInGroup);

    expect(
      find.text('Ya estás en un grupo. Sal de él antes de entrar en otro.'),
      findsOneWidget,
    );
  });

  testWidgets('anything else keeps the screen message', (tester) async {
    await tryCode(tester, AppFailure.unknown);

    expect(
      find.text('No se encontró ningún grupo con ese código.'),
      findsOneWidget,
    );
  });
}
