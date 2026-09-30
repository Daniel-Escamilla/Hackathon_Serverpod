import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/features/auth/google_sign_in_button.dart';

import '../../helpers/harness.dart';

void main() {
  testWidgets('tapping it runs the Google sign-in', (tester) async {
    var calls = 0;
    await openScreen(
      tester,
      GoogleSignInButton(signIn: () async => calls++),
    );

    await tapLabel(tester, 'Entrar con Google');

    expect(calls, 1);
  });

  testWidgets('a failed sign-in says so', (tester) async {
    await openScreen(
      tester,
      // On a Scaffold, like the welcome screen, so the message shows.
      Scaffold(
        body: GoogleSignInButton(signIn: () async => throw Exception('no')),
      ),
    );

    await tapLabel(tester, 'Entrar con Google');

    expect(find.text('No se pudo entrar con Google.'), findsOneWidget);
  });
}
