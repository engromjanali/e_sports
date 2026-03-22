import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/utils/styles.dart';
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
      height: 145,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8), Color(0xFF1440B8)],
        ),
        boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        // Decorative rings
        Positioned(top: -55, right: -55, child: RingWidget(size: 200, opacity: 0.12)),
        Positioned(top: -25, right: -25, child: RingWidget(size: 130, opacity: 0.08)),
        Positioned(bottom: -60, left: -40, child: GlowCircleWidget(size: 180, color: AppColors.white.withOpacity(0.03))),

        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("${n.tag}  ·  ${n.time}",
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                    color: AppColors.neonGold, letterSpacing: 2)),
            const SizedBox(height: 5),
            Text("${n.emoji}  ${n.title}",
                maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.white, height: 1.25)),
            const SizedBox(height: 10),
            Row(children: [
              if (n.hot) Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: AppColors.neonRed, borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
                child: Text(
                  "🔥 BREAKING",
                  style: robotoBold.copyWith(color: AppColors.white, fontSize: Dimensions.fontSizeExtraSmall)
                ), 
              ),
              if (n.hot) const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                child: const Text("Read More →",
                    style: TextStyle(color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
          ]),
        ),

        // Dots
        Positioned(bottom: 12, right: 14,
          child: Row(children: List.generate(news.length, (i) => GestureDetector(
            onTap: () => onDot(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: i == index ? 16 : 5, height: 5,
              margin: const EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: i == index ? AppColors.white : AppColors.white.withOpacity(0.3),
              ),
            ),
          ))),
        ),
      ]),
    );
  }
}
