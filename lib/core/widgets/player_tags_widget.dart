import 'package:e_sports/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

class PlayerTagsWidget extends StatelessWidget {
  final List<String> tags;
  final Color? accentColor;
  final bool showRankSpecial;

  const PlayerTagsWidget({
    super.key,
    required this.tags,
    this.accentColor,
    this.showRankSpecial = true,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? AppColors.neonGold;

    return Wrap(
      spacing: Dimensions.xs,
      runSpacing: Dimensions.xxs,
      children: tags.map((tag) {
        final isRank = tag.toUpperCase().contains("RANK") && showRankSpecial;
        
        if (isRank) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.md, vertical: 2),
              decoration: BoxDecoration(
                gradient: AppColors.goldRibbonGradient,
              ),
              child: Text(
                tag.toUpperCase(),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: Dimensions.black,
                  letterSpacing: 1.0,
                  color: AppColors.goldDeep,
                ),
              ),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.md, vertical: 2),
          decoration: BoxDecoration(
            color: accent.withOpacity(AppColors.opacity12),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: accent.withOpacity(AppColors.opacity30)),
          ),
          child: Text(
            tag.toUpperCase(),
            style: TextStyle(
              fontSize: 8,
              fontWeight: Dimensions.black,
              color: accent.withOpacity(0.9),
              letterSpacing: 0.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}
