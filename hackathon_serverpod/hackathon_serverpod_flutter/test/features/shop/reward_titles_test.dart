import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/features/shop/reward_titles.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final es = lookupAppLocalizations(const Locale('es'));

  test('a starting reward reads in the app language', () {
    expect(rewardTitle(en, 'Un masaje'), 'A massage');
    expect(rewardTitle(es, 'Un masaje'), 'Un masaje');
  });

  test("a member's own reward stays as written", () {
    expect(rewardTitle(en, 'Pizza el viernes'), 'Pizza el viernes');
  });
}
