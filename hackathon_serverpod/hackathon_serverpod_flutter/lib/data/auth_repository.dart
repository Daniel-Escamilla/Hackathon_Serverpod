import 'package:flutter/foundation.dart';
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

  /// The session on this device: null while nobody is signed in. Changes
  /// whenever someone signs in or out.
  ValueListenable<AuthSuccess?> get session => client.auth.authInfoListenable;

  /// Who is signed in on this device, or null when nobody is.
  UuidValue? get signedInUserId => session.value?.authUserId;

  Future<void> signOut() => client.auth.signOutDevice();

  /// Signs in and keeps the session, so the auth gate moves on by itself.
  Future<void> login(String email, String password) =>
      guardServerCall(() async {
        final authSuccess = await client.emailIdp.login(
          email: email,
          password: password,
        );
        await client.auth.updateSignedInUser(authSuccess);
      });

  /// Sends a code to [email] and returns the id of the request it belongs to.
  /// In development the code is printed in the `serverpod start` console.
  Future<UuidValue> startRegistration(String email) =>
      guardServerCall(() => client.emailIdp.startRegistration(email: email));

  /// Returns the token that lets [finishRegistration] create the account.
  Future<String> verifyRegistrationCode(UuidValue requestId, String code) =>
      guardServerCall(
        () => client.emailIdp.verifyRegistrationCode(
          accountRequestId: requestId,
          verificationCode: code,
        ),
      );

  /// Creates the account and signs straight into it.
  Future<void> finishRegistration(String token, String password) =>
      guardServerCall(() async {
        final authSuccess = await client.emailIdp.finishRegistration(
          registrationToken: token,
          password: password,
        );
        await client.auth.updateSignedInUser(authSuccess);
      });
}
