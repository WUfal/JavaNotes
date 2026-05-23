import 'package:flutter/material.dart';
import '../../models/practice_question.dart';
import 'single_question_view.dart';

class DailyQuestionPage extends StatefulWidget {
  final List<PracticeQuestion> questions;

  const DailyQuestionPage({Key? key, required this.questions}) : super(key: key);

  @override
  State<DailyQuestionPage> createState() => _DailyQuestionPageState();
}

class _DailyQuestionPageState extends State<DailyQuestionPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 退出确认
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("退出练习？"),
        content: const Text("当前进度未保存，确定要退出吗？"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("继续做题")),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("退出", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = widget.questions.length;

    // 计算进度 (防止除以0)
    final double progress = total > 0 ? (_currentIndex + 1) / total : 0;

    // 统一背景色
    final bgColor = isDark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
        : const Color(0xFFF8F9FC);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor, // 与背景融为一体
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            tooltip: "结束练习",
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            "每日一练",
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
          centerTitle: true,
          actions: [
            // 页码指示器
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${_currentIndex + 1} / $total",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
          // 底部进度条
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.outline.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              minHeight: 4,
            ),
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          physics: const BouncingScrollPhysics(), // 更有质感的滑动回弹
          itemCount: widget.questions.length,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          itemBuilder: (context, index) {
            return SingleQuestionView(question: widget.questions[index]);
          },
        ),
      ),
    );
  }
}