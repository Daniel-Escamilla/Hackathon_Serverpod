import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Excludes 0/O and 1/I/L: easy to read out loud and to type from a phone,
/// which is how a group's code is meant to travel (PRODUCT.md §7).
const _inviteCodeAlphabet = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';
const _inviteCodeLength = 6;

/// A random invite code no group uses yet. Shared by the group endpoint and
/// the demo seeder.
Future<String> freeInviteCode(Session session) async {
  for (var attempt = 0; attempt < 5; attempt++) {
    final code = _generateInviteCode();
    final taken = await Group.db.findFirstRow(
      session,
      where: (t) => t.inviteCode.equals(code),
    );
    if (taken == null) return code;
  }
  // Five collisions in a row out of 887 million codes is not bad luck. It is
  // a server fault, so it stays a plain error rather than a GroupException.
  throw StateError('Could not generate a unique invite code.');
}

String _generateInviteCode() {
  final random = Random.secure();
  return List.generate(
    _inviteCodeLength,
    (_) => _inviteCodeAlphabet[random.nextInt(_inviteCodeAlphabet.length)],
  ).join();
}
