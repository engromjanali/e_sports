import 'dart:math';
import 'package:e_sports/core/data/models/achievement_model.dart';
import 'package:e_sports/core/data/models/match_entry_model.dart';
import 'package:e_sports/core/data/models/news_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/data/models/tournament_model.dart';
import 'package:flutter/material.dart';

class MockDataSource {
  static List<PlayerModel> getPlayers() => [
        const PlayerModel(id: 1, name: "Aryan Bhuiyan", short: "Aryan", team: "Empire FC", jerseyNumber: 10, tags: ["RANK #1", "VIP", "ELITE"],
          imageUrl: "https://imageio.forbes.com/specials-images/imageserve/663e595b4509f97fdafb95f5/0x0.jpg?format=jpg&crop=383,383,x1045,y23,safe&height=416&width=416&fit=bounds"),
        const PlayerModel(id: 2, name: "Owasikur Rahman", short: "Owasikur", team: "Brothers", jerseyNumber: 7, tags: ["RANK #2", "VIP", "PRO"],
          imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqgucNaWMtVt_NB5N3XSZF7UPFnz8TmtSuvQ&s"),
        const PlayerModel(id: 3, name: "Asif Reza", short: "Asif", team: "Vikings", jerseyNumber: 9, tags: ["RANK #3", "ELITE"],
          imageUrl: "https://imageio.forbes.com/specials-images/imageserve/663e595b4509f97fdafb95f5/0x0.jpg?format=jpg&crop=383,383,x1045,y23,safe&height=416&width=416&fit=bounds"),
        const PlayerModel(id: 4, name: "Shariq Ul Baari", short: "Shariq", team: "Legends", jerseyNumber: 11, tags: ["VIP", "STRIKER"],
          imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqgucNaWMtVt_NB5N3XSZF7UPFnz8TmtSuvQ&s"),
        const PlayerModel(id: 5, name: "Suran Lohani", short: "Suran", team: "PBCC", jerseyNumber: 8, tags: ["PRO","Season 1 champion","MVP","player of the month aplir 24","player of the month may 24","player of the month june 24","player of the month july 24","player of the month august 24","PRO","Season 1 champion","MVP","player of the month aplir 24","player of the month may 24","player of the month june 24","player of the month july 24","player of the month august 24","PRO","Season 1 champion","MVP","player of the month aplir 24","player of the month may 24","player of the month june 24","player of the month july 24","player of the month august 24","PRO","Season 1 champion","MVP","player of the month aplir 24","player of the month may 24","player of the month june 24","player of the month july 24","player of the month august 24",],
          imageUrl: "https://imageio.forbes.com/specials-images/imageserve/663e595b4509f97fdafb95f5/0x0.jpg?format=jpg&crop=383,383,x1045,y23,safe&height=416&width=416&fit=bounds"),
        const PlayerModel(id: 6, name: "Farhan Ahmed", short: "Farhan", team: "Rebels", jerseyNumber: 22, tags: ["MEMBER"],
          imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqgucNaWMtVt_NB5N3XSZF7UPFnz8TmtSuvQ&s"),
        const PlayerModel(id: 7, name: "Zubair Hashmi", short: "Zubair", team: "Elite FC", jerseyNumber: 5, tags: ["DEFENDER"],
          imageUrl: "https://imageio.forbes.com/specials-images/imageserve/663e595b4509f97fdafb95f5/0x0.jpg?format=jpg&crop=383,383,x1045,y23,safe&height=416&width=416&fit=bounds"),
        const PlayerModel(id: 8, name: "Tanvir Hasan", short: "Tanvir", team: "Empire FC", jerseyNumber: 1, tags: ["GK"],
          imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqgucNaWMtVt_NB5N3XSZF7UPFnz8TmtSuvQ&s"),
        const PlayerModel(id: 9, name: "Ahsan abir", short: "abir", team: "Vikings", jerseyNumber: 14, tags: ["MID"],
          imageUrl: "https://imageio.forbes.com/specials-images/imageserve/663e595b4509f97fdafb95f5/0x0.jpg?format=jpg&crop=383,383,x1045,y23,safe&height=416&width=416&fit=bounds"),
        const PlayerModel(id: 10, name: "Mehedi Hassan", short: "Mehedi", team: "Brothers", jerseyNumber: 12, tags: ["SUB"],
          imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqgucNaWMtVt_NB5N3XSZF7UPFnz8TmtSuvQ&s"),
      ];

  // static List<MatchEntryModel> getMatchEntries() {
  //   final now = DateTime.now();
  //   final List<MatchEntryModel> entries = [];
  //   final random = Random();
    
  //   // Generate 22 matches for each of the 10 players
  //   for (int pId = 1; pId <= 10; pId++) {
  //     for (int i = 0; i < 22; i++) {
  //       final date = now.subtract(Duration(days: i + (pId * 2)));
  //       final r = random.nextInt(10);
  //       String result;
  //       int goals;
  //       int goalsConceded;
        
  //       if (r < 6) { // 60% Win
  //         result = 'win';
  //         goals = random.nextInt(4) + (i % 2); 
  //         goalsConceded = random.nextInt(max(1, goals));
  //       } else if (r < 8) { // 20% Draw
  //         result = 'draw';
  //         goals = random.nextInt(3);
  //         goalsConceded = goals;
  //       } else { // 20% Loss
  //         result = 'loss';
  //         goals = random.nextInt(2);
  //         goalsConceded = goals + random.nextInt(3) + 1;
  //       }

  //       entries.add(MatchEntryModel(
  //         id: 'm_${pId}_$i',
  //         playerId: pId,
  //         date: date,
  //         result: result,
  //         goals: goals,
  //         goalsConceded: goalsConceded,
  //         hattrick: goals >= 3,
  //         cleanSheet: goalsConceded == 0,
  //         motm: (result == 'win' && random.nextDouble() > 0.3) || (result == 'draw' && random.nextDouble() > 0.7),
  //       ));
  //     }
  //   }
  //   return entries;
  // }

  static List<MatchEntryModel> getMatchEntries() {
    final now = DateTime.now();
    final List<MatchEntryModel> entries = [];
    final random = Random();

    for (int pId = 1; pId <= 10; pId++) {
      final int matchCount = random.nextInt(21) + 10; // 10 to 30
      for (int i = 0; i < matchCount; i++) {
        final date = now.subtract(Duration(days: i + (pId * 2)));
        final r = random.nextInt(10);
        String result;
        int goals;
        int goalsConceded;

        if (r < 6) {
          result = 'win';
          goals = random.nextInt(4) + (i % 2);
          goalsConceded = random.nextInt(max(1, goals));
        } else if (r < 8) {
          result = 'draw';
          goals = random.nextInt(3);
          goalsConceded = goals;
        } else {
          result = 'loss';
          goals = random.nextInt(2);
          goalsConceded = goals + random.nextInt(3) + 1;
        }

        entries.add(MatchEntryModel(
          id: 'm_${pId}_$i',
          playerId: pId,
          date: date,
          result: result,
          goals: goals,
          goalsConceded: goalsConceded,
          hattrick: goals >= 3,
          cleanSheet: goalsConceded == 0,
          motm: (result == 'win' && random.nextDouble() > 0.3) ||
              (result == 'draw' && random.nextDouble() > 0.7),
        ));
      }
    }
    return entries;
  }

  static List<NewsModel> getNews() => [
        NewsModel(
          id: 1,
          title: "Tawsif Secures MVP",
          summary: "Empire FC captain takes the golden boot.",
          description: "In an incredible season finale, Tawsif showed why he is the best player in the league by scoring a hat-trick against rivals Vikings.",
          tag: "AWARDS",
          time: "2h ago",
          emoji: "🏆",
          hot: true,
          date: DateTime.now().subtract(const Duration(days: 1)),
          imageUrl: 'https://ichef.bbci.co.uk/ace/standard/3840/cpsprodpb/b981/live/400edaa0-ff95-11ef-b50e-9d086302645f.jpg',
          content: "In an incredible season finale, Tawsif showed why he is the best player in the league by scoring a hat-trick against rivals Vikings. The crowd was on their feet as he clinicaly finished three chances to secure the win and the MVP title.",
        ),
        NewsModel(
          id: 2,
          title: "Vikings Final Roster",
          summary: "Asif leads the charge for Vikings.",
          description: "Vikings have announced their final roster for the upcoming Winter Cup, with Asif Reza confirmed as the lead playmaker.",
          tag: "ROSTER",
          time: "1d ago",
          emoji: "⚔️",
          hot: false,
          date: DateTime.now().subtract(const Duration(days: 3)),
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4xoy8uKVarjNlfURyt6iWh8vcv3VPDLDM8g&s',
          content: "Vikings have announced their final roster for the upcoming Winter Cup, with Asif Reza confirmed as the lead playmaker. The team has been training hard and looks ready to challenge for the title this season.",
        ),
        NewsModel(
          id: 3,
          title: "Winter Cup 2026 Registration Open",
          summary: "Join the biggest tournament of the year.",
          description: "Registrations for the highly anticipated Winter Cup 2026 are now officially open. Teams from across the country are expected to participate for the \$5000 prize pool.",
          tag: "TOURNAMENT",
          time: "5h ago",
          emoji: "🏆",
          hot: true,
          date: DateTime.now().subtract(const Duration(hours: 5)),
          imageUrl: 'https://assets.goal.com/images/v3/blt83f90912fb59abba/NXGN%20HIC%20Template%20[16_9]%20Multiple%20Image.jpg?auto=webp&format=pjpg&width=3840&quality=60',
          content: "The Winter Cup return this January with a revamped format and a larger prize pool. House Of Elites, our primary sponsor, has promised an immersive experience for both players and fans. Don't miss out on your chance to be part of history.",
        ),
        NewsModel(
          id: 4,
          title: "New Update: Version 2.4",
          summary: "Balance changes and new features.",
          description: "The latest update brings significant balance changes to player stats and introduces the new 'Team Synergy' mechanic.",
          tag: "UPDATE",
          time: "2d ago",
          emoji: "⚙️",
          hot: false,
          date: DateTime.now().subtract(const Duration(days: 2)),
          imageUrl: 'https://ichef.bbci.co.uk/ace/standard/3840/cpsprodpb/b981/live/400edaa0-ff95-11ef-b50e-9d086302645f.jpg',
          content: "Version 2.4 focuses on competitive integrity. We've adjusted the goal-scoring algorithm and refined the rank point calculations. Check out the full patch notes on our website.",
        ),
      ];

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

      // static List<AchievementModel> getAchievements() => [
      //   const AchievementModel(id: 1, title: "First Blood", description: "Score the first goal of a match.", icon: 'assets/icons/ach_1.png', date: '2024-01-15', category: 'Special', color: Colors.red),
      //   const AchievementModel(id: 2, title: "Hat-trick Hero", description: "Score 3 goals in a single match.", icon: 'assets/icons/ach_2.png', date: '2024-02-10', category: 'Personal', color: Colors.amber),
      //   const AchievementModel(id: 3, title: "Clean Sheet", description: "Win a match without conceding.", icon: 'assets/icons/ach_3.png', date: '2024-03-05', category: 'Team', color: Colors.blue),
      //   const AchievementModel(id: 4, title: "Top Scorer", description: "Become the league's leading scorer.", icon: 'assets/icons/ach_4.png', date: '2024-12-01', category: 'Global', color: Colors.purple),
      //   const AchievementModel(id: 5, title: "Captain Lead", description: "Win 5 matches as a team captain.", icon: 'assets/icons/ach_5.png', date: '2025-01-20', category: 'Social', color: Colors.teal),
      // ];
}
