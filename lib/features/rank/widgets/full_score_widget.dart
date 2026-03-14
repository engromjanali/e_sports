import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/features/rank/widgets/full_ranking_list_widget.dart';
import 'package:flutter/material.dart';

class FullScorerListWidget extends StatelessWidget {
  final List<PlayerModel> players;
  const FullScorerListWidget({required this.players});
  @override
  Widget build(BuildContext context) => FullRankingList(players: players);
}