import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/data/app_failure.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations_es.dart';
import 'package:hackathon_serverpod_flutter/ui/failure_messages.dart';

void main() {
  test('each task refusal from the server gets its own failure', () {
    expect(
      TaskErrorReason.values.map(
        (reason) => failureOf(TaskException(reason: reason)),
      ),
      [
        AppFailure.taskNotFound,
        AppFailure.taskNotOpen,
        AppFailure.ownTask,
        AppFailure.notProposer,
      ],
    );
  });

  test('each shop refusal from the server gets its own failure', () {
    expect(
      ShopErrorReason.values.map(
        (reason) => failureOf(ShopException(reason: reason)),
      ),
      [
        AppFailure.rewardNotFound,
        AppFailure.rewardNotOpen,
        AppFailure.ownReward,
        AppFailure.rewardNotAvailable,
        AppFailure.outOfStock,
        AppFailure.negativeBalance,
        AppFailure.invalidProvider,
        AppFailure.purchaseNotFound,
        AppFailure.purchaseNotOpen,
        AppFailure.notProvider,
      ],
    );
  });

  group('failureMessage', () {
    final l10n = AppLocalizationsEs();

    test('reads a raw server error, not only an AppException', () {
      expect(
        failureMessage(TaskException(reason: TaskErrorReason.ownTask), l10n),
        'No puedes votar tu propia tarea.',
      );
    });

    test('having no group reads as such, not as a generic failure', () {
      expect(
        failureMessage(
          GroupException(reason: GroupErrorReason.noMembership),
          l10n,
        ),
        'Ya no estás en este grupo.',
      );
    });

    test('uses the fallback only when nothing more is known', () {
      expect(
        failureMessage(Exception('boom'), l10n, fallback: 'propio'),
        'propio',
      );
      expect(failureMessage(Exception('boom'), l10n), l10n.errorGeneric);
    });
  });
}
