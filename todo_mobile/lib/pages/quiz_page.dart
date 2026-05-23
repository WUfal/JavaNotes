import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import 'quiz_result_page.dart';
import 'package:flutter/services.dart';
class QuizPage extends StatefulWidget {
  final QuizChapterSummary chapter;
  const QuizPage({Key? key, required this.chapter}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Future<List<QuizQuestionDto>>? _questionsFuture;
  late ApiService _apiService;

  final PageController _pageController = PageController();

  // (Key: questionId, Value: selectedOptionId)
  final Map<int, int> _selectedAnswers = {};

  bool _isSubmitting = false;
  int _currentIndex = 0; // 当前页码索引

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);

    if (_questionsFuture == null) {
      final String? token = Provider.of<AuthService>(context, listen: false).token;
      _questionsFuture = _apiService.fetchQuizQuestions(token, widget.chapter.id);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 退出确认
  Future<bool> _onWillPop() async {
    // 如果正在提交，禁止退出
    if (_isSubmitting) return false;

    // 如果还没做完，弹窗提示
    if (_selectedAnswers.isNotEmpty) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("退出测验？"),
          content: const Text("当前进度未保存，确定要放弃本次测验吗？"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("继续答题"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("退出", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ?? false;
    }
    return true;
  }

  Future<void> _submit(List<QuizQuestionDto> questions) async {
    if (_selectedAnswers.length != questions.length) {
      _showErrorDialog("请先完成所有题目再提交。");
      return;
    }

    setState(() { _isSubmitting = true; });
    try {
      final String? token = Provider.of<AuthService>(context, listen: false).token;
      final result = await _apiService.submitQuiz(token, widget.chapter.id, _selectedAnswers);

      if (mounted) {
        // --- ⬇️ (关键修改) 传递 userAnswers ⬇️ ---
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResultPage(
              result: result,
              questions: questions,
              userAnswers: _selectedAnswers, // 传入用户的答案
            ),
          ),
        );
        // --- ⬆️ (修改结束) ⬆️ ---
      }
    } catch (e) {
      if (mounted) _showErrorDialog("提交失败: $e");
    } finally {
      if (mounted) { setState(() { _isSubmitting = false; }); }
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 背景色
    final bgColor = isDark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
        : const Color(0xFFF8F9FC);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(widget.chapter.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
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
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: FutureBuilder<List<QuizQuestionDto>>(
          future: _questionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text("加载失败: ${snapshot.error}", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("本章节暂无题目"));
            }

            final questions = snapshot.data!;
            final int totalQuestions = questions.length;
            final int answeredQuestions = _selectedAnswers.length;
            final bool allAnswered = totalQuestions == answeredQuestions;

            // 计算进度
            final double progress = totalQuestions > 0 ? answeredQuestions / totalQuestions : 0;

            return Column(
              children: [
                // 1. 顶部进度条
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.outline.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  minHeight: 4,
                ),

                // 2. 题目内容区
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: questions.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return _buildQuestionCard(
                          questions[index],
                          index + 1,
                          totalQuestions,
                          theme,
                          isDark
                      );
                    },
                  ),
                ),

                // 3. 底部提交栏
                _buildBottomBar(context, allAnswered, answeredQuestions, totalQuestions, () => _submit(questions)),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- UI 组件封装 ---

  Widget _buildQuestionCard(
      QuizQuestionDto question,
      int number,
      int total,
      ThemeData theme,
      bool isDark
      ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 80), // 底部留白给按钮
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 题号标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Question $number / $total",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 题干
          Text(
            question.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // 选项列表
          ...question.options.map((option) {
            final isSelected = _selectedAnswers[question.id] == option.id;
            return _buildOptionItem(
                option,
                isSelected,
                theme,
                isDark,
                    () {
                  setState(() {
                    _selectedAnswers[question.id] = option.id;
                  });
                }
            );
          }).toList(),
        ],
      ),
    );
  }

  // 单个选项卡片
  Widget _buildOptionItem(
      QuizOptionDto option,
      bool isSelected,
      ThemeData theme,
      bool isDark,
      VoidCallback onTap
      ) {
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : (isDark ? Colors.white24 : Colors.grey.withOpacity(0.3));

    final bgColor = isSelected
        ? theme.colorScheme.primary.withOpacity(0.1)
        : (isDark ? theme.colorScheme.surface : Colors.white);

    final textColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
            boxShadow: isSelected || isDark ? [] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              // 选项前面的圆圈/对勾
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),

              // 选项文字
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 底部提交栏
  Widget _buildBottomBar(
      BuildContext context,
      bool allAnswered,
      int answeredCount,
      int totalCount,
      VoidCallback onSubmit
      ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
        child: _isSubmitting
            ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
            : FilledButton(
          onPressed: (allAnswered && !_isSubmitting) ? onSubmit : null,
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: allAnswered ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
            foregroundColor: allAnswered ? Colors.white : theme.colorScheme.onSurfaceVariant,
            elevation: allAnswered ? 2 : 0,
          ),
          child: Text(
            allAnswered ? '提交试卷' : '请完成所有题目 ($answeredCount / $totalCount)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}