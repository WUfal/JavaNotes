import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:code_text_field/code_text_field.dart';
// 注意：使用 package:highlight
import 'package:highlight/languages/java.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/github.dart';

import '../models/beginner_logic_problem.dart';
import '../models/course_module.dart';
import '../providers/auth_service.dart';
import '../providers/chat_provider.dart';
import '../services/api_service.dart';
import '../widgets/code_block_widget.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';
import 'ai_chat_page.dart';
import '../../providers/settings_provider.dart'; // <--- 确保导入
import '../utils/java_keywords.dart';
import '../utils/undo_history.dart';

class LogicProblemDetailPage extends StatefulWidget {
  final BeginnerLogicProblemSummary problemSummary;

  const LogicProblemDetailPage({Key? key, required this.problemSummary})
      : super(key: key);

  @override
  State<LogicProblemDetailPage> createState() => _LogicProblemDetailPageState();
}

class _LogicProblemDetailPageState extends State<LogicProblemDetailPage> {
  Future<BeginnerLogicProblemDetail>? _problemDetailFuture;
  late ApiService _apiService;

  CodeController? _codeController;
  String? _token;

  bool _isRunLoading = false;
  String _output = "";
  String _error = "";

  List<String> _suggestions = [];
  final SimpleUndoHistory _undoHistory = SimpleUndoHistory();

