import 'package:hackathon_serverpod_server/src/wallet/week.dart';
import 'package:test/test.dart';

void main() {
  group('madridOffset', () {
    test('is +2 in summer and +1 in winter', () {
      expect(madridOffset(DateTime.utc(2026, 7, 1)), const Duration(hours: 2));
      expect(madridOffset(DateTime.utc(2026, 1, 15)), const Duration(hours: 1));
    });

    test('changes on the last Sundays of March and October at 01:00 UTC', () {
      // 2026: 29 March and 25 October.
      expect(
        madridOffset(DateTime.utc(2026, 3, 29, 0, 59)),
        const Duration(hours: 1),
      );
      expect(
        madridOffset(DateTime.utc(2026, 3, 29, 1)),
        const Duration(hours: 2),
      );
      expect(
        madridOffset(DateTime.utc(2026, 10, 25, 0, 59)),
        const Duration(hours: 2),
      );
      expect(
        madridOffset(DateTime.utc(2026, 10, 25, 1)),
        const Duration(hours: 1),
      );
    });
  });

  group('startOfWeekMadrid', () {
    test('a Monday in summer starts at 22:00 UTC on the Sunday', () {
      expect(
        startOfWeekMadrid(DateTime.utc(2026, 10, 5, 10)),
        DateTime.utc(2026, 10, 4, 22),
      );
    });

    test('a Monday in winter starts at 23:00 UTC on the Sunday', () {
      expect(
        startOfWeekMadrid(DateTime.utc(2026, 12, 7, 8)),
        DateTime.utc(2026, 12, 6, 23),
      );
    });

    test('Sunday late at night in UTC is already Monday in Madrid', () {
      // Sunday 23:30 UTC is Monday 01:30 in Madrid.
      expect(
        startOfWeekMadrid(DateTime.utc(2026, 10, 4, 23, 30)),
        DateTime.utc(2026, 10, 4, 22),
      );
    });

    test('Sunday evening in Madrid still belongs to the week before', () {
      // Sunday 21:00 UTC is Sunday 23:00 in Madrid.
      expect(
        startOfWeekMadrid(DateTime.utc(2026, 10, 4, 21)),
        DateTime.utc(2026, 9, 27, 22),
      );
    });

    test('the week after the clocks go back starts in winter time', () {
      expect(
        startOfWeekMadrid(DateTime.utc(2026, 10, 26, 9)),
        DateTime.utc(2026, 10, 25, 23),
      );
    });

    test('a week that holds the change still starts in summer time', () {
      // Saturday 24 October, before the change on Sunday.
      expect(
        startOfWeekMadrid(DateTime.utc(2026, 10, 24, 12)),
        DateTime.utc(2026, 10, 18, 22),
      );
    });
  });
}
