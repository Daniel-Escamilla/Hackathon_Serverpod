import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import 'app_failure.dart';

/// Signing in and the three calls of a registration, as `EmailIdpBaseEndpoint`
/// exposes them: ask for a code, trade the code for a token, set the password.
///
/// The screens take one of these instead of reaching for `client`, so a test
/// can hand them a fake and run the whole flow without a server.
class AuthRepository {
  const AuthRepository();

  /// Signs in and keeps the session, so the auth gate moves on by itself.
  Future<void> login(String email, String password) => _guard(() async {
    final authSuccess = await client.emailIdp.login(
      email: email,
      password: password,
    );
    await client.auth.updateSignedInUser(authSuccess);
  });

  /// Sends a code to [email] and returns the id of the request it belongs to.
  /// In development the code is printed in the `serverpod start` console.
  Future<UuidValue> startRegistration(String email) =>
      _guard(() => client.emailIdp.startRegistration(email: email));

  /// Returns the token that lets [finishRegistration] create the account.
  Future<String> verifyRegistrationCode(UuidValue requestId, String code) =>
      _guard(
        () => client.emailIdp.verifyRegistrationCode(
          accountRequestId: requestId,
          verificationCode: code,
        ),
      );

  /// Creates the account and signs straight into it.
  Future<void> finishRegistration(String token, String password) =>
      _guard(() async {
        final authSuccess = await client.emailIdp.finishRegistration(
          registrationToken: token,
          password: password,
        );
        await client.auth.updateSignedInUser(authSuccess);
      });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw mapServerError(e);
    }
  }
}
