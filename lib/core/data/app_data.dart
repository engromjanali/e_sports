import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/main.dart';
import 'package:flutter/animation.dart';

class AppData {
  static const players = [
    PlayerModel(id:1,name:"Tawsif Ul Anam",  short:"Tawsif",   pts:946, goals:164,matches:302,wins:233,losses:42, draws:27,gf:945, ga:312,rank:1,fa:4.4,hattricks:12,cleansheets:34),
    PlayerModel(id:2,name:"Owasikur Rahman", short:"Owasikur", pts:888, goals:157,matches:482,wins:290,losses:98, draws:94,gf:1257,ga:589,rank:2,fa:8.4,hattricks:9, cleansheets:28),
    PlayerModel(id:3,name:"Asif Reza",       short:"Asif",     pts:859, goals:149,matches:485,wins:338,losses:87, draws:60,gf:1643,ga:741,rank:3,fa:4.4,hattricks:7, cleansheets:22),
    PlayerModel(id:4,name:"Shariq Ul Baari", short:"Shariq",   pts:824, goals:132,matches:390,wins:201,losses:121,draws:68,gf:899, ga:502,rank:4,fa:3.9,hattricks:5, cleansheets:18),
    PlayerModel(id:5,name:"Suran Lohani",    short:"Suran",    pts:819, goals:128,matches:344,wins:188,losses:99, draws:57,gf:788, ga:431,rank:5,fa:3.7,hattricks:4, cleansheets:15),
    PlayerModel(id:6,name:"Farhan Ahmed",    short:"Farhan",   pts:776, goals:115,matches:310,wins:171,losses:88, draws:51,gf:712, ga:399,rank:6,fa:3.2,hattricks:3, cleansheets:11),
  ];

  static const matches = [
    MatchModel(id:1,t1:"Empire",  i1:"⚔️",t2:"Brothers",i2:"👊",time:"03:00 PM",date:"Today",   status:"live",      slots:"6/24"),
    MatchModel(id:2,t1:"Vikings", i1:"⚡",t2:"Legends",  i2:"🌟",time:"06:00 PM",date:"Today",   status:"upcoming",  slots:"5/33"),
    MatchModel(id:3,t1:"PBCC",    i1:"🐯",t2:"Rebels",   i2:"🔥",time:"08:30 PM",date:"Today",   status:"upcoming",  slots:"8/20"),
    MatchModel(id:4,t1:"Nomads",  i1:"🏕️",t2:"Titans",   i2:"🗡️",time:"06:00 PM",date:"Tomorrow",status:"upcoming",  slots:"5/33"),
    MatchModel(id:5,t1:"Shariq",  i1:"⚔️",t2:"Tawsif",   i2:"👑",time:"05:00 PM",date:"Dec 20", status:"completed", score:"3-1",resultType:"win", resultLabel:"WON by 3 Goals"),
    MatchModel(id:6,t1:"Owasi",   i1:"🌟",t2:"Shariq",   i2:"⚔️",time:"04:00 PM",date:"Dec 19", status:"completed", score:"5-2",resultType:"win", resultLabel:"WON by 3 Goals"),
    MatchModel(id:7,t1:"Asif",    i1:"🔥",t2:"Tawsif",   i2:"👑",time:"07:00 PM",date:"Dec 18", status:"completed", score:"1-4",resultType:"loss",resultLabel:"LOST by 3 Goals"),
    MatchModel(id:8,t1:"Tawsif",  i1:"👑",t2:"Farhan",   i2:"💎",time:"03:00 PM",date:"Dec 17", status:"completed", score:"2-2",resultType:"draw",resultLabel:"DRAW"),
  ];

