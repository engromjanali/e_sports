import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/theme_controller.dart';
import 'package:e_sports/core/utils/dimensions.dart';
import '../../profile/controllers/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController _profile = Get.find<ProfileController>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _tagController;

  @override
  void initState() {
    super.initState();
    final user = _profile.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _tagController = TextEditingController(text: user?.sortName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Edit Profile', 'Name cannot be empty');
      return;
    }
    final ok = await _profile.updateProfile(
      name: name,
      sortName: _tagController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
    );
    Get.snackbar(
      ok ? 'Profile Updated' : 'Update Failed',
      ok ? 'Your profile changes were saved.' : 'Could not save changes. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.neonGoldDim,
      colorText: Colors.black,
      margin: EdgeInsets.all(Dimensions.md),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.find<ThemeController>().isDarkMode;
    final screenColor = isDarkMode ? AppColors.bg : const Color(0xFFF8FAFC);
    final cardColor = isDarkMode ? AppColors.bgCard : Colors.white;
    final borderColor = isDarkMode ? AppColors.glassBorder : const Color(0xFFE2E8F0);
    final titleColor = isDarkMode ? AppColors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode ? AppColors.textMuted : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: screenColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        foregroundColor: titleColor,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: titleColor,
            fontWeight: Dimensions.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.screenPadding),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(Dimensions.lg),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: Dimensions.borderLg,
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Basic Details",
                  style: TextStyle(
                    fontSize: Dimensions.sizeTitleLarge,
                    fontWeight: Dimensions.black,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: Dimensions.xs),
                Text(
                  "Update the information shown in your account section.",
                  style: TextStyle(
                    fontSize: Dimensions.sizeCaption,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: Dimensions.lg),
                _ProfileField(
                  label: "Full Name",
                  controller: _nameController,
                  titleColor: titleColor,
                  subtitleColor: subtitleColor,
                  borderColor: borderColor,
                ),
                SizedBox(height: Dimensions.md),
                _ProfileField(
                  label: "Email",
                  controller: _emailController,
                  titleColor: titleColor,
                  subtitleColor: subtitleColor,
                  borderColor: borderColor,
                ),
                SizedBox(height: Dimensions.md),
                _ProfileField(
                  label: "Sort Name",
                  controller: _tagController,
                  titleColor: titleColor,
                  subtitleColor: subtitleColor,
                  borderColor: borderColor,
                ),
                SizedBox(height: Dimensions.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGoldDim,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: Dimensions.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: Dimensions.borderMd,
                      ),
                    ),
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                        fontWeight: Dimensions.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color titleColor;
  final Color subtitleColor;
  final Color borderColor;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.titleColor,
    required this.subtitleColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.sizeCaption,
            fontWeight: Dimensions.extraBold,
            color: subtitleColor,
          ),
        ),
        SizedBox(height: Dimensions.xs),
        TextField(
          controller: controller,
          style: TextStyle(
            color: titleColor,
            fontSize: Dimensions.sizeBody,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: Dimensions.borderMd,
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: Dimensions.borderMd,
              borderSide: const BorderSide(color: AppColors.neonGoldDim),
            ),
          ),
        ),
      ],
    );
  }
}
