import 'package:e_sports/core/controllers/theme_controller.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/features/faq/controllers/faq_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

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
              'FAQ',
              style: TextStyle(
                color: titleColor,
                fontWeight: Dimensions.black,
              ),
            ),
          ),
          body: GetX<FaqController>(
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
                        'Failed to load FAQs',
                        style: TextStyle(color: subtitleColor),
                      ),
                      SizedBox(height: Dimensions.sm),
                      TextButton(
                        onPressed: controller.loadFaqs,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.faqs.isEmpty) {
                return Center(
                  child: Text(
                    'No FAQs available yet.',
                    style: TextStyle(color: subtitleColor),
                  ),
                );
              }

              final grouped = controller.faqsByCategory;
              final categories = grouped.keys.toList();

              return ListView.builder(
                padding: EdgeInsets.all(Dimensions.screenPadding),
                itemCount: categories.length,
                itemBuilder: (context, catIndex) {
                  final category = categories[catIndex];
                  final items = grouped[category]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (catIndex > 0) SizedBox(height: Dimensions.lg),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Dimensions.xs, bottom: Dimensions.sm),
                        child: Text(
                          category.toUpperCase(),
                          style: TextStyle(
                            fontSize: Dimensions.sizeCaption,
                            fontWeight: FontWeight.w700,
                            color: subtitleColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: Dimensions.borderLg,
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          children: List.generate(items.length, (i) {
                            final faq = items[i];
                            final isLast = i == items.length - 1;
                            return Column(
                              children: [
                                _FaqTile(
                                  question: faq.question,
                                  answer: faq.answer,
                                  titleColor: titleColor,
                                  subtitleColor: subtitleColor,
                                ),
                                if (!isLast)
                                  Divider(
                                    height: 1,
                                    color: borderColor,
                                    indent: Dimensions.lg,
                                    endIndent: Dimensions.lg,
                                  ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final Color titleColor;
  final Color subtitleColor;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      borderRadius: Dimensions.borderLg,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.lg,
          vertical: Dimensions.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: Dimensions.sizeBody,
                      fontWeight: Dimensions.extraBold,
                      color: widget.titleColor,
                    ),
                  ),
                  if (_expanded) ...[
                    SizedBox(height: Dimensions.sm),
                    Text(
                      widget.answer,
                      style: TextStyle(
                        fontSize: Dimensions.sizeBody,
                        height: 1.5,
                        color: widget.subtitleColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: Dimensions.sm),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: widget.subtitleColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