  static const news = [
    NewsModel(id:1,tag:"MILESTONE", title:"Aryan Hits 100 Goals This Season!",               time:"Just now",emoji:"⚽",cat:"milestone", hot:true),
    NewsModel(id:2,tag:"TOURNAMENT",title:"Grand Final Set For Dec 25 — Prize Pool ৳50,000", time:"2h ago",  emoji:"🏆",cat:"tournament",hot:true),
    NewsModel(id:3,tag:"MATCH",     title:"Tawsif Powers Team To Back-to-Back Victory",      time:"5h ago",  emoji:"⚡",cat:"match",     hot:false),
    NewsModel(id:4,tag:"SEASON",    title:"Season 2025 Rewards & Badge System Revealed",     time:"1d ago",  emoji:"🎖️",cat:"season",    hot:false),
    NewsModel(id:5,tag:"RANKINGS",  title:"Owasikur Climbs to #2 After Stunning Week",       time:"2d ago",  emoji:"📈",cat:"rankings",  hot:false),
    NewsModel(id:6,tag:"TRANSFER",  title:"New Player Registrations Now Open For Season 2025",time:"3d ago", emoji:"📋",cat:"season",    hot:false),
  ];

  static const last15 = ["win","win","loss","draw","win","win","win","loss","draw","win","loss","win","win","draw","win"];

  static const achievements = [
    {'icon':"🏆",'label':"Champion",  'unlocked':true },
    {'icon':"⚽",'label':"100 Goals", 'unlocked':true },
    {'icon':"🎖️",'label':"Elite",     'unlocked':true },
    {'icon':"🔥",'label':"10 Streak", 'unlocked':true },
    {'icon':"👑",'label':"Legend",    'unlocked':true },
    {'icon':"💎",'label':"Diamond",   'unlocked':false},
    {'icon':"🎯",'label':"Sniper",    'unlocked':false},
    {'icon':"⭐",'label':"All-Star",  'unlocked':false},
  ];

  static List<TournamentModel> get tournaments => [
    TournamentModel(
      id:1, name:"Season Grand Finals", tag:"GRAND FINAL", status:"open",
      cost:50, prize:"৳50,000 Cash + Gold Trophy", sponsor:"The Elites FC & Season Sponsor",
      starts:"Dec 25 · 9:00 PM", regDeadline:"Dec 24 · 11:59 PM",
      slots:16, filled:12, format:"Single Elimination",
      rounds:const ["Quarter Finals","Semi Finals","Grand Final"],
      bracket:[
        BracketRound(roundName:"QUARTER FINALS",matches:const[["Empire FC","Brothers"],["Vikings","Legends FC"],["PBCC","Rebels"],["Nomads","Titans FC"]]),
        BracketRound(roundName:"SEMI FINALS",   matches:const[["TBD","TBD"],["TBD","TBD"]]),
        BracketRound(roundName:"GRAND FINAL",   matches:const[["TBD","TBD"]]),
      ],
      rewards:const [
        RewardTier(pos:"1st Place", icon:"🥇", color:AppColors.neonGold,   detail:"৳25,000 + Gold Trophy + VIP Badge"),
        RewardTier(pos:"2nd Place", icon:"🥈", color:AppColors.silver,     detail:"৳15,000 + Silver Medal + Badge"),
        RewardTier(pos:"3rd Place", icon:"🥉", color:AppColors.bronze,     detail:"৳10,000 + Bronze Medal"),
        RewardTier(pos:"Top Scorer",icon:"⚽", color:AppColors.neonCyan,   detail:"Special Award + 200 Points"),
      ],
    ),
    TournamentModel(
      id:2, name:"Weekly Cup — Wk 52", tag:"WEEKLY CUP", status:"upcoming",
      cost:20, prize:"200 Points + Club Badge", sponsor:"The Elites Club",
      starts:"Dec 28 · 7:00 PM", regDeadline:"Dec 27 · 11:59 PM",
      slots:8, filled:3, format:"Round Robin",
      rounds:const ["Group Stage","Final"],
      bracket:const [],
      rewards:const [
        RewardTier(pos:"1st Place", icon:"🥇", color:AppColors.neonGold, detail:"200 Points + Exclusive Badge"),
        RewardTier(pos:"2nd Place", icon:"🥈", color:AppColors.silver,   detail:"100 Points + Silver Badge"),
        RewardTier(pos:"Top Scorer",icon:"⚽", color:AppColors.neonCyan, detail:"50 Points + Goal King Badge"),
      ],
    ),
    TournamentModel(
      id:3, name:"Champions League S2", tag:"SEASON", status:"ended",
      cost:100, prize:"৳1,00,000 Grand Prize", sponsor:"Premium Club Sponsor",
      starts:"Nov 15", regDeadline:"Nov 14",
      slots:32, filled:32, format:"Double Elimination",
      rounds:const ["Group","R16","QF","SF","Final"],
      bracket:const [],
      rewards:const [
        RewardTier(pos:"Champion",  icon:"🏆", color:AppColors.neonGold, detail:"৳60,000 + Legend Trophy + Crown Badge"),
        RewardTier(pos:"Runner-up", icon:"🥈", color:AppColors.silver,   detail:"৳30,000 + Runner-up Medal"),
        RewardTier(pos:"3rd Place", icon:"🥉", color:AppColors.bronze,   detail:"৳10,000"),
      ],
    ),
  ];

