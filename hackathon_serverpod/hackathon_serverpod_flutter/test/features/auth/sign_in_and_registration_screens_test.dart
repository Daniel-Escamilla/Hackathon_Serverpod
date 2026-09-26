import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/data/app_failure.dart';
import 'package:hackathon_serverpod_flutter/data/auth_repository.dart';
import 'package:hackathon_serverpod_flutter/features/auth/create_account_code_screen.dart';
import 'package:hackathon_serverpod_flutter/features/auth/create_account_email_screen.dart';
import 'package:hackathon_serverpod_flutter/features/auth/create_account_password_screen.dart';
import 'package:hackathon_serverpod_flutter/features/auth/sign_in_screen.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../../helpers/harness.dart';

final requestId = UuidValue.fromString('00000000-0000-4000-8000-000000000002');

/// Records every call instead of reaching the server, or fails it on demand.
class FakeAuthRepository extends AuthRepository {
  final calls = <String>[];
  AppFailure? failWith;

  void _record(String call) {
    if (failWith != null) throw AppException(failWith!);
    calls.add(call);
  }

  @override
  Future<void> login(String email, String password) async {
    _record('login $email $password');
  }

  @override
  Future<UuidValue> startRegistration(String email) async {
    _record('start $email');
    return requestId;
  }

  @override
  Future<String> verifyRegistrationCode(
    UuidValue requestId,
    String code,
  ) async {
    _record('verify $code');
    return 'token';
  }

  @override
  Future<void> finishRegistration(String token, String password) async {
    _record('finish $token $password');
  }
}

void main() {
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository());

  test('each sign-in refusal from the server gets its own failure', () {
    AppFailure mapped(EmailAccountLoginExceptionReason reason) =>
        mapServerError(EmailAccountLoginException(reason: reason)).failure;

    expect(EmailAccountLoginExceptionReason.values.map(mapped), [
      AppFailure.invalidCredentials,
      AppFailure.tooManyAttempts,
      AppFailure.unknown,
    ]);
  });

  test('each registration refusal from the server gets its own failure', () {
    AppFailure mapped(EmailAccountRequestExceptionReason reason) =>
        mapServerError(EmailAccountRequestException(reason: reason)).failure;

    expect(EmailAccountRequestExceptionReason.values.map(mapped), [
      AppFailure.registrationExpired,
      AppFailure.registrationInvalid,
      AppFailure.passwordPolicy,
      AppFailure.tooManyAttempts,
      AppFailure.unknown,
    ]);
  });

  group('sign-in', () {
    Future<void> signIn(WidgetTester tester) async {
      await openScreen(tester, SignInScreen(auth: repository));
      await tester.enterText(find.byType(TextField).first, ' ana@email.com ');
      await tester.enterText(find.byType(TextField).last, 'clave');
      await tapLabel(tester, 'Entrar');
    }

    testWidgets('signs in with the trimmed email and goes back', (
      tester,
    ) async {
      await signIn(tester);

      expect(repository.calls, ['login ana@email.com clave']);
      expect(find.text('pestaña'), findsOneWidget);
    });

    testWidgets('wrong credentials say so and stay', (tester) async {
      repository.failWith = AppFailure.invalidCredentials;
      await signIn(tester);

      expect(find.text('Email o contraseña incorrectos.'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('too many tries says so', (tester) async {
      repository.failWith = AppFailure.tooManyAttempts;
      await signIn(tester);

      expect(
        find.text('Demasiados intentos. Prueba en unos minutos.'),
        findsOneWidget,
      );
    });

    testWidgets('anything else reads as a failed sign-in', (tester) async {
      repository.failWith = AppFailure.unknown;
      await signIn(tester);

      expect(find.text('No se pudo iniciar sesión.'), findsOneWidget);
    });
  });

  testWidgets('registration runs its three steps and goes back', (
    tester,
  ) async {
    await openScreen(tester, CreateAccountEmailScreen(repository: repository));
    await tester.enterText(find.byType(TextField), 'ana@email.com');
    await tapLabel(tester, 'Continuar');

    expect(find.textContaining('ana@email.com'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '123456');
    await tapLabel(tester, 'Verificar');

    await tester.enterText(find.byType(TextField), 'clave-nueva');
    await tapLabel(tester, 'Crear cuenta');

    expect(repository.calls, [
      'start ana@email.com',
      'verify 123456',
      'finish token clave-nueva',
    ]);
    expect(find.text('pestaña'), findsOneWidget);
  });

  group('email step', () {
    Future<void> submitEmail(WidgetTester tester) async {
      await openScreen(
        tester,
        CreateAccountEmailScreen(repository: repository),
      );
      await tester.enterText(find.byType(TextField), 'ana@email.com');
      await tapLabel(tester, 'Continuar');
    }

    testWidgets('too many requests says so', (tester) async {
      repository.failWith = AppFailure.tooManyAttempts;
      await submitEmail(tester);

      expect(
        find.text('Demasiados intentos. Prueba en unos minutos.'),
        findsOneWidget,
      );
    });

    testWidgets('a refused email asks whether the account exists', (
      tester,
    ) async {
      repository.failWith = AppFailure.registrationInvalid;
      await submitEmail(tester);

      expect(
        find.text(
          'No se pudo empezar el registro. ¿Ya tienes cuenta con ese email?',
        ),
        findsOneWidget,
      );
    });

    testWidgets('anything else reads as a failed start', (tester) async {
      repository.failWith = AppFailure.unknown;
      await submitEmail(tester);

      expect(find.text('No se pudo empezar el registro.'), findsOneWidget);
    });
  });

  group('code step', () {
    Future<void> submitCode(WidgetTester tester) async {
      await openScreen(
        tester,
        CreateAccountCodeScreen(
          email: 'ana@email.com',
          accountRequestId: requestId,
          repository: repository,
        ),
      );
      await tester.enterText(find.byType(TextField), '000000');
      await tapLabel(tester, 'Verificar');
    }

    testWidgets('a wrong code says so and stays', (tester) async {
      repository.failWith = AppFailure.registrationInvalid;
      await submitCode(tester);

      expect(find.text('Código incorrecto.'), findsOneWidget);
      expect(find.text('Verificar'), findsOneWidget);
    });

    testWidgets('an expired code asks to start again', (tester) async {
      repository.failWith = AppFailure.registrationExpired;
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

  group('password step', () {
    Future<void> submitPassword(WidgetTester tester) async {
      await openScreen(
        tester,
        CreateAccountPasswordScreen(
          registrationToken: 'token',
          repository: repository,
        ),
      );
      await tester.enterText(find.byType(TextField), 'x');
      await tapLabel(tester, 'Crear cuenta');
    }

    testWidgets('a password against the policy says so', (tester) async {
      repository.failWith = AppFailure.passwordPolicy;
      await submitPassword(tester);

      expect(
        find.text('La contraseña no cumple los requisitos.'),
        findsOneWidget,
      );
    });

    testWidgets('an expired registration asks to start again', (
      tester,
    ) async {
      repository.failWith = AppFailure.registrationExpired;
      await submitPassword(tester);

      expect(
        find.text('La sesión de registro ha caducado. Vuelve a empezar.'),
        findsOneWidget,
      );
    });

    testWidgets('anything else reads as a failed account', (tester) async {
      repository.failWith = AppFailure.unknown;
      await submitPassword(tester);

      expect(find.text('No se pudo crear la cuenta.'), findsOneWidget);
    });
  });
}
