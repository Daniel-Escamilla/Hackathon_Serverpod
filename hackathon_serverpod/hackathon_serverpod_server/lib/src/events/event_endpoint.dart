import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../groups/current_member.dart';
import 'event_service.dart';

/// Live updates for the signed-in member's group (PRODUCT.md §10.4, issue #65).
class EventEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Subscribes to the group's Stream: every `GroupEvent` published for it
  /// from this point on, until the client stops listening.
  Stream<GroupEvent> watchGroup(Session session) async* {
    final member = await currentGroupMember(session);
    yield* session.messages.createStream<GroupEvent>(
      groupEventChannel(member.groupId),
    );
  }
}
