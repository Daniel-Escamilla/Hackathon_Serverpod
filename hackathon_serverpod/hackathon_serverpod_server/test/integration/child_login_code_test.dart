import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a child in a family group', (sessionBuilder, endpoints) {
    final session = sessionBuilder.build();
    late GroupMember child;

    setUp(() async {
      final family = await Group.db.insertRow(
        session,
        Group(name: 'Familia', type: GroupType.family, inviteCode: 'FAM001'),
      );
      child = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: family.id!,
          authUserId: UuidValue.fromString(
            '41414141-4141-4141-8141-414141414141',
          ),
          displayName: 'Leo',
          role: GroupMemberRole.child,
        ),
      );
    });

    test('then a login code is stored by its hash, unused', () async {
      final expiresAt = DateTime.now().toUtc().add(const Duration(hours: 24));
      final stored = await ChildLoginCode.db.insertRow(
        session,
        ChildLoginCode(
          memberId: child.id!,
          codeHash: 'hash-of-the-code',
          expiresAt: expiresAt,
        ),
      );

      final read = await ChildLoginCode.db.findById(session, stored.id!);
      expect(read!.memberId, child.id);
      expect(read.codeHash, 'hash-of-the-code');
      expect(read.usedAt, isNull);
    });

    test('then two codes can never share a hash', () async {
      final expiresAt = DateTime.now().toUtc().add(const Duration(hours: 24));
      ChildLoginCode code() => ChildLoginCode(
        memberId: child.id!,
        codeHash: 'same-hash',
        expiresAt: expiresAt,
      );

      await ChildLoginCode.db.insertRow(session, code());
      await expectLater(
        ChildLoginCode.db.insertRow(session, code()),
        throwsA(isA<DatabaseException>()),
      );
    });
  });
}
