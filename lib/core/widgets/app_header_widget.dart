import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/player_avater.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String? sub;
  final Widget? child;
  const AppHeader({this.sub, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.bgCard, AppColors.bg],
        ),
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(text: TextSpan(
              children: [
                TextSpan(text: AppData.appName.first, style: TextStyle(
                    color: AppColors.neonCyan, fontSize: 19, fontWeight: FontWeight.w900)),
                TextSpan(text: AppData.appName.last, style: TextStyle(
                    color: AppColors.textPrimary, fontSize: 19, fontWeight: FontWeight.w900)),
              ],
            )),
            Text(sub ?? "Play · Compete · Win",
                style: const TextStyle(fontSize: 9, color: AppColors.textMuted, letterSpacing: 0.5)),
          ]),


           child ?? Row(children: [
            _headerIconButton("🔔", badge: 3),
            const SizedBox(width: 8),
            _headerIconButton("🔍"),
            const SizedBox(width: 8),
            Stack(children: [
              PlayerAvatarWidget(name: "T", size: 34, online: true, borderColor: AppColors.neonGold),
            ]),
          ]),
        ],
      ),
    );
  }

  Widget _headerIconButton(String icon, {int badge = 0}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: AppColors.glassBorder),
          ),
          alignment: Alignment.center,
          child: Text(icon, style: const TextStyle(fontSize: 16)),
        ),
        if (badge > 0) Positioned(
          top: -4, right: -4,
          child: Container(
            width: 16, height: 16,
            decoration: BoxDecoration(
              color: AppColors.neonRed,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.bg, width: 2),
            ),
            alignment: Alignment.center,
            child: Text("$badge",
                style: const TextStyle(color: AppColors.white, fontSize: 8, fontWeight: FontWeight.w800)),
          ),
        ),
      ],
    );
  }
}
