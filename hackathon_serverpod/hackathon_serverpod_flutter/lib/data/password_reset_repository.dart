import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../client.dart';
import 'app_failure.dart';

/// The three calls of a password reset, as `EmailIdpBaseEndpoint` exposes
/// them: ask for a code, trade the code for a token, set the new password.
///
/// The screens take one of these instead of reaching for `client`, so a test
/// can hand them a fake and run the whole flow without a server.
class PasswordResetRepository {
  const PasswordResetRepository();

  /// Sends a code to [email] and returns the id of the request it belongs to.
  /// In development the code is printed in the `serverpod start` console.
  Future<UuidValue> sendCode(String email) =>
      _guard(() => client.emailIdp.startPasswordReset(email: email));

  /// Returns the token that lets [setPassword] finish the request.
  Future<String> verifyCode(UuidValue requestId, String code) => _guard(
    () => client.emailIdp.verifyPasswordResetCode(
      passwordResetRequestId: requestId,
      verificationCode: code,
    ),
  );

  Future<void> setPassword(String token, String newPassword) => _guard(
    () => client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: token,
      newPassword: newPassword,
    ),
  );

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw mapServerError(e);
    }
  }
}
