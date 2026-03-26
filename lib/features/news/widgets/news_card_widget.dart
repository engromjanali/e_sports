import 'package:flutter/material.dart';

import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:e_sports/core/data/models/news_model.dart";
import "package:get/get.dart";

class NewsCardWidget extends StatelessWidget {
  final NewsModel news;
  final VoidCallback onTap;

  const NewsCardWidget({
    super.key,
    required this.news,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: AppSpacing.lg),
        child: GlassCardWidget(
          radius: AppRadius.card,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              if (news.imageUrl != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: 'news-${news.id}',
                          child: Image.network(
                            news.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: AppColors.bgSurface,
                              child: Icon(Icons.broken_image, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                        // Gradient Overlay
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.bgCard.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Tag
                        Positioned(
                          top: AppSpacing.md,
                          left: AppSpacing.md,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.neonBlue.withOpacity(0.8),
                              borderRadius: AppRadius.borderPill,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonBlue.withOpacity(0.3),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: Text(
                              news.tag.toUpperCase(),
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: AppTypography.black,
                                color: AppColors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          news.tag,
                          style: TextStyle(
                            fontSize: AppTypography.sizeTiny,
                            color: AppColors.neonCyan,
                            fontWeight: AppTypography.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          news.time,
                          style: TextStyle(
                            fontSize: AppTypography.sizeTiny,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      news.title,
                      style: TextStyle(
                        fontSize: AppTypography.sizeBody,
                        fontWeight: AppTypography.black,
                        color: AppColors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      news.description,
                      style: TextStyle(
                        fontSize: AppTypography.sizeCaption,
                        color: AppColors.white.withOpacity(0.6),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "READ MORE",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: AppTypography.black,
                            color: AppColors.neonBlue,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.neonBlue),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
