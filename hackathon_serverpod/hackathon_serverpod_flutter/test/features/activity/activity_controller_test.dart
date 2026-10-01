import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/features/activity/activity_controller.dart';

const me = 1;
const other = 2;

GroupEvent event(GroupEventKind kind, {int? actor, int? taskId}) => GroupEvent(
  groupId: 1,
  kind: kind,
  taskId: taskId,
  actorMemberId: actor,
  occurredAt: DateTime.utc(2026, 9, 30),
);

void main() {
  late ActivityController controller;

  setUp(() => controller = ActivityController(myMemberId: () => me));

  test("another member's action is kept and counts as unread", () {
    final kept = controller.add(
      event(GroupEventKind.taskProposed, actor: other),
    );

    expect(kept, isTrue);
    expect(controller.items, hasLength(1));
    expect(controller.unreadCount, 1);
    expect(controller.hasUnread, isTrue);
  });

  test('my own action is left out', () {
    final kept = controller.add(event(GroupEventKind.taskProposed, actor: me));

    expect(kept, isFalse);
    expect(controller.items, isEmpty);
    expect(controller.hasUnread, isFalse);
  });

  test('the newest notice comes first', () {
    controller
      ..add(event(GroupEventKind.taskProposed, actor: other, taskId: 1))
      ..add(event(GroupEventKind.taskClaimed, actor: other, taskId: 2));

    expect(controller.items.map((e) => e.taskId), [2, 1]);
  });

  test('opening Activity marks everything as read and keeps the list', () {
    controller
      ..add(event(GroupEventKind.taskProposed, actor: other))
      ..add(event(GroupEventKind.rewardProposed, actor: other));

    controller.markAllRead();

    expect(controller.unreadCount, 0);
    expect(controller.items, hasLength(2));
  });

  test('before the group loads nothing is filtered out', () {
    controller = ActivityController(myMemberId: () => null);

    expect(
      controller.add(event(GroupEventKind.taskProposed, actor: me)),
      isTrue,
    );
  });

  test('only the latest ones are kept', () {
    for (var i = 0; i < ActivityController.maxItems + 5; i++) {
      controller.add(event(GroupEventKind.taskProposed, actor: other));
    }

    expect(controller.items, hasLength(ActivityController.maxItems));
    expect(controller.unreadCount, ActivityController.maxItems);
  });
}
