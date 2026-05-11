import 'dart:async';

import 'package:e_sports/core/data/models/auth_login_result_model.dart';
import 'package:e_sports/core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';
import 'package:e_sports/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// OTP Verification screen for "HOUSE OF ELITES".
///
/// Accepts the 8-digit OTP sent to the user's email and fires
/// POST /api/user/forget-password-verify.
/// On success, navigates to the reset password screen (or home).
///
/// Expects route arguments: `{ 'email': String }` passed from
/// [ForgetPasswordPage].
class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // 8-digit OTP → 8 individual boxes
  static const int _otpLength = 8;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  // Resend cooldown: 60 seconds
  static const int _resendCooldownSeconds = 60;
  int _resendCountdown = 0;
  Timer? _resendTimer;

  String get _email =>
      (Get.arguments as Map<String, dynamic>?)?['email'] as String? ?? '';

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    // Start countdown immediately so the user can't spam resend
    _startResendCountdown();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String get _otp => _controllers.map((c) => c.text).join();

  void _startResendCountdown() {
    setState(() => _resendCountdown = _resendCooldownSeconds);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCountdown <= 1) {
        t.cancel();
        setState(() => _resendCountdown = 0);
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  /// Move focus forward after each character is typed.
  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    // Auto-submit when all boxes are filled
    if (_otp.length == _otpLength) {
      FocusScope.of(context).unfocus();
    }
  }

  /// Handle backspace to move focus backward.
  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _clearOtp() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
  }

  // ── API calls ──────────────────────────────────────────────────────────────

  Future<void> _verify(AuthController authController) async {
    final otp = _otp;
    if (otp.length < _otpLength) {
      Get.snackbar('Verification', 'Please enter the complete $_otpLength-digit OTP');
      return;
    }

    final AuthLoginResult response = await authController.verifyForgotPasswordOtp(_email, otp);
    if (response.isSuccess) {
      // On success the API returns tokens → navigate to home (or reset-pass page)
      Get.offAllNamed(RouteHelper.home);
    } else {
      Get.snackbar('Verification Failed', response.message);
      _clearOtp();
    }
  }

  Future<void> _resend(AuthController authController) async {
    if (_resendCountdown > 0 || _email.isEmpty) return;

    final response = await authController.forgotPassword(_email);
    if (response.isSuccess) {
      Get.snackbar('OTP Resent', response.message);
      _startResendCountdown();
      _clearOtp();
    } else {
      Get.snackbar('Resend Failed', response.message);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

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

                  // ── Back button ───────────────────────────────────────────
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

                  // ── Badge ─────────────────────────────────────────────────
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
                      "EMAIL VERIFICATION",
                      style: Dimensions.pillLabel(context,
                              color: AppColors.neonGold)
                          .copyWith(fontSize: 12, letterSpacing: 2),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Headline ──────────────────────────────────────────────
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "ENTER THE\n",
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
                            text: "OTP CODE",
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

                  // ── Subtitle with masked email ────────────────────────────
                  Text(
                    "We've sent an 8-digit OTP to",
                    style: Dimensions.mutedText(context).copyWith(
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _email,
                    style: Dimensions.bodyText(context, color: AppColors.neonGold)
                        .copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 52),

                  // ── Shield icon accent ────────────────────────────────────
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
                        Icons.shield_outlined,
                        color: AppColors.neonGold,
                        size: 36,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── OTP input boxes (8 digits) ────────────────────────────
                  _OtpInputRow(
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                    otpLength: _otpLength,
                    onChanged: _onOtpChanged,
                    onKeyEvent: _onKeyEvent,
                  ),

                  const SizedBox(height: 36),

                  // ── Verify button ─────────────────────────────────────────
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
                            : () => _verify(authController),
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
                                "VERIFY & CONTINUE",
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

                  // ── Resend OTP ────────────────────────────────────────────
                  Center(
                    child: GetBuilder<AuthController>(
                      builder: (authController) {
                        final canResend =
                            _resendCountdown == 0 && !authController.isLoading;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: Dimensions.mutedText(context).copyWith(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: canResend
                                  ? () => _resend(authController)
                                  : null,
                              child: Text(
                                _resendCountdown > 0
                                    ? "Resend in ${_resendCountdown}s"
                                    : "Resend OTP",
                                style: Dimensions.bodyText(context,
                                        color: canResend
                                            ? AppColors.neonGold
                                            : AppColors.textMuted)
                                    .copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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

// ── Private widget: OTP input row ─────────────────────────────────────────────

class _OtpInputRow extends StatelessWidget {
  const _OtpInputRow({
    required this.controllers,
    required this.focusNodes,
    required this.otpLength,
    required this.onChanged,
    required this.onKeyEvent,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int otpLength;
  final void Function(int index, String value) onChanged;
  final void Function(int index, KeyEvent event) onKeyEvent;

  @override
  Widget build(BuildContext context) {
    // Calculate box size to fit 8 boxes with spacing
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxRowWidth =
        ResponsiveHelper.isDesktop(context) ? 520 : screenWidth - (Dimensions.statusBarPaddingH * 2);
    // 8 boxes + 7 gaps (gap = 8)
    const double gap = 8;
    final double boxSize = (maxRowWidth - (gap * (otpLength - 1))) / otpLength;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(otpLength, (index) {
        return KeyboardListener(
          focusNode: FocusNode(), // separate listener node
          onKeyEvent: (event) => onKeyEvent(index, event),
          child: SizedBox(
            width: boxSize,
            height: boxSize * 1.12, // slight taller ratio
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard.withValues(alpha: 0.85),
                borderRadius: Dimensions.borderMd,
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGold.withValues(alpha: 0.04),
                    blurRadius: 8,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  // Rebuild to show focus highlight via decoration
                },
                child: Builder(
                  builder: (ctx) {
                    final bool hasFocus = Focus.of(ctx).hasFocus;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: hasFocus
                            ? AppColors.neonGold.withValues(alpha: 0.08)
                            : AppColors.bgCard.withValues(alpha: 0.85),
                        borderRadius: Dimensions.borderMd,
                        border: Border.all(
                          color: hasFocus
                              ? AppColors.neonGold.withValues(alpha: 0.6)
                              : AppColors.glassBorder,
                          width: hasFocus ? 1.5 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        style: Dimensions.bodyText(context,
                                color: AppColors.neonGold)
                            .copyWith(
                          fontSize: boxSize * 0.38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) => onChanged(index, val),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}