import 'package:e_sports/features/profile/models/user_model.dart';

abstract class ProfileRepositoryInterface {
  Future<UserModel?> getProfile(String id);
  Future<UserModel?> updateProfile({
    required String id,
    required String name,
    required String sortName,
    String? email,
  });
}
