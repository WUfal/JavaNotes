import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';

// 代码高亮
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

import '../../models/practice_record.dart';
import 'package:flutter/services.dart';
class PracticeHistoryDetailPage extends StatelessWidget {
  final PracticeRecord record;

  const PracticeHistoryDetailPage({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 6分及格
    final bool isPass = record.score >= 6;
    final Color scoreColor = isPass ? Colors.green : Colors.orange;

    // 格式化时间
    final dateStr = DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(record.createdAt));

    // 背景色
    final bgColor = isDark
        ? theme.colorScheme.background
        : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("练习详情", style: TextStyle(fontWeight: FontWeight.w600)),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 头部：分数与时间
            const SizedBox(height: 10),
            _buildScoreHeader(context, scoreColor, record.score, dateStr, isDark),
            const SizedBox(height: 30),

            // 2. 题目卡片
            _buildContentCard(
              context: context,
              title: "题目描述",
              icon: Icons.description_outlined,
              iconColor: theme.colorScheme.primary,
              // 将标题加粗显示在描述前
              content: "### ${record.title}\n\n${record.description}",
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            // 3. (选择题) 选项展示
            if (record.type == 'CHOICE' && record.options != null) ...[
              _buildChoiceOptionsCard(context, isDark),
              const SizedBox(height: 16),
            ],

            // 4. 我的回答
            _buildUserAnswerCard(context, isDark),
            const SizedBox(height: 16),

            // 5. AI 点评
            _buildContentCard(
              context: context,
              title: "AI 点评",
              icon: Icons.smart_toy_outlined,
              iconColor: scoreColor,
              content: record.comment,
              isDark: isDark,
            ),
            const SizedBox(height: 16),

            // 6. 改进建议
            if (record.improvement != null && record.improvement!.isNotEmpty) ...[
              _buildContentCard(
                context: context,
                title: "改进建议",
                icon: Icons.lightbulb_outline,
                iconColor: Colors.amber.shade700,
                content: record.improvement!,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
            ],

            // 7. 参考答案
            if (record.referenceAnswer != null && record.referenceAnswer!.isNotEmpty)
              _buildReferenceAnswerCard(context, isDark),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI 组件封装 ---

  // 1. 头部：分数与时间
  Widget _buildScoreHeader(BuildContext context, Color color, int score, String time, bool isDark) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 10.0,
          percent: (score / 10.0).clamp(0.0, 1.0),
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "$score",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: color,
                    height: 1.0,
                  )
              ),
              Text(
                  "分",
                  style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54
                  )
              ),
            ],
          ),
          progressColor: color,
          backgroundColor: color.withOpacity(0.15),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1000,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, size: 14, color: Theme.of(context).colorScheme.outline),
              const SizedBox(width: 6),
              Text(
                time,
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. 通用内容卡片
  Widget _buildContentCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required String content,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    // 背景色微调
    final cardColor = isDark ? theme.colorScheme.surface : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.grey.withOpacity(0.1);

    // 处理换行符转义问题
    final processedContent = content.replaceAll(r'\\n', '\n');

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
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 0.5),
            ),
            MarkdownBody(
              data: processedContent,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyMedium?.copyWith(height: 1.6, fontSize: 15),
                listBullet: TextStyle(color: iconColor),
                // 简单的代码块样式
                code: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: isDark ? const Color(0xFFE6E6E6) : const Color(0xFF24292E),
                  backgroundColor: isDark ? const Color(0xFF282C34) : const Color(0xFFF4F5F7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. 用户回答卡片 (特殊处理代码和思路)
  Widget _buildUserAnswerCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final isCodeType = record.type == 'CODE';

    return Card(
      elevation: 0,
      color: isDark ? theme.colorScheme.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.1)),
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
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline, color: Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                const Text("我的回答", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 0.5),
            ),

            // 答案主体
            if (isCodeType)
              _buildCodeBlock(context, record.userAnswer, isDark)
            else
              Text(
                  record.userAnswer,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6, fontSize: 15)
              ),

            // 解题思路
            if (record.userThought != null && record.userThought!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("💡 我的思路", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Text(
                        record.userThought!,
                        style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant)
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 4. 选择题选项卡片
  Widget _buildChoiceOptionsCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: isDark ? theme.colorScheme.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: record.options!.map((opt) {
            String key = opt.split('.').first.trim();
            bool isSelected = key == record.userAnswer;
            bool isCorrect = key == (record.referenceAnswer ?? "").trim();

            Color? bgColor;
            Color? borderColor;
            IconData? icon;
            Color? iconColor;

            if (isSelected) {
              if (isCorrect) {
                // 选对：绿色
                bgColor = Colors.green.withOpacity(0.1);
                borderColor = Colors.green;
                icon = Icons.check_circle;
                iconColor = Colors.green;
              } else {
                // 选错：红色
                bgColor = Colors.red.withOpacity(0.1);
                borderColor = Colors.red;
                icon = Icons.cancel;
                iconColor = Colors.red;
              }
            } else if (isCorrect) {
              // 没选但这是正确答案：淡绿色提示
              bgColor = Colors.green.withOpacity(0.05);
              borderColor = Colors.green.withOpacity(0.3);
              icon = Icons.check_circle_outline;
              iconColor = Colors.green.withOpacity(0.6);
            } else {
              // 普通选项
              borderColor = theme.colorScheme.outline.withOpacity(0.1);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor ?? (isDark ? Colors.transparent : Colors.grey.withOpacity(0.02)),
                border: Border.all(color: borderColor ?? Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: iconColor, size: 20),
                    const SizedBox(width: 10),
                  ] else
                    const SizedBox(width: 30), // 占位保持对齐

                  Expanded(
                      child: Text(
                          opt,
                          style: TextStyle(
                            fontWeight: isSelected || isCorrect ? FontWeight.bold : FontWeight.normal,
                            color: isSelected || isCorrect ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.7),
                          )
                      )
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 5. 参考答案卡片 (适配日间/夜间代码块)
  Widget _buildReferenceAnswerCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    String content = record.referenceAnswer!;
    const accentColor = Colors.deepPurple;

    content = content.replaceAll(r'\\n', '\n');

    if (record.type == 'CODE' && !content.contains('```')) {
      content = "```java\n$content\n```";
    }

    // 动态设置代码块样式
    final codeBlockColor = isDark ? const Color(0xFF282C34) : const Color(0xFFF6F8FA);
    final codeTextColor = isDark ? const Color(0xFFE6E6E6) : const Color(0xFF24292E);
    final borderColor = isDark ? Colors.white10 : Colors.grey.withOpacity(0.15);

    return Card(
      elevation: 0,
      color: isDark ? theme.colorScheme.surface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.withOpacity(0.1)),
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
                    color: accentColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.menu_book_rounded, color: accentColor, size: 20),
                ),
                const SizedBox(width: 12),
                const Text("参考答案", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 0.5),
            ),
            MarkdownBody(
              data: content,
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyMedium?.copyWith(height: 1.6, fontSize: 15),
                // 自适应代码块
                code: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: codeTextColor,
                  backgroundColor: Colors.transparent,
                ),
                codeblockDecoration: BoxDecoration(
                  color: codeBlockColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 辅助：代码块高亮渲染 (自适应)
  Widget _buildCodeBlock(BuildContext context, String code, bool isDark) {
    // 动态配色
    final bgColor = isDark ? const Color(0xFF282C34) : const Color(0xFFF6F8FA);
    final borderColor = isDark ? Colors.white10 : Colors.grey.withOpacity(0.15);
    final highlightTheme = isDark ? monokaiSublimeTheme : githubTheme;
    final textColor = isDark ? const Color(0xFFE6E6E6) : const Color(0xFF24292E);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: HighlightView(
        code,
        language: 'java',
        theme: highlightTheme,
        textStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: textColor,
        ),
      ),
    );
  }
}