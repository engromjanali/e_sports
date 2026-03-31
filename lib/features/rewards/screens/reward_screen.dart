import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_sports/core/controllers/app_data_controller.dart';
import 'package:e_sports/core/data/models/tournament_model.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/core/theme/app_theme.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/neon_pregress_bar_widget.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/core/widgets/player_avater.dart';


class RewardsScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  const RewardsScreen({super.key, this.onSearchTap, this.onProfileTap});
  @override State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> with TickerProviderStateMixin {
  int _tab = 0;
  int _coins = 946;
  int _ads = 47;
  bool _watching = false;
  int _timer = 0;
  Timer? _adTimer;

  // Tournament state
  int _selTrn = 0;
  final List<int> _joined = [];
  bool _bracketOpen = false;

  // Shop state
  late List<ShopItem> _shopItems;
  int? _selShop;

  // Chat state
  final List<ChatMessage> _chats = const [
    ChatMessage(me: false, text: "👋 Welcome to GameArena Season 2025! All prizes are now live.", time: "2h"),
    ChatMessage(me: false, text: "Use your earned points to enter tournaments & win club prizes! 🏆", time: "1h"),
    ChatMessage(me: true,  text: "When does the Grand Final bracket lock?", time: "30m"),
    ChatMessage(me: false, text: "Bracket locks Dec 24 midnight. Register now — good luck! 🎉", time: "25m"),
  ];
  final List<ChatMessage> _extraChats = [];
  List<ChatMessage> get _chatList => [..._chats, ... _extraChats];
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _chatScroll = ScrollController();
  bool _tncOpen = false;

  // Tab animation controller
  late AnimationController _tabAnim;

  @override
  void initState() {
    super.initState();
    _shopItems = _defaultShopItems();
    _tabAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _tabAnim.forward();
  }

  List<ShopItem> _defaultShopItems() {
    return [
      ShopItem(icon: "🎫", name: "Premium Pass", info: "Unlocks premium rewards for Season 2025", cost: 1500, accent: AppColors.neonGold),
      ShopItem(icon: "🎨", name: "Neon Profile Theme", info: "Exclusive purple neon theme", cost: 800, accent: AppColors.neonPurple),
      ShopItem(icon: "🏆", name: "Tournament Ticket", info: "Free entry to any weekend tournament", cost: 500, accent: AppColors.neonCyan),
    ];
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    _msgCtrl.dispose();
    _chatScroll.dispose();
    _tabAnim.dispose();
    super.dispose();
  }

  void _startAd() {
    if (_watching) return;
    setState(() { _watching = true; _timer = 5; });
    _adTimer?.cancel();
    _adTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_timer > 0) { _timer--; }
        else {
          t.cancel();
          _watching = false;
          _ads = (_ads + 1).clamp(0, 400);
          _coins += 1;
        }
      });
    });
  }

  void _sendMsg() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _extraChats.add(ChatMessage(me: true, text: text, time: "now"));
      _msgCtrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScroll.hasClients) {
        _chatScroll.animateTo(_chatScroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _extraChats.add(const ChatMessage(
          me: false, text: "Thanks! Our admin will reply shortly. ✅", time: "now")));
    });
  }

  void _switchTab(int idx) {
    _tabAnim.forward(from: 0);
    setState(() {
      _tab = idx;
      _selShop = null;
    });
  }

  static const _tabs = [
    _TabItem(icon: "📺", label: "Earn"),
    _TabItem(icon: "🏆", label: "Tournament"),
    _TabItem(icon: "🛒", label: "Shop"),
    _TabItem(icon: "💬", label: "Admin Chat"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      _buildTopHeader(),

      _buildTabBar(),
      Expanded(child: FadeTransition(
        opacity: _tabAnim,
        child: _buildTabContent(),
      )),
    ]);
  }

  Widget _buildTopHeader() {
    return AppHeader(
      sub: 'Rewards · Season 2025',
      onSearchTap: widget.onSearchTap,
      onProfileTap: widget.onProfileTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.neonGold.withOpacity(AppColors.opacity10),
            borderRadius: AppRadius.borderMd,
            border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity30)),
            boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(AppColors.opacity20), blurRadius: 10)],
          ),
          child: Row(children: [
            Text("🪙", style: TextStyle(fontSize: AppTypography.sizeBody)),
            SizedBox(width: AppSpacing.xs),
            Text("$_coins",
                style: TextStyle(
                    fontSize: AppTypography.sizeBody, fontWeight: AppTypography.black, color: AppColors.neonGold)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Row(children: List.generate(_tabs.length, (i) {
        final active = _tab == i;
        return Expanded(child: GestureDetector(
          onTap: () => _switchTab(i),
          behavior: HitTestBehavior.opaque,
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md + 1),
                child: Column(children: [
                  Text(_tabs[i].icon, style: TextStyle(fontSize: active ? AppTypography.sizeBody + 2 : AppTypography.sizeBody + 1)),
                  SizedBox(height: AppSpacing.xxs + 1),
                  Text(_tabs[i].label, style: TextStyle(
                    fontSize: AppTypography.sizeCaption,
                    fontWeight: active ? AppTypography.extraBold : AppTypography.medium,
                    color: active ? AppColors.neonCyan : AppColors.textMuted,
                  )),
                ]),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: AppSizing.navIndicatorHeight,
                width: active ? constraints.maxWidth : 0,
                decoration: BoxDecoration(
                  color: AppColors.neonCyan,
                  boxShadow: active ? [BoxShadow(color: AppColors.neonCyan.withOpacity(AppColors.opacity60), blurRadius: 6)] : [],
                ),
              ),
            ]);
          }),
        ));
      })),
    );
  }

  Widget _buildTabContent() {
    switch (_tab) {
      case 0: return _EarnTab(
        ads: _ads, coins: _coins, watching: _watching, timer: _timer,
        tncOpen: _tncOpen, onToggleTnc: () => setState(() => _tncOpen = !_tncOpen),
        onStartAd: _startAd,
      );
      case 1: return TournamentTabWidget(
        selTrn: _selTrn, joined: _joined, bracketOpen: _bracketOpen, coins: _coins,
        onSelTrn: (i) => setState(() { _selTrn = i; _bracketOpen = false; }),
        onToggleBracket: () => setState(() => _bracketOpen = !_bracketOpen),
        onJoin: (TournamentModel trn) {
          if (_coins >= trn.cost && !_joined.contains(trn.id)) {
            setState(() { _coins -= trn.cost; _joined.add(trn.id); });
          }
        },
      );
      case 2: return _ShopTab(
        coins: _coins, items: _shopItems, selIdx: _selShop,
        onSel: (i) => setState(() => _selShop = _selShop == i ? null : i),
        onBuy: (i) => setState(() {
          _coins -= _shopItems[i].cost;
          _shopItems[i].owned = true;
          _selShop = null;
        }),
      );
      case 3: return _ChatTab(
        chats: _chatList, ctrl: _msgCtrl,
        scrollCtrl: _chatScroll, onSend: _sendMsg,
      );
      default: return const SizedBox.shrink();
    }
  }
}

