import 'package:e_sports/core/theme/app_colors.dart';
import 'package:e_sports/core/theme/app_radius.dart';
import 'package:e_sports/core/theme/app_spacing.dart';
import 'package:e_sports/core/theme/app_typography.dart';
import 'package:e_sports/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A premium, high-fidelity login screen for "HOUSE OF ELITES".
/// 
/// This screen follows the app's dark neon aesthetic and provides a clean,
/// immersive entry point for users.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.statusBarPaddingH),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              
              // Small neon badge - "HOUSE OF ELITES"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.neonGold.withOpacity(0.1),
                  borderRadius: AppRadius.borderPill,
                  border: Border.all(
                    color: AppColors.neonGold.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGold.withOpacity(0.15),
                      blurRadius: 12,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Text(
                  "HOUSE OF ELITES",
                  style: AppTypography.pillLabel(context, color: AppColors.neonGold).copyWith(
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Big bold title - "WELCOME BACK , ELITE !!!"
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "WELCOME BACK ,\n",
                      style: AppTypography.statsGiant(context, color: AppColors.white).copyWith(
                        fontSize: 38,
                        letterSpacing: -1,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    TextSpan(
                      text: "ELITE !!!",
                      style: AppTypography.statsGiant(context, color: AppColors.neonGold).copyWith(
                        fontSize: 48,
                        letterSpacing: -1,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Small subtitle
              Text(
                "Access your profile with your credentials",
                style: AppTypography.mutedText(context).copyWith(
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              
              const SizedBox(height: 56),
              
              // Email field with email icon
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgCard.withOpacity(0.8),
                  borderRadius: AppRadius.borderLg,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: TextField(
                  style: AppTypography.bodyText(context),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: AppTypography.mutedText(context).copyWith(
                      color: AppColors.textMuted.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Password field with lock icon and show/hide toggle (UI only)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgCard.withOpacity(0.8),
                  borderRadius: AppRadius.borderLg,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: TextField(
                  obscureText: true,
                  style: AppTypography.bodyText(context),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: AppTypography.mutedText(context).copyWith(
                      color: AppColors.textMuted.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
                    suffixIcon: const Icon(Icons.visibility_off_outlined, color: AppColors.textMuted, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Neon color full-width login button - "SIGN IN"
              Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.borderLg,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGold.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => const DashboardScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGold,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderLg,
                    ),
                  ),
                  child: Text(
                    "SIGN IN",
                    style: AppTypography.labelUppercase(context, color: Colors.black).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 120),
              
              // Bottom decoration - "The Enigmatic Elites"
              Center(
                child: Text(
                  "The Enigmatic Elites",
                  style: AppTypography.labelUppercase(context, color: AppColors.textMuted.withOpacity(0.25)).copyWith(
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
    );
  }
}
