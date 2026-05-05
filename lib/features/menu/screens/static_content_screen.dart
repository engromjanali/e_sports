import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import 'package:e_sports/core/utils/dimensions.dart';

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
            fontWeight: Dimensions.black,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.all(Dimensions.screenPadding),
          itemCount: data.sections.length,
          separatorBuilder: (context, index) => SizedBox(height: Dimensions.md),
          itemBuilder: (context, index) {
            final section = data.sections[index];
            return Container(
              padding: EdgeInsets.all(Dimensions.lg),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: Dimensions.borderLg,
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.heading,
                    style: TextStyle(
                      fontSize: Dimensions.sizeBodyLarge,
                      fontWeight: Dimensions.black,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: Dimensions.sm),
                  Text(
                    section.body,
                    style: TextStyle(
                      fontSize: Dimensions.sizeBody,
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
