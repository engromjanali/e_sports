import 'package:flutter/material.dart';

class AchievementModel {
  final int id;
  final String title;
  final String description;
  final String icon;
  final String date;
  final String category; // 'Personal', 'Team', 'Special'
  final Color color;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.date,
    required this.category,
    required this.color,
  });
}
