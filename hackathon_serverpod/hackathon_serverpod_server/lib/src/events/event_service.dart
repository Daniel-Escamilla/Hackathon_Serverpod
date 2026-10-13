import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// The `session.messages` channel a group's live events are posted to and
/// watched on (PRODUCT.md §10.4, issue #65). Single-instance only: fanning
/// this out across multiple server instances needs Redis enabled, which this
/// project doesn't run.
String groupEventChannel(int groupId) => 'group-events-$groupId';

/// Publishes to a group's live Stream (PRODUCT.md §10.4, issue #65): every
/// member's app watching `EventEndpoint.watchGroup` gets the event the
/// moment it's posted here, no reload needed. Covers the five moments the
/// issue names — propuesta, voto, contraoferta, validación, compra — plus a
/// task being claimed as done, a member being expelled, and the shop: a reward
/// proposed or voted, and a purchase answered or delivered.
class EventService {
  const EventService();

  Future<void> publish(
    Session session, {
    required int groupId,
    required GroupEventKind kind,
    // Required, even as null, so no caller forgets to say who acted.
    required int? actorMemberId,
    int? taskId,
    int? purchaseId,
    int? rewardId,
    int? memberId,
  }) {
    return session.messages.postMessage(
      groupEventChannel(groupId),
      GroupEvent(
        groupId: groupId,
        kind: kind,
        taskId: taskId,
        purchaseId: purchaseId,
        rewardId: rewardId,
        memberId: memberId,
        actorMemberId: actorMemberId,
        occurredAt: DateTime.now().toUtc(),
      ),
    );
  }
}
