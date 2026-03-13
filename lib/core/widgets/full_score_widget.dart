import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/features/rank/screens/rank_screen.dart';
import 'package:flutter/material.dart';

class FullScorerList extends StatelessWidget {
  final List<PlayerModel> players;
  const FullScorerList({required this.players});
  @override
  Widget build(BuildContext context) => FullRankingList(players: players);
}

