import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/course_module.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/code_block_widget.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';
import 'ai_chat_page.dart';
import '../providers/progress_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/comment_section.dart';

// --- 🎨 设计系统常量 (配色升级) ---
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

class BeginnerLessonDetailPage extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;

  const BeginnerLessonDetailPage({
    Key? key,
    required this.lessonId,
    required this.lessonTitle,
  }) : super(key: key);

  @override
  State<BeginnerLessonDetailPage> createState() => _BeginnerLessonDetailPageState();
}

class _BeginnerLessonDetailPageState extends State<BeginnerLessonDetailPage> {
  Future<ModuleDetail>? _detailFuture;
  late ApiService _apiService;
  String? _token;

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
      _detailFuture = _apiService.fetchBeginnerLessonDetail(_token, widget.lessonId);
    });
  }

  void _retry() {
    _loadData();
  }

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

  void _markAsComplete(BuildContext context, ProgressProvider provider) {
    if (!provider.isLessonCompleted(widget.lessonId)) {
      provider.markLessonAsComplete(_token, widget.lessonId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('恭喜！已完成本节课程 🎉'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
    Navigator.of(context).pop();
  }

  Widget _buildLoadingShimmer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(height: 28, width: 200, color: Colors.white),
          const SizedBox(height: 24),
          Container(height: 16, width: double.infinity, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 16, width: double.infinity, color: Colors.white),
          const SizedBox(height: 8),
          Container(height: 16, width: 250, color: Colors.white),
          const SizedBox(height: 32),
          Container(height: 180, width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          widget.lessonTitle,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),

      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<ModuleDetail>(
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
                      message: '无法加载关卡内容。\n(${snapshot.error})',
                      onRetry: _retry,
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: PlaceholderWidget(
                      icon: Icons.article_outlined,
                      title: '暂无内容',
                      message: '该关卡内容正在建设中...',
                    ),
                  );
                }

                final detail = snapshot.data!;
                final blocks = detail.blocks;

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                  itemCount: blocks.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    if (index == blocks.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(height: 40, thickness: 1),
                            Text("讨论区", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                            const SizedBox(height: 16),
                            CommentSection(
                              targetType: "BEGINNER_LESSON",
                              targetId: widget.lessonId.toString(),
                            ),
                          ],
                        ),
                      );
                    }
                    final block = blocks[index];
                    switch (block.type) {
                      case "text":
                        return MarkdownBody(
                          data: block.content,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(fontSize: 16.0, height: 1.8, color: textColor),
                            strong: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                            blockquote: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontStyle: FontStyle.italic),
                            blockquoteDecoration: BoxDecoration(color: isDark ? Colors.white10 : AppColors.backgroundLight, borderRadius: BorderRadius.circular(8), border: Border(left: BorderSide(color: AppColors.primary.withOpacity(0.5), width: 4))),
                            code: TextStyle(backgroundColor: mdCodeBg, color: mdCodeText, fontFamily: 'monospace', fontSize: 14.5, fontWeight: FontWeight.w500, letterSpacing: -0.3),
                            a: const TextStyle(color: AppColors.primary, decoration: TextDecoration.underline),
                          ),
                        );
                      case "sub-header":
                        return Text(block.content, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textColor, height: 1.3));
                      case "code":
                        return Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), offset: const Offset(0, 4), blurRadius: 12)]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CodeBlockWidget(codeContent: block.content, language: block.language ?? 'java', isBeginner: true),
                          ),
                        );
                      default:
                        return Text("未知内容块", style: TextStyle(color: Colors.grey[500], fontSize: 12));
                    }
                  },
                );
              },
            ),
          ),
          _buildBottomBar(context, progressProvider, isDark),
        ],
      ),

      // --- 🔥 全新设计的 AI 悬浮按钮 🔥 ---
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
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
                  "viewing: beginner_lesson_${widget.lessonId}",
                  widget.lessonTitle
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
    );
  }

  Widget _buildBottomBar(BuildContext context, ProgressProvider provider, bool isDark) {
    final isCompleted = provider.isLessonCompleted(widget.lessonId);
    final bgColor = isDark ? AppColors.cardBgDark : Colors.white;
    final borderColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 16)],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _markAsComplete(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.green : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isCompleted ? Icons.check_circle_rounded : Icons.check_rounded),
                  const SizedBox(width: 8),
                  Text(isCompleted ? '已完成 (点击返回)' : '标记为完成', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}