import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';

import '../domain/model/news_model.dart';
import '../controllers/news_controller.dart';
import '../widgets/news_card_widget.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: Dimensions.screenAll,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.key.currentState?.canPop() == true ? Get.back() : Get.offNamed(RouteHelper.home),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.sm),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white.withOpacity(0.1)),
                      ),
                      child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: Dimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NEWS & UPDATES",
                          style: TextStyle(
                            fontSize: Dimensions.sizeHeading,
                            fontWeight: Dimensions.black,
                            color: AppColors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "Stay updated with the latest in House Of Elites",
                          style: TextStyle(
                            fontSize: Dimensions.sizeTiny,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _HeaderIcon(icon: Icons.search),
                  SizedBox(width: Dimensions.sm),
                  _HeaderIcon(icon: Icons.tune),
                ],
              ),
            ),

            // News List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.newsList.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.neonGold),
                  );
                }

                final news = controller.filteredNews;
                if (news.isEmpty) {
                  return Center(
                    child: Text(
                      "No news found",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }

                // Two columns on large tablet / desktop, single column otherwise.
                final twoColumns =
                    ResponsiveHelper.isBigTab(context) || ResponsiveHelper.isDesktop(context);

                return RefreshIndicator(
                  onRefresh: controller.loadNews,
                  child: twoColumns
                      ? _buildGrid(controller, news)
                      : _buildList(controller, news),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Single-column list (phone / small tablet).
  Widget _buildList(NewsController controller, List<NewsModel> news) {
    return ListView.separated(
      padding: Dimensions.screenAll,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: news.length,
      separatorBuilder: (context, i) => SizedBox(height: Dimensions.md),
      itemBuilder: (context, i) => NewsCardWidget(
        news: news[i],
        onTap: () => controller.goToDetail(news[i]),
      ),
    );
  }

  // Two-column grid (large tablet / desktop) — rows of two top-aligned cards.
  Widget _buildGrid(NewsController controller, List<NewsModel> news) {
    final rowCount = (news.length / 2).ceil();
    return ListView.builder(
      padding: Dimensions.screenAll,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: rowCount,
      itemBuilder: (context, row) {
        final left = news[row * 2];
        final rightIndex = row * 2 + 1;
        final right = rightIndex < news.length ? news[rightIndex] : null;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: NewsCardWidget(
                news: left,
                onTap: () => controller.goToDetail(left),
              ),
            ),
            SizedBox(width: Dimensions.md),
            Expanded(
              child: right != null
                  ? NewsCardWidget(
                      news: right,
                      onTap: () => controller.goToDetail(right),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  const _HeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.05),
        borderRadius: Dimensions.borderCard,
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: AppColors.white.withOpacity(0.8), size: 20),
    );
  }
}
