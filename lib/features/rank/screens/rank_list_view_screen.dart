import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/features/rank/controllers/rank_list_view_controller.dart';
import 'package:e_sports/features/rank/domain/services/rank_service_interface.dart';
import 'package:e_sports/features/rank/widgets/mini_player_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/route_helper.dart';
import '../../../core/widgets/route_not_found_screen.dart';

/// Full, paginated ranking for one section (infinite scroll). Receives its
/// filters via Get.arguments (a [RankListViewArgs]).
class RankListViewScreen extends StatefulWidget {
  const RankListViewScreen({super.key});

  @override
  State<RankListViewScreen> createState() => _RankListViewScreenState();
}

class _RankListViewScreenState extends State<RankListViewScreen> {
  late final RankListViewController controller;
  final ScrollController _scroll = ScrollController();
  bool _valid = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is RankListViewArgs) {
      _valid = true;
      controller = RankListViewController(service: Get.find<RankServiceInterface>(), args: args);
      controller.loadFirst();
      _scroll.addListener(_onScroll);
    }
  }

  void _onScroll() {
    // Trigger the next page a little before the very bottom.
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      controller.loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_valid) return const RouteNotFoundScreen();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: Dimensions.screenAll, child: _header(controller.args.title)),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.items.isEmpty) {
                  return Center(child: CircularProgressIndicator(color: AppColors.neonGold));
                }
                final items = controller.items.toList();
                if (items.isEmpty) {
                  return Center(
                    child: Text("No data for this period",
                        style: TextStyle(color: AppColors.textMuted, fontSize: Dimensions.sizeSmall)),
                  );
                }

                final hasMore = controller.hasMore.value;
                final loadingMore = controller.isLoadingMore.value;
                final isScorer = controller.args.isScorer;
                final detailSeason = controller.args.detailSeason;

                return ListView.separated(
                  controller: _scroll,
                  padding: Dimensions.screenAll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length + (hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => SizedBox(height: Dimensions.sm),
                  itemBuilder: (context, i) {
                    if (i >= items.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.lg),
                        child: Center(
                          child: loadingMore
                              ? SizedBox(
                                  height: Dimensions.iconMd,
                                  width: Dimensions.iconMd,
                                  child: CircularProgressIndicator(
                                      strokeWidth: Dimensions.borderMedium, color: AppColors.neonGold),
                                )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () => Get.toNamed(
                          RouteHelper.getRankDetailRoute(items[i].id, seasonId: detailSeason)),
                      child: MiniPlayerCard(player: items[i], isScorer: isScorer),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.key.currentState?.canPop() == true ? Get.back() : Get.offNamed(RouteHelper.ranks),
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
          child: Text(
            title,
            style: TextStyle(
              fontSize: Dimensions.sizeHeading,
              fontWeight: Dimensions.black,
              color: AppColors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}
