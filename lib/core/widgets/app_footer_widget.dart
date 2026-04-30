import 'package:e_sports/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

class AppDesktopFooter extends StatelessWidget {
  const AppDesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSpacing.xxxl),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.cardInnerPadding),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "House Of Elites · Season 2025",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppTypography.sizeCaption,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                Text(
                  'Version - ${AppConstants.appVersion}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppTypography.sizeCaption,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: AppSpacing.lg,
            children: [
              _FooterLink(title: "FAQ", route: "/faq"),
              _FooterLink(title: "Privacy", route: "/privacy-policy"),
              _FooterLink(title: "Terms", route: "/terms"),
              _FooterLink(title: "Support", route: "/support"),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String title;
  final String route;

  const _FooterLink({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(route),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: AppTypography.sizeCaption,
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),
    );
  }
}
