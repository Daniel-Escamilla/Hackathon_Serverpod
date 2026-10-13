import 'package:serverpod/serverpod.dart';

import '../events/event_service.dart';
import '../generated/protocol.dart';
import '../wallet/week.dart';

/// Today in Madrid, as UTC midnight of that calendar day: what a mission's
/// `lastSpawnedOn` holds, and whose `weekday` is matched against its
/// `weekdays` (PRODUCT.md §5).
DateTime madridDay(DateTime now) {
  final utc = now.toUtc();
  final wall = utc.add(madridOffset(utc));
  return DateTime.utc(wall.year, wall.month, wall.day);
}

/// Puts each scheduled mission's task on the board on its weekdays
/// (PRODUCT.md §5). Runs when the home's tasks are listed, so the task
/// appears the first time anyone opens the app that day, and every other
/// phone hears about it on the group's stream.
class MissionService {
  const MissionService({this.eventService = const EventService()});

  final EventService eventService;

  /// Spawns today's tasks for [groupId]'s missions that are due and have not
  /// spawned yet today. Repetitions do not pile up: while the previous one is
  /// still open or being validated, the day passes without a new one.
  Future<void> spawnDue(
    Session session, {
    required int groupId,
    DateTime? now,
  }) async {
    final today = madridDay(now ?? DateTime.now());
    final missions = await Task.db.find(
      session,
      where: (t) =>
          t.groupId.equals(groupId) & t.status.equals(TaskStatus.scheduled),
    );
    for (final mission in missions) {
      if (!_isDue(mission, today)) continue;
      final spawned = await session.db.transaction((transaction) async {
        final locked = await Task.db.findById(
          session,
          mission.id!,
          transaction: transaction,
          lockMode: LockMode.forNoKeyUpdate,
        );
        if (locked == null ||
            locked.status != TaskStatus.scheduled ||
            !_isDue(locked, today)) {
          return null;
        }
        await Task.db.updateRow(
          session,
          locked.copyWith(lastSpawnedOn: today),
          transaction: transaction,
        );
        final pending = await Task.db.count(
          session,
          where: (t) =>
              t.missionId.equals(locked.id!) &
              t.status.inSet({TaskStatus.open, TaskStatus.inValidation}),
          transaction: transaction,
        );
        if (pending > 0) return null;
        return Task.db.insertRow(
          session,
          Task(
            groupId: locked.groupId,
            title: locked.title,
            description: locked.description,
            reward: locked.reward,
            icon: locked.icon,
            proposedById: locked.proposedById,
            status: TaskStatus.open,
            missionId: locked.id,
          ),
          transaction: transaction,
        );
      });
      if (spawned != null) {
        await eventService.publish(
          session,
          groupId: groupId,
          kind: GroupEventKind.missionDue,
          actorMemberId: null,
          taskId: spawned.id,
        );
      }
    }
  }

  bool _isDue(Task mission, DateTime today) =>
      (mission.weekdays ?? const []).contains(today.weekday) &&
      mission.lastSpawnedOn?.isAtSameMomentAs(today) != true;
}
