import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the email identity provider endpoint', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();

    group('when registering an email that already has an account', () {
      setUp(() async {
        final user = await AuthUser.db.insertRow(
          session,
          AuthUser(scopeNames: {}),
        );
        await EmailAccount.db.insertRow(
          session,
          EmailAccount(
            authUserId: user.id!,
            email: 'alice@example.com',
            passwordHash: 'unused',
          ),
        );
      });

      test('then the refusal says the email is registered', () async {
        await expectLater(
          endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: 'alice@example.com',
          ),
          throwsA(
            isA<RegistrationException>().having(
              (e) => e.reason,
              'reason',
              RegistrationErrorReason.emailAlreadyRegistered,
            ),
          ),
        );
      });

      test('then it matches whatever case and spacing it is typed with', () {
        expect(
          endpoints.emailIdp.startRegistration(
            sessionBuilder,
            email: '  Alice@Example.COM ',
          ),
          throwsA(isA<RegistrationException>()),
        );
      });
    });
  });
}
