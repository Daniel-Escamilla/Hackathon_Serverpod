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
/// The endpoints still signal these cases with `StateError`, which is not
/// serialisable, so all the client gets back is the message text. Matching on
/// it is brittle, and deliberately confined to this one function: once the
/// server declares real exceptions in its `.spy.yaml`, this becomes a `switch`
/// on their types and nothing else in the app changes.
AppException mapServerError(Object error) {
  final text = error.toString();
  if (text.contains('No group found for that invite code')) {
    return const AppException(AppFailure.inviteCodeNotFound);
  }
  if (text.contains('already belong to a group')) {
    return const AppException(AppFailure.alreadyInGroup);
  }
  if (text.contains('No active group membership')) {
    return const AppException(AppFailure.noGroup);
  }
  return const AppException(AppFailure.unknown);
}