class _TabItem { final String icon, label; const _TabItem({required this.icon, required this.label}); }

class _EarnTab extends StatelessWidget {
  final int ads, coins, timer;
  final bool watching, tncOpen;
  final VoidCallback onStartAd, onToggleTnc;

  const _EarnTab({
    required this.ads, required this.coins, required this.timer,
    required this.watching, required this.tncOpen,
    required this.onStartAd, required this.onToggleTnc,
  });

  List<TaskModel> get _daily => [
    TaskModel(id:"d1",icon:"📺",label:"Watch 1 Ads Today", goal:1,  done:ads.clamp(0,1),   pts:1,   isAd:true),
    TaskModel(id:"d1",icon:"📺",label:"Watch 3 Ads Today", goal:3,  done:ads.clamp(0,3),   pts:3,   isAd:true),
    TaskModel(id:"d1",icon:"📺",label:"Watch 5 Ads Today", goal:5,  done:ads.clamp(0,5),  pts:5,   isAd:true),
  ];
  List<TaskModel> get _weekly => [
    TaskModel(id:"w1",icon:"📺",label:"Watch 50 Ads",      goal:50,done:ads.clamp(0,50), pts:50, isAd:true),
    TaskModel(id:"w1",icon:"📺",label:"Watch 100 Ads",      goal:100,done:ads.clamp(0,100), pts:100, isAd:true),
  ];
  List<TaskModel> get _monthly => [
    TaskModel(id:"m1",icon:"📺",label:"Watch 400 Ads",      goal:400,done:(ads+120).clamp(0,400),pts:500,isAd:true),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        // ── Hero banner ────────────────────────────────────────────────
        _EarnHeroBanner(coins: coins, watching: watching, timer: timer, onStartAd: onStartAd, ads: ads),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(children: [

            // T&C accordion
            GestureDetector(
              onTap: onToggleTnc,
              child: GlassCardWidget(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text("ℹ️  Terms & Conditions",
                        style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.semiBold, color: AppColors.textSecondary)),
                    AnimatedRotation(
                      turns: tncOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted, size: AppSizing.iconSm),
                    ),
                  ]),
                  AnimatedCrossFade(
                    firstChild: const SizedBox(height: 0),
                    secondChild: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        "• 1 ad = 1 coin. Daily cap: 20 coins from ads.\n"
                            "• Weekly: 100 ads = +100 bonus coins.\n"
                            "• Monthly: 400 ads = +500 bonus coins.\n"
                            "• Coins are non-transferable, no monetary value.\n"
                            "• Redeemable for in-game items only.\n"
                            "• Abuse will result in account suspension.",
                        style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.textMuted, height: 1.8),
                      ),
                    ),
                    crossFadeState: tncOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 14),

            // ── Daily Tasks ────────────────────────────────────────────
            _TaskGroupHeader(emoji: "📅", title: "Daily Tasks", sub: "Reset every midnight",
                color: AppColors.neonCyan),
            ..._daily.map((t) => _TaskCard(t: t, watching: watching, timer: timer, onStartAd: onStartAd)),

            const SizedBox(height: 6),

            // ── Weekly Tasks ───────────────────────────────────────────
            _TaskGroupHeader(emoji: "📆", title: "Weekly Tasks",
                sub: "100 ads this week = +100 bonus coins", color: AppColors.neonGreen),
            ..._weekly.map((t) => _TaskCard(t: t, watching: watching, timer: timer, onStartAd: onStartAd)),

            const SizedBox(height: 6),

            // ── Monthly Tasks ──────────────────────────────────────────
            _TaskGroupHeader(emoji: "🗓️", title: "Monthly Tasks",
                sub: "400 ads = +500 bonus coins", color: AppColors.neonGold),
            ..._monthly.map((t) => _TaskCard(t: t, watching: watching, timer: timer, onStartAd: onStartAd)),
          ]),
        ),
      ]),
    );
  }
}

