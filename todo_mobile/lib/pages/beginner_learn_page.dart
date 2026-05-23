import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/beginner_level.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import 'beginner_lesson_detail_page.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';
import '../providers/progress_provider.dart';

class BeginnerLearnPage extends StatefulWidget {
  const BeginnerLearnPage({Key? key}) : super(key: key);
  @override
  State<BeginnerLearnPage> createState() => _BeginnerLearnPageState();
}

class _BeginnerLearnPageState extends State<BeginnerLearnPage> with AutomaticKeepAliveClientMixin {
  Future<List<BeginnerLevelDto>>? _levelsFuture;
  late ApiService _apiService;
  String? _token;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;

    if (_levelsFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _levelsFuture = _apiService.fetchBeginnerLevels(_token);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _levelsFuture = _apiService.fetchBeginnerLevels(_token);
    });
    await _levelsFuture;
  }

  void _retry() {
    _loadData();
  }

  Widget _buildLoadingShimmer() {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Scaffold 背景色通常由 Theme 自动处理，这里显式指定 surface 看起来更干净
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        title: Text(
          '基础训练营',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu), // 汉堡菜单图标
          tooltip: '打开侧边栏',
          onPressed: () {
            // 打开 MainPage (父级 Scaffold) 的 Drawer
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: FutureBuilder<List<BeginnerLevelDto>>(
        future: _levelsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingShimmer();
          }
          if (snapshot.hasError) {
            return PlaceholderWidget(
              icon: Icons.error_outline,
              title: '加载失败',
              message: '无法连接到服务器。\n(${snapshot.error})',
              onRetry: _retry,
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const PlaceholderWidget(
              icon: Icons.school_outlined,
              title: '暂无课程',
              message: '我们正在努力准备课程，请稍后再来查看！',
            );
          }

          final levels = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: colorScheme.primary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                return _LevelCard(
                  level: levels[index],
                  isInitiallyExpanded: index == 0,
                  progressProvider: progressProvider,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final BeginnerLevelDto level;
  final bool isInitiallyExpanded;
  final ProgressProvider progressProvider;

  const _LevelCard({
    Key? key,
    required this.level,
    required this.isInitiallyExpanded,
    required this.progressProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        // 使用 surfaceContainer (比背景稍亮/稍暗，视模式而定) 制造层次感
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        // 在 M3 中，通常减少阴影，更多使用色调区分，但为了卡片感保留轻微阴影
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isInitiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 16),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer, // 主色容器背景
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.map_outlined, color: colorScheme.onPrimaryContainer, size: 20),
          ),
          title: Text(
            level.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          iconColor: colorScheme.primary,
          collapsedIconColor: colorScheme.onSurfaceVariant,
          children: [
            ...level.lessons.asMap().entries.map((entry) {
              final index = entry.key;
              final lesson = entry.value;
              final isLast = index == level.lessons.length - 1;
              final isCompleted = progressProvider.isLessonCompleted(lesson.id);

              return _LessonItem(
                lesson: lesson,
                isCompleted: isCompleted,
                isLast: isLast,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BeginnerLessonDetailPage(
                        lessonId: lesson.id,
                        lessonTitle: lesson.title,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class _LessonItem extends StatelessWidget {
  final dynamic lesson;
  final bool isCompleted;
  final bool isLast;
  final VoidCallback onTap;

  const _LessonItem({
    Key? key,
    required this.lesson,
    required this.isCompleted,
    required this.isLast,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 状态颜色：完成用 Primary，未完成用 Outline
    final statusColor = isCompleted ? colorScheme.primary : colorScheme.outlineVariant;
    final textColor = isCompleted ? colorScheme.onSurfaceVariant : colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧时间轴
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isCompleted ? statusColor : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: statusColor, width: 2),
                        ),
                        child: isCompleted
                            ? Icon(Icons.check, size: 14, color: colorScheme.onPrimary)
                            : null,
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: colorScheme.outlineVariant.withOpacity(0.5), // 柔和的线条
                            margin: const EdgeInsets.only(top: 4),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 右侧文本
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            lesson.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}