import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../models/quiz.dart';
import 'package:flutter/services.dart';
class QuizResultPage extends StatelessWidget {
  final QuizResultResponse result;
  final List<QuizQuestionDto> questions;
  final Map<int, int> userAnswers; // (新增) 接收用户的答案

  const QuizResultPage({
    Key? key,
    required this.result,
    required this.questions,
    required this.userAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 计算及格状态 (60分及格)
    final bool isPass = result.score >= 60;
    final Color statusColor = isPass ? Colors.green : Colors.orange;

    final bgColor = isDark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
        : const Color(0xFFF8F9FC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('测验结果', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // 禁用返回，强制点底部按钮
        // ⬇️⬇️⬇️ 关键修改在这里 ⬇️⬇️⬇️
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 成绩头部卡片
            _buildScoreHeader(context, statusColor, isPass),
            const SizedBox(height: 24),

            // 2. 统计概览
            Row(
              children: [
                Expanded(child: _buildStatCard(context, "答对", "${result.correctAnswers}", Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, "总题数", "${result.totalQuestions}", Colors.blue)),
              ],
            ),

            const SizedBox(height: 32),
            const Text(
              "题目解析",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 3. 题目列表
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return _buildQuestionReviewCard(context, index + 1, question, isDark);
            }).toList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
      // 底部悬浮按钮
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("完成测验", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // --- 组件封装 ---

  // 成绩头部
  Widget _buildScoreHeader(BuildContext context, Color color, bool isPass) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 12.0,
            percent: (result.score / 100.0).clamp(0.0, 1.0),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${result.score.toInt()}",
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0),
                ),
                const Text("分", style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
            progressColor: Colors.white,
            backgroundColor: Colors.white24,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
          ),
          const SizedBox(height: 16),
          Text(
            isPass ? "🎉 恭喜通过测验！" : "💪 再接再厉，继续加油！",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 统计小卡片
  Widget _buildStatCard(BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  // 题目解析卡片
  Widget _buildQuestionReviewCard(BuildContext context, int index, QuizQuestionDto question, bool isDark) {
    final theme = Theme.of(context);

    // 获取正确答案ID
    final int? correctOptionId = result.correctAnswersMap[question.id.toString()];
    // 获取用户选择的ID
    final int? userSelectedId = userAnswers[question.id];

    final bool isCorrect = userSelectedId == correctOptionId;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
            width: 1.5
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 状态图标
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "$index. ${question.text}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 选项列表
          ...question.options.map((option) {
            final bool isOptionCorrect = option.id == correctOptionId;
            final bool isOptionSelected = option.id == userSelectedId;

            Color? bgColor;
            Color? textColor;
            IconData? icon;

            if (isOptionCorrect) {
              bgColor = Colors.green.withOpacity(0.1);
              textColor = Colors.green[700];
              icon = Icons.check;
            } else if (isOptionSelected && !isCorrect) {
              bgColor = Colors.red.withOpacity(0.1);
              textColor = Colors.red[700];
              icon = Icons.close;
            } else {
              textColor = theme.colorScheme.onSurface.withOpacity(0.7);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: bgColor ?? (isDark ? Colors.white10 : Colors.grey[100]),
                borderRadius: BorderRadius.circular(8),
                border: isOptionSelected || isOptionCorrect
                    ? Border.all(color: isOptionCorrect ? Colors.green : Colors.red, width: 1)
                    : null,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: textColor),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      option.text,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: isOptionCorrect || isOptionSelected ? FontWeight.bold : FontWeight.normal
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}