class _EarnHeroBanner extends StatelessWidget {
  final int coins, ads, timer;
  final bool watching;
  final VoidCallback onStartAd;
  const _EarnHeroBanner({required this.coins, required this.ads, required this.timer, required this.watching, required this.onStartAd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: const BoxDecoration(
          gradient: AppColors.blueHeroGradient,
        ),
      child: Stack(children: [
        // Decorative rings
        Positioned(top: -55, right: -55,
            child: _NeonRing(size: 200, color: AppColors.neonGold.withOpacity(0.12))),
        Positioned(top: -25, right: -25,
            child: _NeonRing(size: 130, color: AppColors.neonGold.withOpacity(0.08))),

        Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("EARN CENTER · 2025",
                  style: TextStyle(fontSize: AppTypography.sizeCaption, fontWeight: AppTypography.black,
                      color: AppColors.neonGold, letterSpacing: 2.5)),
              SizedBox(height: AppSpacing.sm - 1),
              Text("Watch Ads,",
                  style: TextStyle(fontSize: AppTypography.sizeDisplay, fontWeight: AppTypography.black, color: AppColors.white, height: 1.15)),
              Text("Earn Points!",
                  style: TextStyle(fontSize: AppTypography.sizeDisplay, fontWeight: AppTypography.black, color: AppColors.neonGold, height: 1.2)),
              SizedBox(height: AppSpacing.md + 1),
              Text("Complete tasks to earn points. Spend them entering tournaments.",
                  style: TextStyle(fontSize: AppTypography.sizeSmall, color: AppColors.white.withOpacity(AppColors.opacity55), height: 1.7),
                  maxLines: 2),
            ])),
            Column(children: [
              Text("🪙", style: TextStyle(fontSize: 58,
                  shadows: [Shadow(color: AppColors.neonGold.withOpacity(AppColors.opacity50), blurRadius: 22)])),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.neonGold.withOpacity(AppColors.opacity15),
                  borderRadius: AppRadius.borderXl,
                  border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity30)),
                ),
                child: Column(children: [
                  Text("BALANCE", style: TextStyle(
                      fontSize: AppTypography.sizeTiny, color: AppColors.neonGold, letterSpacing: 1)),
                  Text("$coins", style: TextStyle(
                      fontSize: AppTypography.sizeDisplay, fontWeight: AppTypography.black, color: AppColors.neonGold)),
                  Text("coins", style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.textSecondary)),
                ]),
              ),
            ]),
          ]),
          const SizedBox(height: 16),

          // Watch Ad button
          GestureDetector(
            onTap: watching ? null : onStartAd,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.cardInnerPadding),
              decoration: BoxDecoration(
                gradient: watching ? null : AppColors.goldHeroGradient,
                color: watching ? AppColors.white.withOpacity(AppColors.opacity10) : null,
                borderRadius: AppRadius.borderXl,
                boxShadow: watching ? [] : [
                  BoxShadow(color: AppColors.neonGold.withOpacity(AppColors.opacity40), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                  watching ? "⏳  Watching... ${timer}s" : "▶  WATCH AD  —  +1 COIN",
                  style: TextStyle(
                    color: watching ? AppColors.white.withOpacity(AppColors.opacity40) : Colors.black,
                    fontSize: AppTypography.sizeBody, fontWeight: AppTypography.black,
                  )),
            ),
          ),
          const SizedBox(height: 12),

          // Weekly ad progress
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("📆 Weekly Ad Goal",
                style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.white.withOpacity(AppColors.opacity60), fontWeight: AppTypography.semiBold)),
            Text("${ads.clamp(0,100)}/100 ads",
                style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.extraBold, color: AppColors.neonGold)),
          ]),
          SizedBox(height: AppSpacing.xs + 1),
          NeonProgressBarWidget(value: ads.toDouble(), max: 100, color: AppColors.neonGold, height: AppSizing.progressHeightLg),
          SizedBox(height: AppSpacing.xxs + 1),
          Text("Complete 100 ads this week → earn +100 bonus coins",
              style: TextStyle(fontSize: AppTypography.sizeTiny, color: AppColors.white.withOpacity(AppColors.opacity40))),
        ]),
      ]),
    );
  }
}

class _NeonRing extends StatelessWidget {
  final double size; final Color color;
  const _NeonRing({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color)),
  );
}

class _TaskGroupHeader extends StatelessWidget {
  final String emoji, title, sub; final Color color;
  const _TaskGroupHeader({required this.emoji, required this.title, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md - 1),
    margin: EdgeInsets.only(bottom: AppSpacing.md),
    decoration: BoxDecoration(
      color: color.withOpacity(AppColors.opacity8),
      borderRadius: AppRadius.borderDef,
      border: Border.all(color: color.withOpacity(AppColors.opacity20)),
    ),
    child: Row(children: [
      Text(emoji, style: TextStyle(fontSize: AppTypography.sizeBody)),
      SizedBox(width: AppSpacing.md),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.extraBold, color: color)),
        Text(sub, style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.textMuted)),
      ]),
    ]),
  );
}

class _TaskCard extends StatelessWidget {
  final TaskModel t;
  final bool watching;
  final int timer;
  final VoidCallback onStartAd;
  const _TaskCard({required this.t, required this.watching, required this.timer, required this.onStartAd});

  @override
  Widget build(BuildContext context) {
    final done = t.done >= t.goal;
    final barColor = done ? AppColors.neonGreen : t.isAd ? AppColors.neonCyan : AppColors.neonPurple;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GlassCardWidget(
        padding: EdgeInsets.all(AppSpacing.lg + 1),
        borderColor: done ? AppColors.neonGreen.withOpacity(AppColors.opacity30) : AppColors.glassBorder,
        shadows: done ? [BoxShadow(color: AppColors.neonGreen.withOpacity(AppColors.opacity10), blurRadius: 12)] : null,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: AppSizing.iconBtnMd, height: AppSizing.iconBtnMd,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.borderDef,
                  color: barColor.withOpacity(AppColors.opacity10),
                  border: Border.all(color: barColor.withOpacity(AppColors.opacity20)),
                ),
                alignment: Alignment.center,
                child: Text(t.icon, style: TextStyle(fontSize: AppTypography.sizeBody + 2)),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.label,
                    style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.bold, color: AppColors.textPrimary)),
                Row(children: [
                  Text("🪙", style: TextStyle(fontSize: AppTypography.sizeSmall)),
                  SizedBox(width: AppSpacing.xxs + 1),
                  Text("+${t.pts} pts",
                      style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.extraBold, color: AppColors.neonGold)),
                  if (done) ...[
                    SizedBox(width: AppSpacing.iconGap),
                    NeonPillWidget(label: "✓ DONE", color: AppColors.neonGreen),
                  ],
                ]),
              ])),
              Text("${t.done}/${t.goal}",
                  style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.extraBold,
                      color: done ? AppColors.neonGreen : AppColors.textMuted)),
            ]),
            SizedBox(height: AppSpacing.md),
            NeonProgressBarWidget(value: t.done.toDouble(), max: t.goal.toDouble(), color: barColor, height: AppSizing.progressHeightSm),
            if (t.isAd) ...[
              SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: done ? null : onStartAd,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: done ? AppColors.neonGreen.withOpacity(AppColors.opacity10) :
                    watching ? AppColors.bgSurface : AppColors.neonCyan.withOpacity(AppColors.opacity10),
                    borderRadius: AppRadius.borderDef,
                    border: Border.all(
                        color: done ? AppColors.neonGreen.withOpacity(AppColors.opacity30) :
                        watching ? AppColors.glassBorder : AppColors.neonCyan.withOpacity(AppColors.opacity30)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                      done ? "🎁  Claim ${t.pts} Points" :
                      watching ? "⏳  Watching… ${timer}s" : "▶  Watch Ad",
                      style: TextStyle(
                        color: done ? AppColors.neonGreen :
                        watching ? AppColors.textMuted : AppColors.neonCyan,
                        fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.bold,
                      )),
                ),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TOURNAMENT TAB
