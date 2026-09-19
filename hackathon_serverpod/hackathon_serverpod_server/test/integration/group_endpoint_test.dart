import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';

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
            throwsA(isA<StateError>()),
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
          throwsA(isA<StateError>()),
        );
      });

      test('then someone already in a group cannot join another', () async {
        await expectLater(
          endpoints.group.joinGroup(
            sessionOf(_aliceAuthUserId),
            createdGroup.inviteCode,
          ),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
