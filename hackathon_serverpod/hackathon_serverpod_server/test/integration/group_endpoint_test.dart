import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
const _carolAuthUserId = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
const _race1AdminAuthUserId = '31313131-3131-4131-8131-313131313131';
const _race1BobAuthUserId = '32323232-3232-4232-8232-323232323232';
const _race1CarolAuthUserId = '33333333-3333-4333-8333-333333333333';

/// A refusal the app can act on: the right exception type *and* the right
/// reason, since the reason is what picks the sentence the user sees.
Matcher _throwsGroupError(GroupErrorReason reason) => throwsA(
  isA<GroupException>().having((e) => e.reason, 'reason', reason),
);

void main() {
  withServerpod('Given the group endpoint', (sessionBuilder, endpoints) {
    final session = sessionBuilder.build();

    TestSessionBuilder sessionOf(String authUserId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(authUserId, {}),
    );

    group('when creating a shared-flat group', () {
      test(
        'then the creator becomes admin and the templates are seeded',
        () async {
          final group = await endpoints.group.createGroup(
            sessionOf(_aliceAuthUserId),
            'Piso de prueba',
            GroupType.sharedFlat,
            displayName: 'Alice',
          );

          expect(group.inviteCode, hasLength(6));

          final member = await GroupMember.db.findFirstRow(
            session,
            where: (t) => t.groupId.equals(group.id!),
          );
          expect(member!.role, GroupMemberRole.admin);
          expect(member.displayName, 'Alice');

          final rewards = await RewardItem.db.find(
            session,
            where: (t) => t.groupId.equals(group.id!),
          );
          expect(rewards, isNotEmpty);
          expect(
            rewards.every((r) => r.status == RewardItemStatus.active),
            isTrue,
          );
        },
      );

      test(
        'then a second call by the same user fails: one group per person',
        () async {
          await endpoints.group.createGroup(
            sessionOf(_aliceAuthUserId),
            'Piso de prueba',
            GroupType.sharedFlat,
          );

          await expectLater(
            endpoints.group.createGroup(
              sessionOf(_aliceAuthUserId),
              'Otro piso',
              GroupType.couple,
            ),
            _throwsGroupError(GroupErrorReason.alreadyInGroup),
          );
        },
      );
    });

    group('when joining with an invite code', () {
      late Group createdGroup;

      setUp(() async {
        createdGroup = await endpoints.group.createGroup(
          sessionOf(_aliceAuthUserId),
          'Piso de prueba',
          GroupType.sharedFlat,
          displayName: 'Alice',
        );
      });

      test('then it adds the joiner as a plain member', () async {
        final member = await endpoints.group.joinGroup(
          sessionOf(_bobAuthUserId),
          createdGroup.inviteCode,
          displayName: 'Bob',
        );

        expect(member.groupId, createdGroup.id);
        expect(member.role, GroupMemberRole.member);
      });

      test('then the code is case-insensitive', () async {
        final member = await endpoints.group.joinGroup(
          sessionOf(_bobAuthUserId),
          createdGroup.inviteCode.toLowerCase(),
          displayName: 'Bob',
        );
        expect(member.groupId, createdGroup.id);
      });

      test('then an unknown code fails', () async {
        await expectLater(
          endpoints.group.joinGroup(sessionOf(_bobAuthUserId), 'ZZZZZZ'),
          _throwsGroupError(GroupErrorReason.inviteCodeNotFound),
        );
      });

      test('then someone already in a group cannot join another', () async {
        await expectLater(
          endpoints.group.joinGroup(
            sessionOf(_aliceAuthUserId),
            createdGroup.inviteCode,
          ),
          _throwsGroupError(GroupErrorReason.alreadyInGroup),
        );
      });

      test(
        'then the joiner can read the group back, invite code included',
        () async {
          await endpoints.group.joinGroup(
            sessionOf(_bobAuthUserId),
            createdGroup.inviteCode,
            displayName: 'Bob',
          );

          final group = await endpoints.group.myGroup(
            sessionOf(_bobAuthUserId),
          );
          expect(group.id, createdGroup.id);
          expect(group.inviteCode, createdGroup.inviteCode);
        },
      );

      test('then listMembers returns everyone, oldest first', () async {
        await endpoints.group.joinGroup(
          sessionOf(_bobAuthUserId),
          createdGroup.inviteCode,
          displayName: 'Bob',
        );

        final members = await endpoints.group.listMembers(
          sessionOf(_bobAuthUserId),
        );
        expect(members.map((m) => m.displayName), ['Alice', 'Bob']);
      });
    });

    group('when the caller belongs to no group', () {
      test('then myGroup is refused with noMembership', () async {
        await expectLater(
          endpoints.group.myGroup(sessionOf(_carolAuthUserId)),
          _throwsGroupError(GroupErrorReason.noMembership),
        );
      });

      test('then listMembers is refused with noMembership', () async {
        await expectLater(
          endpoints.group.listMembers(sessionOf(_carolAuthUserId)),
          _throwsGroupError(GroupErrorReason.noMembership),
        );
      });
    });

    group('when the admin protects the group', () {
      late Group createdGroup;
      late GroupMember bob;

      setUp(() async {
        createdGroup = await endpoints.group.createGroup(
          sessionOf(_aliceAuthUserId),
          'Piso de prueba',
          GroupType.sharedFlat,
          displayName: 'Alice',
        );
        bob = await endpoints.group.joinGroup(
          sessionOf(_bobAuthUserId),
          createdGroup.inviteCode,
          displayName: 'Bob',
        );
      });

      test('then expelling removes the member from the group', () async {
        await endpoints.group.expelMember(sessionOf(_aliceAuthUserId), bob.id!);

        final members = await endpoints.group.listMembers(
          sessionOf(_aliceAuthUserId),
        );
        expect(members.map((m) => m.displayName), ['Alice']);
        await expectLater(
          endpoints.group.myGroup(sessionOf(_bobAuthUserId)),
          _throwsGroupError(GroupErrorReason.noMembership),
        );
      });

      test(
        'then the expelled member keeps their row, marked as left',
        () async {
          await endpoints.group.expelMember(
            sessionOf(_aliceAuthUserId),
            bob.id!,
          );

          final row = await GroupMember.db.findById(session, bob.id!);
          expect(row!.leftAt, isNotNull);
        },
      );

      test('then an expelled member is free to join another group', () async {
        await endpoints.group.expelMember(sessionOf(_aliceAuthUserId), bob.id!);

        final other = await endpoints.group.createGroup(
          sessionOf(_bobAuthUserId),
          'Casa de Bob',
          GroupType.couple,
        );
        expect(other.id, isNot(createdGroup.id));
      });

      test(
        'then rejoining the same group after expulsion carries over a debt',
        () async {
          await GroupMember.db.updateRow(
            session,
            bob.copyWith(balance: -15),
          );
          await endpoints.group.expelMember(
            sessionOf(_aliceAuthUserId),
            bob.id!,
          );

          final rejoined = await endpoints.group.joinGroup(
            sessionOf(_bobAuthUserId),
            createdGroup.inviteCode,
            displayName: 'Bob',
          );

          // The debt follows: leaving and rejoining the same group can't be
          // used to erase a fine (Notion "Puntos de mejora", punto 2).
          expect(rejoined.balance, -15);
          expect(rejoined.id, isNot(bob.id));
        },
      );

      test(
        'then rejoining the same group after expulsion does not carry over a '
        'positive balance',
        () async {
          await GroupMember.db.updateRow(
            session,
            bob.copyWith(balance: 40),
          );
          await endpoints.group.expelMember(
            sessionOf(_aliceAuthUserId),
            bob.id!,
          );

          final rejoined = await endpoints.group.joinGroup(
            sessionOf(_bobAuthUserId),
            createdGroup.inviteCode,
            displayName: 'Bob',
          );

          // Winnings still don't carry over — only closing the debt-evasion
          // direction, not changing PRODUCT.md §4.6 for the other one.
          expect(rejoined.balance, 0);
        },
      );

      test('then a plain member cannot expel anyone', () async {
        final alice = (await endpoints.group.listMembers(
          sessionOf(_aliceAuthUserId),
        )).first;

        await expectLater(
          endpoints.group.expelMember(sessionOf(_bobAuthUserId), alice.id!),
          _throwsGroupError(GroupErrorReason.notAdmin),
        );
      });

      test('then the admin cannot expel themselves', () async {
        final alice = (await endpoints.group.listMembers(
          sessionOf(_aliceAuthUserId),
        )).first;

        await expectLater(
          endpoints.group.expelMember(sessionOf(_aliceAuthUserId), alice.id!),
          _throwsGroupError(GroupErrorReason.cannotExpelSelf),
        );
      });

      test('then expelling someone from another group is refused', () async {
        final carol = await endpoints.group.createGroup(
          sessionOf(_carolAuthUserId),
          'Otro piso',
          GroupType.sharedFlat,
        );
        final carolMember = (await endpoints.group.listMembers(
          sessionOf(_carolAuthUserId),
        )).single;
        expect(carol.id, isNot(createdGroup.id));

        await expectLater(
          endpoints.group.expelMember(
            sessionOf(_aliceAuthUserId),
            carolMember.id!,
          ),
          _throwsGroupError(GroupErrorReason.memberNotFound),
        );
      });

      test('then handing the role over swaps admin and member', () async {
        final newAdmin = await endpoints.group.transferAdmin(
          sessionOf(_aliceAuthUserId),
          bob.id!,
        );
        expect(newAdmin.role, GroupMemberRole.admin);

        final members = await endpoints.group.listMembers(
          sessionOf(_aliceAuthUserId),
        );
        final roles = {for (final m in members) m.displayName: m.role};
        expect(roles, {
          'Alice': GroupMemberRole.member,
          'Bob': GroupMemberRole.admin,
        });

        await endpoints.group.regenerateInviteCode(sessionOf(_bobAuthUserId));
        await expectLater(
          endpoints.group.regenerateInviteCode(sessionOf(_aliceAuthUserId)),
          _throwsGroupError(GroupErrorReason.notAdmin),
        );
      });

      test('then a plain member cannot hand the role over', () async {
        final alice = (await endpoints.group.listMembers(
          sessionOf(_aliceAuthUserId),
        )).first;

        await expectLater(
          endpoints.group.transferAdmin(sessionOf(_bobAuthUserId), alice.id!),
          _throwsGroupError(GroupErrorReason.notAdmin),
        );
      });

      test('then the admin cannot hand the role to themselves', () async {
        final alice = (await endpoints.group.listMembers(
          sessionOf(_aliceAuthUserId),
        )).first;

        await expectLater(
          endpoints.group.transferAdmin(sessionOf(_aliceAuthUserId), alice.id!),
          _throwsGroupError(GroupErrorReason.cannotTransferAdmin),
        );
      });

      test('then the role cannot go to someone in another group', () async {
        await endpoints.group.createGroup(
          sessionOf(_carolAuthUserId),
          'Otro piso',
          GroupType.sharedFlat,
        );
        final carolMember = (await endpoints.group.listMembers(
          sessionOf(_carolAuthUserId),
        )).single;

        await expectLater(
          endpoints.group.transferAdmin(
            sessionOf(_aliceAuthUserId),
            carolMember.id!,
          ),
          _throwsGroupError(GroupErrorReason.memberNotFound),
        );
      });

      test('then in a family the old admin stays a guardian', () async {
        final family = await endpoints.group.createGroup(
          sessionOf(_carolAuthUserId),
          'Familia',
          GroupType.family,
          displayName: 'Carol',
        );
        final guardian = await GroupMember.db.insertRow(
          session,
          GroupMember(
            groupId: family.id!,
            authUserId: UuidValue.fromString(
              '34343434-3434-4434-8434-343434343434',
            ),
            displayName: 'Dani',
            role: GroupMemberRole.guardian,
          ),
        );

        await endpoints.group.transferAdmin(
          sessionOf(_carolAuthUserId),
          guardian.id!,
        );

        final carol = await GroupMember.db.findFirstRow(
          session,
          where: (t) =>
              t.groupId.equals(family.id!) & t.displayName.equals('Carol'),
        );
        expect(carol!.role, GroupMemberRole.guardian);
      });

      test('then the role never goes to a child', () async {
        final child = await GroupMember.db.insertRow(
          session,
          GroupMember(
            groupId: createdGroup.id!,
            authUserId: UuidValue.fromString(_carolAuthUserId),
            displayName: 'Carol',
            role: GroupMemberRole.child,
          ),
        );

        await expectLater(
          endpoints.group.transferAdmin(sessionOf(_aliceAuthUserId), child.id!),
          _throwsGroupError(GroupErrorReason.cannotTransferAdmin),
        );
      });

      test('then a new invite code replaces the old one', () async {
        final renewed = await endpoints.group.regenerateInviteCode(
          sessionOf(_aliceAuthUserId),
        );
        expect(renewed.inviteCode, isNot(createdGroup.inviteCode));

        await expectLater(
          endpoints.group.joinGroup(
            sessionOf(_carolAuthUserId),
            createdGroup.inviteCode,
          ),
          _throwsGroupError(GroupErrorReason.inviteCodeNotFound),
        );

        final carol = await endpoints.group.joinGroup(
          sessionOf(_carolAuthUserId),
          renewed.inviteCode,
        );
        expect(carol.groupId, createdGroup.id);
      });

      test('then a plain member cannot replace the invite code', () async {
        await expectLater(
          endpoints.group.regenerateInviteCode(sessionOf(_bobAuthUserId)),
          _throwsGroupError(GroupErrorReason.notAdmin),
        );
      });

      test('then the admin renames the group and changes its fine', () async {
        final updated = await endpoints.group.updateGroup(
          sessionOf(_aliceAuthUserId),
          name: '  Piso nuevo  ',
          finePercent: 35,
        );
        expect(updated.name, 'Piso nuevo');
        expect(updated.finePercent, 35);

        final seenByBob = await endpoints.group.myGroup(
          sessionOf(_bobAuthUserId),
        );
        expect(seenByBob.name, 'Piso nuevo');
        expect(seenByBob.finePercent, 35);
      });

      test('then renaming alone keeps the fine percentage', () async {
        final updated = await endpoints.group.updateGroup(
          sessionOf(_aliceAuthUserId),
          name: 'Solo el nombre',
        );
        expect(updated.name, 'Solo el nombre');
        expect(updated.finePercent, createdGroup.finePercent);
      });

      test('then a field left out keeps its current value', () async {
        final updated = await endpoints.group.updateGroup(
          sessionOf(_aliceAuthUserId),
          finePercent: 10,
        );
        expect(updated.name, createdGroup.name);
        expect(updated.finePercent, 10);
      });

      test('then a plain member cannot change the settings', () async {
        await expectLater(
          endpoints.group.updateGroup(
            sessionOf(_bobAuthUserId),
            finePercent: 50,
          ),
          _throwsGroupError(GroupErrorReason.notAdmin),
        );
      });

      test('then a blank name or a fine outside 0-100 is refused', () async {
        await expectLater(
          endpoints.group.updateGroup(sessionOf(_aliceAuthUserId), name: '  '),
          throwsA(anything),
        );
        await expectLater(
          endpoints.group.updateGroup(
            sessionOf(_aliceAuthUserId),
            finePercent: 101,
          ),
          throwsA(anything),
        );

        final unchanged = await endpoints.group.myGroup(
          sessionOf(_aliceAuthUserId),
        );
        expect(unchanged.name, createdGroup.name);
        expect(unchanged.finePercent, createdGroup.finePercent);
      });
    });
  });

  // Real concurrent transactions need rollback disabled (serverpod-testing
  // skill); each withServerpod group gets its own database.
  withServerpod(
    'Given an admin handing the role over twice at once',
    (sessionBuilder, endpoints) {
      final session = sessionBuilder.build();

      TestSessionBuilder sessionOf(String authUserId) =>
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authUserId,
              {},
            ),
          );

      test('then the group still ends with exactly one admin', () async {
        final group = await endpoints.group.createGroup(
          sessionOf(_race1AdminAuthUserId),
          'Piso de prueba',
          GroupType.sharedFlat,
          displayName: 'Admin',
        );
        final bob = await endpoints.group.joinGroup(
          sessionOf(_race1BobAuthUserId),
          group.inviteCode,
          displayName: 'Bob',
        );
        final carol = await endpoints.group.joinGroup(
          sessionOf(_race1CarolAuthUserId),
          group.inviteCode,
          displayName: 'Carol',
        );

        final outcomes = await Future.wait([
          for (final target in [bob, carol])
            endpoints.group
                .transferAdmin(sessionOf(_race1AdminAuthUserId), target.id!)
                .then<Object>((m) => m, onError: (Object e) => e),
        ]);
        expect(outcomes.whereType<GroupMember>(), hasLength(1));
        expect(outcomes.whereType<GroupException>(), hasLength(1));

        final admins = await GroupMember.db.find(
          session,
          where: (t) =>
              t.groupId.equals(group.id!) &
              t.role.equals(GroupMemberRole.admin),
        );
        expect(admins, hasLength(1));
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
