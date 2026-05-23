import 'package:e_sports/core/helper/type_converter_helper.dart';

class ConfigModel {
  final String? version;
  final bool verifyEmail;
  final bool maintenanceMode;


  ConfigModel({
    this.version,
    required this.verifyEmail,
    required this.maintenanceMode,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      version: json['version']?.toString(),
      verifyEmail: TypeConverterHelper.readBool(json['verify_email']),
      maintenanceMode: TypeConverterHelper.readBool(json['maintenance_mode']),
    );
  }
}
