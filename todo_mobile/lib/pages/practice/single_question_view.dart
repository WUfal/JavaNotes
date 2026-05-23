import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

// (代码编辑器相关)
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/java.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import '../../providers/settings_provider.dart';
import '../../models/practice_question.dart';
import '../../models/grading_result.dart';
import '../../services/api_service.dart';
import '../../providers/auth_service.dart';
import 'practice_result_page.dart';
import 'full_code_editor_page.dart';
import '../../models/practice_record.dart';
import '../../providers/practice_history_provider.dart';

class SingleQuestionView extends StatefulWidget {
  final PracticeQuestion question;

  const SingleQuestionView({Key? key, required this.question}) : super(key: key);

  @override
  State<SingleQuestionView> createState() => _SingleQuestionViewState();
}

class _SingleQuestionViewState extends State<SingleQuestionView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // --- 状态 ---
  String? _selectedOption;
  bool _showResult = false;

  late CodeController _codeController;
  final TextEditingController _thoughtController = TextEditingController();
  final TextEditingController _qaController = TextEditingController();

  bool _isSubmitting = false;

  // 缓存上次评测结果
  GradingResult? _cachedResult;
  String? _cachedAnswerUsed;

  String get _questionType => widget.question.type.toUpperCase().trim();

  @override
  void initState() {
    super.initState();
    if (_questionType == 'CODE') {
      _codeController = CodeController(
        text: widget.question.codeStub ?? "public class Solution {\n    // 在这里编写代码\n}",
        language: java,
      );
    } else {
      _codeController = CodeController();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _thoughtController.dispose();
    _qaController.dispose();
    super.dispose();
  }

  // 跳转全屏编辑器
  Future<void> _openFullScreenEditor() async {
    final newCode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullCodeEditorPage(
          initialCode: _codeController.text,
        ),
      ),
    );

    if (newCode != null && newCode is String) {
      setState(() {
        _codeController.text = newCode;
      });
    }
  }

  // 保存选择题到本地数据库
  Future<void> _saveChoiceRecord() async {
    final bool isCorrect = _selectedOption == widget.question.correctAnswer?.toUpperCase().trim();
    final int score = isCorrect ? 10 : 0;

    final record = PracticeRecord(
      title: widget.question.title,
      description: widget.question.description,
      type: 'CHOICE',
      options: widget.question.options,
      explanation: widget.question.explanation,
      userAnswer: _selectedOption ?? "未选",
      score: score,
      comment: isCorrect ? "回答正确" : "回答错误",
      referenceAnswer: widget.question.correctAnswer,
      createdAt: DateTime.now().toIso8601String(),
    );

    await Provider.of<PracticeHistoryProvider>(context, listen: false).addRecord(record);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ 已保存到刷题统计"), behavior: SnackBarBehavior.floating),
      );
    }
  }

  // 跳转结果页
  void _navigateToResult(GradingResult result, String answer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PracticeResultPage(
          result: result,
          question: widget.question,
          userAnswer: answer,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_questionType == 'CHOICE') {
      if (_selectedOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("请先选择一个选项")));
        return;
      }
      setState(() {
        _showResult = true;
      });
    } else {
      // 编程/简答
      String answer = _questionType == 'CODE' ? _codeController.text : _qaController.text;
      String? thoughts = _questionType == 'CODE' ? _thoughtController.text : null;

      if (answer.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("请先输入答案")));
        return;
      }

      setState(() => _isSubmitting = true);

      try {
        final apiService = Provider.of<ApiService>(context, listen: false);
        final token = Provider.of<AuthService>(context, listen: false).token;

        final result = await apiService.submitForGrading(
          token,
          widget.question.title,
          widget.question.description,
          answer,
          thoughts,
        );

        if (!mounted) return;

        setState(() {
          _cachedResult = result;
          _cachedAnswerUsed = answer;
        });

        _navigateToResult(result, answer);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("提交失败: $e")));
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 题头区域 (类型 + 标题)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTypeBadge(theme, _questionType),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.question.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 2. 题目描述区域 (卡片化)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_outlined, size: 16, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text("题目描述", style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      MarkdownBody(
                        data: widget.question.description,
                        styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                          p: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                          code: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            backgroundColor: theme.colorScheme.surfaceVariant,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 分割线
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "答题区域",
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.outline),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. 交互区域
                if (_questionType == 'CHOICE')
                  _buildChoiceArea(theme)
                else if (_questionType == 'CODE')
                  _buildCodeArea(theme, isDark)
                else if (_questionType == 'QA')
                    _buildQAArea(theme)
                  else
                    _buildErrorArea(),

                const SizedBox(height: 80), // 底部留白，防遮挡
              ],
            ),
          ),
        ),

        // 4. 底部提交栏
        _buildBottomBar(theme, isDark),
      ],
    );
  }

  // --- UI 组件封装 ---

  // 题型标签
  Widget _buildTypeBadge(ThemeData theme, String type) {
    Color color;
    String label;
    IconData icon;

    switch (type) {
      case 'CHOICE':
        color = Colors.purple;
        label = "选择题";
        icon = Icons.check_circle_outline;
        break;
      case 'CODE':
        color = Colors.blue;
        label = "编程题";
        icon = Icons.code;
        break;
      case 'QA':
        color = Colors.orange;
        label = "简答题";
        icon = Icons.short_text;
        break;
      default:
        color = Colors.grey;
        label = type;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)
          ),
        ],
      ),
    );
  }

  // 错误提示
  Widget _buildErrorArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "未知题型: [${widget.question.type}]\n请联系管理员或重试。",
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // 选择题区域 (优化版)
  Widget _buildChoiceArea(ThemeData theme) {
    final options = widget.question.options ?? [];
    if (options.isEmpty) return const SizedBox();

    List<Widget> children = [];
    for (int i = 0; i < options.length; i++) {
      String optText = options[i];
      // 处理 "A. xxx" 这种格式，提取纯文本
      String key = String.fromCharCode(65 + i);
      if (optText.startsWith("$key.") || optText.startsWith("$key)") || optText.startsWith("$key ")) {
        optText = optText.substring(2).trim();
      }

      bool isSelected = _selectedOption == key;

      // 结果展示逻辑
      Color? borderColor;
      Color? bgColor;
      IconData? statusIcon;

      if (_showResult) {
        String correct = (widget.question.correctAnswer ?? "").toUpperCase().trim();
        if (key == correct) {
          // 正确答案
          borderColor = Colors.green;
          bgColor = Colors.green.withOpacity(0.1);
          statusIcon = Icons.check_circle;
        } else if (isSelected && key != correct) {
          // 选错了
          borderColor = Colors.red;
          bgColor = Colors.red.withOpacity(0.1);
          statusIcon = Icons.cancel;
        } else {
          // 其他未选项
          borderColor = theme.colorScheme.outline.withOpacity(0.1);
        }
      } else {
        // 答题中逻辑
        if (isSelected) {
          borderColor = theme.colorScheme.primary;
          bgColor = theme.colorScheme.primary.withOpacity(0.05);
        } else {
          borderColor = theme.colorScheme.outline.withOpacity(0.2);
        }
      }

      children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: _showResult ? null : () => setState(() => _selectedOption = key),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor ?? theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: borderColor ?? Colors.transparent,
                      width: isSelected || (_showResult && borderColor != null) ? 2 : 1
                  ),
                ),
                child: Row(
                  children: [
                    // 选项标号 (A, B, C...)
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        key,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 选项文字
                    Expanded(
                      child: Text(
                        optText,
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal
                        ),
                      ),
                    ),

                    // 结果图标
                    if (_showResult && statusIcon != null)
                      Icon(statusIcon, color: borderColor),
                  ],
                ),
              ),
            ),
          )
      );
    }

    if (_showResult) {
      children.add(_buildAnalysisCard(theme));
    }

    return Column(children: children);
  }

  // 答案解析卡片
  Widget _buildAnalysisCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: theme.colorScheme.tertiary),
              const SizedBox(width: 8),
              Text(
                  "答案解析",
                  style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.tertiary, fontSize: 16)
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.question.explanation ?? "暂无详细解析", style: theme.textTheme.bodyMedium),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.tertiary),
                foregroundColor: theme.colorScheme.tertiary,
              ),
              icon: const Icon(Icons.save_alt, size: 18),
              label: const Text("保存并加入错题本"),
              onPressed: _saveChoiceRecord,
            ),
          ),
        ],
      ),
    );
  }

  // 编程题区域 (IDE 风格)
  Widget _buildCodeArea(ThemeData theme, bool isDark) {
    final settings = Provider.of<SettingsProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("代码实现", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            TextButton.icon(
              icon: const Icon(Icons.fullscreen, size: 20),
              label: const Text("全屏专注模式"),
              onPressed: _openFullScreenEditor,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 模拟 IDE 窗口
        GestureDetector(
          onTap: _openFullScreenEditor,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              children: [
                // 顶部状态栏 (Mac 风格)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFEEEEEE),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1))),
                  ),
                  child: Row(
                    children: [
                      _macDot(Colors.red),
                      const SizedBox(width: 6),
                      _macDot(Colors.amber),
                      const SizedBox(width: 6),
                      _macDot(Colors.green),
                      const Spacer(),
                      const Icon(Icons.code, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text("Solution.java", style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'monospace')),
                      const Spacer(),
                    ],
                  ),
                ),
                // 代码区
                SizedBox(
                  height: 320,
                  child: AbsorbPointer(
                    child: CodeTheme(
                      data: CodeThemeData(styles: isDark ? monokaiSublimeTheme : githubTheme),
                      child: CodeField(
                        controller: _codeController,
                        textStyle: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: settings.editorFontSize,
                        ),
                        lineNumbers: settings.showLineNumbers,
                        expands: true,
                        wrap: false,
                        background: Colors.transparent, // 使用容器背景
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        Text("解题思路 (可选)", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _thoughtController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "简单记录你的算法复杂度分析或解题关键点...",
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _macDot(Color color) {
    return Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }

  // 简答题区域
  Widget _buildQAArea(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("你的回答", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _qaController,
          maxLines: 10,
          style: const TextStyle(height: 1.5),
          decoration: InputDecoration(
            hintText: "请在此处详细阐述你的观点...",
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ],
    );
  }

  // 底部栏
  Widget _buildBottomBar(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 预览上次结果按钮
          if (_cachedResult != null && _questionType != 'CHOICE')
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.history_edu),
                  label: const Text("查看上次 AI 评测报告"),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  onPressed: () {
                    _navigateToResult(_cachedResult!, _cachedAnswerUsed ?? "");
                  },
                ),
              ),
            ),

          // 提交按钮
          SizedBox(
            width: double.infinity,
            height: 54,
            child: _isSubmitting
                ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
                : FilledButton.icon(
              onPressed: (_showResult && _questionType == 'CHOICE') ? null : _submit,
              icon: Icon(_questionType == 'CHOICE' ? Icons.check_circle : Icons.cloud_upload),
              label: Text(
                _questionType == 'CHOICE' ? "确认答案" : "提交 AI 评测",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}