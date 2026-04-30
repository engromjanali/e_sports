import '../../../core/data/models/computed_player_stats.dart';
import 'full_ranking_list_widget.dart';
import 'package:flutter/material.dart';

class FullScorerListWidget extends StatelessWidget {
  final List<ComputedPlayerStats> players;
  const FullScorerListWidget({required this.players});
  @override
  Widget build(BuildContext context) => FullRankingList(
        players: players,
        isScorerList: true,
      );
}