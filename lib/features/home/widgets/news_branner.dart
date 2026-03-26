import 'package:e_sports/core/theme/app_theme.dart';
import "package:e_sports/core/controllers/app_data_controller.dart";
import "package:e_sports/core/data/models/news_model.dart";
import "package:get/get.dart";
import 'package:e_sports/core/widgets/glow_circle_widget.dart';
import 'package:e_sports/features/home/widgets/ring_widget.dart';
import 'package:flutter/material.dart';

class NewsBannerWidget extends StatelessWidget {
  final NewsModel n;
  final int index;
  final List<NewsModel> news;
  final void Function(int) onDot;

  const NewsBannerWidget({super.key, required this.n, required this.index, required this.news, required this.onDot});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizing.newsbannerHeight,
      decoration: BoxDecoration(
        borderRadius: AppRadius.borderXxl,
        gradient: AppColors.blueHeroGradient,
        boxShadow: AppElevation.bannerShadow(AppColors.neonBlue, opacity: AppColors.opacity25),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        // Decorative rings
        Positioned(top: -55, right: -55, child: RingWidget(size: 200, opacity: AppColors.opacity12)),
        Positioned(top: -25, right: -25, child: RingWidget(size: 130, opacity: AppColors.opacity8)),
        Positioned(bottom: -60, left: -40, child: GlowCircleWidget(size: 180, color: AppColors.white.withOpacity(0.03))),

        Padding(
          padding: EdgeInsets.all(AppSpacing.huge),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${n.tag}  ·  ${n.time}",
                style: AppTypography.tagLabel(context)),
            SizedBox(height: AppSpacing.sm),
            Text("${n.emoji}  ${n.title}",
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppTypography.sizeTitleLarge,
                  fontWeight: AppTypography.black,
                  color: AppColors.white,
                  height: 1.25,
                )),
            SizedBox(height: AppSpacing.lg),
            Row(children: [
              if (n.hot) Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neonRed,
                  borderRadius: AppRadius.borderPill,
                ),
                child: Text(
                  "🔥 BREAKING",
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontWeight: AppTypography.bold,
                    color: AppColors.white,
                    fontSize: AppTypography.sizeCaption,
                  ),
                ),
              ),
              if (n.hot) SizedBox(width: AppSpacing.iconGap),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(AppColors.opacity15 - 0.01),
                  borderRadius: AppRadius.borderPill,
                ),
                child: Text("Read More →",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppTypography.sizeBody2,
                      fontWeight: AppTypography.bold,
                    )),
              ),
            ]),
          ]),
        ),

        // Dots
        Positioned(bottom: AppSpacing.xl, right: AppSpacing.xxl,
          child: Row(children: List.generate(news.length, (i) => GestureDetector(
            onTap: () => onDot(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: i == index ? AppSpacing.xxxl : AppSpacing.sm,
              height: AppSpacing.sm,
              margin: EdgeInsets.only(left: AppSpacing.xs),
              decoration: BoxDecoration(
                borderRadius: AppRadius.borderXs - const BorderRadius.all(Radius.circular(1)),
                color: i == index ? AppColors.white : AppColors.white.withOpacity(AppColors.opacity30),
              ),
            ),
          ))),
        ),
      ]),
    );
  }
}
