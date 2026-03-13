import 'dart:async';
import 'dart:ui';
import 'package:e_sports/core/constants/app_colors.dart';
import 'package:e_sports/core/data/app_data.dart';
import 'package:e_sports/core/widgets/app_header_widget.dart';
import 'package:e_sports/core/widgets/brand_title.dart';
import 'package:e_sports/core/widgets/glass_card_widget.dart';
import 'package:e_sports/core/widgets/neon_pill_widget.dart';
import 'package:e_sports/core/widgets/neon_pregress_bar_widget.dart';
import 'package:e_sports/core/widgets/player_avater.dart';
import 'package:e_sports/core/widgets/section_heading_widget.dart';
import 'package:e_sports/main.dart';
import 'package:flutter/material.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});
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
    _shopItems = AppData.defaultShopItems();
    _tabAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _tabAnim.forward();
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.neonGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
            boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.2), blurRadius: 10)],
          ),
          child: Row(children: [
            const Text("🪙", style: TextStyle(fontSize: 15)),
            const SizedBox(width: 5),
            Text("$_coins",
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.neonGold)),
          ]),
        ),
        const SizedBox(width: 9),
        // Notification bell
        Stack(clipBehavior: Clip.none, children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
            ),
            alignment: Alignment.center,
            child: const Text("🔔", style: TextStyle(fontSize: 16)),
          ),
          Positioned(top: -3, right: -3,
            child: Container(
              width: 15, height: 15,
              decoration: BoxDecoration(
                color: AppColors.neonRed,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bg, width: 2),
              ),
              alignment: Alignment.center,
              child: const Text("2",
                  style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Column(children: [
                Text(_tabs[i].icon, style: TextStyle(fontSize: active ? 17 : 16)),
                const SizedBox(height: 3),
                Text(_tabs[i].label, style: TextStyle(
                  fontSize: 9,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                  color: active ? AppColors.neonCyan : AppColors.textMuted,
                )),
              ]),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2.5,
              width: active ? double.infinity : 0,
              decoration: BoxDecoration(
                color: AppColors.neonCyan,
                boxShadow: active ? [BoxShadow(color: AppColors.neonCyan.withOpacity(0.6), blurRadius: 6)] : [],
              ),
            ),
          ]),
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
        onJoin: (trn) {
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
                    const Text("ℹ️  Terms & Conditions",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    AnimatedRotation(
                      turns: tncOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted, size: 16),
                    ),
                  ]),
                  AnimatedCrossFade(
                    firstChild: const SizedBox(height: 0),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Text(
                        "• 1 ad = 1 coin. Daily cap: 20 coins from ads.\n"
                            "• Weekly: 100 ads = +100 bonus coins.\n"
                            "• Monthly: 400 ads = +500 bonus coins.\n"
                            "• Coins are non-transferable, no monetary value.\n"
                            "• Redeemable for in-game items only.\n"
                            "• Abuse will result in account suspension.",
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted, height: 1.8),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8), Color(0xFF1440B8)],
        ),
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
              const Text("EARN CENTER · 2025",
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                      color: AppColors.neonGold, letterSpacing: 2.5)),
              const SizedBox(height: 7),
              const Text("Watch Ads,",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1.15)),
              const Text("Earn Points!",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.neonGold, height: 1.2)),
              const SizedBox(height: 9),
              Text("Complete tasks to earn points. Spend them entering tournaments.",
                  style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.55), height: 1.7),
                  maxLines: 2),
            ])),
            Column(children: [
              Text("🪙", style: TextStyle(fontSize: 58,
                  shadows: [Shadow(color: AppColors.neonGold.withOpacity(0.5), blurRadius: 22)])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.neonGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
                ),
                child: Column(children: [
                  const Text("BALANCE", style: TextStyle(
                      fontSize: 8, color: AppColors.neonGold, letterSpacing: 1)),
                  Text("$coins", style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.neonGold)),
                  const Text("coins", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
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
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: watching ? null : const LinearGradient(
                    colors: [AppColors.neonGold, Color(0xFFF59E0B)]),
                color: watching ? Colors.white.withOpacity(0.1) : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow: watching ? [] : [
                  BoxShadow(color: AppColors.neonGold.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                  watching ? "⏳  Watching... ${timer}s" : "▶  WATCH AD  —  +1 COIN",
                  style: TextStyle(
                    color: watching ? Colors.white.withOpacity(0.4) : Colors.black,
                    fontSize: 14, fontWeight: FontWeight.w900,
                  )),
            ),
          ),
          const SizedBox(height: 12),

          // Weekly ad progress
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("📆 Weekly Ad Goal",
                style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w600)),
            Text("${ads.clamp(0,100)}/100 ads",
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.neonGold)),
          ]),
          const SizedBox(height: 5),
          NeonProgressBarWidget(value: ads.toDouble(), max: 100, color: AppColors.neonGold, height: 8),
          const SizedBox(height: 3),
          Text("Complete 100 ads this week → earn +100 bonus coins",
              style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.4))),
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
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 14)),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
        Text(sub, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
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
        padding: const EdgeInsets.all(13),
        borderColor: done ? AppColors.neonGreen.withOpacity(0.3) : AppColors.glassBorder,
        shadows: done ? [BoxShadow(color: AppColors.neonGreen.withOpacity(0.1), blurRadius: 12)] : null,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: barColor.withOpacity(0.1),
                  border: Border.all(color: barColor.withOpacity(0.2)),
                ),
                alignment: Alignment.center,
                child: Text(t.icon, style: const TextStyle(fontSize: 17)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.label,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Row(children: [
                  const Text("🪙", style: TextStyle(fontSize: 11)),
                  const SizedBox(width: 3),
                  Text("+${t.pts} pts",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.neonGold)),
                  if (done) ...[
                    const SizedBox(width: 6),
                    NeonPillWidget(label: "✓ DONE", color: AppColors.neonGreen),
                  ],
                ]),
              ])),
              Text("${t.done}/${t.goal}",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                      color: done ? AppColors.neonGreen : AppColors.textMuted)),
            ]),
            const SizedBox(height: 8),
            NeonProgressBarWidget(value: t.done.toDouble(), max: t.goal.toDouble(), color: barColor, height: 5),
            if (t.isAd) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: done ? null : onStartAd,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: done ? AppColors.neonGreen.withOpacity(0.1) :
                    watching ? AppColors.bgSurface : AppColors.neonCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: done ? AppColors.neonGreen.withOpacity(0.3) :
                        watching ? AppColors.glassBorder : AppColors.neonCyan.withOpacity(0.3)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                      done ? "🎁  Claim ${t.pts} Points" :
                      watching ? "⏳  Watching… ${timer}s" : "▶  Watch Ad",
                      style: TextStyle(
                        color: done ? AppColors.neonGreen :
                        watching ? AppColors.textMuted : AppColors.neonCyan,
                        fontSize: 11, fontWeight: FontWeight.w700,
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
    final tournaments = AppData.tournaments;
    final trn = tournaments[selTrn];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
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
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: active ? const LinearGradient(
                      colors: [Color(0xFF1B4FD8), Color(0xFF0D1B4E)]) : null,
                  color: active ? null : AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: active ? AppColors.neonCyan.withOpacity(0.4) : AppColors.glassBorder),
                  boxShadow: active ? [BoxShadow(color: AppColors.neonBlue.withOpacity(0.3), blurRadius: 12)] : [],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 7, height: 7, margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor,
                        boxShadow: [BoxShadow(color: statusColor.withOpacity(0.6), blurRadius: 4)]),
                  ),
                  Text(t.name,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                          color: active ? Colors.white : AppColors.textSecondary)),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: i < trn.rewards.length - 1
                      ? Border(bottom: BorderSide(color: AppColors.glassBorder)) : null,
                  gradient: i == 0 ? LinearGradient(
                      colors: [AppColors.neonGold.withOpacity(0.08), Colors.transparent]) : null,
                ),
                child: Row(children: [
                  Text(r.icon, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.pos, style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    Text(r.detail, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ])),
                  Container(width: 10, height: 10, decoration: BoxDecoration(
                    shape: BoxShape.circle, color: r.color,
                    boxShadow: [BoxShadow(color: r.color.withOpacity(0.6), blurRadius: 6)],
                  )),
                ]),
              );
            }),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withOpacity(0.05),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B4E), Color(0xFF1B4FD8)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neonGold.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.2), blurRadius: 20)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.neonGold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
              ),
              child: Text(trn.tag,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                      color: AppColors.neonGold, letterSpacing: 1.2)),
            ),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(trn.status.toUpperCase(),
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: statusColor)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(trn.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
        const SizedBox(height: 4),
        Text("🏅  ${trn.prize}",
            style: const TextStyle(fontSize: 13, color: AppColors.neonGold, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text("🏟️  ${trn.sponsor}",
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.55))),
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
              style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.55))),
          Text("${trn.filled} / ${trn.slots}",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.neonGold)),
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
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [
      Text(icon, style: const TextStyle(fontSize: 13)),
      const SizedBox(width: 6),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderColor: AppColors.neonGreen.withOpacity(0.3),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("✅", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          const Text("You're Registered!", style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.neonGreen)),
        ]),
      );
    }

    if (!canAfford) {
      return GlassCardWidget(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
        borderColor: AppColors.neonRed.withOpacity(0.3),
        child: Row(children: [
          const Text("⚠️", style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(child: Text(
              "Need ${trn.cost - coins} more points — watch ads to earn!",
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.neonRed))),
        ]),
      );
    }

    return GestureDetector(
      onTap: () => onJoin(trn),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.neonGold, Color(0xFFF59E0B)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.neonGold.withOpacity(0.4), blurRadius: 16, offset: const Offset(0,4))],
        ),
        alignment: Alignment.center,
        child: Text("Register Now  —  🪙 ${trn.cost} Points",
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w900)),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: open ? const BorderRadius.vertical(top: Radius.circular(16)) : BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.neonCyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
                  ),
                  alignment: Alignment.center,
                  child: const Text("🏟️", style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text("Tournament Bracket",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  Text(trn.rounds.join(" → "),
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                ]),
              ]),
              AnimatedRotation(
                turns: open ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted),
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
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(m[0], style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: m[0] == "TBD" ? AppColors.textMuted : AppColors.textPrimary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.neonBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.neonBlue.withOpacity(0.3)),
                      ),
                      child: const Text("VS",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.neonBlue)),
                    ),
                    Text(m[1], style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
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
    final players = AppData.players;
    final medals = ["🥇", "🥈", "🥉"];
    final colors = [AppColors.gold, AppColors.silver, AppColors.bronze,
      AppColors.neonBlue, AppColors.textMuted];

    return GlassCardWidget(
      child: Column(children: List.generate(players.length, (i) {
        final p = players[i];
        final c = colors[i.clamp(0, colors.length - 1)];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            border: i < players.length - 1 ? Border(bottom: BorderSide(color: AppColors.glassBorder)) : null,
            gradient: i == 0 ? LinearGradient(
                colors: [AppColors.neonGold.withOpacity(0.07), Colors.transparent]) : null,
          ),
          child: Row(children: [
            SizedBox(width: 24, child: Text(
              i < 3 ? medals[i] : "${i + 1}",
              style: TextStyle(fontSize: i < 3 ? 20 : 13, fontWeight: FontWeight.w800, color: c),
              textAlign: TextAlign.center,
            )),
            const SizedBox(width: 11),
            PlayerAvatarWidget(name: p.name, size: 36),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(p.name, style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                if (i < 2) ...[const SizedBox(width: 5), NeonPillWidget(label: "VIP", color: AppColors.neonGold)],
              ]),
              Text("${p.wins}W · ${p.goals} goals",
                  style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text("${p.pts}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: c)),
              const Text("pts", style: TextStyle(fontSize: 8, color: AppColors.textMuted)),
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
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF0D1B4E), Color(0xFF2d1b5e)],
            ),
          ),
          child: Stack(children: [
            Positioned(top: -30, right: -30,
                child: Container(width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neonPurple.withOpacity(0.12),
                    ))),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("POINTS SHOP",
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                        color: AppColors.neonPurple, letterSpacing: 2)),
                const SizedBox(height: 6),
                const Text("Spend Points,",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                const Text("Look Elite! 🛒",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.neonGold)),
                const SizedBox(height: 5),
                Text("Cosmetics only · Points are earned, never sold",
                    style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.4))),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text("BALANCE", style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.4))),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.neonGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: AppColors.neonGold.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Text("🪙", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text("$coins",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.neonGold)),
                  ]),
                ),
              ]),
            ]),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(children: [
            SectionHeadingWidget(
              title: "🎖️ Cosmetic Items",
              sub: "Unlock with earned points — cosmetics only",
            ),

            // ── Shop grid ──────────────────────────────────────────────
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final item = items[i];
                final sel = selIdx == i;
                return GestureDetector(
                  onTap: () => onSel(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
                    decoration: BoxDecoration(
                      color: sel ? item.accent.withOpacity(0.1) : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: sel ? item.accent.withOpacity(0.5) : AppColors.glassBorder,
                        width: sel ? 1.5 : 1,
                      ),
                      boxShadow: sel ? [BoxShadow(
                          color: item.accent.withOpacity(0.2), blurRadius: 16)] : [],
                    ),
                    child: Stack(children: [
                      if (item.owned) Positioned(top: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.neonGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("✓",
                              style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Colors.white)),
                        ),
                      ),
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(item.icon, style: TextStyle(fontSize: 28,
                            shadows: sel ? [Shadow(color: item.accent.withOpacity(0.8), blurRadius: 12)] : [])),
                        const SizedBox(height: 8),
                        Text(item.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary, height: 1.2)),
                        const SizedBox(height: 5),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Text("🪙", style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 3),
                          Text("${item.cost}",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: item.accent)),
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              borderColor: AppColors.neonCyan.withOpacity(0.15),
              child: Row(children: [
                const Text("🛡️", style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Points are earned — never purchased",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  SizedBox(height: 2),
                  Text("All points come from watching ads & completing tasks. No real money. Cosmetics only.",
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted, height: 1.6)),
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
      padding: const EdgeInsets.all(16),
      borderColor: item.accent.withOpacity(0.3),
      shadows: [BoxShadow(color: item.accent.withOpacity(0.1), blurRadius: 20)],
      child: Column(children: [
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: item.accent.withOpacity(0.1),
              border: Border.all(color: item.accent.withOpacity(0.3), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(item.icon, style: TextStyle(fontSize: 26,
                shadows: [Shadow(color: item.accent.withOpacity(0.8), blurRadius: 12)])),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            Text(item.info,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Row(children: [
              const Text("🪙"),
              const SizedBox(width: 4),
              Text("${item.cost}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: item.accent)),
              const SizedBox(width: 5),
              const Text("points", style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
            ]),
          ])),
        ]),
        const SizedBox(height: 14),

        if (item.owned)
          Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.neonGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neonGreen.withOpacity(0.25)),
            ),
            alignment: Alignment.center,
            child: const Text("✓  Already in your collection",
                style: TextStyle(color: AppColors.neonGreen, fontSize: 12, fontWeight: FontWeight.w700)),
          )
        else if (canAfford)
          GestureDetector(
            onTap: () => onBuy(idx),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [item.accent, item.accent.withOpacity(0.75)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: item.accent.withOpacity(0.4), blurRadius: 16)],
              ),
              alignment: Alignment.center,
              child: Text("Buy Now  —  🪙 ${item.cost} Points",
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900)),
            ),
          )
        else
          Container(
            width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.neonRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neonRed.withOpacity(0.25)),
            ),
            alignment: Alignment.center,
            child: Text("⚠️  Need ${item.cost - coins} more points — watch ads to earn!",
                style: const TextStyle(color: AppColors.neonRed, fontSize: 11, fontWeight: FontWeight.w700)),
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
      padding: const EdgeInsets.all(14),
      child: Column(children: [
        // Admin info card
        GlassCardWidget(
          padding: const EdgeInsets.all(12),
          borderColor: AppColors.neonBlue.withOpacity(0.2),
          child: Row(children: [
            Stack(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: const LinearGradient(
                      colors: [AppColors.neonBlue, Color(0xFF2563EB)]),
                  boxShadow: [BoxShadow(color: AppColors.neonBlue.withOpacity(0.4), blurRadius: 10)],
                ),
                alignment: Alignment.center,
                child: const Text("🛡️", style: TextStyle(fontSize: 20)),
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
            const SizedBox(width: 12),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("GameArena Admin",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Text("● Online · Replies within 5 minutes",
                  style: TextStyle(fontSize: 10, color: AppColors.neonGreen, fontWeight: FontWeight.w600)),
            ])),
            NeonPillWidget(label: "OFFICIAL", color: AppColors.neonBlue),
          ]),
        ),
        const SizedBox(height: 12),

        // Messages
        Expanded(child: ListView.builder(
          controller: scrollCtrl,
          itemCount: chats.length,
          itemBuilder: (ctx, i) {
            final m = chats[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: m.me ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!m.me) ...[
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                            colors: [AppColors.neonBlue, Color(0xFF2563EB)]),
                      ),
                      alignment: Alignment.center,
                      child: const Text("🛡️", style: TextStyle(fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * 0.66),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
                      decoration: BoxDecoration(
                        gradient: m.me ? const LinearGradient(
                            colors: [AppColors.neonCyan, Color(0xFF0077AA)]) : null,
                        color: m.me ? null : AppColors.bgCard,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: m.me ? const Radius.circular(16) : const Radius.circular(4),
                          bottomRight: m.me ? const Radius.circular(4) : const Radius.circular(16),
                        ),
                        border: m.me ? null : Border.all(color: AppColors.glassBorder),
                        boxShadow: m.me ? [BoxShadow(color: AppColors.neonCyan.withOpacity(0.25), blurRadius: 10)] : [],
                      ),
                      child: Column(crossAxisAlignment: m.me ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
                        Text(m.text,
                            style: TextStyle(
                              fontSize: 12,
                              color: m.me ? Colors.white : AppColors.textPrimary,
                              height: 1.55,
                            )),
                        const SizedBox(height: 4),
                        Text("${m.time} ago",
                            style: TextStyle(
                              fontSize: 9,
                              color: m.me ? Colors.white.withOpacity(0.4) : AppColors.textMuted,
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
          padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(0.06), blurRadius: 12)],
          ),
          child: Row(children: [
            Expanded(child: TextField(
              controller: ctrl,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
              decoration: const InputDecoration(
                hintText: "Ask admin anything…",
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (_) => onSend(),
            )),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.neonCyan, Color(0xFF0077AA)]),
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(0.4), blurRadius: 10)],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
