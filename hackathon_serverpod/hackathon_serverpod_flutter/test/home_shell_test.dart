import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/data/app_failure.dart';
import 'package:hackathon_serverpod_flutter/home_shell.dart';

void main() {
  test('only a refusal for having no group means leaving it', () {
    expect(
      meansNoGroup(GroupException(reason: GroupErrorReason.noMembership)),
      isTrue,
    );
    expect(meansNoGroup(const AppException(AppFailure.noGroup)), isTrue);
    expect(
      meansNoGroup(GroupException(reason: GroupErrorReason.notAdmin)),
      isFalse,
    );
    expect(meansNoGroup(Exception('sin red')), isFalse);
    expect(meansNoGroup(null), isFalse);
  });

  test('every live event reloads something', () {
    for (final kind in GroupEventKind.values) {
      expect(staleAfter(kind), isNotEmpty, reason: kind.name);
    }
  });

  test('the shop events reload the shop', () {
    for (final kind in [
      GroupEventKind.rewardProposed,
      GroupEventKind.rewardVoteCast,
      GroupEventKind.purchased,
      GroupEventKind.purchaseResponded,
      GroupEventKind.purchaseDelivered,
    ]) {
      expect(staleAfter(kind), contains(HomeData.shop), reason: kind.name);
    }
  });

  test('what moves coins reloads the wallet too', () {
    // A validation pays, a purchase charges, a refusal fines and refunds.
    for (final kind in [
      GroupEventKind.taskValidated,
      GroupEventKind.purchased,
      GroupEventKind.purchaseResponded,
    ]) {
      expect(staleAfter(kind), contains(HomeData.wallet), reason: kind.name);
    }
  });

  test("a member's new name or avatar reloads the member list (#140)", () {
    expect(staleAfter(GroupEventKind.memberUpdated), {HomeData.group});
  });

  test('what moves no coins leaves the wallet alone', () {
    for (final kind in [
      GroupEventKind.taskProposed,
      GroupEventKind.taskClaimed,
      GroupEventKind.rewardProposed,
      GroupEventKind.rewardVoteCast,
      GroupEventKind.purchaseDelivered,
    ]) {
      expect(
        staleAfter(kind),
        isNot(contains(HomeData.wallet)),
        reason: kind.name,
      );
    }
  });
}