// ══════════════════════════════════════════════════════════════════════════════
class TournamentTabWidget extends StatelessWidget {
  final int selTrn;
  final List<int> joined;
  final bool bracketOpen;
  final int coins;
  final void Function(int) onSelTrn;
  final VoidCallback onToggleBracket;
  final void Function(TournamentModel) onJoin;

  const TournamentTabWidget({
    required this.selTrn, required this.joined, required this.bracketOpen,
    required this.coins, required this.onSelTrn, required this.onToggleBracket,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final tournaments = Get.find<AppDataController>().tournaments;
    final trn = tournaments[selTrn];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.cardInnerPadding, AppSpacing.xxxl, AppSpacing.massive),
      child: Column(children: [
        // ── Tournament selector ────────────────────────────────────────
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: List.generate(tournaments.length, (i) {
            final t = tournaments[i];
            final active = selTrn == i;
            final statusColor = t.status == "open" ? AppColors.neonGreen :
            t.status == "upcoming" ? AppColors.neonBlue : AppColors.textMuted;
            return GestureDetector(
              onTap: () => onSelTrn(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.only(right: AppSpacing.md),
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: active ? AppColors.blueHeroGradient : null,
                  color: active ? null : AppColors.bgSurface,
                  borderRadius: AppRadius.borderPill,
                  border: Border.all(
                      color: active ? AppColors.neonCyan.withOpacity(AppColors.opacity40) : AppColors.glassBorder),
                  boxShadow: active ? [BoxShadow(color: AppColors.neonBlue.withOpacity(AppColors.opacity30), blurRadius: 12)] : [],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 7, height: 7, margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor,
                        boxShadow: [BoxShadow(color: statusColor.withOpacity(0.6), blurRadius: 4)]),
                  ),
                  Text(t.name,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                          color: active ? AppColors.white : AppColors.textSecondary)),
                ]),
              ),
            );
          })),
        ),
        const SizedBox(height: 14),

        // ── Tournament Hero Card ───────────────────────────────────────
        _TournamentHeroCard(trn: trn),
        const SizedBox(height: 12),

        // ── Register button ────────────────────────────────────────────
        if (trn.status != "ended") _RegisterSection(
            trn: trn, coins: coins, joined: joined, onJoin: onJoin),
        const SizedBox(height: 12),

        // ── Rewards ────────────────────────────────────────────────────
        SectionHeadingWidget(title: "🎁 Prize Pool"),
        GlassCardWidget(
          child: Column(children: [
            ...List.generate(trn.rewards.length, (i) {
              final r = trn.rewards[i];
            return Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
                decoration: BoxDecoration(
                  border: i < trn.rewards.length - 1
                      ? Border(bottom: BorderSide(color: AppColors.glassBorder)) : null,
                  gradient: i == 0 ? LinearGradient(
                      colors: [AppColors.neonGold.withOpacity(AppColors.opacity8), Colors.transparent]) : null,
                ),
                child: Row(children: [
                  Text(r.icon, style: TextStyle(fontSize: AppTypography.sizeHeading)),
                  SizedBox(width: AppSpacing.xl),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.pos, style: TextStyle(
                        fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.black, color: AppColors.textPrimary)),
                    Text(r.detail, style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.textMuted)),
                  ])),
                  Container(width: 10, height: 10, decoration: BoxDecoration(
                    shape: BoxShape.circle, color: r.color,
                    boxShadow: [BoxShadow(color: r.color.withOpacity(0.6), blurRadius: 6)],
                  )),
                ]),
              );
            }),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.md + 1),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withOpacity(AppColors.opacity5),
                border: Border(top: BorderSide(color: AppColors.glassBorder)),
              ),
              child: Row(children: [
                const Text("🎁", style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                const Expanded(child: Text(
                    "All prizes provided by the club & sponsor. Platform organises only.",
                    style: TextStyle(fontSize: 10, color: AppColors.neonCyan))),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 12),

        // ── Tournament Bracket ─────────────────────────────────────────
        if (trn.bracket.isNotEmpty) _BracketSection(trn: trn, open: bracketOpen, onToggle: onToggleBracket),

        // ── Leaderboard ────────────────────────────────────────────────
        SectionHeadingWidget(title: "📊 Season Standings"),
        _TournamentLeaderboard(),
        const SizedBox(height: 8),
      ]),
    );
  }
}

class _TournamentHeroCard extends StatelessWidget {
  final TournamentModel trn;
  const _TournamentHeroCard({required this.trn});

