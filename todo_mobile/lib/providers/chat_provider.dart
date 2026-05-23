import 'package:flutter/material.dart';
import 'dart:collection';
import '../services/api_service.dart';

// (消息模型 - 不变)
class ChatMessage {
  final String text;
  final bool isUser;
  // (新增) 增加一个“类型”，用于显示“分隔符”
  final String type; // "MESSAGE" or "CONTEXT_SEPARATOR"

  ChatMessage({
    required this.text,
    required this.isUser,
    this.type = "MESSAGE",
  });
}

class ChatProvider with ChangeNotifier {

  final ApiService _apiService;
  String? _token;

  // (内部状态)
  final List<ChatMessage> _messages = []; // (列表现在是持久化的)
  bool _isLoading = false;
  String? _contextId;
  String? _contextTitle;

  // (Getters 不变)
  UnmodifiableListView<ChatMessage> get messages => UnmodifiableListView(_messages);
  bool get isLoading => _isLoading;
  String? get contextTitle => _contextTitle;

  ChatProvider(this._apiService, this._token);

  void updateAuth(String? token) {
    this._token = token;
    if (token == null) {
      _messages.clear(); // (只在登出时清除)
    }
  }

  // --- ⬇️ (关键修改) ⬇️ ---
  // (核心 1) "启动聊天" 不再清除聊天记录
  void startNewChat(String? contextId, String? contextTitle) {
    // 1. 检查上下文是否 *真的* 改变了
    if (contextId == _contextId) {
      return; // (如果上下文没变，什么也不做)
    }

    // 2. 更新上下文
    _contextId = contextId;
    _contextTitle = contextTitle;

    // 3. (不清空) 而是插入一个“分隔符”
    if (_contextTitle != null) {
      _messages.add(ChatMessage(
        text: '--- 正在查看: $_contextTitle ---',
        isUser: false,
        type: "CONTEXT_SEPARATOR", // (标记为分隔符)
      ));
    }

    // 4. 添加欢迎消息
    String welcomeMessage = "你好！我是你的 AI 助教。有什么 Java 问题吗？";
    _messages.add(ChatMessage(text: welcomeMessage, isUser: false));

    notifyListeners();
  }
  // --- ⬆️ (修改结束) ⬆️ ---

  // (核心 2) "发送消息" (100% 不变)
  Future<void> sendMessage(String userMessageText,String persona) async {
    if (userMessageText.isEmpty || _isLoading || _token == null) return;

    // 1. (不变) 创建并添加用户消息
    final userMessage = ChatMessage(text: userMessageText, isUser: true);
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners(); // (显示用户消息和“加载中”)

    // --- ⬇️ (关键修改) ⬇️ ---
    try {
      // 2. (新) 我们必须 *只* 发送 "MESSAGE" 类型的历史
      //    (我们不应该把 "--- 正在查看: ---" 这种分隔符发给 AI)
      List<ChatMessage> historyToSend = _messages
          .where((msg) => msg.type == "MESSAGE")
          .toList();

      // 3. (新) 调用 *新* 的 API
      final response = await _apiService.chatWithAi(
          _token,
          historyToSend, // (发送过滤后的历史)
          _contextTitle ?? "", // <--- (修复：如果为空，传空字符串)
          persona// (Bug 2 修复：发送可读的上下文)
      );

      final aiReply = response['reply'] ?? "抱歉，我暂时无法回答。";
      _messages.add(ChatMessage(text: aiReply, isUser: false));

    } catch (e) {
      _messages.add(ChatMessage(text: "连接 AI 失败: $e", isUser: false));
    } finally {
      _isLoading = false;
      notifyListeners(); // (显示 AI 回复，隐藏“加载中”)
    }
    // --- ⬆️ (修改结束) ⬆️ ---
  }
}