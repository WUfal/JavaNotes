import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_service.dart';
import '../providers/bookmark_provider.dart';
import '../models/bookmark.dart';

// 导入详情页
import 'content_detail_page.dart';
import 'project_detail_page.dart';
import 'algorithm_detail_page.dart';

// 导入摘要模型
import '../models/project.dart';
import '../models/algorithm.dart';
import 'package:flutter/services.dart';
class BookmarkListPage extends StatefulWidget {
  const BookmarkListPage({Key? key}) : super(key: key);

  @override
  State<BookmarkListPage> createState() => _BookmarkListPageState();
}

class _BookmarkListPageState extends State<BookmarkListPage> {
  // 当前选中的筛选类型: "ALL", "COURSE_MODULE", "PROJECT", "ALGORITHM"
  String _selectedFilter = "ALL";

  // --- 🎨 样式辅助方法 ---

  _BookmarkStyle _getStyleForType(String type) {
    switch (type) {
      case "COURSE_MODULE":
        return _BookmarkStyle(
          color: Colors.blue,
          label: "课程学习",
          icon: Icons.school_outlined,
        );
      case "PROJECT":
        return _BookmarkStyle(
          color: Colors.purple,
          label: "实战项目",
          icon: Icons.code_rounded,
        );
      case "ALGORITHM":
        return _BookmarkStyle(
          color: Colors.orange,
          label: "算法题解",
          icon: Icons.functions_rounded,
        );
      default:
        return _BookmarkStyle(
          color: Colors.grey,
          label: "其他收藏",
          icon: Icons.bookmark_outline,
        );
    }
  }

  // --- 🚀 导航逻辑 ---
  void _navigateToDetail(BuildContext context, Bookmark bookmark) {
    switch (bookmark.type) {
      case "COURSE_MODULE":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentDetailPage(
              moduleId: bookmark.bookmarkedId,
              moduleTitle: bookmark.title,
            ),
          ),
        );
        break;

      case "PROJECT":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailPage(
              projectSummary: ProjectSummary(
                id: bookmark.bookmarkedId,
                title: bookmark.title,
                description: '',
                techStack: '',
              ),
            ),
          ),
        );
        break;

      case "ALGORITHM":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlgorithmDetailPage(
              summary: AlgorithmSummary(
                id: bookmark.bookmarkedId,
                title: bookmark.title,
                difficulty: '',
              ),
            ),
          ),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('无法识别的收藏类型: ${bookmark.type}')),
        );
    }
  }

  // --- 🗑️ 删除逻辑 ---
  Future<void> _handleDelete(BuildContext context, BookmarkProvider provider, Bookmark bookmark) async {
    final token = Provider.of<AuthService>(context, listen: false).token;
    await provider.removeBookmark(token, bookmark.type, bookmark.bookmarkedId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
        : const Color(0xFFF8F9FC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("我的收藏", style: TextStyle(fontWeight: FontWeight.w600)),
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
        // ⬆️⬆️⬆️ 关键修改结束 ⬆️⬆️⬆️
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          // 1. 加载中
          if (bookmarkProvider.isLoading) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }

          // 2. 错误状态
          if (bookmarkProvider.error != null) {
            return _buildErrorState(context, bookmarkProvider);
          }

          // 3. 全局空状态 (没有任何收藏)
          if (bookmarkProvider.bookmarks.isEmpty) {
            return _buildEmptyState(context);
          }

          // 4. 过滤列表
          final allBookmarks = bookmarkProvider.bookmarks;
          final filteredBookmarks = _selectedFilter == "ALL"
              ? allBookmarks
              : allBookmarks.where((b) => b.type == _selectedFilter).toList();

          return Column(
            children: [
              // 顶部筛选栏
              _buildFilterBar(context, theme),

              const SizedBox(height: 8),

              // 列表区域
              Expanded(
                child: filteredBookmarks.isEmpty
                    ? _buildEmptyFilterState(context) // 分类下无内容
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: filteredBookmarks.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final bookmark = filteredBookmarks[index];
                    return _buildBookmarkCard(context, bookmark, bookmarkProvider, isDark);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- UI 组件构建 ---

  // 构建筛选栏
  Widget _buildFilterBar(BuildContext context, ThemeData theme) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(context, "全部", "ALL"),
          const SizedBox(width: 8),
          _buildFilterChip(context, "课程", "COURSE_MODULE"),
          const SizedBox(width: 8),
          _buildFilterChip(context, "项目", "PROJECT"),
          const SizedBox(width: 8),
          _buildFilterChip(context, "算法", "ALGORITHM"),
        ],
      ),
    );
  }

  // 单个筛选标签
  Widget _buildFilterChip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isSelected = _selectedFilter == value;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
      showCheckmark: false, // 不显示对勾，更像 Tab
      selectedColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.transparent : theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildBookmarkCard(BuildContext context, Bookmark bookmark, BookmarkProvider provider, bool isDark) {
    final style = _getStyleForType(bookmark.type);
    final theme = Theme.of(context);

    return Dismissible(
      key: Key("bookmark_${bookmark.id}"),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text("取消收藏", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.bookmark_remove, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("取消收藏"),
            content: Text("确定要移除“${bookmark.title}”吗？"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("保留")),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text("移除", style: TextStyle(color: Colors.red))
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        _handleDelete(context, provider, bookmark);
      },
      child: InkWell(
        onTap: () => _navigateToDetail(context, bookmark),
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
              // 左侧图标容器
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: style.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(style.icon, color: style.color, size: 24),
              ),
              const SizedBox(width: 16),

              // 中间文本
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookmark.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // 标签 Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: style.color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: style.color.withOpacity(0.2), width: 0.5),
                      ),
                      child: Text(
                        style.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: style.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 右侧箭头
              Icon(Icons.chevron_right, color: theme.colorScheme.outline.withOpacity(0.4)),
            ],
          ),
        ),
      ),
    );
  }

  // 全局空状态
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.bookmarks_outlined, size: 64, color: colorScheme.primary.withOpacity(0.4)),
          ),
          const SizedBox(height: 24),
          Text(
            "暂无收藏内容",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withOpacity(0.7)
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "在学习过程中，点击右上角的\n收藏按钮即可添加到这里",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // 筛选后为空的状态
  Widget _buildEmptyFilterState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_list_off, size: 48, color: theme.colorScheme.outline.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            "该分类下暂无收藏",
            style: TextStyle(
              color: theme.colorScheme.outline,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, BookmarkProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text("加载失败: ${provider.error}"),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              final String? token = Provider.of<AuthService>(context, listen: false).token;
              provider.loadBookmarks(token);
            },
            icon: const Icon(Icons.refresh),
            label: const Text("重试"),
          )
        ],
      ),
    );
  }
}

// 简单的样式配置类
class _BookmarkStyle {
  final Color color;
  final String label;
  final IconData icon;

  _BookmarkStyle({required this.color, required this.label, required this.icon});
}