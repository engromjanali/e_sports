import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import '../../../core/helper/route_helper.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_header_widget.dart';

class MenuScreen extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;

  const MenuScreen({
    super.key,
    this.onSearchTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        final isDarkMode = themeController.isDarkMode;
        final screenColor = isDarkMode ? AppColors.bg : const Color(0xFFF8FAFC);
        final cardColor = isDarkMode ? AppColors.bgCard : Colors.white;
        final borderColor = isDarkMode ? AppColors.glassBorder : const Color(0xFFE2E8F0);
        final titleColor = isDarkMode ? AppColors.white : const Color(0xFF0F172A);
        final subtitleColor = isDarkMode ? AppColors.textMuted : const Color(0xFF64748B);

        return Scaffold(
          backgroundColor: screenColor,
          body: Column(
            children: [
              AppHeader(
                sub: "Settings & Support",
                onSearchTap: onSearchTap,
                onProfileTap: onProfileTap,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MenuSectionCard(
                        title: "Preferences",
                        titleColor: titleColor,
                        backgroundColor: cardColor,
                        borderColor: borderColor,
                        children: [
                          _MenuTile(
                            icon: Icons.palette_outlined,
                            title: "Theme",
                            subtitle: isDarkMode ? "Dark mode active" : "Light mode active",
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                            iconColor: AppColors.neonGoldDim,
                            onTap: () => _showThemeSelector(context, themeController, isDarkMode, titleColor, subtitleColor, cardColor, borderColor),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg),
                      _MenuSectionCard(
                        title: "Account",
                        titleColor: titleColor,
                        backgroundColor: cardColor,
                        borderColor: borderColor,
                        children: [
                          _MenuTile(
                            icon: Icons.edit_outlined,
                            title: "Edit Profile",
                            subtitle: "Update your basic profile details",
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                            iconColor: AppColors.neonCyan,
                            onTap: () => Get.toNamed(RouteHelper.editProfile),
                          ),
                          _MenuTile(
                            icon: Icons.logout,
                            title: "Logout",
                            subtitle: "Sign out and go back to login",
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                            iconColor: AppColors.neonRed,
                            onTap: () => _showLogoutDialog(context, isDarkMode, titleColor, subtitleColor, cardColor, borderColor),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg),
                      _MenuSectionCard(
                        title: "Information",
                        titleColor: titleColor,
                        backgroundColor: cardColor,
                        borderColor: borderColor,
                        children: [
                          _MenuTile(
                            icon: Icons.help_outline,
                            title: "FAQ",
                            subtitle: "Common answers and app guidance",
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                            iconColor: AppColors.neonGreen,
                            onTap: () => Get.toNamed(RouteHelper.faq),
                          ),
                          _MenuTile(
                            icon: Icons.privacy_tip_outlined,
                            title: "Privacy Policy",
                            subtitle: "How app data is handled in this build",
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                            iconColor: AppColors.neonPurple,
                            onTap: () => Get.toNamed(RouteHelper.privacyPolicy),
                          ),
                          _MenuTile(
                            icon: Icons.description_outlined,
                            title: "Terms & Conditions",
                            subtitle: "Usage and rewards-related terms",
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                            iconColor: AppColors.neonBlue,
                            onTap: () => Get.toNamed(RouteHelper.terms),
                          ),
                          _MenuTile(
                            icon: Icons.support_agent_outlined,
                            title: "Help & Support",
                            subtitle: "Troubleshooting and support guidance",
                            titleColor: titleColor,
                            subtitleColor: subtitleColor,
                            iconColor: AppColors.neonOrange,
                            onTap: () => Get.toNamed(RouteHelper.support),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showThemeSelector(
    BuildContext context,
    ThemeController themeController,
    bool isDarkMode,
    Color titleColor,
    Color subtitleColor,
    Color cardColor,
    Color borderColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xl)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Theme",
                  style: TextStyle(
                    fontSize: AppTypography.sizeTitleLarge,
                    fontWeight: AppTypography.black,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                _ThemeOptionTile(
                  title: "Dark",
                  selected: isDarkMode,
                  titleColor: titleColor,
                  subtitleColor: subtitleColor,
                  borderColor: borderColor,
                  onTap: () async {
                    await themeController.setThemeMode(ThemeMode.dark);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                SizedBox(height: AppSpacing.sm),
                _ThemeOptionTile(
                  title: "Light",
                  selected: !isDarkMode,
                  titleColor: titleColor,
                  subtitleColor: subtitleColor,
                  borderColor: borderColor,
                  onTap: () async {
                    await themeController.setThemeMode(ThemeMode.light);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    bool isDarkMode,
    Color titleColor,
    Color subtitleColor,
    Color cardColor,
    Color borderColor,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderLg,
            side: BorderSide(color: borderColor),
          ),
          title: Text(
            "Logout",
            style: TextStyle(
              color: titleColor,
              fontWeight: AppTypography.black,
            ),
          ),
          content: Text(
            "Do you want to logout from the app?",
            style: TextStyle(
              color: subtitleColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: subtitleColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Get.offAllNamed(RouteHelper.login);
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: AppColors.neonRed),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MenuSectionCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color backgroundColor;
  final Color borderColor;
  final List<Widget> children;

  const _MenuSectionCard({
    required this.title,
    required this.titleColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppTypography.sizeBodyLarge,
              fontWeight: AppTypography.black,
              color: titleColor,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color titleColor;
  final Color subtitleColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.subtitleColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderMd,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.borderMd,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppTypography.sizeBody,
                      fontWeight: AppTypography.extraBold,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppTypography.sizeCaption,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.arrow_forward_ios,
              color: subtitleColor,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final bool selected;
  final Color titleColor;
  final Color subtitleColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.title,
    required this.selected,
    required this.titleColor,
    required this.subtitleColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderMd,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppRadius.borderMd,
          border: Border.all(
            color: selected ? AppColors.neonGoldDim : borderColor,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppTypography.sizeBody,
                  fontWeight: AppTypography.extraBold,
                  color: titleColor,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.neonGoldDim : subtitleColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
