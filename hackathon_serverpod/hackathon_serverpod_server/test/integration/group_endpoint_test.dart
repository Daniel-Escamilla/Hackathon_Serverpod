import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
const _carolAuthUserId = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';

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
    });
  });
}
