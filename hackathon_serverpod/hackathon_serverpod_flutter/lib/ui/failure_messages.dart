import '../data/app_failure.dart';
import '../l10n/generated/app_localizations.dart';

/// Turns a failure into the sentence a person reads. Kept out of the
/// repositories so the data layer never holds display text, and out of the
/// widgets so the same failure reads the same everywhere.
extension AppFailureMessage on AppFailure {
  String message(AppLocalizations l10n) => switch (this) {
    AppFailure.inviteCodeNotFound => l10n.errorInviteCode,
    AppFailure.alreadyInGroup => l10n.errorAlreadyInGroup,
    AppFailure.notAdmin => l10n.errorNotAdmin,
    AppFailure.memberNotFound => l10n.errorMemberNotFound,
    AppFailure.cannotExpelSelf => l10n.errorCannotExpelSelf,
    AppFailure.cannotTransferAdmin => l10n.errorCannotTransferAdmin,
    AppFailure.resetExpired => l10n.codeErrorExpired,
    AppFailure.resetCodeInvalid => l10n.codeErrorInvalid,
    AppFailure.passwordPolicy => l10n.passwordErrorPolicy,
    AppFailure.invalidCredentials => l10n.signInErrorInvalidCredentials,
    AppFailure.registrationExpired => l10n.passwordErrorExpired,
    AppFailure.registrationInvalid => l10n.codeErrorInvalid,
    AppFailure.tooManyAttempts => l10n.authErrorTooManyAttempts,
    AppFailure.taskNotFound => l10n.errorTaskNotFound,
    AppFailure.taskNotOpen => l10n.errorTaskNotOpen,
    AppFailure.ownTask => l10n.errorOwnTask,
    AppFailure.notProposer => l10n.errorNotProposer,
    AppFailure.rewardNotFound => l10n.errorRewardNotFound,
    AppFailure.rewardNotOpen => l10n.errorRewardNotOpen,
    AppFailure.ownReward => l10n.errorOwnReward,
    AppFailure.rewardNotAvailable => l10n.errorRewardNotAvailable,
    AppFailure.outOfStock => l10n.errorOutOfStock,
    AppFailure.negativeBalance => l10n.errorNegativeBalance,
    AppFailure.invalidProvider => l10n.errorInvalidProvider,
    AppFailure.purchaseNotFound => l10n.errorPurchaseNotFound,
    AppFailure.purchaseNotOpen => l10n.errorPurchaseNotOpen,
    AppFailure.notProvider => l10n.errorNotProvider,
    AppFailure.noGroup => l10n.errorNoGroup,
    AppFailure.unknown => l10n.errorGeneric,
  };
}

/// The message for anything thrown by a repository, or by a controller that
/// still calls the server directly: a raw server error is mapped first.
/// [fallback] replaces the generic sentence when nothing more specific is
/// known, so a screen can keep its own wording for that case.
String failureMessage(
  Object error,
  AppLocalizations l10n, {
  String? fallback,
}) {
  final failure = failureOf(error);
  return failure == AppFailure.unknown
      ? fallback ?? l10n.errorGeneric
      : failure.message(l10n);
}
