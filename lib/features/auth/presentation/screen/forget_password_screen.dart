import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Forgot Password screen for "HOUSE OF ELITES".
///
/// Accepts an email address and fires POST /api/user/forget-password.
/// On success, navigates to [OtpVerificationPage] passing the email.
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp(AuthController authController) async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar('Forgot Password', 'Please enter your email address');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Forgot Password', 'Please enter a valid email address');
      return;
    }

    final response = await authController.forgotPassword(email);
    if (response.isSuccess) {
      Get.snackbar('OTP Sent', response.message);
      // Navigate to OTP verification, carrying the email forward
      Get.toNamed(
        RouteHelper.otpVerification,
        arguments: {'email': email},
      );
    } else {
      Get.snackbar('Failed', response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double formMaxWidth = isDesktop ? 520 : double.infinity;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.statusBarPaddingH),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: formMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // ── Back button ──────────────────────────────────────────
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard.withValues(alpha: 0.8),
                        borderRadius: Dimensions.borderMd,
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Badge ────────────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.neonGold.withValues(alpha: 0.1),
                      borderRadius: Dimensions.borderPill,
                      border: Border.all(
                        color: AppColors.neonGold.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGold.withValues(alpha: 0.15),
                          blurRadius: 12,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: Text(
                      "ACCOUNT RECOVERY",
                      style:
                          Dimensions.pillLabel(context, color: AppColors.neonGold)
                              .copyWith(fontSize: 12, letterSpacing: 2),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Headline ─────────────────────────────────────────────
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "FORGOT YOUR\n",
                            style: Dimensions.statsGiant(context,
                                    color: AppColors.white)
                                .copyWith(
                              fontSize: 38,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                          TextSpan(
                            text: "PASSWORD ?",
                            style: Dimensions.statsGiant(context,
                                    color: AppColors.neonGold)
                                .copyWith(
                              fontSize: 48,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Subtitle ─────────────────────────────────────────────
                  Text(
                    "Enter your registered email and we'll send\nan OTP to reset your password.",
                    style: Dimensions.mutedText(context).copyWith(
                      fontSize: 14,
                      letterSpacing: 0.2,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 56),

                  // ── Lock icon visual accent ───────────────────────────────
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.neonGold.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.neonGold.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonGold.withValues(alpha: 0.12),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: AppColors.neonGold,
                        size: 36,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Email field ───────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard.withValues(alpha: 0.8),
                      borderRadius: Dimensions.borderLg,
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _sendOtp(authController),
                      style: Dimensions.bodyText(context),
                      decoration: InputDecoration(
                        hintText: "Email address",
                        hintStyle: Dimensions.mutedText(context).copyWith(
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: AppColors.textMuted, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Send OTP button ───────────────────────────────────────
                  Container(
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: Dimensions.borderLg,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonGold.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: GetBuilder<AuthController>(
                      builder: (authController) => ElevatedButton(
                        onPressed: authController.isLoading
                            ? null
                            : () => _sendOtp(authController),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonGold,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor:
                              AppColors.neonGold.withValues(alpha: 0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: Dimensions.borderLg,
                          ),
                        ),
                        child: authController.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.4, color: Colors.black),
                              )
                            : Text(
                                "SEND OTP",
                                style: Dimensions.labelUppercase(context,
                                        color: Colors.black)
                                    .copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Back to login ─────────────────────────────────────────
                  Center(
                    child: TextButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_rounded,
                          size: 16, color: AppColors.textSecondary),
                      label: Text(
                        "Back to Sign In",
                        style:
                            Dimensions.bodyText(context, color: AppColors.textSecondary)
                                .copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 70),

                  // ── Footer ────────────────────────────────────────────────
                  Center(
                    child: Text(
                      "The Enigmatic Elites",
                      style: Dimensions.labelUppercase(context,
                              color: AppColors.textMuted.withValues(alpha: 0.25))
                          .copyWith(
                        fontSize: 11,
                        letterSpacing: 5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}