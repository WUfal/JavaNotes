import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/quiz.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';
import 'quiz_page.dart';
import 'package:flutter/services.dart';
class MistakeListPage extends StatefulWidget {
  const MistakeListPage({Key? key}) : super(key: key);

  @override
  State<MistakeListPage> createState() => _MistakeListPageState();
}

class _MistakeListPageState extends State<MistakeListPage> {
  Future<List<QuizMistakeChapter>>? _mistakesFuture;
  late ApiService _apiService;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;

    if (_mistakesFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _mistakesFuture = _apiService.fetchMistakes(_token);
    });
  }

  Future<void> _onRefresh() async {
    _mistakesFuture = _apiService.fetchMistakes(_token);
    await _mistakesFuture;
    setState(() {});
  }

  void _retry() {
    _loadData();
  }

  void _retryQuiz(QuizMistakeChapter chapter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
            chapter: QuizChapterSummary(
                id: chapter.chapterId.toInt(),
                title: chapter.chapterTitle
            )
        ),
      ),
    );
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
        title: const Text('我的错题本', style: TextStyle(fontWeight: FontWeight.w600)),
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
      body: FutureBuilder<List<QuizMistakeChapter>>(
        future: _mistakesFuture,
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
                title: '加载失败',
                message: '无法加载错题本。\n(${snapshot.error})',
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
          final mistakeChapters = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: mistakeChapters.length,
              separatorBuilder: (ctx, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildChapterCard(context, mistakeChapters[index], isDark);
              },
            ),
          );
        },
      ),
    );
  }

  // --- UI 组件封装 ---

  Widget _buildChapterCard(BuildContext context, QuizMistakeChapter chapter, bool isDark) {
    final theme = Theme.of(context);

    // 自定义 ExpansionTile 的主题，去除默认的分隔线
    return Container(
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true, // 默认展开，方便查看
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: EdgeInsets.zero,

          // 标题头部
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.folder_open_rounded, color: Colors.red),
          ),
          title: Text(
            chapter.chapterTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${chapter.mistakes.length} 错题",
                    style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // 展开内容
          children: [
            // 分割线
            Divider(height: 1, thickness: 1, color: theme.colorScheme.outline.withOpacity(0.1)),

            // "重新练习" 按钮区域
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () => _retryQuiz(chapter),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.refresh_rounded, size: 18, color: theme.colorScheme.primary),
                  label: Text(
                      '重新挑战本章测验',
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)
                  ),
                ),
              ),
            ),

            // 错题列表
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chapter.mistakes.length,
              itemBuilder: (context, index) {
                final question = chapter.mistakes[index];
                return InkWell(
                  onTap: () => _retryQuiz(chapter),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right, size: 16, color: theme.colorScheme.outline.withOpacity(0.5)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 3,
        separatorBuilder: (ctx, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => Container(
          height: 120,
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
              color: Colors.green.withOpacity(0.1), // 绿色代表没有错误
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline_rounded, size: 64, color: Colors.green),
          ),
          const SizedBox(height: 24),
          Text(
            "太棒了！没有错题",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7)
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "你已经消灭了所有错题，\n保持这个势头继续学习吧！",
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