  @override
  Widget build(BuildContext context) {
    final statusColor = trn.status == "open" ? AppColors.neonGreen :
    trn.status == "upcoming" ? AppColors.neonBlue : AppColors.textMuted;
    final fillPct = trn.slots > 0 ? trn.filled / trn.slots : 0.0;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl + 2),
      decoration: BoxDecoration(
        gradient: AppColors.blueHeroGradient,
        borderRadius: AppRadius.borderXl,
        border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity20)),
        boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(AppColors.opacity20), blurRadius: 20)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 1),
                decoration: BoxDecoration(
                  color: AppColors.neonGold.withOpacity(AppColors.opacity15),
                  borderRadius: AppRadius.borderSm,
                  border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity30)),
                ),
                child: Text(trn.tag,
                    style: TextStyle(fontSize: AppTypography.sizeTiny, fontWeight: AppTypography.black,
                        color: AppColors.neonGold, letterSpacing: 1.2)),
              ),
            ]),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg + 2, vertical: AppSpacing.xs + 1),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(AppColors.opacity12),
                borderRadius: AppRadius.borderPill,
                border: Border.all(color: statusColor.withOpacity(AppColors.opacity30)),
              ),
              child: Text(trn.status.toUpperCase(),
                  style: TextStyle(fontSize: AppTypography.sizeTiny, fontWeight: AppTypography.black, color: statusColor)),
            ),
          ]),
        SizedBox(height: AppSpacing.xl),
        Text(trn.name,
            style: TextStyle(fontSize: AppTypography.sizeTitleLarge, fontWeight: AppTypography.black, color: AppColors.white)),
        SizedBox(height: AppSpacing.xs + 1),
        Text("🏅  ${trn.prize}",
            style: TextStyle(fontSize: AppTypography.sizeBody, color: AppColors.neonGold, fontWeight: AppTypography.bold)),
        SizedBox(height: AppSpacing.xs + 1),
        Text("🏟️  ${trn.sponsor}",
            style: TextStyle(fontSize: AppTypography.sizeSmall, color: AppColors.white.withOpacity(AppColors.opacity55))),
        const SizedBox(height: 12),

        // Info grid
        Row(children: [
          _TrnInfoItem(icon: "📅", label: "Starts", value: trn.starts),
          _TrnInfoItem(icon: "⏰", label: "Reg. Closes", value: trn.regDeadline),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _TrnInfoItem(icon: "🎮", label: "Format", value: trn.format),
          _TrnInfoItem(icon: "🪙", label: "Entry Cost", value: "${trn.cost} pts"),
        ]),
        const SizedBox(height: 14),

        // Slots progress
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("👥  Slots Filled",
              style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.white.withOpacity(AppColors.opacity55))),
          Text("${trn.filled} / ${trn.slots}",
              style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.black, color: AppColors.neonGold)),
        ]),
        const SizedBox(height: 5),
        NeonProgressBarWidget(value: fillPct * trn.slots, max: trn.slots.toDouble(),
            color: trn.status == "ended" ? AppColors.textMuted : AppColors.neonGold),
      ]),
    );
  }
}

class _TrnInfoItem extends StatelessWidget {
  final String icon, label, value;
  const _TrnInfoItem({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Expanded(child: Padding(
    padding: EdgeInsets.only(bottom: AppSpacing.xs + 1),
    child: Row(children: [
      Text(icon, style: TextStyle(fontSize: AppTypography.sizeBody)),
      SizedBox(width: AppSpacing.md - 1),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.textMuted)),
        Text(value, style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.bold, color: AppColors.textPrimary)),
      ])),
    ]),
  ));
}

class _RegisterSection extends StatelessWidget {
  final TournamentModel trn;
  final int coins;
  final List<int> joined;
  final void Function(TournamentModel) onJoin;
  const _RegisterSection({required this.trn, required this.coins, required this.joined, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final alreadyJoined = joined.contains(trn.id);
    final canAfford = coins >= trn.cost;

    if (alreadyJoined) {
      return GlassCardWidget(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
        borderColor: AppColors.neonGreen.withOpacity(AppColors.opacity30),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("✅", style: TextStyle(fontSize: AppTypography.sizeSubtitle)),
          SizedBox(width: AppSpacing.md),
          Text("You're Registered!", style: TextStyle(
              fontSize: AppTypography.sizeBody, fontWeight: AppTypography.black, color: AppColors.neonGreen)),
        ]),
      );
    }

    if (!canAfford) {
      return GlassCardWidget(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg - 1, horizontal: AppSpacing.xl),
        borderColor: AppColors.neonRed.withOpacity(AppColors.opacity30),
        child: Row(children: [
          Text("⚠️", style: TextStyle(fontSize: AppTypography.sizeSmall)),
          SizedBox(width: AppSpacing.md),
          Expanded(child: Text(
              "Need ${trn.cost - coins} more points — watch ads to earn!",
              style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.bold, color: AppColors.neonRed))),
        ]),
      );
    }

    return GestureDetector(
      onTap: () => onJoin(trn),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.cardInnerPadding),
        decoration: BoxDecoration(
          gradient: AppColors.goldHeroGradient,
          borderRadius: AppRadius.borderXl,
          boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(AppColors.opacity40), blurRadius: 16, offset: const Offset(0,4))],
        ),
        alignment: Alignment.center,
        child: Text("Register Now  —  🪙 ${trn.cost} Points",
            style: TextStyle(color: Colors.black, fontSize: AppTypography.sizeBody, fontWeight: AppTypography.black)),
      ),
    );
  }
}

class _BracketSection extends StatelessWidget {
  final TournamentModel trn; final bool open; final VoidCallback onToggle;
  const _BracketSection({required this.trn, required this.open, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg + 1),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: open ? AppRadius.borderXlOnlyTop : AppRadius.borderXl,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Container(
                  width: AppSizing.iconBtnMd, height: AppSizing.iconBtnMd,
                  decoration: BoxDecoration(
                    color: AppColors.neonCyan.withOpacity(AppColors.opacity10),
                    borderRadius: AppRadius.borderDef,
                    border: Border.all(color: AppColors.neonCyan.withOpacity(AppColors.opacity20)),
                  ),
                  alignment: Alignment.center,
                  child: Text("🏟️", style: TextStyle(fontSize: AppTypography.sizeTitleLarge)),
                ),
                SizedBox(width: AppSpacing.lg),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Tournament Bracket",
                      style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.black, color: AppColors.textPrimary)),
                  Text(trn.rounds.join(" → "),
                      style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.textMuted)),
                ]),
              ]),
              AnimatedRotation(
                turns: open ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
              ),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: Container(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border(
                left: BorderSide(color: AppColors.glassBorder),
                right: BorderSide(color: AppColors.glassBorder),
                bottom: BorderSide(color: AppColors.glassBorder),
              ),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: trn.bracket.map((rnd) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(rnd.roundName,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800,
                          color: AppColors.neonCyan, letterSpacing: 1.5)),
                ),
                ...rnd.matches.map((m) => Container(
                  margin: EdgeInsets.only(bottom: AppSpacing.xs + 2),
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.md - 1),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: AppRadius.borderMd,
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(m[0], style: TextStyle(
                        fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.bold,
                        color: m[0] == "TBD" ? AppColors.textMuted : AppColors.textPrimary)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg - 2, vertical: AppSpacing.xxs + 1),
                      decoration: BoxDecoration(
                        color: AppColors.neonBlue.withOpacity(AppColors.opacity15),
                        borderRadius: AppRadius.borderSm,
                        border: Border.all(color: AppColors.neonBlue.withOpacity(0.3)),
                      ),
                      child: Text("VS",
                          style: TextStyle(fontSize: AppTypography.sizeCaption, fontWeight: AppTypography.black, color: AppColors.neonBlue)),
                    ),
                    Text(m[1], style: TextStyle(
                        fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.bold,
                        color: m[1] == "TBD" ? AppColors.textMuted : AppColors.textPrimary)),
                  ]),
                )),
              ]);
            }).toList()),
          ),
          crossFadeState: open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 280),
        ),
      ]),
    );
  }
}

