import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

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
/// endpoints declare `GroupException`; the task and shop endpoints still throw
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
  }),
  _ => const AppException(AppFailure.unknown),
};
