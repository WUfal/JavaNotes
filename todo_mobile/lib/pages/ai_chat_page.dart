import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/chat_provider.dart';
import '../providers/settings_provider.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({Key? key}) : super(key: key);

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode(); // 管理焦点

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollDown(jump: true);
    });
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    // 1. 获取当前的 AI 人设配置
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final String currentPersona = settings.aiPersona;

    // 2. 将消息和人设一起传递给 ChatProvider
    // (注意：你需要确保 ChatProvider.sendMessage 方法签名已经更新为接收两个参数)
    Provider.of<ChatProvider>(context, listen: false)
        .sendMessage(_textController.text, currentPersona);

    _textController.clear();
    _scrollDown();
  }

  void _scrollDown({bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (jump) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        } else {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuad,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        // 如果有新消息，尝试滚动
        if (chatProvider.isLoading) {
          _scrollDown();
        }

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            // 顶部的圆角，让它看起来像个卡片
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // --- 1. 顶部标题栏 (更现代的设计) ---
              _buildHeader(context, chatProvider, colorScheme),

              // --- 2. 消息列表 ---
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(), // 点击空白处收起键盘
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    itemCount: chatProvider.messages.length + (chatProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // 如果正在加载，且是最后一个 item，显示 "AI 正在思考" 的气泡
                      if (chatProvider.isLoading && index == chatProvider.messages.length) {
                        return _buildLoadingBubble(colorScheme);
                      }

                      final message = chatProvider.messages[index];
                      if (message.type == "CONTEXT_SEPARATOR") {
                        return _buildContextSeparator(message, colorScheme);
                      } else {
                        return _buildChatBubble(message, colorScheme);
                      }
                    },
                  ),
                ),
              ),

              // --- 3. 底部输入栏 (胶囊风格) ---
              _buildInputArea(context, chatProvider, colorScheme),
            ],
          ),
        );
      },
    );
  }

  // 构建顶部栏
  Widget _buildHeader(BuildContext context, ChatProvider provider, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(bottom: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3))),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), offset: const Offset(0, 2), blurRadius: 4)
          ]
      ),
      child: Column(
        children: [
          // 拖拽条小把手
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2)),
          ),
          Row(
            children: [
              // AI 头像容器
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI 助教',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
                    ),
                    if (provider.contextTitle != null)
                      Text(
                        '正在讨论: ${provider.contextTitle}',
                        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: colorScheme.onSurfaceVariant),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建上下文分割线
  Widget _buildContextSeparator(ChatMessage message, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: colorScheme.outlineVariant)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "新的上下文",
              style: TextStyle(color: colorScheme.outline, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Divider(color: colorScheme.outlineVariant)),
        ],
      ),
    );
  }

  // 构建加载气泡 (模拟打字机)
  Widget _buildLoadingBubble(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(Icons.auto_awesome, size: 14, color: colorScheme.primary),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: SizedBox(
              width: 40,
              height: 20,
              child: Center(
                // 一个小的呼吸进度条
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: colorScheme.primary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建消息气泡
  Widget _buildChatBubble(ChatMessage message, ColorScheme colorScheme) {
    final isUser = message.isUser;
    final align = isUser ? MainAxisAlignment.end : MainAxisAlignment.start;

    // 用户气泡：使用 Primary 色
    // AI 气泡：使用 Surface Container (灰底)
    final bgColor = isUser ? colorScheme.primary : colorScheme.surfaceContainerHighest;
    final textColor = isUser ? colorScheme.onPrimary : colorScheme.onSurface;

    // Markdown 样式定制
    final mdStyle = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: TextStyle(color: textColor, fontSize: 15, height: 1.4),
      code: TextStyle(
        backgroundColor: isUser ? Colors.black12 : colorScheme.surface, // 代码块背景微调
        color: textColor,
        fontFamily: 'monospace',
      ),
      codeblockDecoration: BoxDecoration(
        color: isUser ? Colors.black12 : colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: align,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 如果是 AI，显示小头像
          if (!isUser) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.auto_awesome, size: 14, color: colorScheme.primary),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor,
                // 气泡圆角处理：说话人的那个角变尖，模仿气泡尾巴
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                // 给 AI 气泡加一点微弱阴影，增加层次感
                boxShadow: !isUser ? [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                ] : null,
              ),
              child: MarkdownBody(
                data: message.text,
                selectable: true,
                styleSheet: mdStyle,
              ),
            ),
          ),

          // 如果是用户，显示小人头
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: colorScheme.tertiaryContainer,
              child: Icon(Icons.person, size: 14, color: colorScheme.onTertiaryContainer),
            ),
          ],
        ],
      ),
    );
  }

  // 构建输入框区域
  Widget _buildInputArea(BuildContext context, ChatProvider provider, ColorScheme colorScheme) {
    return Container(
      // 考虑键盘高度 (viewInsets)
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24), // 胶囊圆角
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: 3,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: '询问 AI 助教...',
                  hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 发送按钮 (动态变化颜色)
          ListenableBuilder(
              listenable: _textController,
              builder: (context, _) {
                final hasText = _textController.text.trim().isNotEmpty;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: hasText && !provider.isLoading
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                        Icons.arrow_upward_rounded,
                        color: hasText && !provider.isLoading
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant
                    ),
                    onPressed: (hasText && !provider.isLoading) ? _sendMessage : null,
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}