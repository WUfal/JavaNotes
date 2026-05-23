import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/java.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/github.dart';
import '../../utils/java_keywords.dart';
import '../../utils/undo_history.dart'; // 确保这个文件存在
import '../../providers/settings_provider.dart';
import 'package:provider/provider.dart';
class FullCodeEditorPage extends StatefulWidget {
  final String initialCode;
  const FullCodeEditorPage({Key? key, required this.initialCode}) : super(key: key);

  @override
  State<FullCodeEditorPage> createState() => _FullCodeEditorPageState();
}

class _FullCodeEditorPageState extends State<FullCodeEditorPage> {
  late CodeController _codeController;
  final SimpleUndoHistory _undoHistory = SimpleUndoHistory();
  List<String> _suggestions = [];
  String _currentWord = "";

  // 常用符号
  final List<String> _quickSymbols = ['(', ')', ';', '.', '=', '"', '+', '-', '*', '/', '[', ']'];

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: widget.initialCode,
      language: java,
    );
    // 初始化历史
    _undoHistory.record(widget.initialCode, force: true);
    // 监听输入
    _codeController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // --- 核心逻辑 (复用自 LogicProblemDetailPage) ---
  void _onCodeChanged() {
    final text = _codeController.text;
    final selection = _codeController.selection;

    _undoHistory.record(text);

    if (!selection.isCollapsed) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }

    String textBeforeCursor = text.substring(0, selection.baseOffset);

    // 1. 检测 "." 触发
    if (textBeforeCursor.trim().endsWith('.')) {
      if (mounted) setState(() => _suggestions = JavaKeywords.methods);
      return;
    }

    // 2. 检测单词触发
    RegExp wordRegex = RegExp(r'[a-zA-Z0-9_]+$');
    Match? match = wordRegex.firstMatch(textBeforeCursor);

    if (match != null) {
      String prefix = match.group(0)!;
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
    final text = _codeController.text;
    final selection = _codeController.selection;
    String textBeforeCursor = text.substring(0, selection.baseOffset);

    if (textBeforeCursor.trim().endsWith('.')) {
      final newText = text.replaceRange(selection.baseOffset, selection.baseOffset, suggestion);
      int newCursor = selection.baseOffset + suggestion.length;
      if (suggestion.endsWith('()')) newCursor -= 1;
      _codeController.value = TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newCursor));
    } else {
      RegExp wordRegex = RegExp(r'[a-zA-Z0-9_]+$');
      Match? match = wordRegex.firstMatch(textBeforeCursor);
      int start = match != null ? match.start : selection.baseOffset;
      final newText = text.replaceRange(start, selection.baseOffset, suggestion);
      int newCursor = start + suggestion.length;
      if (suggestion.endsWith('()')) newCursor -= 1;
      _codeController.value = TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newCursor));
    }
    _undoHistory.record(_codeController.text, force: true);
  }

  void _insertSymbol(String symbol) {
    final text = _codeController.text;
    final selection = _codeController.selection;
    String insertText = symbol;
    int cursorOffset = 1;

    if (symbol == '(') insertText = '()';
    if (symbol == '[') insertText = '[]';
    if (symbol == '"') insertText = '""';

    final newText = text.replaceRange(selection.start, selection.end, insertText);
    _codeController.value = TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: selection.start + cursorOffset));
    _undoHistory.record(newText, force: true);
    if (symbol == '.') _onCodeChanged();
  }

  void _insertBraces() {
    final text = _codeController.text;
    final selection = _codeController.selection;
    final newText = text.replaceRange(selection.start, selection.end, "{}");
    _codeController.value = TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: selection.start + 1));
    _undoHistory.record(newText, force: true);
  }

  void _smartEnter() {
    final text = _codeController.text;
    final selection = _codeController.selection;
    final cursor = selection.baseOffset;
    if (cursor < 0) return;

    String charBefore = cursor > 0 ? text[cursor - 1] : "";
    String charAfter = cursor < text.length ? text[cursor] : "";
    String textBeforeCursor = text.substring(0, cursor);
    int lineStart = textBeforeCursor.lastIndexOf('\n') + 1;
    String currentLine = textBeforeCursor.substring(lineStart);
    String indent = "";
    for (int i = 0; i < currentLine.length; i++) {
      if (currentLine[i] == ' ') indent += " "; else break;
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
    _codeController.value = TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: cursor + newCursorOffset));
    _undoHistory.record(newText, force: true);
  }

  void _undo() {
    final oldText = _undoHistory.undo();
    if (oldText != null) {
      _codeController.value = TextEditingValue(text: oldText, selection: TextSelection.collapsed(offset: oldText.length));
    }
  }

  void _redo() {
    final futureText = _undoHistory.redo();
    if (futureText != null) {
      _codeController.value = TextEditingValue(text: futureText, selection: TextSelection.collapsed(offset: futureText.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = isDarkMode ? monokaiSublimeTheme : githubTheme;
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("全屏编辑器"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _codeController.text);
            },
            child: const Text("完成", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          // 编辑器主体
          Expanded(
            child: CodeTheme(
              data: CodeThemeData(styles: theme),
              child: CodeField(
                controller: _codeController,
                textStyle: TextStyle(fontFamily: 'monospace', fontSize: settings.editorFontSize),
                lineNumbers: settings.showLineNumbers,
                expands: true,
                wrap: false,
              ),
            ),
          ),

          // 智能建议栏
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

          // 功能工具栏
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
                IconButton(icon: Icon(Icons.undo, color: _undoHistory.canUndo ? null : Colors.grey), onPressed: _undoHistory.canUndo ? _undo : null),
                IconButton(icon: Icon(Icons.redo, color: _undoHistory.canRedo ? null : Colors.grey), onPressed: _undoHistory.canRedo ? _redo : null),
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

                IconButton(icon: const Icon(Icons.keyboard_return, color: Colors.blue), onPressed: _smartEnter),
                IconButton(icon: const Icon(Icons.keyboard_tab), onPressed: () => _insertSymbol("    ")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}