import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  /// Like the base call, except that an email with an account is refused with
  /// [RegistrationErrorReason.emailAlreadyRegistered] instead of getting a
  /// dummy request id, so the app can send that person to sign-in.
  ///
  /// This tells anyone whether an email has an account here. The team chose
  /// that over leaving a returning user stuck on a code that never arrives.
  @override
  Future<UuidValue> startRegistration(
    Session session, {
    required String email,
  }) async {
    final taken = await EmailAccount.db.count(
      session,
      // The same normalisation the identity provider stores emails with.
      where: (t) => t.email.equals(email.trim().toLowerCase()),
    );
    if (taken > 0) {
      throw RegistrationException(
        reason: RegistrationErrorReason.emailAlreadyRegistered,
      );
    }
    return super.startRegistration(session, email: email);
  }
}
