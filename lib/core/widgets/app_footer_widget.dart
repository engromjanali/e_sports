import 'package:e_sports/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_sports/core/utils/dimensions.dart';

class AppDesktopFooter extends StatelessWidget {
  const AppDesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.xxxl),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.screenPadding, vertical: Dimensions.cardInnerPadding),
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
                    fontSize: Dimensions.sizeCaption,
                    fontWeight: Dimensions.medium,
                  ),
                ),
                Text(
                  'Version - ${AppConstants.appVersion}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: Dimensions.sizeCaption,
                    fontWeight: Dimensions.medium,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: Dimensions.lg,
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
        padding: EdgeInsets.symmetric(vertical: Dimensions.xs),
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: Dimensions.sizeCaption,
            fontWeight: Dimensions.semiBold,
          ),
        ),
      ),
    );
  }
}
