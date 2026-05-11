import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A premium, high-fidelity login screen for "HOUSE OF ELITES".
/// 
/// This screen follows the app's dark neon aesthetic and provides a clean,
/// immersive entry point for users.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final TapGestureRecognizer _registrationRecognizer;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _registrationRecognizer = TapGestureRecognizer()..onTap = () => Get.toNamed(RouteHelper.registration);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _registrationRecognizer.dispose();
    super.dispose();
  }

  Future<void> _login(AuthController authController) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if(email.isEmpty) {
      Get.snackbar('Login', 'Please enter your email');
      return;
    }
    if(!GetUtils.isEmail(email)) {
      Get.snackbar('Login', 'Please enter a valid email');
      return;
    }
    if(password.isEmpty) {
      Get.snackbar('Login', 'Please enter your password');
      return;
    }

    final response = await authController.login(email, password);
    if(response.isSuccess) {
      Get.offAllNamed(RouteHelper.home);
    }else {
      Get.snackbar('Login failed', response.message);
    }
  }

  Future<void> _forgotPassword(AuthController authController) async {
    final email = _emailController.text.trim();

    if(email.isEmpty) {
      Get.snackbar('Forgot password', 'Please enter your email first');
      return;
    }
    if(!GetUtils.isEmail(email)) {
      Get.snackbar('Forgot password', 'Please enter a valid email');
      return;
    }

    final response = await authController.forgotPassword(email);
    if(response.isSuccess) {
      Get.snackbar('Forgot password', response.message);
    }else {
      Get.snackbar('Forgot password failed', response.message);
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
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.statusBarPaddingH),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: formMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
              
              // Small neon badge - "HOUSE OF ELITES"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  "HOUSE OF ELITES",
                  style: Dimensions.pillLabel(context, color: AppColors.neonGold).copyWith(
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Big bold title - "WELCOME BACK , ELITE !!!"
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "WELCOME BACK ,\n",
                        style: Dimensions.statsGiant(context, color: AppColors.white).copyWith(
                          fontSize: 38,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      TextSpan(
                        text: "ELITE !!!",
                        style: Dimensions.statsGiant(context, color: AppColors.neonGold).copyWith(
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
              
              // Small subtitle
              Text(
                "Access your profile with your credentials",
                style: Dimensions.mutedText(context).copyWith(
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              
              const SizedBox(height: 56),
              
              // Email field with email icon
              Container(
                decoration: BoxDecoration(
                  color: AppColors.bgCard.withValues(alpha: 0.8),
                  borderRadius: Dimensions.borderLg,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: Dimensions.bodyText(context),
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: Dimensions.mutedText(context).copyWith(
                      color: AppColors.textMuted.withValues(alpha: 0.5),
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
                  color: AppColors.bgCard.withValues(alpha: 0.8),
                  borderRadius: Dimensions.borderLg,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _login(authController),
                  style: Dimensions.bodyText(context),
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: Dimensions.mutedText(context).copyWith(
                      color: AppColors.textMuted.withValues(alpha: 0.5),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textMuted, size: 20),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: GetBuilder<AuthController>(
                  builder: (authController) => TextButton(
                    onPressed: authController.isLoading ? null : () => _forgotPassword(authController),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.neonGold,
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    ),
                    child: Text(
                      "Forgot password?",
                      style: Dimensions.bodyText(context, color: AppColors.neonGold).copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              
              // Neon color full-width login button - "SIGN IN"
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
                    onPressed: authController.isLoading ? null : () => _login(authController),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGold,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: AppColors.neonGold.withValues(alpha: 0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: Dimensions.borderLg,
                      ),
                    ),
                    child: authController.isLoading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.black))
                        : Text(
                            "SIGN IN",
                            style: Dimensions.labelUppercase(context, color: Colors.black).copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                    ),
                ),
              ),
              
              const SizedBox(height: 26),

              Center(
                child: Text.rich(
                  TextSpan(
                    text: "New to House Of Elites? ",
                    style: Dimensions.mutedText(context).copyWith(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: "Create account",
                        recognizer: _registrationRecognizer,
                        style: Dimensions.bodyText(context, color: AppColors.neonGold).copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 70),
              
              // Bottom decoration - "The Enigmatic Elites"
              Center(
                child: Text(
                  "The Enigmatic Elites",
                  style: Dimensions.labelUppercase(context, color: AppColors.textMuted.withValues(alpha: 0.25)).copyWith(
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
