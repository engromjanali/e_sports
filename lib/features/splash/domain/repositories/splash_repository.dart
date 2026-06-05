import 'package:e_sports/core/api/api_client.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/splash/domain/models/config_model.dart';
import 'package:e_sports/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:supabase/supabase.dart';

class SplashRepository implements SplashRepositoryInterface {
  final ApiClient apiClient;
  final SupabaseClient supabase;

  SplashRepository({required this.apiClient, required this.supabase});

  @override
  Future<ConfigModel> getConfig() async {
    final data = await supabase
    .from('app_settings')
    .select()
    .single();
    printer("GET: ${data}");
    return ConfigModel.fromJson(data);
  }
}
