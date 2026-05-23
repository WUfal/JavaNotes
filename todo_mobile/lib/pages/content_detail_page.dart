import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/course_module.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/code_block_widget.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';
import '../providers/chat_provider.dart';
import 'ai_chat_page.dart';
import '../widgets/comment_section.dart';

// --- 🎨 设计系统常量 (保持一致性) ---
class AppColors {
  // Light Mode
  static const Color primary = Color(0xFF4F46E5);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardBgLight = Colors.white;
  static const Color textMainLight = Color(0xFF1E293B); // Slate 800
  static const Color textSubLight = Color(0xFF64748B);
  static const Color dividerLight = Color(0xFFE2E8F0);

  // Dark Mode
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color cardBgDark = Color(0xFF1E293B); // Slate 800
  static const Color textMainDark = Color(0xFFF1F5F9); // Slate 100
  static const Color textSubDark = Color(0xFF94A3B8);
  static const Color dividerDark = Color(0xFF334155);

  // Markdown Styles
  static const Color codeBgLight = Color(0xFFF1F5F9);
  static const Color codeBgDark = Color(0xFF334155);
  static const Color codeTextLight = Color(0xFF4338CA);
  static const Color codeTextDark = Color(0xFFA5B4FC);
  static const Color blockquoteBorder = Color(0xFFCBD5E1);
}

class ContentDetailPage extends StatefulWidget {
  final String moduleId;
  final String moduleTitle;

  const ContentDetailPage({
    Key? key,
    required this.moduleId,
    required this.moduleTitle,
  }) : super(key: key);

  @override
  State<ContentDetailPage> createState() => _ContentDetailPageState();
}

class _ContentDetailPageState extends State<ContentDetailPage> {
  Future<ModuleDetail>? _detailFuture;

  late ApiService _apiService;
  String? _token;

  void _openAiChat(BuildContext context, String contextId, String contextTitle) {
    Provider.of<ChatProvider>(context, listen: false)
        .startNewChat(contextId, contextTitle);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Expanded(child: AiChatPage()),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;

    if (_detailFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _detailFuture = _apiService.fetchModuleDetail(_token, widget.moduleId);
    });
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
        padding: const EdgeInsets.all(20.0),
        itemCount: 6,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) ...[
                Container(height: 28, width: 200, color: colorScheme.surface),
                const SizedBox(height: 24),
              ],
              Container(height: 16, width: double.infinity, color: colorScheme.surface),
              const SizedBox(height: 8),
              Container(height: 16, width: double.infinity, color: colorScheme.surface),
              const SizedBox(height: 8),
              Container(height: 16, width: 250, color: colorScheme.surface),
              if (index == 2) ...[
                const SizedBox(height: 32),
                Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String bookmarkType = "COURSE_MODULE";
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 颜色定义
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? AppColors.textMainDark : AppColors.textMainLight;
    final mdCodeBg = isDark ? AppColors.codeBgDark : AppColors.codeBgLight;
    final mdCodeText = isDark ? AppColors.codeTextDark : AppColors.codeTextLight;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(
          widget.moduleTitle,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              final bool isMarked = bookmarkProvider.isBookmarked(
                  bookmarkType,
                  widget.moduleId
              );

              return IconButton(
                icon: Icon(
                  isMarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isMarked ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
                tooltip: isMarked ? '取消收藏' : '收藏',
                onPressed: () {
                  final String? token = Provider.of<AuthService>(context, listen: false).token;
                  if (isMarked) {
                    bookmarkProvider.removeBookmark(
                        token,
                        bookmarkType,
                        widget.moduleId
                    );
                  } else {
                    bookmarkProvider.addBookmark(
                        token,
                        bookmarkType,
                        widget.moduleId,
                        widget.moduleTitle
                    );
                  }
                },
              );
            },
          )
        ],
      ),

      // --- 🔥 全新设计的 AI 悬浮按钮 🔥 ---
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 200.0), // 底部留出一点空间
        child: Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // 流光渐变：靛青 -> 紫 -> 粉
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6366F1), // Indigo
                Color(0xFFA855F7), // Purple
                Color(0xFFEC4899), // Pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // 弥散阴影 (Glow)
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFA855F7).withOpacity(0.5), // 紫色光晕
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              _openAiChat(
                  context,
                  "viewing: ${widget.moduleId}",
                  widget.moduleTitle
              );
            },
            // 将背景设为透明，展示下方的渐变 Container
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            shape: const CircleBorder(),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
          ),
        ),
      ),

      body: FutureBuilder<ModuleDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingShimmer();
          }
          if (snapshot.hasError) {
            return Center(
              child: PlaceholderWidget(
                icon: Icons.error_outline,
                title: '加载失败',
                message: '无法加载课程内容。\n(${snapshot.error})',
                onRetry: _retry,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: PlaceholderWidget(
                icon: Icons.article_outlined,
                title: '暂无内容',
                message: '该课程内容正在建设中...',
              ),
            );
          }

          final detail = snapshot.data!;
          final blocks = detail.blocks;

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), // 底部留白给 FAB
            itemCount: blocks.length + 1,
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemBuilder: (context, index) {

              if (index == blocks.length) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(thickness: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
                    const SizedBox(height: 16),
                    Text(
                      "讨论区",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CommentSection(
                      targetType: "COURSE_MODULE",
                      targetId: widget.moduleId,
                    ),
                  ],
                );
              }

              final block = blocks[index];

              switch (block.type) {
                case "text":
                  return MarkdownBody(
                    data: block.content,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        fontSize: 16.0,
                        height: 1.8,
                        color: textColor,
                      ),
                      strong: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      blockquote: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                      blockquoteDecoration: BoxDecoration(
                        color: isDark ? Colors.white10 : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          left: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 4),
                        ),
                      ),
                      code: TextStyle(
                        backgroundColor: mdCodeBg,
                        color: mdCodeText, // 适配后的文字颜色
                        fontFamily: 'monospace',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                      a: const TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  );

                case "sub-header":
                  return Text(
                    block.content,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      height: 1.3,
                    ),
                  );

                case "code":
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CodeBlockWidget(
                        codeContent: block.content,
                        language: block.language ?? 'java',
                        isBeginner: false, // B 路径
                      ),
                    ),
                  );

                default:
                  return Text("未知内容块: ${block.content}", style: TextStyle(color: Colors.grey[500]));
              }
            },
          );
        },
      ),
    );
  }
}