import 'package:hackathon_serverpod_server/src/demo/demo_seeder.dart';
import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _password = 'demo-password-123';
const _strangerAuthUserId = 'f1f1f1f1-f1f1-4f1f-8f1f-f1f1f1f1f1f1';

void main() {
  // The test server does not run server.dart, so nothing has set up the auth
  // services the seeder creates accounts through.
  setUpAll(() {
    AuthServices.set(
      tokenManagerBuilders: [
        ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
      ],
      identityProviderBuilders: [
        const EmailIdpConfig(secretHashPepper: 'test-pepper'),
      ],
    );
  });

  withServerpod('Given the demo seeder', (sessionBuilder, endpoints) {
    final session = sessionBuilder.build();
    const seeder = DemoSeeder();

    Future<List<GroupMember>> demoMembers() async {
      final ids = <UuidValue>{};
      for (final account in demoAccounts) {
        final found = await AuthServices.instance.emailIdp.admin.findAccount(
          session,
          email: account.email,
        );
        ids.add(found!.authUserId);
      }
      return GroupMember.db.find(
        session,
        where: (t) => t.authUserId.inSet(ids) & t.leftAt.equals(null),
        orderBy: (t) => t.id,
      );
    }

    group('when it runs on an empty database', () {
      late String inviteCode;

      setUp(() async {
        inviteCode = await seeder.reseed(session, password: _password);
      });

      test('then both accounts share one couple group', () async {
        final members = await demoMembers();
        expect(members.map((m) => m.displayName), ['Ana', 'Leo']);
        expect(members.map((m) => m.groupId).toSet(), hasLength(1));

        final group = await Group.db.findById(session, members.first.groupId);
        expect(group!.type, GroupType.couple);
        expect(group.inviteCode, inviteCode);
        expect(members.first.role, GroupMemberRole.admin);
      });

      test('then the accounts sign in with the password', () async {
        // The check login runs, without the endpoint: its rate limiter opens
        // a transaction inside the test's, which rollback mode refuses.
        final authUserId = await AuthServices
            .instance
            .emailIdp
            .utils
            .authentication
            .authenticate(
              session,
              email: demoAccounts.first.email,
              password: _password,
              transaction: null,
            );
        final members = await demoMembers();
        expect(authUserId, members.first.authUserId);
      });

      test('then the history has payments, a fine and a purchase', () async {
        final members = await demoMembers();
        final ana = members[0];
        final leo = members[1];

        final tasks = await Task.db.find(
          session,
          where: (t) => t.groupId.equals(ana.groupId),
        );
        String statusOf(String title) =>
            tasks.firstWhere((t) => t.title == title).status.name;
        expect(statusOf('Limpiar el baño'), 'done');
        expect(statusOf('Hacer la compra'), 'done');
        expect(statusOf('Fregar los platos'), 'done');
        expect(statusOf('Poner una lavadora'), 'open');
        expect(statusOf('Regar las plantas'), 'open');
        expect(
          tasks.firstWhere((t) => t.title == 'Poner una lavadora').reward,
          8,
        );
        // No vote left open: it would expire and fine somebody.
        expect(
          tasks.where(
            (t) =>
                t.status == TaskStatus.proposed ||
                t.status == TaskStatus.inValidation,
          ),
          isEmpty,
        );

        final leoMoves = await CoinTransaction.db.find(
          session,
          where: (t) => t.memberId.equals(leo.id!),
        );
        expect(
          leoMoves.map((m) => m.reason),
          containsAll([
            CoinTransactionReason.earned,
            CoinTransactionReason.validationDenied,
            CoinTransactionReason.spent,
          ]),
        );
        expect(leo.balance, leoMoves.fold<int>(0, (sum, m) => sum + m.amount));
        expect(leo.balance, greaterThan(0));
        expect(ana.balance, 15);

        final purchases = await Purchase.db.find(
          session,
          where: (t) => t.groupId.equals(ana.groupId),
        );
        expect(purchases.single.status, PurchaseStatus.accepted);
        expect(purchases.single.buyerId, leo.id);
        expect(purchases.single.providerId, ana.id);
      });

      test('then running it again starts over', () async {
        final before = await demoMembers();

        await seeder.reseed(session, password: _password);

        final after = await demoMembers();
        expect(after, hasLength(2));
        expect(after.first.groupId, isNot(before.first.groupId));
        expect(
          after.map((m) => m.authUserId),
          before.map((m) => m.authUserId),
        );
        expect(await Group.db.findById(session, before.first.groupId), isNull);
      });

      test('then a group with somebody else in it is kept', () async {
        final members = await demoMembers();
        final stranger = await GroupMember.db.insertRow(
          session,
          GroupMember(
            groupId: members.first.groupId,
            authUserId: UuidValue.fromString(_strangerAuthUserId),
            displayName: 'Carla',
            role: GroupMemberRole.member,
          ),
        );

        await seeder.reseed(session, password: _password);

        final kept = await Group.db.findById(session, stranger.groupId);
        expect(kept, isNotNull);
        final left = await GroupMember.db.find(
          session,
          where: (t) =>
              t.groupId.equals(stranger.groupId) & t.id.notEquals(stranger.id),
        );
        expect(left.every((m) => m.leftAt != null), isTrue);
        expect(
          (await demoMembers()).map((m) => m.groupId).toSet().single,
          isNot(stranger.groupId),
        );
      });
    });

    test(
      'when the server has no demo secret then the endpoint refuses',
      () async {
        expect(await endpoints.demo.reseed(sessionBuilder, 'anything'), isNull);
        final found = await AuthServices.instance.emailIdp.admin.findAccount(
          session,
          email: demoAccounts.first.email,
        );
        expect(found, isNull);
      },
    );
  });
}