  final List<String> _quickSymbols = ['(', ')', ';', '.', '=', '"', '+', '-', '*', '/', '[', ']'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;

    if (_problemDetailFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _codeController = null;
      _problemDetailFuture = _apiService.fetchLogicProblemDetail(_token, widget.problemSummary.id);

      _problemDetailFuture!.then((detail) {
        setState(() {
          _codeController = CodeController(
            text: detail.codeStub,
            language: java,
          );
          _undoHistory.record(detail.codeStub, force: true);
          _codeController!.addListener(_onCodeChanged);
        });
      }).catchError((_) {});
    });
  }

  void _retry() {
    _loadData();
  }

  // --- 核心逻辑：监听输入 ---
  void _onCodeChanged() {
    if (_codeController == null) return;

    final text = _codeController!.text;
    final selection = _codeController!.selection;

    _undoHistory.record(text);

    if (!selection.isCollapsed) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }

    // 获取光标前的文本
    String textBeforeCursor = text.substring(0, selection.baseOffset);

    // --- ⬇️ (新功能) 检测是否刚输入了 "." ⬇️ ---
    if (textBeforeCursor.trim().endsWith('.')) {
      // 如果刚输入了点，直接显示常用方法列表
      if (mounted) {
        setState(() {
          _suggestions = JavaKeywords.methods;
        });
      }
      return;
    }
    // --- ⬆️ (结束) ⬆️ ---

    // 原有的单词匹配逻辑
    RegExp wordRegex = RegExp(r'[a-zA-Z0-9_]+$');
    Match? match = wordRegex.firstMatch(textBeforeCursor);

    if (match != null) {
      String prefix = match.group(0)!;

      // 混合搜索：搜索关键字 + 搜索常用方法
      List<String> allCandidates = [...JavaKeywords.all, ...JavaKeywords.methods];

      List<String> matches = allCandidates
          .where((kw) => kw.toLowerCase().startsWith(prefix.toLowerCase()) && kw != prefix)
          .toList();

      if (mounted) setState(() => _suggestions = matches);
    } else {
      if (mounted) setState(() => _suggestions = []);
    }
  }

  void _insertSuggestion(String suggestion) {
    final text = _codeController!.text;
    final selection = _codeController!.selection;

    String textBeforeCursor = text.substring(0, selection.baseOffset);

    // 检查是否是 "." 触发的补全
    if (textBeforeCursor.trim().endsWith('.')) {
      // 直接插入方法名
      final newText = text.replaceRange(selection.baseOffset, selection.baseOffset, suggestion);
      int newCursor = selection.baseOffset + suggestion.length;

      if (suggestion.endsWith('()')) newCursor -= 1;

      _codeController!.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newCursor),
      );
    } else {
      // 替换单词逻辑
      RegExp wordRegex = RegExp(r'[a-zA-Z0-9_]+$');
      Match? match = wordRegex.firstMatch(textBeforeCursor);

      int start = selection.baseOffset;
      if (match != null) {
        start = match.start;
      }

      final newText = text.replaceRange(start, selection.baseOffset, suggestion);
      int newCursor = start + suggestion.length;

      if (suggestion.endsWith('()')) newCursor -= 1;

      _codeController!.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newCursor),
      );
    }
    _undoHistory.record(_codeController!.text, force: true);
  }

  void _insertSymbol(String symbol) {
    final text = _codeController!.text;
    final selection = _codeController!.selection;

    String insertText = symbol;
    int cursorOffset = 1;

    if (symbol == '(') insertText = '()';
    if (symbol == '[') insertText = '[]';
    if (symbol == '"') insertText = '""';

    final newText = text.replaceRange(selection.start, selection.end, insertText);

    _codeController!.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + cursorOffset),
    );
    _undoHistory.record(newText, force: true);

    // 如果插入的是点，手动触发一下建议更新
    if (symbol == '.') {
      _onCodeChanged();
    }
  }

  void _insertBraces() {
    final text = _codeController!.text;
    final selection = _codeController!.selection;
    final newText = text.replaceRange(selection.start, selection.end, "{}");
    _codeController!.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + 1),
    );
    _undoHistory.record(newText, force: true);
  }

  void _smartEnter() {
    // ... (保持之前的智能回车逻辑不变)
    final text = _codeController!.text;
    final selection = _codeController!.selection;
    final cursor = selection.baseOffset;
    if (cursor < 0) return;

    String charBefore = cursor > 0 ? text[cursor - 1] : "";
    String charAfter = cursor < text.length ? text[cursor] : "";

    String textBeforeCursor = text.substring(0, cursor);
    int lineStart = textBeforeCursor.lastIndexOf('\n') + 1;
    String currentLine = textBeforeCursor.substring(lineStart);
    String indent = "";
    for (int i = 0; i < currentLine.length; i++) {
      if (currentLine[i] == ' ') indent += " ";
      else break;
    }

    String insertText = "";
    int newCursorOffset = 0;

    if (charBefore == '{' && charAfter == '}') {
      String innerIndent = indent + "    ";
      insertText = "\n" + innerIndent + "\n" + indent;
      newCursorOffset = 1 + innerIndent.length;
    } else if (charBefore == '{') {
      String innerIndent = indent + "    ";
      insertText = "\n" + innerIndent;
      newCursorOffset = insertText.length;
    } else {
      insertText = "\n" + indent;
      newCursorOffset = insertText.length;
    }

    final newText = text.replaceRange(selection.start, selection.end, insertText);
    _codeController!.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursor + newCursorOffset),
    );
    _undoHistory.record(newText, force: true);
  }

  String? _diagnoseCode(String code) {
    // ... (保持之前的诊断逻辑不变)
    int openBraces = code.split('{').length - 1;
    int closeBraces = code.split('}').length - 1;
    if (openBraces != closeBraces) {
      return "⚠️ 语法错误: 大括号不匹配。'{'有$openBraces个，'}'有$closeBraces个。";
    }
    if (!code.contains("public static void main")) {
      return "⚠️ 结构错误: 找不到 main 方法。";
    }
    return null;
  }

  void _undo() {
    final oldText = _undoHistory.undo();
    if (oldText != null) {
      _codeController!.value = TextEditingValue(text: oldText, selection: TextSelection.collapsed(offset: oldText.length));
    }
  }

  void _redo() {
    final futureText = _undoHistory.redo();
    if (futureText != null) {
      _codeController!.value = TextEditingValue(text: futureText, selection: TextSelection.collapsed(offset: futureText.length));
    }
  }

  Future<void> _runCode() async {
    if (_codeController == null) return;
    String? diagnosticError = _diagnoseCode(_codeController!.text);
    if (diagnosticError != null) {
      setState(() { _output = ""; _error = diagnosticError; });
      return;
    }
    setState(() { _isRunLoading = true; _output = ""; _error = ""; });
    try {
      final response = await _apiService.runCode(_token, _codeController!.text);
      setState(() { _output = response['output'] ?? ""; _error = response['error'] ?? ""; });
    } catch (e) {
      setState(() { _error = "连接沙盒失败: $e"; });
    } finally {
      setState(() { _isRunLoading = false; });
    }
  }

  void _openAiChat(BuildContext context) {
    Provider.of<ChatProvider>(context, listen: false).startNewChat(
        "viewing: logic_${widget.problemSummary.id}",
        "编程题: ${widget.problemSummary.title}"
    );
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => FractionallySizedBox(heightFactor: 0.9, child: const AiChatPage()),
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.problemSummary.title),
          // --- ⬇️ (修改) 把 AI 按钮移到 AppBar Actions ⬇️ ---
          actions: [
            IconButton(
              icon: const Icon(Icons.support_agent),
              tooltip: 'AI 助教',
              onPressed: () => _openAiChat(context),
            ),
          ],
          // --- ⬆️ (修改结束) ⬆️ ---
          bottom: const TabBar(tabs: [Tab(text: '题目描述'), Tab(text: '代码编辑器')]),
        ),
        // (移除 FloatingActionButton)
        body: FutureBuilder<BeginnerLogicProblemDetail>(
          future: _problemDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || _codeController == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return PlaceholderWidget(icon: Icons.error_outline, title: '加载失败', message: '${snapshot.error}', onRetry: _retry);
            }
            final detail = snapshot.data!;
            return TabBarView(
              children: [
                _buildDescriptionTab(detail.descriptionBlocks),
                _buildEditorTab(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionTab(List<ContentBlock> blocks) {
    // ... (与之前一样，可以使用 MarkdownBody)
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        final block = blocks[index];
        switch (block.type) {
          case "text":
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(block.content, style: const TextStyle(fontSize: 16.0, height: 1.5)),
            );
          case "sub-header":
            return Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(block.content, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            );
          case "code":
            return CodeBlockWidget(
              codeContent: block.content,
              language: block.language ?? 'java',
              isBeginner: false, // (描述块不需要“运行”)
            );
          default:
            return Text("未知内容块: ${block.content}");
        }
      },
    );
  }

  Widget _buildEditorTab(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = isDarkMode ? monokaiSublimeTheme : githubTheme;
    final settings = Provider.of<SettingsProvider>(context);
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: CodeTheme(
            data: CodeThemeData(styles: theme),
            child: CodeField(
              controller: _codeController!,
              keyboardType: TextInputType.multiline,


              // 应用设置
              textStyle: TextStyle(fontFamily: 'monospace', fontSize: settings.editorFontSize),
              lineNumbers: settings.showLineNumbers,
              expands: true, wrap: false,
            ),
          ),
        ),

        // 智能辅助栏 (建议)
        if (_suggestions.isNotEmpty)
          Container(
            height: 40,
            color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                  child: ActionChip(
                    label: Text(_suggestions[index]),
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    labelStyle: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    onPressed: () => _insertSuggestion(_suggestions[index]),
                  ),
                );
              },
            ),
          ),

        // 工具栏
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12, offset: Offset(0, -2))]
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            children: [
              IconButton(
                icon: Icon(Icons.undo, color: _undoHistory.canUndo ? null : Colors.grey),
                onPressed: _undoHistory.canUndo ? _undo : null,
              ),
              IconButton(
                icon: Icon(Icons.redo, color: _undoHistory.canRedo ? null : Colors.grey),
                onPressed: _undoHistory.canRedo ? _redo : null,
              ),
              const VerticalDivider(width: 10, indent: 10, endIndent: 10),
              TextButton(
                onPressed: _insertBraces,
                style: TextButton.styleFrom(minimumSize: const Size(40, 40), padding: EdgeInsets.zero),
                child: const Text("{}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              ..._quickSymbols.map((s) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: TextButton(
                  onPressed: () => _insertSymbol(s),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                  ),
                  child: Text(s, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              )).toList(),
              const VerticalDivider(width: 10, indent: 10, endIndent: 10),
              IconButton(
                icon: const Icon(Icons.keyboard_return, color: Colors.blue),
                onPressed: _smartEnter,
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_tab),
                onPressed: () => _insertSymbol("    "),
              ),
            ],
          ),
        ),

        // 输出面板
        Container(
          padding: const EdgeInsets.all(8.0),
          color: isDarkMode ? Colors.black54 : Colors.grey[100],
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _error.isNotEmpty ? "❌ $_error" : (_output.isNotEmpty ? "✅ 输出:\n$_output" : "等待运行..."),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: _error.isNotEmpty ? Colors.red : (_output.isNotEmpty ? Colors.green[700] : Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _isRunLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : FloatingActionButton.small(
                onPressed: _runCode,
                backgroundColor: Colors.green,
                child: const Icon(Icons.play_arrow),
              ),
            ],
          ),
        ),
      ],
    );
  }
}