import '../models/season_period.dart';

/// Generates the `weeks` / `months` period slices for a season from its
/// start/end dates. All math is done in UTC so it is DST-safe and consistent
/// with the timestamptz values stored in the DB.
class SeasonPeriodBuilder {
  /// Season end used for slicing: the explicit end_date, or "now" when the
  /// season is still ongoing (end_date is null).
  static DateTime resolveEnd(DateTime? end) => (end ?? DateTime.now()).toUtc();

  /// 7-day rolling chunks from [start] up to (but not into) [end].
  /// week-1 = `[start, start+7d)`, week-2 = `[start+7d, start+14d)`, …
  /// The last chunk is clamped to [end] (so it may be a partial week).
  static List<SeasonPeriod> buildWeeks({
    required DateTime start,
    required DateTime end,
  }) {
    final s = start.toUtc();
    final e = end.toUtc();
    final weeks = <SeasonPeriod>[];
    if (!e.isAfter(s)) return weeks; // empty / inverted season

    var chunkStart = s;
    var n = 1;
    while (chunkStart.isBefore(e)) {
      // Duration math is exact in UTC (no DST shifts).
      var chunkEnd = chunkStart.add(const Duration(days: 7));
      if (chunkEnd.isAfter(e)) chunkEnd = e; // clamp final partial week
      weeks.add(SeasonPeriod(
        number: n,
        name: 'week-$n',
        startDate: chunkStart,
        endDate: chunkEnd,
      ));
      chunkStart = chunkEnd;
      n++;
    }
    return weeks;
  }

  /// Calendar months from [start] to [end].
  /// month-1 = `[start, firstOfNextMonth)` (partial first month),
  /// month-2 = the next full calendar month, … last clamped to [end].
  static List<SeasonPeriod> buildMonths({
    required DateTime start,
    required DateTime end,
  }) {
    final s = start.toUtc();
    final e = end.toUtc();
    final months = <SeasonPeriod>[];
    if (!e.isAfter(s)) return months;

    var chunkStart = s;
    var n = 1;
    while (chunkStart.isBefore(e)) {
      // First instant of the next calendar month after chunkStart.
      final nextMonth = (chunkStart.month == 12)
          ? DateTime.utc(chunkStart.year + 1, 1, 1)
          : DateTime.utc(chunkStart.year, chunkStart.month + 1, 1);
      var chunkEnd = nextMonth;
      if (chunkEnd.isAfter(e)) chunkEnd = e; // clamp final partial month
      months.add(SeasonPeriod(
        number: n,
        name: 'month-$n',
        startDate: chunkStart,
        endDate: chunkEnd,
      ));
      chunkStart = chunkEnd;
      n++;
    }
    return months;
  }
}
