/// When the weekly ranking's week starts: Monday at 00:00 in Madrid, the
/// team's and the video's time zone (decided 5 October, PRODUCT.md §4.6).
///
/// Dart has no time zone database, and adding one for a single zone is more
/// than this needs, so the EU rule is written out: summer time (UTC+2) from
/// the last Sunday of March to the last Sunday of October, both at 01:00 UTC;
/// UTC+1 the rest of the year. The clocks change on a Sunday night, so a
/// Monday midnight is never ambiguous.
DateTime startOfWeekMadrid(DateTime now) {
  final utc = now.toUtc();
  final wall = utc.add(madridOffset(utc));
  final mondayWall = DateTime.utc(
    wall.year,
    wall.month,
    wall.day,
  ).subtract(Duration(days: wall.weekday - DateTime.monday));
  // Midnight's offset is the one an hour before it in UTC terms: no change
  // falls between Sunday 22:00 UTC and Monday 00:00 UTC.
  final guess = mondayWall.subtract(const Duration(hours: 1));
  return mondayWall.subtract(madridOffset(guess));
}

/// Madrid's offset from UTC at the instant [utc].
Duration madridOffset(DateTime utc) {
  final t = utc.toUtc();
  final summerStarts = _lastSundayAt1Utc(t.year, DateTime.march);
  final summerEnds = _lastSundayAt1Utc(t.year, DateTime.october);
  final summer = !t.isBefore(summerStarts) && t.isBefore(summerEnds);
  return Duration(hours: summer ? 2 : 1);
}

DateTime _lastSundayAt1Utc(int year, int month) {
  final lastDay = DateTime.utc(year, month + 1, 0);
  final back = lastDay.weekday % 7; // Sunday is 7, so it goes back 0 days.
  return DateTime.utc(year, month, lastDay.day - back, 1);
}
