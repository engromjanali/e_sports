/// A single named slice of a season — either a 7-day week or a calendar month.
///
/// [startDate] is inclusive, [endDate] is exclusive (half-open `[start, end)`),
/// both stored in UTC. A calendar month's inclusive end is represented as the
/// first instant of the next month.
class SeasonPeriod {
  final int number;
  final String name; // "week-1", "month-3", ...
  final DateTime startDate;
  final DateTime endDate;

  const SeasonPeriod({
    required this.number,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  /// True if [when] falls within `[startDate, endDate)`.
  bool contains(DateTime when) {
    final w = when.toUtc();
    return !w.isBefore(startDate) && w.isBefore(endDate);
  }

  factory SeasonPeriod.fromJson(Map<String, dynamic> json) {
    return SeasonPeriod(
      number: (json['number'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      startDate: DateTime.parse(json['start_date'].toString()).toUtc(),
      endDate: DateTime.parse(json['end_date'].toString()).toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      };
}