  static List<ShopItem> defaultShopItems() => [
    ShopItem(icon:"👑", name:"VIP Crown",    cost:500, accent:AppColors.neonGold,   owned:true,  info:"Crown badge on your profile card"),
    ShopItem(icon:"✨", name:"Name Glow",    cost:200, accent:AppColors.neonBlue,   owned:false, info:"Glowing name in match listings"),
    ShopItem(icon:"🛡️", name:"Elite Shield", cost:350, accent:AppColors.neonPurple, owned:false, info:"Elite defender badge"),
    ShopItem(icon:"⚡", name:"Rank Boost",   cost:300, accent:AppColors.neonOrange, owned:false, info:"1.5× points for 7 days"),
    ShopItem(icon:"🎯", name:"Goal FX",      cost:150, accent:AppColors.neonGreen,  owned:false, info:"Goal celebration effect"),
    ShopItem(icon:"💎", name:"Diamond Tag",  cost:800, accent:AppColors.neonCyan,   owned:false, info:"Ultra-rare diamond-tier tag"),
  ];
}
class PlayerModel {
  final int id;
  final String name, short;
  final int pts, goals, matches, wins, losses, draws, gf, ga, rank, hattricks, cleansheets;
  final double fa;
  const PlayerModel({
    required this.id, required this.name, required this.short,
    required this.pts, required this.goals, required this.matches,
    required this.wins, required this.losses, required this.draws,
    required this.gf, required this.ga, required this.rank, required this.fa,
    required this.hattricks, required this.cleansheets,
  });
}

class MatchModel {
  final int id;
  final String t1, i1, t2, i2, time, date, status;
  final String? slots, score, resultType, resultLabel;
  const MatchModel({
    required this.id, required this.t1, required this.i1,
    required this.t2, required this.i2, required this.time,
    required this.date, required this.status,
    this.slots, this.score, this.resultType, this.resultLabel,
  });
}

class NewsModel {
  final int id;
  final String tag, title, time, emoji, cat;
  final bool hot;
  const NewsModel({
    required this.id, required this.tag, required this.title,
    required this.time, required this.emoji, required this.cat, required this.hot,
  });
}

class TournamentModel {
  final int id;
  final String name, tag, status, prize, sponsor, starts, regDeadline, format;
  final int cost, slots, filled;
  final List<String> rounds;
  final List<BracketRound> bracket;
  final List<RewardTier> rewards;
  const TournamentModel({
    required this.id, required this.name, required this.tag,
    required this.status, required this.prize, required this.sponsor,
    required this.starts, required this.regDeadline, required this.format,
    required this.cost, required this.slots, required this.filled,
    required this.rounds, required this.bracket, required this.rewards,
  });
}

class BracketRound {
  final String roundName;
  final List<List<String>> matches;
  const BracketRound({required this.roundName, required this.matches});
}

class RewardTier {
  final String pos, icon, detail;
  final Color color;
  const RewardTier({required this.pos, required this.icon, required this.detail, required this.color});
}

class ShopItem {
  final String icon, name, info;
  final int cost;
  final Color accent;
  bool owned;
  ShopItem({required this.icon, required this.name, required this.info,
    required this.cost, required this.accent, required this.owned});
}

class TaskModel {
  final String id, icon, label;
  final int goal;
  int done;
  final int pts;
  final bool isAd;
  TaskModel({required this.id, required this.icon, required this.label,
    required this.goal, required this.done, required this.pts, required this.isAd});
}

class ChatMessage {
  final bool me;
  final String text, time;
  const ChatMessage({required this.me, required this.text, required this.time});
}