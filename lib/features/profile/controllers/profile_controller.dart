import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:e_sports/features/profile/domain/services/profile_service_interface.dart';
import 'package:e_sports/features/profile/models/user_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final ProfileServiceInterface profileServiceInterface;

  ProfileController({required this.profileServiceInterface});

  final Rxn<UserModel> _user = Rxn<UserModel>();
  UserModel? get user => _user.value;

  /// The logged-in player's UUID, taken from the fetched profile.
  String get userId => _user.value?.id ?? '';

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-load the profile if a session already exists (app restart / refresh).
    final token = Get.find<AuthController>().getUserToken();
    if (token.isNotEmpty) fetchProfile(id: token);
  }

  /// Fetches the logged-in player's profile. Defaults to the auth token (UUID).
  Future<void> fetchProfile({String? id}) async {
    final pid = id ?? Get.find<AuthController>().getUserToken();
    if (pid.isEmpty) return;
    isLoading.value = true;
    try {
      _user.value = await profileServiceInterface.getProfile(pid);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String sortName,
    String? email,
  }) async {
    if (userId.isEmpty) return false;
    isLoading.value = true;
    try {
      final updated = await profileServiceInterface.updateProfile(
        id: userId,
        name: name,
        sortName: sortName,
        email: email,
      );
      if (updated != null) {
        _user.value = updated;
        return true;
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clear() => _user.value = null;
}
