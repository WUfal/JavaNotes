import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';

// 使用别名避免与 Material 3 的 Badge 组件冲突
import '../models/badge.dart' as model;
import 'package:flutter/services.dart';
class BadgeListPage extends StatefulWidget {
  const BadgeListPage({Key? key}) : super(key: key);

  @override
  State<BadgeListPage> createState() => _BadgeListPageState();
}

class _BadgeListPageState extends State<BadgeListPage> {
  Future<List<model.Badge>>? _badgesFuture;
  late ApiService _apiService;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _token = Provider.of<AuthService>(context, listen: false).token;

    if (_badgesFuture == null) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _badgesFuture = _apiService.fetchMyBadges(_token);
    });
  }

  Future<void> _onRefresh() async {
    _loadData();
    await _badgesFuture;
  }

  void _retry() {
    _loadData();
  }

  // --- 🎨 样式辅助方法 ---
  _BadgeStyle _getBadgeStyle(String iconName) {
    switch (iconName) {
      case "school":
        return _BadgeStyle(Colors.blue, Icons.school_rounded);
      case "emoji_events":
        return _BadgeStyle(Colors.amber, Icons.emoji_events_rounded);
      case "play_arrow":
        return _BadgeStyle(Colors.green, Icons.play_arrow_rounded);
      default:
        return _BadgeStyle(Colors.purple, Icons.military_tech_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 统一背景色
    final bgColor = isDark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
        : const Color(0xFFF8F9FC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('我的徽章', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          // 1. 设置状态栏背景为透明
          statusBarColor: Colors.transparent,

          // 2. Android 设置：
          // 如果是暗黑模式(isDark)，图标要亮的(白色) -> Brightness.light
          // 如果是白天模式(!isDark)，图标要暗的(黑色) -> Brightness.dark  <-- 这就是您需要的效果
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,

          // 3. iOS 设置 (逻辑通常是反的，控制的是背景亮度感知)：
          // 白天模式下，告诉 iOS 背景是亮的(Light)，它就会自动把字变成黑色
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      body: FutureBuilder<List<model.Badge>>(
        future: _badgesFuture,
        builder: (context, snapshot) {
          // 1. 加载中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingShimmer(isDark);
          }

          // 2. 错误
          if (snapshot.hasError) {
            return Center(
              child: PlaceholderWidget(
                icon: Icons.error_outline,
                title: '加载徽章失败',
                message: snapshot.error.toString(),
                onRetry: _retry,
              ),
            );
          }

          // 3. 空数据
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight * 2,
                  child: _buildEmptyState(context),
                ),
              ),
            );
          }

          // 4. 数据展示
          final badges = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: badges.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildBadgeCard(context, badges[index], isDark);
              },
            ),
          );
        },
      ),
    );
  }

  // --- UI 组件封装 ---

  Widget _buildBadgeCard(BuildContext context, model.Badge badge, bool isDark) {
    final theme = Theme.of(context);
    final style = _getBadgeStyle(badge.iconName);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.1),
        ),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // 左侧：徽章图标块
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: style.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16), // Squircle 风格
            ),
            child: Icon(style.icon, color: style.color, size: 28),
          ),
          const SizedBox(width: 16),

          // 右侧：文本信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  badge.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 4,
        separatorBuilder: (ctx, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => Container(
          height: 88, // 模拟卡片高度
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.emoji_events_outlined, size: 64, color: theme.colorScheme.primary.withOpacity(0.4)),
          ),
          const SizedBox(height: 24),
          Text(
            "暂无徽章",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7)
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "完成学习关卡和测验，\n收集属于你的荣誉徽章！",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// 简单的样式配置类
class _BadgeStyle {
  final Color color;
  final IconData icon;

  _BadgeStyle(this.color, this.icon);
}