import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/dark.dart';
import 'package:provider/provider.dart';

// 1. 导入我们需要的服务
import '../providers/auth_service.dart';
import '../services/api_service.dart';

// 2. (修改) 变为 StatefulWidget
class CodeBlockWidget extends StatefulWidget {
  final String codeContent;
  final String language;
  final bool isBeginner; // <--- 3. (新增) "A路径" 开关

  const CodeBlockWidget({
    Key? key,
    required this.codeContent,
    this.language = 'java',
    this.isBeginner = false, // <--- (新增) 默认为 false (B路径)
  }) : super(key: key);

  @override
  State<CodeBlockWidget> createState() => _CodeBlockWidgetState();
}

class _CodeBlockWidgetState extends State<CodeBlockWidget> {
  // 4. (新增) API 实例和状态
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // 5. (新增) “运行”按钮的点击事件
  Future<void> _runCode() async {
    setState(() { _isLoading = true; });

    String output = "";
    String error = "";

    try {
      // 6. 获取 Token
      final String? token = Provider.of<AuthService>(context, listen: false).token;

      // 7. 调用 API
      final response = await _apiService.runCode(token, widget.codeContent);

      output = response['output'] ?? "";
      error = response['error'] ?? "";

    } catch (e) {
      error = "连接沙盒失败: $e";
    } finally {
      setState(() { _isLoading = false; });

      // 8. (关键) 显示底部结果面板
      if (mounted) {
        _showOutputPanel(context, output, error);
      }
    }
  }

  // 9. (新增) 显示底部面板的辅助方法
  void _showOutputPanel(BuildContext context, String output, String error) {
    bool hasError = error.isNotEmpty;

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题 (输出 或 错误)
              Text(
                hasError ? "编译/运行 错误" : "控制台输出",
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: hasError ? Colors.red : Colors.green,
                ),
              ),
              const Divider(),
              // 结果
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    color: Theme.of(ctx).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.grey.shade200,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      hasError ? error : output,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF8F8F8);

    // 10. (修改) Stack 布局，以容纳 "运行" 按钮
    return Stack(
      children: [
        // --- (不变) 代码高亮主体 ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 40), // (修改) 增加上下 padding
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              widget.codeContent,
              language: widget.language,
              theme: isDarkMode ? darkTheme : githubTheme,
              padding: const EdgeInsets.all(0),
              textStyle: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14.0,
              ),
            ),
          ),
        ),

        // --- (不变) 复制按钮 ---
        Positioned(
          top: 12,
          right: 12,
          child: IconButton(
            icon: Icon(
              Icons.copy,
              size: 20.0,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.codeContent));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('代码已复制到剪贴板'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: '复制',
          ),
        ),

        // --- 11. (关键新增) A 路径的 "运行" 按钮 ---
        if (widget.isBeginner)
          Positioned(
            bottom: 12,
            right: 12,
            child: _isLoading
                ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)
              ),
            )
                : ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('运 行'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: _runCode, // <--- (点击运行)
            ),
          ),
      ],
    );
  }
}