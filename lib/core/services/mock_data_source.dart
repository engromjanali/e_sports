import '../../features/news/domain/model/news_model.dart';
import '../data/models/tournament_model.dart';
import 'package:flutter/material.dart';

class MockDataSource {

  static List<TournamentModel> getTournaments() => [
        TournamentModel(
          id: 1,
          name: "Winter Cup 2026",
          status: "Ongoing",
          tag: "MAJOR",
          prize: "\$5000",
          sponsor: "House Of Elites",
          starts: "20 Dec 2025",
          regDeadline: "15 Dec 2025",
          format: "Knockout",
          cost: 50,
          slots: 16,
          filled: 12,
          rounds: ["Quarter Finals", "Semi Finals", "Grand Final"],
          rewards: [
            TournamentReward(icon: "🥇", pos: "1st Place", detail: "\$3,000 + Trophy", color: Colors.amber),
            TournamentReward(icon: "🥈", pos: "2nd Place", detail: "\$1,500", color: Colors.grey),
            TournamentReward(icon: "🥉", pos: "3rd Place", detail: "\$500", color: Colors.brown),
          ],
          bracket: [
            TournamentBracketRound(roundName: "Quarter Finals", matches: [
              ["Empire FC", "Vikings"], ["Legends", "PBCC"], ["Brothers", "Rebels"], ["Elite", "Phoenix"]
            ]),
            TournamentBracketRound(roundName: "Semi Finals", matches: [
              ["TBD", "TBD"], ["TBD", "TBD"]
            ]),
          ],
        ),
        TournamentModel(
          id: 2,
          name: "Summer League 2026",
          status: "Upcoming",
          tag: "LEAGUE",
          prize: "\$10,000",
          sponsor: "Global Gaming",
          starts: "01 June 2026",
          regDeadline: "20 May 2026",
          format: "Round Robin",
          cost: 100,
          slots: 20,
          filled: 5,
          rounds: ["Regular Season", "Playoffs"],
          rewards: [
            TournamentReward(icon: "🥇", pos: "Champion", detail: "\$7,000", color: Colors.amber),
            TournamentReward(icon: "🥈", pos: "Runner-up", detail: "\$3,000", color: Colors.grey),
          ],
          bracket: [],
        ),
      ];
}
