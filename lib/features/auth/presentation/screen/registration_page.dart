import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:e_sports/features/auth/helper/registration_access.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final TapGestureRecognizer _loginRecognizer;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loginRecognizer = TapGestureRecognizer()..onTap = () => Get.offNamed(RouteHelper.login);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _loginRecognizer.dispose();
    super.dispose();
  }

  Future<void> _register(AuthController authController) async {
    // Safety net: refuse if self-registration was disabled meanwhile.
    if (!ensureRegistrationAllowed()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if(name.isEmpty) {
      Get.snackbar('Registration', 'Please enter your name');
      return;
    }
    if(name.length < 2) {
      Get.snackbar('Registration', 'Please enter a valid name');
      return;
    }
    if(email.isEmpty) {
      Get.snackbar('Registration', 'Please enter your email');
      return;
    }
    if(!GetUtils.isEmail(email)) {
      Get.snackbar('Registration', 'Please enter a valid email');
      return;
    }
    if(password.isEmpty) {
      Get.snackbar('Registration', 'Please enter your password');
      return;
    }
    if(password.length < 6) {
      Get.snackbar('Registration', 'Password must be at least 6 characters');
      return;
    }

    final response = await authController.register(name, email, password);
    if(response.isSuccess) {
      Get.snackbar('Registration', response.message);
      Get.offNamed(RouteHelper.login);
    }else {
      Get.snackbar('Registration failed', response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If an admin disabled self sign-up, show a message instead of the form.
    if (!isSelfRegistrationEnabled()) {
      return const _RegistrationDisabledView();
    }

    final authController = Get.find<AuthController>();
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double topGap = isDesktop ? 72 : 42;
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
                    SizedBox(height: topGap),
                    const _Badge(),
                    const SizedBox(height: 30),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "JOIN THE\n",
                              style: Dimensions.statsGiant(context, color: AppColors.white).copyWith(
                                fontSize: 38,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                              ),
                            ),
                            TextSpan(
                              text: "ELITE SQUAD",
                              style: Dimensions.statsGiant(context, color: AppColors.neonGold).copyWith(
                                fontSize: 46,
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
                    Text(
                      "Create your profile and start tracking your match journey.",
                      style: Dimensions.mutedText(context).copyWith(
                        fontSize: 14,
                        letterSpacing: 0.2,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 42),
                    _InputShell(
                      child: TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: Dimensions.bodyText(context),
                        decoration: _inputDecoration(context, "Full name", Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _InputShell(
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: Dimensions.bodyText(context),
                        decoration: _inputDecoration(context, "Email", Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _InputShell(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _register(authController),
                        style: Dimensions.bodyText(context),
                        decoration: _inputDecoration(context, "Password", Icons.lock_outline).copyWith(
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textMuted, size: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
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
                          onPressed: authController.isLoading ? null : () => _register(authController),
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
                                  "CREATE ACCOUNT",
                                  style: Dimensions.labelUppercase(context, color: Colors.black).copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                          ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: Dimensions.mutedText(context).copyWith(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: "Sign in",
                              recognizer: _loginRecognizer,
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
                    const SizedBox(height: 48),
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

  InputDecoration _inputDecoration(BuildContext context, String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Dimensions.mutedText(context).copyWith(
        color: AppColors.textMuted.withValues(alpha: 0.5),
      ),
      prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}

class _InputShell extends StatelessWidget {
  final Widget child;

  const _InputShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard.withValues(alpha: 0.8),
        borderRadius: Dimensions.borderLg,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }
}

/// Shown when the admin has turned off user self-registration.
class _RegistrationDisabledView extends StatelessWidget {
  const _RegistrationDisabledView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neonGold.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.neonGold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(Icons.lock_outline,
                        color: AppColors.neonGold, size: 40),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    "Sign-ups Closed",
                    textAlign: TextAlign.center,
                    style: Dimensions.statsGiant(context, color: AppColors.white)
                        .copyWith(
                      fontSize: 30,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    kRegistrationDisabledMessage,
                    textAlign: TextAlign.center,
                    style: Dimensions.mutedText(context).copyWith(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Get.offNamed(RouteHelper.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonGold,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: Dimensions.borderLg,
                        ),
                      ),
                      child: Text(
                        "BACK TO SIGN IN",
                        style: Dimensions.labelUppercase(context,
                                color: Colors.black)
                            .copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
