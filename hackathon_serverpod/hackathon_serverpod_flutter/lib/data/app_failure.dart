import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

/// What went wrong, in terms the interface can act on.
///
/// Repositories translate whatever the server threw into one of these, so no
/// widget ever has to read a server message. The text a person sees is chosen
/// in the UI layer, from the ARB — see `ui/failure_messages.dart`.
enum AppFailure {
  /// No group matches that invite code.
  inviteCodeNotFound,

  /// The caller already has an active membership. One group per person.
  alreadyInGroup,

  /// The caller belongs to no group, so the call was refused.
  noGroup,

  /// Only the admin may do that.
  notAdmin,

  /// That member is not in the group, or has already left it.
  memberNotFound,

  /// The admin tried to expel themselves.
  cannotExpelSelf,

  /// The admin role can only go to another member, never to a child.
  cannotTransferAdmin,

  /// The password reset request ran out of time; it has to start again.
  resetExpired,

  /// The password reset code is wrong.
  resetCodeInvalid,

  /// The new password does not meet the server's password policy.
  passwordPolicy,

  /// Wrong email or password on sign-in.
  invalidCredentials,

  /// The registration request ran out of time; it has to start again.
  registrationExpired,

  /// The server refused a registration step: a wrong code, or a request or
  /// token it no longer accepts.
  registrationInvalid,

  /// Too many tries in a row; the server makes the caller wait.
  tooManyAttempts,

  /// Anything we cannot be specific about.
  unknown,
}

class AppException implements Exception {
  const AppException(this.failure);

  final AppFailure failure;

  @override
  String toString() => 'AppException(${failure.name})';
}

/// Maps a server error onto an [AppFailure].
///
/// Only serialisable exceptions carry a reason across the wire: anything else
/// arrives as a generic failure and becomes [AppFailure.unknown]. The group
/// endpoints declare `GroupException`, and the email identity provider
/// `EmailAccountLoginException`, `EmailAccountRequestException` and
/// `EmailAccountPasswordResetException`; the task and shop endpoints still throw
/// plain errors, so their refusals read as the generic message until they get
/// exceptions of their own.
///
/// The inner switch has no wildcard on purpose: a reason added on the server
/// fails the build here until the app decides what it means.
AppException mapServerError(Object error) => switch (error) {
  GroupException(:final reason) => AppException(switch (reason) {
    GroupErrorReason.inviteCodeNotFound => AppFailure.inviteCodeNotFound,
    GroupErrorReason.alreadyInGroup => AppFailure.alreadyInGroup,
    GroupErrorReason.noMembership => AppFailure.noGroup,
    GroupErrorReason.notAdmin => AppFailure.notAdmin,
    GroupErrorReason.memberNotFound => AppFailure.memberNotFound,
    GroupErrorReason.cannotExpelSelf => AppFailure.cannotExpelSelf,
    GroupErrorReason.cannotTransferAdmin => AppFailure.cannotTransferAdmin,
  }),
  EmailAccountPasswordResetException(:final reason) => AppException(
    switch (reason) {
      EmailAccountPasswordResetExceptionReason.expired =>
        AppFailure.resetExpired,
      EmailAccountPasswordResetExceptionReason.invalid =>
        AppFailure.resetCodeInvalid,
      EmailAccountPasswordResetExceptionReason.policyViolation =>
        AppFailure.passwordPolicy,
      EmailAccountPasswordResetExceptionReason.tooManyAttempts =>
        AppFailure.tooManyAttempts,
      EmailAccountPasswordResetExceptionReason.unknown => AppFailure.unknown,
    },
  ),
  EmailAccountLoginException(:final reason) => AppException(switch (reason) {
    EmailAccountLoginExceptionReason.invalidCredentials =>
      AppFailure.invalidCredentials,
    EmailAccountLoginExceptionReason.tooManyAttempts =>
      AppFailure.tooManyAttempts,
    EmailAccountLoginExceptionReason.unknown => AppFailure.unknown,
  }),
  EmailAccountRequestException(:final reason) => AppException(switch (reason) {
    EmailAccountRequestExceptionReason.expired =>
      AppFailure.registrationExpired,
    EmailAccountRequestExceptionReason.invalid =>
      AppFailure.registrationInvalid,
    EmailAccountRequestExceptionReason.policyViolation =>
      AppFailure.passwordPolicy,
    EmailAccountRequestExceptionReason.tooManyAttempts =>
      AppFailure.tooManyAttempts,
    EmailAccountRequestExceptionReason.unknown => AppFailure.unknown,
  }),
  _ => const AppException(AppFailure.unknown),
};
