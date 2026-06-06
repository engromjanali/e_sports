import 'package:flutter/material.dart';

import 'package:e_sports/core/utils/dimensions.dart';
import '../../../core/widgets/glass_card_widget.dart';
import "../../../core/controllers/app_data_controller.dart";
import "../domain/model/news_model.dart";
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
        margin: EdgeInsets.only(bottom: Dimensions.lg),
        child: GlassCardWidget(
          radius: Dimensions.radiusCardValue,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              if (news.imageUrl != null)
                AspectRatio(
                  aspectRatio: 20 / 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radiusCardValue)),
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
                          top: Dimensions.md,
                          left: Dimensions.md,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.sm, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.neonBlue.withOpacity(0.8),
                              borderRadius: Dimensions.borderPill,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonBlue.withOpacity(0.3),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: Text(
                              news.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: Dimensions.black,
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
                padding: EdgeInsets.all(Dimensions.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          news.category,
                          style: TextStyle(
                            fontSize: Dimensions.sizeTiny,
                            color: AppColors.neonCyan,
                            fontWeight: Dimensions.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          news.time,
                          style: TextStyle(
                            fontSize: Dimensions.sizeTiny,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.sm),
                    Text(
                      news.title,
                      style: TextStyle(
                        fontSize: Dimensions.sizeBody,
                        fontWeight: Dimensions.black,
                        color: AppColors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.sm),
                    Text(
                      news.content,
                      style: TextStyle(
                        fontSize: Dimensions.sizeCaption,
                        color: AppColors.white.withOpacity(0.6),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "READ MORE",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: Dimensions.black,
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
