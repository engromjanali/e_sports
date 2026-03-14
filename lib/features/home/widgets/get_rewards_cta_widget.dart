import 'package:e_sports/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class GetRewardsCta extends StatelessWidget {
  final VoidCallback onTap;
  const GetRewardsCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1a0a2e), Color(0xFF2d1b5e)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.neonPurple.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(color: AppColors.neonPurple.withOpacity(0.15), blurRadius: 20)
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("GET REWARDS",
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.neonGold,
                    letterSpacing: 1.5)),
            const SizedBox(height: 3),
            const Text("Unlock Badges & Trophies",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neonPurple.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.neonPurple.withOpacity(0.4), blurRadius: 12)
                ],
              ),
              child: const Text("Claim Now →",
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
          const Text("🏆", style: TextStyle(fontSize: 52)),
        ]),
      ),
    );
  }
}
