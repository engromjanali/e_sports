import 'package:e_sports/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SectionHeadingWidget extends StatelessWidget {
  final String title;
  final String? sub;
  final VoidCallback? onAll;

  const SectionHeadingWidget({super.key, required this.title, this.sub, this.onAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              if (sub != null) Text(sub!, style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
          if (onAll != null)
            GestureDetector(
              onTap: onAll,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.neonBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.neonBlue.withOpacity(0.25)),
                ),
                child: const Text("View All →",
                    style: TextStyle(color: AppColors.neonBlue, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ),
        ],
      ),
    );
  }
}
