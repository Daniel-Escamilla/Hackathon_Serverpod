import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/data/auth_repository.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_page.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../helpers/harness.dart';

/// A session that records signing out instead of reaching the server.
class FakeAuth extends AuthRepository {
  final _session = ValueNotifier<AuthSuccess?>(null);
  bool signedOut = false;

  @override
  ValueListenable<AuthSuccess?> get session => _session;

  @override
  Future<void> signOut() async => signedOut = true;
}

/// Ana administers the group; Bea is a plain member. [me] picks who is
/// looking.
class AdminGroupController extends FakeGroupController {
  AdminGroupController({required int me})
    : super(
        me: me,
        members: [
          member(1, 'Ana').copyWith(role: GroupMemberRole.admin),
          member(2, 'Bea'),
        ],
      ) {
    this.group = Group(
      id: 1,
      name: 'Piso de prueba',
      type: GroupType.sharedFlat,
      inviteCode: 'ABC234',
    );
  }

  final fakeAuth = FakeAuth();
  final handedTo = <int>[];

  @override
  AuthRepository get auth => fakeAuth;

  @override
  Future<void> transferAdmin(int memberId) async => handedTo.add(memberId);
}

/// The group tab as the app shows it: in a Scaffold, the way HomeShell hosts
/// it, so its messages have somewhere to appear.
const groupTab = Scaffold(body: GroupPage());

/// Scrolls the tab until [finder] is on screen and lets the scroll finish
/// before tapping: the last rows sit below the fold.
Future<void> scrollAndTap(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('handing the admin role over', () {
    testWidgets('the admin confirms and it goes to that member', (
      tester,
    ) async {
      final group = AdminGroupController(me: 1);
      await openScreen(tester, groupTab, group: group);

      await tester.tap(find.byTooltip('Hacer admin'));
      await tester.pumpAndSettle();
      expect(find.text('¿Ceder el cargo de admin a Bea?'), findsOneWidget);
      await tapLabel(tester, 'Ceder el cargo');

      expect(group.handedTo, [2]);
      expect(find.text('Bea es ahora admin de la casa.'), findsOneWidget);
    });

    testWidgets('backing out of the confirmation hands nothing over', (
      tester,
    ) async {
      final group = AdminGroupController(me: 1);
      await openScreen(tester, groupTab, group: group);

      await tester.tap(find.byTooltip('Hacer admin'));
      await tester.pumpAndSettle();
      await tapLabel(tester, 'Cancelar');

      expect(group.handedTo, isEmpty);
    });

    testWidgets('a plain member does not get the option', (tester) async {
      await openScreen(tester, groupTab, group: AdminGroupController(me: 2));

      expect(find.byTooltip('Hacer admin'), findsNothing);
      expect(find.byTooltip('Expulsar'), findsNothing);
    });
  });

  // Pushed over a plain route, not under AuthGate: after creating or joining a
  // group, or coming back from a result screen, HomeShell replaces the whole
  // stack, and signing out used to leave the member stuck there.
  testWidgets('signing out lands on the welcome screen', (tester) async {
    final group = AdminGroupController(me: 2);
    await openScreen(tester, groupTab, group: group);

    await scrollAndTap(tester, find.text('Cerrar sesión'));
    await tester.tap(find.text('Cerrar sesión').last);
    await tester.pumpAndSettle();

    expect(group.fakeAuth.signedOut, isTrue);
    expect(find.text('Entrar con email'), findsOneWidget);
  });
}
