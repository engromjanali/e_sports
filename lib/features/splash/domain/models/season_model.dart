import 'package:e_sports/features/splash/domain/models/season_period.dart';
import 'package:e_sports/features/splash/domain/services/season_period_builder.dart';

class SeasonModel {
  final int id;
  final String name;
  final bool status; // active/inactive
  final DateTime? startDate; // UTC
  final DateTime? endDate;   // UTC, null => ongoing

  /// 7-day chunks from [startDate]; last clamped to season end (or today).
  final List<SeasonPeriod> weeks;

  /// Calendar months from [startDate]; last clamped to season end (or today).
  final List<SeasonPeriod> months;

  const SeasonModel({
    required this.id,
    required this.name,
    this.status = true,
    this.startDate,
    this.endDate,
    this.weeks = const [],
    this.months = const [],
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    DateTime? parse(dynamic v) {
      final s = v?.toString();
      if (s == null || s.isEmpty) return null;
      return DateTime.tryParse(s)?.toUtc();
    }

    final start = parse(json['start_date']);
    final end = parse(json['end_date']);
    final effectiveEnd = SeasonPeriodBuilder.resolveEnd(end);

    return SeasonModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      status: json['status'] as bool? ?? true,
      startDate: start,
      endDate: end,
      weeks: start == null
          ? const []
          : SeasonPeriodBuilder.buildWeeks(start: start, end: effectiveEnd),
      months: start == null
          ? const []
          : SeasonPeriodBuilder.buildMonths(start: start, end: effectiveEnd),
    );
  }

  /// End used for period generation: end_date, or "now" when ongoing.
  DateTime get effectiveEnd => SeasonPeriodBuilder.resolveEnd(endDate);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'start_date': startDate?.toIso8601String(),
        'end_date': endDate?.toIso8601String(),
        'weeks': weeks.map((w) => w.toJson()).toList(),
        'months': months.map((m) => m.toJson()).toList(),
      };
}
