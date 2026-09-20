import 'package:hackathon_serverpod_server/src/groups/current_member.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _strangerAuthUserId = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee';

void main() {
  withServerpod('Given currentGroupMember', (sessionBuilder, _) {
    test('then an unauthenticated session throws', () async {
      final session = sessionBuilder.build();

      await expectLater(
        currentGroupMember(session),
        throwsA(isA<StateError>()),
      );
    });

    test(
      'then a signed-in user with no active group membership throws',
      () async {
        final session = sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                _strangerAuthUserId,
                {},
              ),
            )
            .build();

        await expectLater(
          currentGroupMember(session),
          throwsA(isA<StateError>()),
        );
      },
    );
  });
}
