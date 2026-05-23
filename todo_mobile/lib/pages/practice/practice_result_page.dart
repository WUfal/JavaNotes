import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../models/grading_result.dart';
import '../../models/practice_question.dart';
import '../../models/practice_record.dart';
import '../../providers/practice_history_provider.dart';

class PracticeResultPage extends StatefulWidget {
  final GradingResult result;
  final PracticeQuestion question;
  final String userAnswer;
  final String? userThought;

  const PracticeResultPage({
    Key? key,
    required this.result,
    required this.question,
    required this.userAnswer,
    this.userThought,
  }) : super(key: key);

  @override
  State<PracticeResultPage> createState() => _PracticeResultPageState();
}

class _PracticeResultPageState extends State<PracticeResultPage> {
  bool _isSaved = false;

  // 保存逻辑
  Future<void> _saveToHistory() async {
    if (_isSaved) return;

    try {
      final record = PracticeRecord(
        title: widget.question.title,
        description: widget.question.description,
        type: widget.question.type,
        options: widget.question.options,
        explanation: widget.question.explanation,
        userAnswer: widget.userAnswer,
        userThought: widget.userThought,
        score: widget.result.score,
        comment: widget.result.comment,
        improvement: widget.result.improvement,
        referenceAnswer: widget.result.referenceAnswer,
        createdAt: DateTime.now().toIso8601String(),
      );

      await Provider.of<PracticeHistoryProvider>(context, listen: false).addRecord(record);

      if (mounted) {
        setState(() => _isSaved = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ 已保存到刷题统计"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("保存失败: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 6分及格
    final bool isPass = widget.result.score >= 6;

    // 评分主色调
    final Color scoreColor = isPass ? Colors.green : Colors.orange;

    // 页面背景色
    final bgColor = isDark
        ? theme.colorScheme.background
        : const Color(0xFFF5F7FA); // 柔和的浅灰背景

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("评测报告", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. 简洁的分数展示 (无背景)
                  const SizedBox(height: 10),
                  _buildSimpleScore(context, scoreColor, isDark),
                  const SizedBox(height: 30),

                  // 2. AI 点评卡片 (跟随评分颜色)
                  _buildContentCard(
                    context: context,
                    title: "AI 点评",
                    icon: Icons.smart_toy_outlined,
                    iconColor: scoreColor, // 绿色或橙色
                    content: widget.result.comment,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 16),

                  // 3. 改进建议 (固定琥珀色，提示注意)
                  if (widget.result.improvement.isNotEmpty)
                    _buildContentCard(
                      context: context,
                      title: "改进建议",
                      icon: Icons.lightbulb_outline,
                      iconColor: Colors.amber.shade700, // 琥珀色
                      content: widget.result.improvement,
                      isDark: isDark,
                    ),

                  const SizedBox(height: 16),

                  // 4. 参考答案 (固定紫色，代表代码/知识)
                  if (widget.result.referenceAnswer.isNotEmpty)
                    _buildReferenceAnswerCard(context, isDark),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // 5. 底部保存栏
          _buildBottomAction(context, isDark, scoreColor),
        ],
      ),
    );
  }

  // --- UI 组件封装 ---

  // 1. 极简风格的分数展示
  Widget _buildSimpleScore(BuildContext context, Color color, bool isDark) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 70.0,
          lineWidth: 12.0,
          percent: (widget.result.score / 10.0).clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.result.score}",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.0,
                ),
              ),
              Text(
                "分",
                style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.black54
                ),
              ),
            ],
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.15),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1200,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.result.score >= 8 ? "🌟 表现优异"
                : widget.result.score >= 6 ? "✅ 通过考核"
                : "💪 继续加油",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // 2. 通用内容卡片 (增加背景色区分度)
  Widget _buildContentCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    // 修复：处理可能存在的转义换行符 (JSON返回 \\n 导致 Markdown 不换行)
    final String processedContent = content.replaceAll(r'\\n', '\n');

    // 日间模式下使用极淡的主题色背景，夜间模式保持深色
    final cardColor = isDark ? theme.colorScheme.surface : iconColor.withOpacity(0.05);
    // 边框颜色
    final borderColor = isDark ? iconColor.withOpacity(0.3) : iconColor.withOpacity(0.15);

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 增加图标背景容器
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? iconColor.withOpacity(0.1) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 0.5, color: iconColor.withOpacity(0.2)),
            ),
            MarkdownBody(
              data: processedContent,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    fontSize: 15,
                    color: isDark ? Colors.white70 : Colors.black87
                ),
                listBullet: TextStyle(color: iconColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. 参考答案卡片 (紫色主题)
  Widget _buildReferenceAnswerCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    String content = widget.result.referenceAnswer;
    const accentColor = Colors.deepPurple; // 答案专属色：紫色

    // --- 修复：处理转义换行符 (关键) ---
    // 防止 API 返回的 "\\n" 导致所有代码/文本挤在一行
    content = content.replaceAll(r'\\n', '\n');

    // 智能补全代码块标记
    if (widget.question.type == 'CODE' && !content.contains('```')) {
      content = "```java\n$content\n```";
    }

    // 动态设置代码块颜色
    final codeBlockColor = isDark ? const Color(0xFF282C34) : const Color(0xFFF4F5F7);
    final codeTextColor = isDark ? const Color(0xFFE6E6E6) : const Color(0xFF24292E);

    // 卡片背景与边框
    final cardColor = isDark ? theme.colorScheme.surface : accentColor.withOpacity(0.04);
    final borderColor = isDark ? accentColor.withOpacity(0.3) : accentColor.withOpacity(0.15);

    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? accentColor.withOpacity(0.1) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.menu_book_rounded, color: accentColor, size: 22),
                ),
                const SizedBox(width: 12),
                const Text("参考答案", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 0.5, color: accentColor.withOpacity(0.2)),
            ),
            MarkdownBody(
              data: content,
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyMedium?.copyWith(height: 1.6, fontSize: 15),
                // 代码块样式适配日间/夜间模式
                code: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: codeTextColor,
                  backgroundColor: Colors.transparent,
                ),
                codeblockDecoration: BoxDecoration(
                  color: codeBlockColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. 底部悬浮按钮
  Widget _buildBottomAction(BuildContext context, bool isDark, Color mainColor) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton.icon(
          onPressed: _isSaved ? null : _saveToHistory,
          style: FilledButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: _isSaved ? theme.colorScheme.surfaceVariant : mainColor,
            foregroundColor: _isSaved ? theme.colorScheme.onSurfaceVariant : Colors.white,
          ),
          icon: Icon(_isSaved ? Icons.check_circle_rounded : Icons.bookmark_border_rounded),
          label: Text(
            _isSaved ? "已保存到历史" : "保存到刷题统计",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}