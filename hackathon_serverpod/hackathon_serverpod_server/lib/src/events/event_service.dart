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
/// issue names — propuesta, voto, contraoferta, validación, compra — not
/// every state change (marking a task done, a shop vote or purchase
/// response don't publish yet).
class EventService {
  const EventService();

  Future<void> publish(
    Session session, {
    required int groupId,
    required GroupEventKind kind,
    int? taskId,
    int? purchaseId,
  }) {
    return session.messages.postMessage(
      groupEventChannel(groupId),
      GroupEvent(
        groupId: groupId,
        kind: kind,
        taskId: taskId,
        purchaseId: purchaseId,
        occurredAt: DateTime.now().toUtc(),
      ),
    );
  }
}
