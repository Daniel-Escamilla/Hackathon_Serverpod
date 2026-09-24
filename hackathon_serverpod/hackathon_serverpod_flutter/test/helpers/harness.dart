import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/common/navigation.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_controller.dart';
import 'package:hackathon_serverpod_flutter/features/shop/shop_controller.dart';
import 'package:hackathon_serverpod_flutter/features/tasks/tasks_controller.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

/// Records every call instead of reaching the server, or fails it on demand.
class FakeTasksController extends TasksController {
  final calls = <String>[];
  Object? failWith;

  Future<Task> _record(String call, int taskId) async {
    if (failWith != null) throw failWith!;
    calls.add(call);
    return Task(
      id: taskId,
      groupId: 1,
      title: 't',
      description: 'd',
      reward: 10,
      proposedById: 1,
    );
  }

  @override
  Future<Task> voteTaskProposal(int taskId, bool approve) =>
      _record('proposal $taskId $approve', taskId);

  @override
  Future<Task> respondToCounterOffer(int taskId, bool accept) =>
      _record('counter $taskId $accept', taskId);

  @override
  Future<Task> markTaskDone(int taskId) => _record('done $taskId', taskId);

  @override
  Future<Task> voteTaskCompletion(int taskId, bool approve) =>
      _record('completion $taskId $approve', taskId);
}

class FakeShopController extends ShopController {
  final calls = <String>[];
  Object? failWith;

  Future<void> _record(String call) async {
    if (failWith != null) throw failWith!;
    calls.add(call);
  }

  @override
  Future<void> voteReward(int itemId, bool approve) =>
      _record('vote $itemId $approve');

  @override
  Future<void> respondToPurchase(int purchaseId, bool accept) =>
      _record('respond $purchaseId $accept');

  @override
  Future<void> markDelivered(int purchaseId) =>
      _record('delivered $purchaseId');

  @override
  Future<Purchase> purchaseReward(int itemId, int providerId) async {
    await _record('buy $itemId from $providerId');
    return Purchase(
      id: 1,
      groupId: 1,
      itemId: itemId,
      buyerId: 1,
      providerId: providerId,
    );
  }
}

/// Members without a signed-in session: the id of "me" is set by hand.
class FakeGroupController extends GroupController {
  FakeGroupController({this.me, List<GroupMember>? members}) {
    this.members = members ?? [];
    hasLoaded = true;
  }

  final int? me;

  @override
  int? get myMemberId => me;
}

GroupMember member(int id, String name) => GroupMember(
  id: id,
  groupId: 1,
  authUserId: UuidValue.fromString(
    '00000000-0000-4000-8000-${id.toString().padLeft(12, '0')}',
  ),
  displayName: name,
  role: GroupMemberRole.member,
);

/// Opens [screen] the way the app does — pushed from a tab that has the
/// controllers above it — so popping back and reading a controller behave
/// as they do for real.
Future<void> openScreen(
  WidgetTester tester,
  Widget screen, {
  TasksController? tasks,
  ShopController? shop,
  GroupController? group,
}) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TasksController>.value(
          value: tasks ?? FakeTasksController(),
        ),
        ChangeNotifierProvider<ShopController>.value(
          value: shop ?? FakeShopController(),
        ),
        ChangeNotifierProvider<GroupController>.value(
          value: group ?? FakeGroupController(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => pushPage(context, screen),
              child: const Text('pestaña'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('pestaña'));
  await tester.pumpAndSettle();
}

/// Taps a button by its label, scrolling to it first if it is off screen.
Future<void> tapLabel(WidgetTester tester, String label) async {
  final finder = find.text(label).last;
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