class _TournamentLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final players = Get.find<AppDataController>().rankedPlayers;
    final medals = ["🥇", "🥈", "🥉"];
    final colors = [AppColors.gold, AppColors.silver, AppColors.bronze,
      AppColors.neonBlue, AppColors.textMuted];

    return GlassCardWidget(
      child: Column(children: List.generate(players.length, (i) {
        final p = players[i];
        final c = colors[i.clamp(0, colors.length - 1)];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg - 1),
          decoration: BoxDecoration(
            border: i < players.length - 1 ? Border(bottom: BorderSide(color: AppColors.glassBorder)) : null,
            gradient: i == 0 ? LinearGradient(
                colors: [AppColors.neonGold.withOpacity(AppColors.opacity8), Colors.transparent]) : null,
          ),
          child: Row(children: [
            SizedBox(width: AppSpacing.xl + 4, child: Text(
              i < 3 ? medals[i] : "${i + 1}",
              style: TextStyle(fontSize: i < 3 ? AppTypography.sizeTitleLarge : AppTypography.sizeSmall, fontWeight: AppTypography.black, color: c),
              textAlign: TextAlign.center,
            )),
            SizedBox(width: AppSpacing.lg + 1),
            PlayerAvatarWidget(name: p.name, size: AppSizing.avatarSm),
            SizedBox(width: AppSpacing.lg),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(p.name, style: TextStyle(
                    fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.bold, color: AppColors.textPrimary)),
                if (i < 2) ...[SizedBox(width: AppSpacing.xs + 1), NeonPillWidget(label: "VIP", color: AppColors.neonGold)],
              ]),
              Text("${p.wins}W · ${p.goals} goals",
                  style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.textMuted)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text("${p.pts}", style: TextStyle(fontSize: AppTypography.sizeSubtitle, fontWeight: AppTypography.black, color: c)),
              Text("pts", style: TextStyle(fontSize: AppTypography.sizeTiny, color: AppColors.textMuted)),
            ]),
          ]),
        );
      })),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHOP TAB
// ══════════════════════════════════════════════════════════════════════════════
class _ShopTab extends StatelessWidget {
  final int coins;
  final List<ShopItem> items;
  final int? selIdx;
  final void Function(int) onSel;
  final void Function(int) onBuy;

