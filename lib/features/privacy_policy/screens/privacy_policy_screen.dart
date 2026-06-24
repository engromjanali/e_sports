import 'package:e_sports/core/controllers/theme_controller.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/features/privacy_policy/controllers/privacy_policy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDarkMode = themeController.isDarkMode;
        final screenColor = isDarkMode ? AppColors.bg : const Color(0xFFF8FAFC);
        final cardColor = isDarkMode ? AppColors.bgCard : Colors.white;
        final borderColor =
            isDarkMode ? AppColors.glassBorder : const Color(0xFFE2E8F0);
        final titleColor =
            isDarkMode ? AppColors.white : const Color(0xFF0F172A);
        final subtitleColor =
            isDarkMode ? AppColors.textMuted : const Color(0xFF64748B);

        return Scaffold(
          backgroundColor: screenColor,
          appBar: AppBar(
            backgroundColor: cardColor,
            foregroundColor: titleColor,
            elevation: 0,
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                color: titleColor,
                fontWeight: Dimensions.black,
              ),
            ),
          ),
          body: SafeArea(
            child: GetX<PrivacyPolicyController>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.errorMessage.value != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: subtitleColor),
                        SizedBox(height: Dimensions.md),
                        Text(
                          'Failed to load Privacy Policy',
                          style: TextStyle(color: subtitleColor),
                        ),
                        SizedBox(height: Dimensions.sm),
                        TextButton(
                          onPressed: controller.loadPrivacyPolicy,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final content = controller.policy?.content.trim() ?? '';
                if (content.isEmpty) {
                  return Center(
                    child: Text(
                      'Privacy Policy is not available yet.',
                      style: TextStyle(color: subtitleColor),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.screenPadding),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimensions.lg),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: Dimensions.borderLg,
                      border: Border.all(color: borderColor),
                    ),
                    child: HtmlWidget(
                      content,
                      textStyle: TextStyle(
                        fontSize: Dimensions.sizeBody,
                        height: 1.5,
                        color: subtitleColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
