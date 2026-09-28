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

  /// No task with that id in the caller's group.
  taskNotFound,

  /// The task moved on before the action: the vote closed, the counter-offer
  /// was answered, or someone else claimed it first.
  taskNotOpen,

  /// Nobody votes on their own proposal or their own completion.
  ownTask,

  /// Only the proposer answers a counter-offer.
  notProposer,

  /// No reward with that id in the caller's group.
  rewardNotFound,

  /// The reward is no longer being voted on.
  rewardNotOpen,

  /// Nobody votes on a reward they proposed.
  ownReward,

  /// The reward is not in the shop right now.
  rewardNotAvailable,

  /// No stock left.
  outOfStock,

  /// Nothing can be bought with a negative balance.
  negativeBalance,

  /// The provider has to be another member of the group.
  invalidProvider,

  /// No purchase with that id in the caller's group.
  purchaseNotFound,

  /// The purchase was already answered, or is not accepted yet.
  purchaseNotOpen,

  /// Only the member chosen to fulfil a purchase answers or delivers it.
  notProvider,

  /// Anything we cannot be specific about.
  unknown,
}

class AppException implements Exception {
  const AppException(this.failure);

  final AppFailure failure;

  @override
  String toString() => 'AppException(${failure.name})';
}

/// Runs a server call and rethrows whatever it throws as an [AppException],
/// so nothing above `lib/data/` ever sees a server exception.
Future<T> guardServerCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } catch (e) {
    throw mapServerError(e);
  }
}

/// The failure behind anything a repository or a controller threw, mapping a
/// raw server error first.
AppFailure failureOf(Object error) =>
    (error is AppException ? error : mapServerError(error)).failure;

/// Maps a server error onto an [AppFailure].
///
/// Only serialisable exceptions carry a reason across the wire: anything else
/// arrives as a generic failure and becomes [AppFailure.unknown]. The group
/// endpoints declare `GroupException`, the task endpoints `TaskException`, the
/// shop endpoints `ShopException`, and the email identity provider
/// `EmailAccountLoginException`, `EmailAccountRequestException` and
/// `EmailAccountPasswordResetException`.
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
  TaskException(:final reason) => AppException(switch (reason) {
    TaskErrorReason.taskNotFound => AppFailure.taskNotFound,
    TaskErrorReason.notOpen => AppFailure.taskNotOpen,
    TaskErrorReason.ownTask => AppFailure.ownTask,
    TaskErrorReason.notProposer => AppFailure.notProposer,
  }),
  ShopException(:final reason) => AppException(switch (reason) {
    ShopErrorReason.rewardNotFound => AppFailure.rewardNotFound,
    ShopErrorReason.rewardNotOpen => AppFailure.rewardNotOpen,
    ShopErrorReason.ownReward => AppFailure.ownReward,
    ShopErrorReason.rewardNotAvailable => AppFailure.rewardNotAvailable,
    ShopErrorReason.outOfStock => AppFailure.outOfStock,
    ShopErrorReason.negativeBalance => AppFailure.negativeBalance,
    ShopErrorReason.invalidProvider => AppFailure.invalidProvider,
    ShopErrorReason.purchaseNotFound => AppFailure.purchaseNotFound,
    ShopErrorReason.purchaseNotOpen => AppFailure.purchaseNotOpen,
    ShopErrorReason.notProvider => AppFailure.notProvider,
  }),
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
