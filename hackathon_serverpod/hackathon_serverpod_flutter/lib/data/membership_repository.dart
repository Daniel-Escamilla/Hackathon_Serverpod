import '../client.dart';
import 'app_failure.dart';

/// Whether the signed-in user belongs to a group yet.
///
/// `GroupGate` takes one of these instead of reaching for `client`, so a test
/// can decide the answer without a server.
class MembershipRepository {
  const MembershipRepository();

  /// True once the caller is in a group. The server refuses `myGroup` with
  /// `GroupErrorReason.noMembership` when they are not, which is an answer,
  /// not a failure; anything else is thrown as an [AppException].
  Future<bool> hasGroup() async {
    try {
      await client.group.myGroup();
      return true;
    } catch (e) {
      final failure = mapServerError(e);
      if (failure.failure == AppFailure.noGroup) return false;
      throw failure;
    }
  }
}
