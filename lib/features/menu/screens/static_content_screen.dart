import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import '../../../core/theme/app_theme.dart';

class StaticContentScreen extends StatelessWidget {
  final StaticContentData data;

  const StaticContentScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.find<ThemeController>().isDarkMode;
    final screenColor = isDarkMode ? AppColors.bg : const Color(0xFFF8FAFC);
    final cardColor = isDarkMode ? AppColors.bgCard : Colors.white;
    final borderColor = isDarkMode ? AppColors.glassBorder : const Color(0xFFE2E8F0);
    final titleColor = isDarkMode ? AppColors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode ? AppColors.textMuted : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: screenColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        foregroundColor: titleColor,
        elevation: 0,
        title: Text(
          data.title,
          style: TextStyle(
            color: titleColor,
            fontWeight: AppTypography.black,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: data.sections.length,
          separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final section = data.sections[index];
            return Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.heading,
                    style: TextStyle(
                      fontSize: AppTypography.sizeBodyLarge,
                      fontWeight: AppTypography.black,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    section.body,
                    style: TextStyle(
                      fontSize: AppTypography.sizeBody,
                      height: 1.5,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class StaticContentData {
  final String title;
  final List<StaticContentSection> sections;

  const StaticContentData({
    required this.title,
    required this.sections,
  });
}

class StaticContentSection {
  final String heading;
  final String body;

  const StaticContentSection({
    required this.heading,
    required this.body,
  });
}
