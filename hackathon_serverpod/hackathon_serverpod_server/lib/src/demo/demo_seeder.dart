import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../generated/protocol.dart';
import '../groups/invite_code.dart';
import '../shop/shop_service.dart';
import '../tasks/task_service.dart';

/// One of the two demo accounts handed to the judges.
typedef DemoAccount = ({
  String email,
  String name,
  String avatar,
  String color,
});

/// The couple the judges sign in as: a cycle needs two people and a judge
/// opens the app alone (PRODUCT.md §14). `example.com` is reserved, so these
/// addresses can never reach a real inbox. The avatars are two of the app's
/// house characters.
const demoAccounts = <DemoAccount>[
  (
    email: 'ana.demo@example.com',
    name: 'Ana',
    avatar: 'planta',
    color: 'coral',
  ),
  (
    email: 'leo.demo@example.com',
    name: 'Leo',
    avatar: 'calcetin',
    color: 'sky',
  ),
];

/// Builds the judges' couple group from scratch, through the same services
/// the app uses, so what they find is what the app would have made.
///
/// What they get: a settled history (tasks paid, one fine, a purchase waiting
/// to be delivered), two tasks open to claim and the couple's shop. No vote is
/// left open: it would close by itself after the vote window and fine whoever
/// had not voted, so the judges start every vote themselves.
///
/// Safe to run again: it first removes the groups the demo accounts are in.
/// A group with anybody else in it is left alone and only the demo account
/// leaves it.
class DemoSeeder {
  const DemoSeeder({
    this.taskService = const TaskService(),
    this.shopService = const ShopService(),
  });

  final TaskService taskService;
  final ShopService shopService;

  /// Returns the new group's invite code.
  Future<String> reseed(Session session, {required String password}) async {
    final authUserIds = [
      for (final account in demoAccounts)
        await _ensureAccount(session, account.email, password),
    ];
    await _clearGroups(session, authUserIds.toSet());

    final group = await Group.db.insertRow(
      session,
      Group(
        name: 'Casa de Ana y Leo',
        type: GroupType.couple,
        inviteCode: await freeInviteCode(session),
      ),
    );
    final ana = await _addMember(
      session,
      group,
      authUserIds[0],
      demoAccounts[0],
      GroupMemberRole.admin,
    );
    final leo = await _addMember(
      session,
      group,
      authUserIds[1],
      demoAccounts[1],
      GroupMemberRole.member,
    );
    await shopService.seedRewardTemplates(
      session,
      group: group,
      createdBy: ana,
    );

    // Paid, each validated by whoever proposed it.
    await _paidTask(session, 'Limpiar el baño', 25, proposer: ana, doer: leo);
    await _paidTask(session, 'Hacer la compra', 15, proposer: leo, doer: ana);
    await _paidTask(session, 'Fregar los platos', 20, proposer: ana, doer: leo);

    // Fined: Leo says he took the rubbish out, Ana says he did not.
    final rubbish = await _openTask(
      session,
      'Sacar la basura',
      5,
      proposer: leo,
      voter: ana,
    );
    final claimed = await taskService.markDone(
      session,
      task: rubbish,
      claimant: leo,
    );
    await taskService.castCompletionVote(
      session,
      task: claimed,
      voter: ana,
      approve: false,
    );

    // Open to claim, one of them after a counter-offer: Leo offers 8 instead
    // of 10 and Ana accepts, which restarts the vote.
    final laundry = await taskService.proposeTask(
      session,
      proposer: ana,
      title: 'Poner una lavadora',
      description: '',
      reward: 10,
    );
    final countered = await taskService.counterOfferTask(
      session,
      task: laundry,
      voter: leo,
      counterReward: 8,
    );
    final restarted = await taskService.respondToCounterOffer(
      session,
      task: countered,
      author: ana,
      accept: true,
    );
    await taskService.castProposalVote(
      session,
      task: restarted,
      voter: leo,
      approve: true,
    );
    await _openTask(
      session,
      'Regar las plantas',
      10,
      proposer: leo,
      voter: ana,
    );

    // Bought and accepted, waiting for Ana to deliver it.
    final series = await RewardItem.db.findFirstRow(
      session,
      where: (t) =>
          t.groupId.equals(group.id!) &
          t.title.equals('Elijo yo la serie esta noche'),
    );
    if (series != null) {
      final purchase = await shopService.purchase(
        session,
        item: series,
        buyer: (await GroupMember.db.findById(session, leo.id!))!,
        provider: ana,
      );
      await shopService.respond(
        session,
        purchase: purchase,
        item: series,
        group: group,
        accept: true,
      );
    }

    return group.inviteCode;
  }

  /// The account's auth user, created if missing. The password is set every
  /// time, so a judge who changed it cannot lock the next one out.
  Future<UuidValue> _ensureAccount(
    Session session,
    String email,
    String password,
  ) async {
    final emailIdp = AuthServices.instance.emailIdp;
    final existing = await emailIdp.admin.findAccount(session, email: email);
    if (existing != null) {
      await emailIdp.admin.setPassword(
        session,
        email: email,
        password: password,
      );
      return existing.authUserId;
    }
    final user = await AuthServices.instance.authUsers.create(session);
    await emailIdp.admin.createEmailAuthentication(
      session,
      authUserId: user.id,
      email: email,
      password: password,
    );
    return user.id;
  }

