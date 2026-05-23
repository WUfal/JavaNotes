import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/quiz.dart';
import '../models/beginner_logic_problem.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import 'quiz_page.dart';
import 'logic_problem_detail_page.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';

/// [A路径-练习] Tab的真实页面
class ExercisePage extends StatelessWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          centerTitle: false,
          title: Text(
            '练习中心',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          bottom: TabBar(
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            indicatorColor: colorScheme.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent, // 去掉 M3 默认的分割线
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            tabs: const [
              Tab(text: '知识测验'),
              Tab(text: '编程逻辑'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            QuizChapterList(),
            LogicProblemList(),
          ],
        ),
      ),
    );
  }
}

class ModernExerciseCard extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isCode;

  const ModernExerciseCard({
    Key? key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isCode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 核心映射逻辑：
    // 知识测验 -> 使用 Primary 色系
    // 编程逻辑 -> 使用 Tertiary 色系 (提供视觉区分)
    final containerColor = isCode
        ? colorScheme.tertiaryContainer
        : colorScheme.primaryContainer;
    final onContainerColor = isCode
        ? colorScheme.onTertiaryContainer
        : colorScheme.onPrimaryContainer;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow, // 卡片底色
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 图标容器
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: containerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: onContainerColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // 文字
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LEVEL ${index + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // 箭头
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  size: 24,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// QuizChapterList 和 LogicProblemList 逻辑保持不变，
// 但移除了 AppColors 引用，使用 Theme.of(context) 的 Shimmer 颜色。
class QuizChapterList extends StatefulWidget {
  const QuizChapterList({Key? key}) : super(key: key);
  @override
  State<QuizChapterList> createState() => _QuizChapterListState();
}

class _QuizChapterListState extends State<QuizChapterList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<QuizChapterSummary>>? _chaptersFuture;
  late ApiService _apiService;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;
    if (_chaptersFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _chaptersFuture = _apiService.fetchQuizChapters(_token);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _chaptersFuture = _apiService.fetchQuizChapters(_token);
    });
    await _chaptersFuture;
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
        padding: const EdgeInsets.only(top: 16),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<QuizChapterSummary>>(
      future: _chaptersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoadingShimmer();
        if (snapshot.hasError) {
          return PlaceholderWidget(
            icon: Icons.wifi_off_rounded,
            title: '加载失败',
            message: '无法连接到服务器',
            onRetry: _retry,
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const PlaceholderWidget(
            icon: Icons.quiz_outlined,
            title: '暂无测验',
            message: '题库正在建设中...',
          );
        }

        final chapters = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: colorScheme.primary,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              return ModernExerciseCard(
                index: index,
                title: chapter.title,
                subtitle: '包含多道精选练习题',
                icon: Icons.menu_book_rounded,
                isCode: false, // 使用 Primary 色系
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage(chapter: chapter)));
                },
              );
            },
          ),
        );
      },
    );
  }
}

class LogicProblemList extends StatefulWidget {
  const LogicProblemList({Key? key}) : super(key: key);
  @override
  State<LogicProblemList> createState() => _LogicProblemListState();
}

class _LogicProblemListState extends State<LogicProblemList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<List<BeginnerLogicProblemSummary>>? _problemsFuture;
  late ApiService _apiService;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;
    if (_problemsFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _problemsFuture = _apiService.fetchLogicProblems(_token);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _problemsFuture = _apiService.fetchLogicProblems(_token);
    });
    await _problemsFuture;
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
        padding: const EdgeInsets.only(top: 16),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<BeginnerLogicProblemSummary>>(
      future: _problemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _buildLoadingShimmer();
        if (snapshot.hasError) {
          return PlaceholderWidget(
            icon: Icons.wifi_off_rounded,
            title: '加载失败',
            message: '无法连接到服务器',
            onRetry: _retry,
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const PlaceholderWidget(
            icon: Icons.terminal_rounded,
            title: '暂无题目',
            message: '更多逻辑挑战即将上线！',
          );
        }

        final problems = snapshot.data!;
        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: colorScheme.primary,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            itemCount: problems.length,
            itemBuilder: (context, index) {
              final problem = problems[index];
              return ModernExerciseCard(
                index: index,
                title: problem.title,
                subtitle: '逻辑推理 · 算法入门',
                icon: Icons.code_rounded,
                isCode: true, // 使用 Tertiary 色系
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LogicProblemDetailPage(problemSummary: problem)));
                },
              );
            },
          ),
        );
      },
    );
  }
}