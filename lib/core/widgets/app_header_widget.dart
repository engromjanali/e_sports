import 'package:e_sports/core/utils/dimensions.dart';
import 'player_avater.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHeader extends StatelessWidget {
  final String? title;
  final String? sub;
  final Widget? child;
  final Widget? actionPrefix;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onBack;

  const AppHeader({
    this.title,
    this.sub, 
    this.child,
    this.actionPrefix,
    this.onSearchTap,
    this.onProfileTap,
    this.onMenuTap,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Dimensions.headerPadding,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (onBack != null) 
                  GestureDetector(
                    onTap: onBack,
                    child: Container(
                      margin: EdgeInsets.only(right: Dimensions.md),
                      padding: EdgeInsets.all(Dimensions.xs),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 16),
                    ),
                  ),
                Flexible(child: GestureDetector(
                  onTap: title == null ? () => Get.offNamed('/home') : null,
                  behavior: title == null ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (title != null)
                    Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(
                        color: AppColors.neonCyan,
                        fontSize: Dimensions.sizeHeading + 1,
                        fontWeight: Dimensions.black))
                  else
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                      children: [
                        TextSpan(text: "House Of", style: TextStyle(
                            color: AppColors.neonCyan,
                            fontSize: Dimensions.sizeHeading + 1,
                            fontWeight: Dimensions.black)),
                        TextSpan(text: " Elites", style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: Dimensions.sizeHeading + 1,
                            fontWeight: Dimensions.black)),
                      ],
                    )),
                  Text(sub ?? "Play · Compete · Win",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Dimensions.sizeCaption,
                        color: AppColors.textMuted,
                        letterSpacing: Dimensions.trackingNormal,
                      )),
                ]))),
              ],
            ),
          ),

          SizedBox(width: Dimensions.md),
          child ?? Row(mainAxisSize: MainAxisSize.min, children: [
            if (actionPrefix != null) ...[
              actionPrefix!,
              SizedBox(width: Dimensions.md),
            ],
            _headerIconButton("🔍", onTap: onSearchTap),
            SizedBox(width: Dimensions.md),
            GestureDetector(
              onTap: onProfileTap,
              child: Stack(children: [
                PlayerAvatarWidget(
                  name: "T",
                  size: Dimensions.headerIconSize,
                  online: true,
                  borderColor: AppColors.neonGold,
                ),
              ]),
            ),
            if (onMenuTap != null) ...[
              SizedBox(width: Dimensions.md),
              _headerIconButton("☰", onTap: onMenuTap),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _headerIconButton(String icon, {int badge = 0, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: Dimensions.headerIconSize,
            height: Dimensions.headerIconSize,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: Dimensions.borderDef,
              border: Border.all(color: AppColors.glassBorder),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: TextStyle(fontSize: Dimensions.sizeTitleLarge)),
          ),
          if (badge > 0) Positioned(
            top: -4, right: -4,
            child: Container(
              width: Dimensions.badgeMd,
              height: Dimensions.badgeMd,
              decoration: BoxDecoration(
                color: AppColors.neonRed,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bg, width: Dimensions.borderThick),
              ),
              alignment: Alignment.center,
              child: Text("$badge",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: Dimensions.sizeTiny,
                    fontWeight: Dimensions.extraBold,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
