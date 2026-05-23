import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/comment.dart';
import '../services/api_service.dart';
import '../providers/auth_service.dart';
import 'package:intl/intl.dart';

class CommentSection extends StatefulWidget {
  final String targetType; // e.g., "COURSE_MODULE", "PROJECT"
  final String targetId;   // e.g., "core_oop", "1"

  const CommentSection({
    Key? key,
    required this.targetType,
    required this.targetId,
  }) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late ApiService _apiService;
  String? _token;

  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isPosting = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _token = Provider.of<AuthService>(context, listen: false).token;
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final comments = await _apiService.fetchComments(
          _token, widget.targetType, widget.targetId);
      if (mounted) {
        setState(() {
          _comments = comments;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("加载评论失败: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _postComment() async {
    final content = _textController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isPosting = true);

    try {
      final newComment = await _apiService.postComment(
          _token, widget.targetType, widget.targetId, content);
      if (mounted) {
        setState(() {
          _comments.insert(0, newComment);
          _textController.clear();
          _isPosting = false;
        });
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isPosting = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("发送失败: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前的配色方案 (自动适配亮/暗模式)
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(thickness: 1, height: 32, color: colorScheme.outlineVariant),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "评论区",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface, // 适配文字颜色
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 1. 评论列表区域
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_comments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "暂无评论，快来抢沙发吧！",
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _comments.length,
            separatorBuilder: (ctx, i) => Divider(height: 1, color: colorScheme.outlineVariant.withOpacity(0.5)),
            itemBuilder: (ctx, i) {
              final comment = _comments[i];

              return ListTile(
                leading: _buildAvatar(comment.avatarId, comment.nickname, colorScheme),
                title: Text(
                  comment.nickname,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface, // 适配昵称颜色
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    comment.content,
                    style: TextStyle(color: colorScheme.onSurfaceVariant), // 适配内容颜色
                  ),
                ),
                trailing: Text(
                  _formatTimeSafe(comment.createdAt),
                  style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                ),
              );
            },
          ),

        const SizedBox(height: 16),

        // 2. 输入框区域
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: TextStyle(color: colorScheme.onSurface), // 输入文字颜色
                  decoration: InputDecoration(
                    hintText: "写下你的想法...",
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    border: const OutlineInputBorder(),
                    // 关键修复：添加填充色，确保输入框在深色背景下可见
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _isPosting
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : IconButton(
                icon: const Icon(Icons.send),
                // 关键修复：使用 Primary 色作为发送按钮颜色
                color: colorScheme.primary,
                onPressed: _postComment,
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  // 修复头像显示的方法
  Widget _buildAvatar(String avatarId, String username, ColorScheme colorScheme) {
    // 1. 默认头像
    if (avatarId == 'default' || avatarId.isEmpty) {
      return CircleAvatar(
        // 使用 Primary Container 颜色，保证对比度
        backgroundColor: colorScheme.primaryContainer,
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '?',
          // 使用 On Primary Container 颜色，保证文字清晰
          style: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
        ),
      );
    }

    // 2. 图片头像
    return CircleAvatar(
      // 给图片头像也加一个底色，防止透明图片在黑底上看不清
      backgroundColor: colorScheme.surfaceContainerHighest,
      radius: 20,
      child: Transform.scale(
          scale: 2.4, // 调整缩放比例，2.5可能太大了
        child: Image.asset(
          'assets/images/$avatarId.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // 如果图片加载失败，回退到默认图标
            return Icon(Icons.person, color: colorScheme.onSurfaceVariant);
          },
        ),
      ),
    );
  }

  String _formatTimeSafe(String? isoString) {
    if (isoString == null || isoString.isEmpty) {
      return "刚刚";
    }
    try {
      final DateTime dt = DateTime.parse(isoString).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (e) {
      return isoString.length > 16
          ? isoString.substring(0, 16).replaceFirst('T', ' ')
          : isoString;
    }
  }
}