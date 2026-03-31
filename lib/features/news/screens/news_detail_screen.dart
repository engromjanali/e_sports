import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_sports/core/theme/app_theme.dart';
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:e_sports/core/data/models/news_model.dart";
import "package:get/get.dart";

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;
  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // Header / Banner
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.bg,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: AppColors.white),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.share, color: AppColors.white, size: 20),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (news.imageUrl != null)
                    Hero(
                      tag: 'news-${news.id}',
                      child: Image.network(news.imageUrl!, fit: BoxFit.cover),
                    ),
                  
                  // Bottom Gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.bg,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tag and Title
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.neonBlue,
                            borderRadius: AppRadius.borderPill,
                          ),
                          child: Text(
                            news.tag.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: AppTypography.black,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          news.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: AppTypography.black,
                            color: AppColors.white,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        "${news.time} · Published in ${news.tag}",
                        style: TextStyle(
                          fontSize: AppTypography.sizeTiny,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    news.description,
                    style: TextStyle(
                      fontSize: AppTypography.sizeBody,
                      fontWeight: AppTypography.bold,
                      color: AppColors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.neonBlue.withOpacity(0.3),
                      borderRadius: AppRadius.borderPill,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    news.content,
                    style: TextStyle(
                      fontSize: AppTypography.sizeBody,
                      color: AppColors.white.withOpacity(0.7),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
