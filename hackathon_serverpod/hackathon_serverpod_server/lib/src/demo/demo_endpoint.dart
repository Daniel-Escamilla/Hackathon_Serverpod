import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import 'demo_seeder.dart';

/// Rebuilds the judges' demo couple (PRODUCT.md §14), called by
/// `scripts/sembrar_demo.sh`. Public, because the script signs in as nobody,
/// but dead unless the server's `passwords.yaml` has both `demoSeedSecret`
/// and `demoAccountPassword`: a server without them refuses every call.
class DemoEndpoint extends Endpoint {
  final DemoSeeder _seeder = const DemoSeeder();

  /// Wipes and re-creates the demo group when [secret] is the server's
  /// `demoSeedSecret`, and returns its invite code. Null when refused, with
  /// no hint of why.
  Future<String?> reseed(Session session, String secret) async {
    final expected = session.passwords['demoSeedSecret'];
    final password = session.passwords['demoAccountPassword'];
    if (expected == null || expected.isEmpty || password == null) return null;
    if (!_sameSecret(secret, expected)) {
      session.log('Demo reseed refused: wrong secret', level: LogLevel.warning);
      return null;
    }
    return _seeder.reseed(session, password: password);
  }

  /// Compares without stopping at the first different byte, so the time it
  /// takes says nothing about how much of the secret was right.
  bool _sameSecret(String given, String expected) {
    final a = utf8.encode(given);
    final b = utf8.encode(expected);
    var diff = a.length ^ b.length;
    for (var i = 0; i < b.length; i++) {
      diff |= (i < a.length ? a[i] : 0) ^ b[i];
    }
    return diff == 0;
  }
}
