import 'package:e_sports/core/helper/type_converter_helper.dart';
import 'package:e_sports/features/splash/domain/models/season_model.dart';

class ConfigModel {
  final String? version;
  final bool verifyEmail;
  final bool maintenanceMode;
  final int? currentSeason;
  final List<SeasonModel> seasons;

  ConfigModel({
    this.version,
    required this.verifyEmail,
    required this.maintenanceMode,
    this.currentSeason,
    this.seasons = const [],
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      version: json['version']?.toString(),
      verifyEmail: TypeConverterHelper.readBool(json['verify_email']),
      maintenanceMode: TypeConverterHelper.readBool(json['maintenance_mode']),
      currentSeason: TypeConverterHelper.readInt(json['current_season']),
      seasons: (json['seasons'] as List?)
              ?.map((s) => SeasonModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
