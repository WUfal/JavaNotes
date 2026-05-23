import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/project.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/code_block_widget.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';
import '../providers/chat_provider.dart';
import 'ai_chat_page.dart';
import '../widgets/comment_section.dart';

class ProjectDetailPage extends StatefulWidget {
  final ProjectSummary projectSummary;
  const ProjectDetailPage({Key? key, required this.projectSummary}) : super(key: key);

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  Future<ProjectDetail>? _projectDetailFuture;
  late ApiService _apiService;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;

    if (_projectDetailFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _projectDetailFuture = _apiService.fetchProjectDetail(_token, widget.projectSummary.id);
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

  Widget _buildLoadingShimmer() {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => Container(
          height: 120,
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
    final colorScheme = Theme.of(context).colorScheme;
    const String bookmarkType = "PROJECT";

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text(
          widget.projectSummary.title,
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              final bool isMarked = bookmarkProvider.isBookmarked(
                  bookmarkType,
                  widget.projectSummary.id
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
                    bookmarkProvider.removeBookmark(token, bookmarkType, widget.projectSummary.id);
                  } else {
                    bookmarkProvider.addBookmark(token, bookmarkType, widget.projectSummary.id, widget.projectSummary.title);
                  }
                },
              );
            },
          )
        ],
      ),

      // --- 🔥 全新设计的 AI 悬浮按钮 🔥 ---
      floatingActionButton: Container(
        height: 58,
        width: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFA855F7).withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            _openAiChat(
                context,
                "viewing: ${widget.projectSummary.id}",
                widget.projectSummary.title
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
        ),
      ),

      body: FutureBuilder<ProjectDetail>(
        future: _projectDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingShimmer();
          }
          if (snapshot.hasError) {
            return Center(
              child: PlaceholderWidget(
                icon: Icons.error_outline,
                title: '加载失败',
                message: '无法加载项目内容。\n(${snapshot.error})',
                onRetry: _retry,
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.steps.isEmpty) {
            return const Center(
              child: PlaceholderWidget(
                icon: Icons.article_outlined,
                title: '暂无内容',
                message: '该项目内容正在建设中...',
              ),
            );
          }

          final projectDetail = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // 底部留空给 FAB
            itemCount: projectDetail.steps.length + 1,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == projectDetail.steps.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1, color: colorScheme.outlineVariant),
                      const SizedBox(height: 16),
                      Text("项目讨论", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                      const SizedBox(height: 16),
                      CommentSection(targetType: "PROJECT", targetId: widget.projectSummary.id),
                    ],
                  ),
                );
              }

              final step = projectDetail.steps[index];

              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: colorScheme.shadow.withOpacity(0.05), offset: const Offset(0, 2), blurRadius: 8)],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: index == 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

                    leading: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSecondaryContainer),
                      ),
                    ),
                    title: Text(step.stepTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface)),

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: step.blocks.map((block) {
                          switch (block.type) {
                            case "text":
                              return MarkdownBody(
                                data: block.content,
                                selectable: true,
                                styleSheet: MarkdownStyleSheet(
                                  p: TextStyle(fontSize: 15.0, height: 1.6, color: colorScheme.onSurface),
                                  strong: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
                                  code: TextStyle(backgroundColor: colorScheme.surfaceContainerHighest, color: colorScheme.primary, fontFamily: 'monospace', fontSize: 14),
                                  blockquote: TextStyle(color: colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic),
                                  blockquoteDecoration: BoxDecoration(color: colorScheme.surfaceContainerHighest.withOpacity(0.5), borderRadius: BorderRadius.circular(8), border: Border(left: BorderSide(color: colorScheme.primary, width: 3))),
                                ),
                              );
                            case "sub-header":
                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                                child: Text(block.content, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colorScheme.onSurface)),
                              );
                            case "code":
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5))),
                                child: ClipRRect(borderRadius: BorderRadius.circular(12), child: CodeBlockWidget(codeContent: block.content, language: block.language ?? 'java')),
                              );
                            default:
                              return Text("未知内容块: ${block.content}");
                          }
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}