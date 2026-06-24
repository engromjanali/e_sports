import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/helper/route_helper.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/helper/responsive_helper.dart';

import '../domain/model/news_model.dart';
import '../controllers/news_controller.dart';
import '../widgets/news_card_widget.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsController controller = Get.find<NewsController>();
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _searching = false;

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _searching = true);
    _searchFocus.requestFocus();
  }

  void _closeSearch() {
    setState(() => _searching = false);
    _searchTextController.clear();
    controller.clearSearch();
    _searchFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: Dimensions.screenAll,
              child: _searching ? _buildSearchBar() : _buildHeader(),
            ),

            // News List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.newsList.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.neonGold),
                  );
                }

                final news = controller.newsList.toList();
                if (news.isEmpty) {
                  return Center(
                    child: Text(
                      controller.searchQuery.trim().isEmpty
                          ? "No news found"
                          : "No news found for \"${controller.searchQuery.trim()}\"",
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  );
                }

                // Capture reactive flags here (inside Obx) so the lazy ListView
                // itemBuilder, which runs outside this closure, stays in sync.
                final hasMore = controller.hasMore;
                final loadingMore = controller.isLoadingMore.value;

                // Two columns on large tablet / desktop, single column otherwise.
                final twoColumns =
                    ResponsiveHelper.isBigTab(context) || ResponsiveHelper.isDesktop(context);

                return RefreshIndicator(
                  onRefresh: controller.loadNews,
                  child: twoColumns
                      ? _buildGrid(controller, news, hasMore, loadingMore)
                      : _buildList(controller, news, hasMore, loadingMore),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Default header with title + search trigger.
  Widget _buildHeader() {
    return Row(
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
        _HeaderIcon(icon: Icons.search, onTap: _openSearch),
        SizedBox(width: Dimensions.sm),
      ],
    );
  }

  // Inline search bar shown when the search icon is tapped.
  Widget _buildSearchBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: _closeSearch,
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.md),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.05),
              borderRadius: Dimensions.borderCard,
              border: Border.all(color: AppColors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppColors.white.withOpacity(0.8), size: 20),
                SizedBox(width: Dimensions.sm),
                Expanded(
                  child: TextField(
                    controller: _searchTextController,
                    focusNode: _searchFocus,
                    autofocus: true,
                    onChanged: controller.setSearchQuery,
                    textInputAction: TextInputAction.search,
                    cursorColor: AppColors.neonGold,
                    style: TextStyle(color: AppColors.white, fontSize: Dimensions.sizeBody),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Search news...",
                      hintStyle: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ),
                Obx(() => controller.searchQuery.isEmpty
                    ? const SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {
                          _searchTextController.clear();
                          controller.clearSearch();
                          _searchFocus.requestFocus();
                        },
                        child: Icon(Icons.close, color: AppColors.white.withOpacity(0.8), size: 18),
                      )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Single-column list (phone / small tablet).
  Widget _buildList(NewsController controller, List<NewsModel> news, bool hasMore, bool loadingMore) {
    final itemCount = news.length + (hasMore ? 1 : 0);
    return ListView.separated(
      padding: Dimensions.screenAll,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, i) => SizedBox(height: Dimensions.md),
      itemBuilder: (context, i) {
        if (i >= news.length) return _loadMoreButton(controller, loadingMore);
        return NewsCardWidget(
          news: news[i],
          onTap: () => controller.goToDetail(news[i]),
        );
      },
    );
  }

  // Two-column grid (large tablet / desktop) — rows of two top-aligned cards.
  Widget _buildGrid(NewsController controller, List<NewsModel> news, bool hasMore, bool loadingMore) {
    final rowCount = (news.length / 2).ceil();
    final itemCount = rowCount + (hasMore ? 1 : 0);
    return ListView.builder(
      padding: Dimensions.screenAll,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, row) {
        if (row >= rowCount) {
          return Padding(
            padding: EdgeInsets.only(top: Dimensions.md),
            child: _loadMoreButton(controller, loadingMore),
          );
        }
        final left = news[row * 2];
        final rightIndex = row * 2 + 1;
        final right = rightIndex < news.length ? news[rightIndex] : null;
        return Padding(
          padding: EdgeInsets.only(bottom: Dimensions.md),
          child: Row(
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
          ),
        );
      },
    );
  }

  // Pagination footer — tap to fetch the next offset for the current query.
  Widget _loadMoreButton(NewsController controller, bool loadingMore) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.sm, bottom: Dimensions.lg),
      child: GestureDetector(
        onTap: loadingMore ? null : controller.loadMore,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: Dimensions.lg),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.neonGold.withOpacity(AppColors.opacity10),
            borderRadius: Dimensions.borderDef,
            border: Border.all(
              color: AppColors.neonGold.withOpacity(AppColors.opacity25),
              width: Dimensions.borderThin,
            ),
          ),
          child: loadingMore
              ? SizedBox(
                  height: Dimensions.lg,
                  width: Dimensions.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: Dimensions.borderThin,
                    color: AppColors.neonGold,
                  ),
                )
              : Text(
                  "Load More",
                  style: TextStyle(
                    color: AppColors.neonGold,
                    fontWeight: Dimensions.extraBold,
                    letterSpacing: Dimensions.trackingNormal,
                  ),
                ),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _HeaderIcon({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: EdgeInsets.all(Dimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.05),
        borderRadius: Dimensions.borderCard,
        border: Border.all(color: AppColors.white.withOpacity(0.1)),
      ),
      child: Icon(icon, color: AppColors.white.withOpacity(0.8), size: 20),
      ),
    );
  }
}
