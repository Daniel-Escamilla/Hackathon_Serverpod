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
    AppFailure.tooManyAttempts => l10n.authErrorTooManyAttempts,
    AppFailure.noGroup || AppFailure.unknown => l10n.errorGeneric,
  };
}

/// The message for anything thrown by a repository.
String failureMessage(Object error, AppLocalizations l10n) =>
    error is AppException ? error.failure.message(l10n) : l10n.errorGeneric;