  const _ShopTab({
    required this.coins, required this.items, required this.selIdx,
    required this.onSel, required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        // ── Shop Hero Banner ───────────────────────────────────────────
        Container(
          padding: EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.massive, AppSpacing.xxxl, AppSpacing.xxxl),
          decoration: BoxDecoration(
            gradient: AppColors.blueDeepHeroGradient,
          ),
          child: Stack(children: [
            Positioned(top: -30, right: -30,
                child: Container(width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neonPurple.withOpacity(AppColors.opacity12),
                    ))),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("POINTS SHOP",
                    style: TextStyle(fontSize: AppTypography.sizeCaption, fontWeight: AppTypography.black,
                        color: AppColors.neonPurple, letterSpacing: 2)),
                SizedBox(height: AppSpacing.xs + 1),
                Text("Spend Points,",
                    style: TextStyle(fontSize: AppTypography.sizeDisplay, fontWeight: AppTypography.black, color: AppColors.white)),
                Text("Look Elite! 🛒",
                    style: TextStyle(fontSize: AppTypography.sizeDisplay, fontWeight: AppTypography.black, color: AppColors.neonGold)),
                SizedBox(height: AppSpacing.xs),
                Text("Cosmetics only · Points are earned, never sold",
                    style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.white.withOpacity(AppColors.opacity40))),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("BALANCE", style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.white.withOpacity(AppColors.opacity40))),
                SizedBox(height: AppSpacing.xs + 1),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withOpacity(AppColors.opacity15),
                    borderRadius: AppRadius.borderMd + const BorderRadius.all(Radius.circular(1)),
                    border: Border.all(color: AppColors.neonGold.withOpacity(AppColors.opacity30)),
                  ),
                  child: Row(children: [
                    Text("🪙", style: TextStyle(fontSize: AppTypography.sizeSubtitle)),
                    SizedBox(width: AppSpacing.xs + 2),
                    Text("$coins",
                        style: TextStyle(fontSize: AppTypography.sizeDisplay, fontWeight: AppTypography.black, color: AppColors.neonGold)),
                  ]),
                ),
              ]),
            ]),
          ]),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.cardInnerPadding, AppSpacing.xxxl, AppSpacing.massive),
          child: Column(children: [
            SectionHeadingWidget(
              title: "🎖️ Cosmetic Items",
              sub: "Unlock with earned points — cosmetics only",
            ),

            // ── Shop grid ──────────────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: AppSpacing.md, crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.82,
              ),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                final sel = selIdx == i;
                return GestureDetector(
                  onTap: () => onSel(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.cardInnerPadding, AppSpacing.md, AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: sel ? item.accent.withOpacity(AppColors.opacity10) : AppColors.bgCard,
                      borderRadius: AppRadius.borderXl + const BorderRadius.all(Radius.circular(2)),
                      border: Border.all(
                        color: sel ? item.accent.withOpacity(AppColors.opacity50) : AppColors.glassBorder,
                        width: sel ? 1.5 : 1,
                      ),
                      boxShadow: sel ? [BoxShadow(
                          color: item.accent.withOpacity(AppColors.opacity20), blurRadius: 16)] : [],
                    ),
                    child: Stack(children: [
                      if (item.owned) Positioned(top: 0, right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs + 1, vertical: AppSpacing.xxs + 1),
                          decoration: BoxDecoration(
                            color: AppColors.neonGreen,
                            borderRadius: AppRadius.borderSm,
                          ),
                          child: Text("✓",
                              style: TextStyle(fontSize: AppTypography.sizeTiny - 2, fontWeight: AppTypography.black, color: AppColors.white)),
                        ),
                      ),
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(item.icon, style: TextStyle(fontSize: AppTypography.sizeHeading + 2,
                            shadows: sel ? [Shadow(color: item.accent.withOpacity(AppColors.opacity80), blurRadius: 12)] : [])),
                        SizedBox(height: AppSpacing.md),
                        Text(item.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: AppTypography.sizeCaption + 1, fontWeight: AppTypography.bold,
                                color: AppColors.textPrimary, height: 1.2)),
                        SizedBox(height: AppSpacing.xs + 1),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text("🪙", style: TextStyle(fontSize: AppTypography.sizeSmall - 1)),
                          SizedBox(width: AppSpacing.xxs + 1),
                          Text("${item.cost}",
                              style: TextStyle(fontSize: AppTypography.sizeSmall - 1, fontWeight: AppTypography.black, color: item.accent)),
                        ]),
                      ]),
                    ]),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // ── Selected item detail ────────────────────────────────────
            if (selIdx != null) _ShopItemDetail(
                item: items[selIdx!], coins: coins, idx: selIdx!, onBuy: onBuy),

            // ── Disclaimer ─────────────────────────────────────────────
            GlassCardWidget(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.lg),
              borderColor: AppColors.neonCyan.withOpacity(AppColors.opacity15),
              child: Row(children: [
                Text("🛡️", style: TextStyle(fontSize: AppTypography.sizeHeading)),
                SizedBox(width: AppSpacing.xl),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Points are earned — never purchased",
                      style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.black, color: AppColors.textPrimary)),
                  SizedBox(height: AppSpacing.xxs),
                  Text("All points come from watching ads & completing tasks. No real money. Cosmetics only.",
                      style: TextStyle(fontSize: AppTypography.sizeTiny + 1, color: AppColors.textMuted, height: 1.6)),
                ])),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _ShopItemDetail extends StatelessWidget {
  final ShopItem item; final int coins, idx; final void Function(int) onBuy;
  const _ShopItemDetail({required this.item, required this.coins, required this.idx, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    final canAfford = coins >= item.cost;

    return GlassCardWidget(
      padding: EdgeInsets.all(AppSpacing.xxxl),
      borderColor: item.accent.withOpacity(AppColors.opacity30),
      shadows: [BoxShadow(color: item.accent.withOpacity(AppColors.opacity10), blurRadius: 20)],
      child: Column(children: [
        Row(children: [
          Container(
            width: AppSizing.iconBtnLg, height: AppSizing.iconBtnLg,
            decoration: BoxDecoration(
              borderRadius: AppRadius.borderXl,
              color: item.accent.withOpacity(AppColors.opacity10),
              border: Border.all(color: item.accent.withOpacity(AppColors.opacity30), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(item.icon, style: TextStyle(fontSize: AppTypography.sizeHeading,
                shadows: [Shadow(color: item.accent.withOpacity(AppColors.opacity80), blurRadius: 12)])),
          ),
          SizedBox(width: AppSpacing.xl),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name,
                style: TextStyle(fontSize: AppTypography.sizeBody + 2, fontWeight: AppTypography.black, color: AppColors.textPrimary)),
            Text(item.info,
                style: TextStyle(fontSize: AppTypography.sizeSmall - 1, color: AppColors.textMuted)),
            SizedBox(height: AppSpacing.xs + 1),
            Row(children: [
              Text("🪙"),
              SizedBox(width: AppSpacing.xs),
              Text("${item.cost}",
                  style: TextStyle(fontSize: AppTypography.sizeSubtitle + 2, fontWeight: AppTypography.black, color: item.accent)),
              SizedBox(width: AppSpacing.xs + 1),
              Text("points", style: TextStyle(fontSize: AppTypography.sizeTiny + 1, color: AppColors.textMuted)),
            ]),
          ])),
        ]),
        SizedBox(height: AppSpacing.cardInnerPadding),

        if (item.owned)
          Container(
            width: double.infinity, padding: EdgeInsets.symmetric(vertical: AppSpacing.md + 1),
            decoration: BoxDecoration(
              color: AppColors.neonGreen.withOpacity(AppColors.opacity10),
              borderRadius: AppRadius.borderDef + const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: AppColors.neonGreen.withOpacity(AppColors.opacity25)),
            ),
            alignment: Alignment.center,
            child: Text("✓  Already in your collection",
                style: TextStyle(color: AppColors.neonGreen, fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.bold)),
          )
        else if (canAfford)
          GestureDetector(
            onTap: () => onBuy(idx),
            child: Container(
              width: double.infinity, padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [item.accent, item.accent.withOpacity(0.75)]),
                borderRadius: AppRadius.borderDef + const BorderRadius.all(Radius.circular(2)),
                boxShadow: [BoxShadow(color: item.accent.withOpacity(AppColors.opacity40), blurRadius: 16)],
              ),
              alignment: Alignment.center,
              child: Text("Buy Now  —  🪙 ${item.cost} Points",
                  style: TextStyle(color: AppColors.white, fontSize: AppTypography.sizeBody, fontWeight: AppTypography.extraBold)),
            ),
          )
        else
          Container(
            width: double.infinity, padding: EdgeInsets.symmetric(vertical: AppSpacing.md + 1),
            decoration: BoxDecoration(
              color: AppColors.neonRed.withOpacity(AppColors.opacity10),
              borderRadius: AppRadius.borderDef + const BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: AppColors.neonRed.withOpacity(AppColors.opacity25)),
            ),
            alignment: Alignment.center,
            child: Text("⚠️  Need ${item.cost - coins} more points — watch ads to earn!",
                style: TextStyle(color: AppColors.neonRed, fontSize: AppTypography.sizeCaption + 1, fontWeight: AppTypography.bold)),
          ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ADMIN CHAT TAB
// ══════════════════════════════════════════════════════════════════════════════
class _ChatTab extends StatelessWidget {
  final List<ChatMessage> chats;
  final TextEditingController ctrl;
  final ScrollController scrollCtrl;
  final VoidCallback onSend;

  const _ChatTab({
    required this.chats, required this.ctrl,
    required this.scrollCtrl, required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.xxxl),
      child: Column(children: [
        // Admin info card
        GlassCardWidget(
          padding: EdgeInsets.all(AppSpacing.lg),
          borderColor: AppColors.neonBlue.withOpacity(AppColors.opacity20),
          child: Row(children: [
            Stack(children: [
              Container(
                width: AppSizing.iconBtnMd + 10, height: AppSizing.iconBtnMd + 10,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.borderMd + const BorderRadius.all(Radius.circular(1)),
                  gradient: AppColors.blueHeroGradient,
                  boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(AppColors.opacity40), blurRadius: 10)],
                ),
                alignment: Alignment.center,
                child: Text("🛡️", style: TextStyle(fontSize: AppTypography.sizeTitleLarge)),
              ),
              Positioned(bottom: 2, right: 2,
                child: Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonGreen,
                    border: Border.all(color: AppColors.bg, width: 2),
                    boxShadow: [BoxShadow(color: AppColors.neonGreen.withOpacity(0.6), blurRadius: 4)],
                  ),
                ),
              ),
            ]),
            SizedBox(width: AppSpacing.lg),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("GameArena Admin",
                  style: TextStyle(fontSize: AppTypography.sizeSmall, fontWeight: AppTypography.black, color: AppColors.textPrimary)),
              Text("● Online · Replies within 5 minutes",
                  style: TextStyle(fontSize: AppTypography.sizeCaption, color: AppColors.neonGreen, fontWeight: AppTypography.extraBold)),
            ])),
            NeonPillWidget(label: "OFFICIAL", color: AppColors.neonBlue),
          ]),
        ),
        SizedBox(height: AppSpacing.lg),

        // Messages
        Expanded(child: ListView.builder(
          controller: scrollCtrl,
          itemCount: chats.length,
          itemBuilder: (ctx, i) {
            final m = chats[i];
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md + 1),
              child: Row(
                mainAxisAlignment: m.me ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!m.me) ...[
                    Container(
                      width: AppSizing.avatarXs, height: AppSizing.avatarXs,
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.borderSm,
                        gradient: AppColors.blueHeroGradient,
                      ),
                      alignment: Alignment.center,
                      child: Text("🛡️", style: TextStyle(fontSize: AppTypography.sizeSmall + 1)),
                    ),
                    SizedBox(width: AppSpacing.md),
                  ],
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * 0.66),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl - 1, vertical: AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: m.me ? AppColors.blueHeroGradient : null,
                        color: m.me ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.only(
                          topLeft: AppRadius.radiusXl,
                          topRight: AppRadius.radiusXl,
                          bottomLeft: m.me ? AppRadius.radiusXl : AppRadius.radiusDef,
                          bottomRight: m.me ? AppRadius.radiusDef : AppRadius.radiusXl,
                        ),
                        border: m.me ? null : Border.all(color: AppColors.glassBorder),
                        boxShadow: m.me ? [BoxShadow(color: AppColors.neonCyan.withOpacity(AppColors.opacity25), blurRadius: 10)] : [],
                      ),
                      child: Column(crossAxisAlignment: m.me ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
                        Text(m.text,
                            style: TextStyle(
                              fontSize: AppTypography.sizeSmall,
                              color: m.me ? AppColors.white : AppColors.textPrimary,
                              height: 1.55,
                            )),
                        SizedBox(height: AppSpacing.xs),
                        Text("${m.time} ago",
                            style: TextStyle(
                              fontSize: AppTypography.sizeTiny,
                              color: m.me ? AppColors.white.withOpacity(AppColors.opacity40) : AppColors.textMuted,
                            )),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        )),
        const SizedBox(height: 8),

        // Input bar
        Container(
          padding: EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.md, AppSpacing.md, AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.borderXl,
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(AppColors.opacity6), blurRadius: 12)],
          ),
          child: Row(children: [
            Expanded(child: TextField(
              controller: ctrl,
              style: TextStyle(color: AppColors.textPrimary, fontSize: AppTypography.sizeSmall + 1),
              decoration: InputDecoration(
                hintText: "Ask admin anything…",
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: AppTypography.sizeSmall + 1),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (_) => onSend(),
            )),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: AppSizing.iconBtnMd + 2, height: AppSizing.iconBtnMd + 2,
                decoration: BoxDecoration(
                  gradient: AppColors.blueHeroGradient,
                  borderRadius: AppRadius.borderMd + const BorderRadius.all(Radius.circular(2)),
                  boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(AppColors.opacity40), blurRadius: 10)],
                ),
                alignment: Alignment.center,
                child: Icon(Icons.send_rounded, color: AppColors.white, size: AppSizing.iconSm + 2),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class ShopItem {
  final String icon, name, info;
  final int cost;
  final Color accent;
  bool owned;
  ShopItem({required this.icon, required this.name, required this.info, required this.cost, required this.accent, this.owned = false});
}

class ChatMessage {
  final bool me;
  final String text, time;
  const ChatMessage({required this.me, required this.text, required this.time});
}

class TaskModel {
  final String id, icon, label;
  final int goal, done, pts;
  final bool isAd;
  const TaskModel({required this.id, required this.icon, required this.label, required this.goal, required this.done, required this.pts, this.isAd = false});
}
