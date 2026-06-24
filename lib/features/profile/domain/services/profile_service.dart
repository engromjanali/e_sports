import 'package:e_sports/core/error/exception/app_exception.dart';
import 'package:e_sports/core/helper/printer.dart';
import 'package:e_sports/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:e_sports/features/profile/domain/services/profile_service_interface.dart';
import 'package:e_sports/features/profile/models/user_model.dart';

class ProfileService implements ProfileServiceInterface {
  final ProfileRepositoryInterface profileRepositoryInterface;

  ProfileService({required this.profileRepositoryInterface});

  @override
  Future<UserModel?> getProfile(String id) async {
    try {
      return await profileRepositoryInterface.getProfile(id);
    } on AppException catch (e) {
      printer('[ProfileService.getProfile] ${e.message}');
      return null;
    } catch (e) {
      printer('[ProfileService.getProfile] Unexpected: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> updateProfile({
    required String id,
    required String name,
    required String sortName,
    String? email,
  }) async {
    try {
      return await profileRepositoryInterface.updateProfile(
        id: id,
        name: name,
        sortName: sortName,
        email: email,
      );
    } on AppException catch (e) {
      printer('[ProfileService.updateProfile] ${e.message}');
      return null;
    } catch (e) {
      printer('[ProfileService.updateProfile] Unexpected: $e');
      return null;
    }
  }
}
