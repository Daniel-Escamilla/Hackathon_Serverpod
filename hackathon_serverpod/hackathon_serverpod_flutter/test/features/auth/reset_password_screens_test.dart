import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/data/app_failure.dart';
import 'package:hackathon_serverpod_flutter/data/password_reset_repository.dart';
import 'package:hackathon_serverpod_flutter/features/auth/reset_password_code_screen.dart';
import 'package:hackathon_serverpod_flutter/features/auth/reset_password_email_screen.dart';
import 'package:hackathon_serverpod_flutter/features/auth/reset_password_new_screen.dart';
import 'package:hackathon_serverpod_flutter/features/auth/sign_in_screen.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../../helpers/harness.dart';

final requestId = UuidValue.fromString('00000000-0000-4000-8000-000000000001');

/// Records every call instead of reaching the server, or fails it on demand.
class FakePasswordResetRepository extends PasswordResetRepository {
  final calls = <String>[];
  AppFailure? failWith;

  void _record(String call) {
    if (failWith != null) throw AppException(failWith!);
    calls.add(call);
  }

  @override
  Future<UuidValue> sendCode(String email) async {
    _record('send $email');
    return requestId;
  }

  @override
  Future<String> verifyCode(UuidValue requestId, String code) async {
    _record('verify $code');
    return 'token';
  }

  @override
  Future<void> setPassword(String token, String newPassword) async {
    _record('set $token $newPassword');
  }
}

void main() {
  late FakePasswordResetRepository repository;

  setUp(() => repository = FakePasswordResetRepository());

  test('each reset refusal from the server gets its own failure', () {
    AppFailure mapped(EmailAccountPasswordResetExceptionReason reason) =>
        mapServerError(
          EmailAccountPasswordResetException(reason: reason),
        ).failure;

    expect(
      EmailAccountPasswordResetExceptionReason.values.map(mapped),
      [
        AppFailure.resetExpired,
        AppFailure.resetCodeInvalid,
        AppFailure.passwordPolicy,
        AppFailure.tooManyAttempts,
        AppFailure.unknown,
      ],
    );
  });

  testWidgets('from sign-in, the three steps end back on sign-in', (
    tester,
  ) async {
    // Tall enough for the whole sign-in form: its ListView only builds what
    // fits, and the link sits at the bottom.
    tester.view.physicalSize = const Size(2400, 4800);
    addTearDown(tester.view.reset);
    await openScreen(tester, SignInScreen(passwordReset: repository));
    await tester.enterText(find.byType(TextField).first, 'ana@email.com');

    await tapLabel(tester, '¿Has olvidado la contraseña?');
    expect(find.text('ana@email.com'), findsOneWidget);
    await tapLabel(tester, 'Enviar código');

    expect(find.textContaining('ana@email.com'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '123456');
    await tapLabel(tester, 'Verificar');

    await tester.enterText(find.byType(TextField), 'nueva-clave');
    await tapLabel(tester, 'Cambiar contraseña');

    expect(repository.calls, [
      'send ana@email.com',
      'verify 123456',
      'set token nueva-clave',
    ]);
    expect(find.text('Entra en tu cuenta'), findsOneWidget);
    expect(
      find.text('Contraseña cambiada. Entra con la nueva.'),
      findsOneWidget,
    );
  });

  group('email step', () {
    testWidgets('too many requests says so', (tester) async {
      repository.failWith = AppFailure.tooManyAttempts;
      await openScreen(
        tester,
        ResetPasswordEmailScreen(repository: repository),
      );

      await tapLabel(tester, 'Enviar código');

      expect(
        find.text('Demasiados intentos. Prueba en unos minutos.'),
        findsOneWidget,
      );
    });
  });

  group('code step', () {
    Future<void> submitCode(WidgetTester tester) async {
      await openScreen(
        tester,
        ResetPasswordCodeScreen(
          email: 'ana@email.com',
          requestId: requestId,
          repository: repository,
        ),
      );
      await tester.enterText(find.byType(TextField), '000000');
      await tapLabel(tester, 'Verificar');
    }

    testWidgets('a wrong code says so and stays', (tester) async {
      repository.failWith = AppFailure.resetCodeInvalid;
      await submitCode(tester);

      expect(find.text('Código incorrecto.'), findsOneWidget);
      expect(find.text('Verificar'), findsOneWidget);
    });

    testWidgets('an expired code asks to start again', (tester) async {
      repository.failWith = AppFailure.resetExpired;
      await submitCode(tester);

      expect(
        find.text('El código ha caducado. Vuelve a empezar.'),
        findsOneWidget,
      );
    });

    testWidgets('too many tries says so', (tester) async {
      repository.failWith = AppFailure.tooManyAttempts;
      await submitCode(tester);

      expect(
        find.text('Demasiados intentos. Prueba en unos minutos.'),
        findsOneWidget,
      );
    });
  });

  group('new password step', () {
    testWidgets('a password against the policy says so', (tester) async {
      repository.failWith = AppFailure.passwordPolicy;
      await openScreen(
        tester,
        ResetPasswordNewScreen(token: 'token', repository: repository),
      );

      await tester.enterText(find.byType(TextField), 'x');
      await tapLabel(tester, 'Cambiar contraseña');

      expect(
        find.text('La contraseña no cumple los requisitos.'),
        findsOneWidget,
      );
    });
  });
}
