import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/algorithm.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import 'algorithm_detail_page.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';
import 'search_page.dart';

class AlgorithmPage extends StatefulWidget {
  const AlgorithmPage({Key? key}) : super(key: key);
  @override
  State<AlgorithmPage> createState() => _AlgorithmPageState();
}

class _AlgorithmPageState extends State<AlgorithmPage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  Future<List<AlgorithmSummary>>? _algorithmsFuture;
  late ApiService _apiService;
  String? _token;
  late TabController _tabController;
  final List<Tab> _tabs = const [Tab(text: '全部'), Tab(text: '简单'), Tab(text: '中等'), Tab(text: '困难')];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;
    if (_algorithmsFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _algorithmsFuture = _apiService.fetchAlgorithms(_token);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _algorithmsFuture = _apiService.fetchAlgorithms(_token);
    });
    await _algorithmsFuture;
  }

  void _retry() {
    _loadData();
  }

  Widget _buildLoadingShimmer() {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: ListView.separated(
        itemCount: 8,
        separatorBuilder: (_, __) => Divider(height: 1, color: colorScheme.outlineVariant),
        itemBuilder: (_, __) => Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(8))),
              const SizedBox(width: 16),
              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 120, height: 16, color: colorScheme.surface),
                const SizedBox(height: 8),
                Container(width: 60, height: 12, color: colorScheme.surface),
              ])),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          '算法题库',
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            tooltip: '搜索',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colorScheme.outlineVariant, width: 1))),
            child: TabBar(
              controller: _tabController,
              tabs: _tabs,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<AlgorithmSummary>>(
        future: _algorithmsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return _buildLoadingShimmer();
          if (snapshot.hasError) {
            return PlaceholderWidget(icon: Icons.error_outline, title: '加载失败', message: '无法连接到服务器', onRetry: _retry);
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return PlaceholderWidget(icon: Icons.code_off_outlined, title: '暂无题目', message: '我们的题库正在建设中！', onRetry: _retry);
          }
          final allAlgorithms = snapshot.data!;
          return TabBarView(
            controller: _tabController,
            children: [
              _buildAlgorithmList(allAlgorithms, 'All'),
              _buildAlgorithmList(allAlgorithms, 'Easy'),
              _buildAlgorithmList(allAlgorithms, 'Medium'),
              _buildAlgorithmList(allAlgorithms, 'Hard'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAlgorithmList(List<AlgorithmSummary> allAlgorithms, String difficulty) {
    final List<AlgorithmSummary> filteredList;
    if (difficulty == 'All') {
      filteredList = allAlgorithms;
    } else {
      filteredList = allAlgorithms.where((algo) => algo.difficulty.toLowerCase() == difficulty.toLowerCase()).toList();
    }

    if (filteredList.isEmpty) {
      return PlaceholderWidget(icon: Icons.filter_list_off, title: '暂无题目', message: '没有找到“$difficulty”难度的题目。');
    }

    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: colorScheme.primary,
      child: ListView.separated(
        key: PageStorageKey<String>('algo_tab_$difficulty'),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredList.length,
        separatorBuilder: (context, index) => Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant.withOpacity(0.5), indent: 68),
        itemBuilder: (context, index) {
          final algo = filteredList[index];
          return CleanAlgorithmTile(
            index: index + 1,
            title: algo.title,
            difficulty: algo.difficulty,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AlgorithmDetailPage(summary: algo)));
            },
          );
        },
      ),
    );
  }
}

class CleanAlgorithmTile extends StatelessWidget {
  final int index;
  final String title;
  final String difficulty;
  final VoidCallback onTap;

  const CleanAlgorithmTile({Key? key, required this.index, required this.title, required this.difficulty, required this.onTap}) : super(key: key);

  // 难度颜色通常保留语义（绿/黄/红），但会根据模式调整亮度
  Color _getDifficultyColor(String difficulty, bool isDark) {
    switch (difficulty.toLowerCase()) {
      case "easy": return isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);
      case "medium": return isDark ? const Color(0xFFFACC15) : const Color(0xFFA16207);
      case "hard": return isDark ? const Color(0xFFF87171) : const Color(0xFFB91C1C);
      default: return isDark ? Colors.grey : Colors.grey;
    }
  }

  Color _getDifficultyBg(String difficulty, bool isDark) {
    switch (difficulty.toLowerCase()) {
      case "easy": return isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
      case "medium": return isDark ? const Color(0xFF422006) : const Color(0xFFFEF9C3);
      case "hard": return isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
      default: return isDark ? Colors.grey[800]! : Colors.grey[200]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final badgeBg = _getDifficultyBg(difficulty, isDark);
    final badgeText = _getDifficultyColor(difficulty, isDark);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  "$index",
                  style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  difficulty,
                  style: TextStyle(color: badgeText, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 18, color: colorScheme.onSurfaceVariant.withOpacity(0.3))
            ],
          ),
        ),
      ),
    );
  }
}