import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_sports/core/theme/app_theme.dart';

import 'package:e_sports/features/news/controllers/news_controller.dart';
import 'package:e_sports/features/news/widgets/news_card_widget.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewsController());

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: AppSpacing.screenAll,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white.withOpacity(0.1)),
                      ),
                      child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NEWS & UPDATES",
                          style: TextStyle(
                            fontSize: AppTypography.sizeHeading,
                            fontWeight: AppTypography.black,
                            color: AppColors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "Stay updated with the latest in House Of Elites",
                          style: TextStyle(
                            fontSize: AppTypography.sizeTiny,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _HeaderIcon(icon: Icons.search),
                  SizedBox(width: AppSpacing.sm),
                  _HeaderIcon(icon: Icons.tune),
                ],
              ),
            ),

            // News List
            Expanded(
              child: Obx(() {
                final news = controller.filteredNews;
                return ListView.separated(
                  padding: AppSpacing.screenAll,
                  itemCount: news.length,
                  separatorBuilder: (context, i) => SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, i) => NewsCardWidget(
                    news: news[i],
                    onTap: () => controller.goToDetail(news[i]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.05),
        borderRadius: AppRadius.borderCard,
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: AppColors.white.withOpacity(0.8), size: 20),
    );
  }
}
