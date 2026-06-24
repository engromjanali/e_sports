import 'dart:async';

import 'package:e_sports/core/utils/dimensions.dart';
import 'package:e_sports/core/data/models/player_model.dart';
import 'package:e_sports/features/player/domain/services/player_service_interface.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Server-backed player picker shared across the app (compare screen, home
/// search, …): debounced search + infinite-scroll pagination. Identity only
/// (no season/stats). Opened with `showSearch<PlayerModel?>` and returns the
/// picked [PlayerModel] (or null when dismissed) — the caller decides what to
/// do with the selection.
class PlayerSelectDelegate extends SearchDelegate<PlayerModel?> {
  final PlayerServiceInterface _service = Get.find<PlayerServiceInterface>();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: AppColors.bgCard),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _results(context);

  @override
  Widget buildSuggestions(BuildContext context) => _results(context);

  Widget _results(BuildContext context) => _PlayerSearchResults(
        service: _service,
        query: query,
        onPick: (p) => close(context, p),
      );
}

/// Loads a player page from the server for the current [query], debouncing
/// query changes and paginating on scroll.
class _PlayerSearchResults extends StatefulWidget {
  final PlayerServiceInterface service;
  final String query;
  final ValueChanged<PlayerModel> onPick;

  const _PlayerSearchResults({
    required this.service,
    required this.query,
    required this.onPick,
  });

  @override
  State<_PlayerSearchResults> createState() => _PlayerSearchResultsState();
}

class _PlayerSearchResultsState extends State<_PlayerSearchResults> {
  static const int _pageSize = 20;

  final List<PlayerModel> _items = [];
  final ScrollController _scroll = ScrollController();
  Timer? _debounce;
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _reload();
  }

  @override
  void didUpdateWidget(covariant _PlayerSearchResults old) {
    super.didUpdateWidget(old);
    if (old.query != widget.query) {
      _debounce?.cancel();
      // Show the loader right away while we wait out the debounce + fetch.
      _loading = true;
      _debounce = Timer(const Duration(milliseconds: 350), _reload);
    }
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    _page = 1;
    final result = await widget.service.searchPlayers(
      search: widget.query, limit: _pageSize, offset: _page,
    );
    if (!mounted) return;
    setState(() {
      _items..clear()..addAll(result);
      _hasMore = result.length == _pageSize;
      _loading = false;
    });
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _loading || _loadingMore) return;
    setState(() => _loadingMore = true);
    final next = _page + 1;
    final result = await widget.service.searchPlayers(
      search: widget.query, limit: _pageSize, offset: next,
    );
    if (!mounted) return;
    setState(() {
      _items.addAll(result);
      _page = next;
      _hasMore = result.length == _pageSize;
      _loadingMore = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: Column(
        children: [
          // Thin loader over existing results while (re)searching.
          SizedBox(
            height: 2,
            child: (_loading && _items.isNotEmpty)
                ? LinearProgressIndicator(color: AppColors.neonGold, backgroundColor: Colors.transparent)
                : null,
          ),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading && _items.isEmpty) {
      return Center(child: CircularProgressIndicator(color: AppColors.neonGold));
    }
    if (_items.isEmpty) {
      return Center(child: Text("No players found", style: TextStyle(color: AppColors.textMuted)));
    }
    return ListView.separated(
      controller: _scroll,
      padding: EdgeInsets.all(Dimensions.xxxl),
      itemCount: _items.length + (_hasMore ? 1 : 0),
      separatorBuilder: (_, _) => SizedBox(height: Dimensions.md),
      itemBuilder: (context, i) {
        if (i >= _items.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.lg),
            child: Center(
              child: _loadingMore
                  ? SizedBox(
                      height: Dimensions.iconMd, width: Dimensions.iconMd,
                      child: CircularProgressIndicator(strokeWidth: Dimensions.borderMedium, color: AppColors.neonGold),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }
        return _PlayerRow(player: _items[i], onTap: () => widget.onPick(_items[i]));
      },
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final PlayerModel player;
  final VoidCallback onTap;
  const _PlayerRow({required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = player;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.md),
        decoration: BoxDecoration(
          color: AppColors.bgCard.withOpacity(0.5),
          borderRadius: Dimensions.borderLg,
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.neonGold.withOpacity(0.1),
              backgroundImage: p.imageUrl.isNotEmpty ? NetworkImage(p.imageUrl) : null,
              child: p.imageUrl.isNotEmpty
                  ? null
                  : Text(p.name.isNotEmpty ? p.name[0] : '?', style: TextStyle(color: AppColors.neonGold, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: Dimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: TextStyle(color: AppColors.white, fontWeight: Dimensions.bold, fontSize: 14)),
                  Text("#${p.jerseyNumber}", style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
