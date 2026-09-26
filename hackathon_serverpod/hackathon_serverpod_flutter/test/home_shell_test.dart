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
}
