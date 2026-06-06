import 'package:e_sports/core/utils/dimensions.dart';
import "../../../core/controllers/app_data_controller.dart";
import "../../news/domain/model/news_model.dart";
import "package:get/get.dart";
import '../../../core/widgets/glow_circle_widget.dart';
import 'ring_widget.dart';
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
      height: Dimensions.newsbannerHeight,
      decoration: BoxDecoration(
        borderRadius: Dimensions.borderXxl,
        gradient: AppColors.blueHeroGradient,
        boxShadow: Dimensions.bannerShadow(AppColors.neonBlue, opacity: AppColors.opacity25),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        // Decorative rings
        Positioned(top: -55, right: -55, child: RingWidget(size: 200, opacity: AppColors.opacity12)),
        Positioned(top: -25, right: -25, child: RingWidget(size: 130, opacity: AppColors.opacity8)),
        Positioned(bottom: -60, left: -40, child: GlowCircleWidget(size: 180, color: AppColors.white.withOpacity(0.03))),

        Padding(
          padding: EdgeInsets.all(Dimensions.huge),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${n.category}  ·  ${n.time}",
                style: Dimensions.tagLabel(context)),
            SizedBox(height: Dimensions.sm),
            Text("${n.emoji}  ${n.title}",
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Dimensions.sizeTitleLarge,
                  fontWeight: Dimensions.black,
                  color: AppColors.white,
                  height: 1.25,
                )),
            SizedBox(height: Dimensions.lg),
            Row(children: [
              if (n.hot) Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.lg,
                  vertical: Dimensions.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neonRed,
                  borderRadius: Dimensions.borderPill,
                ),
                child: Text(
                  "🔥 BREAKING",
                  style: TextStyle(
                    fontFamily: Dimensions.fontFamily,
                    fontWeight: Dimensions.bold,
                    color: AppColors.white,
                    fontSize: Dimensions.sizeCaption,
                  ),
                ),
              ),
              if (n.hot) SizedBox(width: Dimensions.iconGap),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.xxl,
                  vertical: Dimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(AppColors.opacity15 - 0.01),
                  borderRadius: Dimensions.borderPill,
                ),
                child: Text("Read More →",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: Dimensions.sizeBody2,
                      fontWeight: Dimensions.bold,
                    )),
              ),
            ]),
          ]),
        ),

        // Dots
        Positioned(bottom: Dimensions.xl, right: Dimensions.xxl,
          child: Row(children: List.generate(news.length, (i) => GestureDetector(
            onTap: () => onDot(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: i == index ? Dimensions.xxxl : Dimensions.sm,
              height: Dimensions.sm,
              margin: EdgeInsets.only(left: Dimensions.xs),
              decoration: BoxDecoration(
                borderRadius: Dimensions.borderXs - const BorderRadius.all(Radius.circular(1)),
                color: i == index ? AppColors.white : AppColors.white.withOpacity(AppColors.opacity30),
              ),
            ),
          ))),
        ),
      ]),
    );
  }
}
