import 'package:e_sports/core/widgets/custom_snackbar.dart';
import 'package:e_sports/features/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';

/// Message shown when an admin has turned off user self-registration.
const String kRegistrationDisabledMessage =
    'New account sign-ups are currently disabled by the administrator. '
    'Please contact support to get an account.';

/// Whether new users may create their own account, per the backend config.
/// Defaults to true if config hasn't loaded (don't lock users out by accident).
bool isSelfRegistrationEnabled() {
  if (!Get.isRegistered<SplashController>()) return true;
  return Get.find<SplashController>().configModel?.userSelfRegistration ?? true;
}

/// Returns true if registration is allowed. When disabled, shows a proper
/// message and returns false so callers can stop.
bool ensureRegistrationAllowed() {
  if (isSelfRegistrationEnabled()) return true;
  showCustomSnackBar(kRegistrationDisabledMessage, isError: true);
  return false;
}
