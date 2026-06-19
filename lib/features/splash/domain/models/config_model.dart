import 'package:e_sports/core/helper/type_converter_helper.dart';
import 'package:e_sports/features/splash/domain/models/season_model.dart';

class ConfigModel {
  final String? version;
  final bool verifyEmail;
  final bool maintenanceMode;
  final bool userSelfRegistration;
  final int? currentSeason;
  final List<SeasonModel> seasons;

  ConfigModel({
    this.version,
    required this.verifyEmail,
    required this.maintenanceMode,
    this.userSelfRegistration = true,
    this.currentSeason,
    this.seasons = const [],
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      version: json['version']?.toString(),
      verifyEmail: TypeConverterHelper.readBool(json['verify_email']),
      maintenanceMode: TypeConverterHelper.readBool(json['maintenance_mode']),
      // Absent/null → allow registration (don't lock users out on old configs).
      userSelfRegistration: json['user_self_registration'] == null
          ? true
          : TypeConverterHelper.readBool(json['user_self_registration']),
      currentSeason: TypeConverterHelper.readInt(json['current_season']),
      seasons: (json['seasons'] as List?)
              ?.map((s) => SeasonModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