  Future<void> _clearGroups(Session session, Set<UuidValue> demoUsers) async {
    final memberships = await GroupMember.db.find(
      session,
      where: (t) => t.authUserId.inSet(demoUsers) & t.leftAt.equals(null),
    );
    for (final groupId in memberships.map((m) => m.groupId).toSet()) {
      final active = await GroupMember.db.find(
        session,
        where: (t) => t.groupId.equals(groupId) & t.leftAt.equals(null),
      );
      if (active.every((m) => demoUsers.contains(m.authUserId))) {
        await _deleteGroup(session, groupId);
      } else {
        final now = DateTime.now().toUtc();
        for (final member in active.where(
          (m) => demoUsers.contains(m.authUserId),
        )) {
          await GroupMember.db.updateRow(
            session,
            member.copyWith(leftAt: now),
          );
        }
      }
    }
  }

  /// Deletes the group and everything in it. The foreign keys are
  /// `ON DELETE NO ACTION`, so the rows go children first, in one
  /// transaction: a failure halfway leaves the group as it was.
  Future<void> _deleteGroup(Session session, int groupId) async {
    await session.db.transaction((transaction) async {
      final memberIds = {
        for (final m in await GroupMember.db.find(
          session,
          where: (t) => t.groupId.equals(groupId),
          transaction: transaction,
        ))
          m.id!,
      };
      final taskIds = {
        for (final t in await Task.db.find(
          session,
          where: (t) => t.groupId.equals(groupId),
          transaction: transaction,
        ))
          t.id!,
      };
      final itemIds = {
        for (final i in await RewardItem.db.find(
          session,
          where: (t) => t.groupId.equals(groupId),
          transaction: transaction,
        ))
          i.id!,
      };

      if (taskIds.isNotEmpty) {
        await TaskVote.db.deleteWhere(
          session,
          where: (t) => t.taskId.inSet(taskIds),
          transaction: transaction,
        );
      }
      if (itemIds.isNotEmpty) {
        await RewardVote.db.deleteWhere(
          session,
          where: (t) => t.itemId.inSet(itemIds),
          transaction: transaction,
        );
      }
      await Purchase.db.deleteWhere(
        session,
        where: (t) => t.groupId.equals(groupId),
        transaction: transaction,
      );
      await CoinTransaction.db.deleteWhere(
        session,
        where: (t) => t.groupId.equals(groupId),
        transaction: transaction,
      );
      if (memberIds.isNotEmpty) {
        await ChildLoginCode.db.deleteWhere(
          session,
          where: (t) => t.memberId.inSet(memberIds),
          transaction: transaction,
        );
      }
      await Task.db.deleteWhere(
        session,
        where: (t) => t.groupId.equals(groupId),
        transaction: transaction,
      );
      await RewardItem.db.deleteWhere(
        session,
        where: (t) => t.groupId.equals(groupId),
        transaction: transaction,
      );
      await GroupMember.db.deleteWhere(
        session,
        where: (t) => t.groupId.equals(groupId),
        transaction: transaction,
      );
      await Group.db.deleteWhere(
        session,
        where: (t) => t.id.equals(groupId),
        transaction: transaction,
      );
    });
  }

  Future<GroupMember> _addMember(
    Session session,
    Group group,
    UuidValue authUserId,
    DemoAccount account,
    GroupMemberRole role,
  ) => GroupMember.db.insertRow(
    session,
    GroupMember(
      groupId: group.id!,
      authUserId: authUserId,
      displayName: account.name,
      avatarEmoji: account.avatar,
      avatarColor: account.color,
      role: role,
    ),
  );

  /// Proposed by [proposer] and approved by [voter]: in a couple one vote is
  /// the majority (PRODUCT.md §4.1).
  Future<Task> _openTask(
    Session session,
    String title,
    int reward, {
    required GroupMember proposer,
    required GroupMember voter,
  }) async {
    final task = await taskService.proposeTask(
      session,
      proposer: proposer,
      title: title,
      description: '',
      reward: reward,
    );
    return taskService.castProposalVote(
      session,
      task: task,
      voter: voter,
      approve: true,
    );
  }

  /// Opened by [doer]'s vote, done by [doer] and validated by [proposer],
  /// which pays it.
  Future<void> _paidTask(
    Session session,
    String title,
    int reward, {
    required GroupMember proposer,
    required GroupMember doer,
  }) async {
    final open = await _openTask(
      session,
      title,
      reward,
      proposer: proposer,
      voter: doer,
    );
    final claimed = await taskService.markDone(
      session,
      task: open,
      claimant: doer,
    );
    await taskService.castCompletionVote(
      session,
      task: claimed,
      voter: proposer,
      approve: true,
    );
  }
}
