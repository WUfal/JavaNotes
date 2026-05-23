import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_module.dart';
import '../models/grading_result.dart';
import '../models/practice_generation_task.dart';
import '../models/practice_question.dart';
import '../models/project.dart';
import '../models/algorithm.dart';
import '../models/beginner_level.dart';
import '../models/quiz.dart';
import '../models/beginner_logic_problem.dart';
import '../models/bookmark.dart';
import '../models/user_profile.dart';
import '../providers/chat_provider.dart';
import '../models/search_result.dart';
import '../models/badge.dart';
import '../models/comment.dart';
import 'package:provider/provider.dart'; // <--- (1) 导入 Provider

import '../main.dart'; // <--- (2) 导入 main.dart 以获取 navigatorKey
import '../providers/auth_service.dart'; // <--- (3) 导入 AuthService
class ApiService {
  static const String _domain = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const String _baseUrl = "$_domain/api/v1";
  static const String _userBaseUrl = "$_domain/api/user";

  // (新增) 一个公开的 Getter，让外部也能拿到这个域名
  String get baseUrlDomain => _domain;
  // --- 辅助方法：创建带 Token 的请求头 ---
  Map<String, String> _getHeaders(String? token) {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token'; // 关键：添加“门禁卡”
    }
    return headers;
  }

  // --- 1. Course Modules (已修改) ---
  Future<List<ModuleGroup>> fetchAdvancedModules(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/modules/advanced'),
      headers: _getHeaders(token), // <--- 传递请求头
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList
          .map((jsonItem) => ModuleGroup.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception(
          'Failed to load modules. Status code: ${response.statusCode}');
    }
  }

  Future<ModuleDetail> fetchModuleDetail(String? token, String moduleId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/modules/advanced/$moduleId'),
      headers: _getHeaders(token), // <--- 传递请求头
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = jsonDecode(responseBody);
      return ModuleDetail.fromJson(jsonMap);
    } else {
      throw Exception(
          'Failed to load module detail. Status code: ${response.statusCode}');
    }
  }

  // --- 2. Projects (已修改) ---
  Future<List<ProjectSummary>> fetchProjects(String? token) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.get(
      Uri.parse('$_baseUrl/projects'),
      headers: _getHeaders(token), // <--- 传递请求头
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList
          .map((jsonItem) => ProjectSummary.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<ProjectDetail> fetchProjectDetail(String? token,
      String projectId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/projects/$projectId'),
      headers: _getHeaders(token), // <--- 传递请求头
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = jsonDecode(responseBody);
      return ProjectDetail.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load project detail');
    }
  }

  // --- 3. Algorithms (已修改) ---
  Future<List<AlgorithmSummary>> fetchAlgorithms(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/algorithms'),
      headers: _getHeaders(token), // <--- 传递请求头
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList
          .map((jsonItem) => AlgorithmSummary.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to load algorithms');
    }
  }

  Future<AlgorithmDetail> fetchAlgorithmDetail(String? token,
      String problemId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/algorithms/$problemId'),
      headers: _getHeaders(token), // <--- 传递请求头
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = jsonDecode(responseBody);
      return AlgorithmDetail.fromJson(jsonMap);
    } else {
      throw Exception('Failed to load algorithm detail');
    }
  }

  Future<bool> saveUserPath(String token, String path) async {
    final response = await http.post(
      Uri.parse('$_userBaseUrl/path'), // <--- (注意 URL)
      headers: _getHeaders(token), // <--- (必须带 Token)
      body: jsonEncode({
        'path': path // "BEGINNER" 或 "ADVANCED"
      }),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to save user path. Status code: ${response.statusCode}');
    }
  }

// --- ⬇️ A 路径 (Beginner) API ⬇️ ---

  /**
   * API 1: 获取所有 A 路径的大关卡
   */
  Future<List<BeginnerLevelDto>> fetchBeginnerLevels(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/beginner/levels'), // <--- (注意 URL)
      headers: _getHeaders(token), // <--- (带 Token)
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList
          .map((jsonItem) => BeginnerLevelDto.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to load beginner levels');
    }
  }

  /**
   * API 2: 获取单个 A 路径的小关卡详情
   * (注意：我们复用 B 路径的 ModuleDetail 模型)
   */
  Future<ModuleDetail> fetchBeginnerLessonDetail(String? token,
      int lessonId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/beginner/lesson/$lessonId'), // <--- (注意 URL)
      headers: _getHeaders(token), // <--- (带 Token)
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = jsonDecode(responseBody);
      return ModuleDetail.fromJson(jsonMap); // 复用 ModuleDetail 模型
    } else {
      throw Exception('Failed to load lesson detail');
    }
  }

// --- ⬆️ A 路径 API 结束 ⬆️ ---
// --- ⬇️ 沙盒 (Sandbox) API ⬇️ ---

  /**
   *   API: 运行代码
   *   返回一个 Map, e.g., {"output": "...", "error": "..."}
   */
  Future<Map<String, dynamic>> runCode(String? token, String code) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/sandbox/run'), // <--- (注意 URL)
      headers: _getHeaders(token), // <--- (必须带 Token)
      body: jsonEncode({
        'code': code
      }),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      // 成功 (即使有编译错误，也算 200 成功)
      String responseBody = utf8.decode(response.bodyBytes);
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      // 网络或服务器内部错误
      throw Exception(
          'Failed to run code. Status code: ${response.statusCode}');
    }
  }

// --- ⬆️ API 结束 ⬆️ ---
// --- ⬇️ A 路径 (Quiz) API ⬇️ ---

  /**
   * API 1: 获取所有测验章节
   */
  Future<List<QuizChapterSummary>> fetchQuizChapters(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/quiz/chapters'), // <--- (注意 URL)
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList
          .map((jsonItem) => QuizChapterSummary.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to load quiz chapters');
    }
  }

  /**
   * API 2: 获取单个章节的所有问题
   */
  Future<List<QuizQuestionDto>> fetchQuizQuestions(String? token,
      int chapterId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/quiz/chapter/$chapterId'), // <--- (注意 URL)
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList
          .map((jsonItem) => QuizQuestionDto.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to load quiz questions');
    }
  }

  /**
   * API 3: 提交测验答案
   * (answers: { 1: 2, 3: 10, ... } -> Key: questionId, Value: selectedOptionId)
   */
  Future<QuizResultResponse> submitQuiz(String? token, int chapterId,
      Map<int, int> answers) async {
    // (将 Map<int, int> 转换为 Map<String, int> 以匹配 JSON)
    final Map<String, int> stringKeyAnswers = answers.map((key, value) =>
        MapEntry(key.toString(), value));

    final response = await http.post(
      Uri.parse('$_baseUrl/quiz/chapter/$chapterId/submit'), // <--- (注意 URL)
      headers: _getHeaders(token),
      body: jsonEncode({
        'answers': stringKeyAnswers
      }),
    );

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return QuizResultResponse.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to submit quiz');
    }
  }

// --- ⬆️ A 路径 API 结束 ⬆️ ---
// --- ⬇️ A 路径 (Beginner Logic) API ⬇️ ---

  /**
   * API 1: 获取所有编程逻辑题
   */
  Future<List<BeginnerLogicProblemSummary>> fetchLogicProblems(
      String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/beginner/logic/problems'), // <--- (注意 URL)
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((jsonItem) =>
          BeginnerLogicProblemSummary.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load logic problems');
    }
  }

  /**
   * API 2: 获取单个编程逻辑题详情
   */
  Future<BeginnerLogicProblemDetail> fetchLogicProblemDetail(String? token,
      int problemId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/beginner/logic/problem/$problemId'), // <--- (注意 URL)
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return BeginnerLogicProblemDetail.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to load logic problem detail');
    }
  }

// --- ⬆️ A 路径 API 结束 ⬆️ ---
// --- ⬇️ AI 聊天 (Chat) API ⬇️ ---

// --- 12. AI Chat (全局) ---
  Future<Map<String, dynamic>> chatWithAi(
      String? token,
      List<ChatMessage> history, // <--- (1. 新增参数)// (现在 'ChatMessage' 被正确识别了)
      String? contextTitle,
      String persona
      ) async {
    // (将 List<ChatMessage> 转换为 API 需要的 JSON 列表)
    List<Map<String, String>> historyForJson = history.map((msg) {
      return {
        // (现在 'msg.isUser' 和 'msg.text' 也能被正确访问了)
        "role": msg.isUser ? "user" : "model",
        "text": msg.text
      };
    }).toList();

    final response = await http.post(
      Uri.parse('$_baseUrl/ai/chat'),
      headers: _getHeaders(token),
      body: jsonEncode({
        'history': historyForJson,
        'contextTitle': contextTitle,
        'persona': persona // <--- (2. 发送参数)
      }),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Failed to chat with AI. Status code: ${response.statusCode}');
    }
  }

// --- ⬆️ API 结束 ⬆️ ---
// --- ⬇️ 收藏夹 (Bookmark) API ⬇️ ---

  /**
   * API 1: 获取所有收藏
   */
  Future<List<Bookmark>> fetchBookmarks(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bookmarks'), // <--- (注意 URL)
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((jsonItem) => Bookmark.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load bookmarks');
    }
  }

  /**
   * API 2: 添加一个新收藏
   */
  Future<Bookmark> addBookmark(String? token, String type, String id,
      String title) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bookmarks'), // <--- (注意 URL)
      headers: _getHeaders(token),
      body: jsonEncode({
        'type': type,
        'id': id,
        'title': title,
      }),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Bookmark.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to add bookmark');
    }
  }

  /**
   * API 3: 删除一个收藏
   */
  Future<void> removeBookmark(String? token, String type, String id) async {
    final response = await http.delete(
      // (注意 URL 和 Query Parameters)
      Uri.parse('$_baseUrl/bookmarks?type=$type&id=$id'),
      headers: _getHeaders(token),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove bookmark');
    }
    // (204 No Content, 成功时没有 body)
  }

// --- ⬆️ A 路径 API 结束 ⬆️ ---
// --- ⬇️ A 路径 (Progress) API ⬇️ ---

  /**
   * API 4: 获取所有已完成的关卡 ID
   */
  Future<Set<int>> fetchCompletedLessonIds(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/beginner/progress/ids'),
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((id) => id as int).toSet();
    } else {
      throw Exception('Failed to load progress');
    }
  }

  /**
   * API 5: 标记关卡为已完成
   */
  Future<void> markLessonAsComplete(String? token, int lessonId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/beginner/lesson/$lessonId/complete'),
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode != 200) {
      throw Exception('Failed to mark lesson as complete');
    }
  }

// --- ⬆️ A 路径 API 结束 ⬆️ ---
// --- ⬇️ A 路径 (Mistake Log) API ⬇️ ---

  // --- ⬇️ A 路径 (Mistake Log) API (已修改) ⬇️ ---
  /**
   * API 4: 获取所有错题 (按章节分组)
   */
  Future<List<QuizMistakeChapter>> fetchMistakes(String? token) async {
    // <--- (1. 修改返回类型)
    final response = await http.get(
      Uri.parse('$_baseUrl/quiz/mistakes'),
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      // (2. 修改解析逻辑)
      return jsonList
          .map((jsonItem) => QuizMistakeChapter.fromJson(jsonItem))
          .toList();
    } else {
      throw Exception('Failed to load mistakes');
    }
  }

// --- ⬆️ A 路径 API 结束 ⬆️ ---
  /**
   * API: 执行全局搜索
   */
  Future<List<SearchResult>> search(String? token, String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search?q=${Uri.encodeComponent(query)}'),
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    // --- ⬇️ (关键修复) ⬇️ ---
    // (使用我们回滚后的“简单”逻辑，不使用 _handleResponse)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList
          .map((jsonItem) => SearchResult.fromJson(jsonItem))
          .toList();
    } else {
      // (这是“普通”的加载失败)
      throw Exception('Failed to search. Status code: ${response.statusCode}');
    }
    // --- ⬆️ (修复结束) ⬆️ ---
  }

// --- ⬇️ 徽章 (Badge) API ⬇️ ---

  /**
   * API: 获取当前用户的所有徽章
   */
  Future<List<Badge>> fetchMyBadges(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/badges/my'), // <--- (注意 URL)
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    // --- ⬇️ (关键修复：使用我们“稳定”的 if-else 逻辑) ⬇️ ---
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((jsonItem) => Badge.fromJson(jsonItem)).toList();
    } else {
      // (这是“普通”的加载失败)
      throw Exception('Failed to load badges');
    }
    // --- ⬆️ (修复结束) ⬆️ ---
  }

// --- ⬆️ API 结束 ⬆️ ---
// --- ⬇️ 评论 (Comment) API ⬇️ ---

  // 1. 获取评论列表
  Future<List<Comment>> fetchComments(String? token, String targetType,
      String targetId) async {
    final response = await http.get(
      // 注意：这里假设你的后端 API 路径是 /comments?type=...&id=...
      Uri.parse('$_baseUrl/comments?type=$targetType&id=$targetId'),
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = jsonDecode(responseBody);
      return jsonList.map((jsonItem) => Comment.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  // 2. 发布新评论
  Future<Comment> postComment(String? token, String targetType, String targetId,
      String content) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/comments'),
      headers: _getHeaders(token),
      body: jsonEncode({
        'targetType': targetType,
        'targetId': targetId,
        'content': content,
      }),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return Comment.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to post comment');
    }
  }

// --- ⬆️ 评论 API 结束 ⬆️ ---
  Future<void> updateProfile(String? token, String nickname,
      String avatarId) async {
    final response = await http.put(
      Uri.parse('$_userBaseUrl/profile'), // 注意：这里用 _userBaseUrl (/api/user)
      headers: _getHeaders(token),
      body: jsonEncode({
        'nickname': nickname,
        'avatarId': avatarId,
      }),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update profile. Status: ${response.statusCode}');
    }
  }

// --- ⬇️ 用户资料 API ⬇️ ---
  /**
   * API: 获取个人资料
   */
  Future<UserProfile> fetchUserProfile(String? token) async {
    final response = await http.get(
      Uri.parse('$_userBaseUrl/profile'), // GET /api/user/profile
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return UserProfile.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to load profile');
    }
  }

// --- ⬇️ 每日一练 (异步版) ⬇️ ---

  // 1. 创建生成任务 (替换了之前的 generatePracticeQuestions)
  // 返回: PracticeGenerationTask (状态为 PENDING)
  Future<PracticeGenerationTask> createPracticeTask(String? token,
      String difficulty,
      String topic,
      String type,
      String extraRequirement) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/practice/generate'),
      headers: _getHeaders(token),
      body: jsonEncode({
        'difficulty': difficulty,
        'topic': topic,
        'type': type,
        'extraRequirement': extraRequirement
      }),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return PracticeGenerationTask.fromJson(jsonDecode(responseBody));
    } else {
      // 智能解析后端返回的 JSON 错误信息
      String errorMsg = "创建任务失败";
      try {
        String body = utf8.decode(response.bodyBytes);
        // 尝试解析 JSON
        Map<String, dynamic> json = jsonDecode(body);
        if (json.containsKey('message')) {
          errorMsg = json['message']; // <--- 获取 "任务列表已满 (5/5)..."
        } else if (json.containsKey('error')) {
          errorMsg = json['error'];
        }
      } catch(_) {
        // 如果不是 JSON，就显示原始文本
        try { errorMsg = utf8.decode(response.bodyBytes); } catch(_) {}
      }

      // 抛出干净的错误信息
      throw Exception(errorMsg);
    }
  }

  // 2. 获取任务列表
  Future<List<PracticeGenerationTask>> fetchPracticeTasks(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/practice/tasks'),
      headers: _getHeaders(token),
    );
    _checkUnauthorized(response); // <--- 🟢 插入这一行！(在判断 200 之前)
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> list = jsonDecode(responseBody);
      return list.map((json) => PracticeGenerationTask.fromJson(json)).toList();
    } else {
      throw Exception('获取任务列表失败');
    }
  }
// --- ⬆️ -------------------- ⬆️ ---
  // 2. 提交判题 (新增)
  Future<GradingResult> submitForGrading(
      String? token,
      String title,
      String description,
      String answer,
      String? userThought
      ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/practice/grade'),
      headers: _getHeaders(token),
      body: jsonEncode({
        'questionTitle': title,
        'questionDescription': description,
        'userAnswer': answer,
        'userThought': userThought
      }),
    );

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return GradingResult.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('判题失败: ${response.statusCode}');
    }
  }
// 3. 删除单个任务
  Future<void> deletePracticeTask(String? token, int taskId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/practice/tasks/$taskId'),
      headers: _getHeaders(token),
    );

    // 200 OK 或 204 No Content 都算成功
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('删除失败: ${response.statusCode}');
    }
  }

  // 4. 清空所有任务
  Future<void> clearAllPracticeTasks(String? token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/practice/tasks'),
      headers: _getHeaders(token),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('清空失败: ${response.statusCode}');
    }
  }
// --- ⬇️ (4) 关键新增：检查 Token 是否失效的辅助方法 ⬇️ ---
  void _checkUnauthorized(http.Response response) {
    // 如果后端返回 401 (未授权) 或 403 (禁止访问)
    if (response.statusCode == 401 || response.statusCode == 403) {

      // 使用全局 Key 获取当前的 Context
      final context = navigatorKey.currentContext;

      if (context != null) {
        // 打印日志方便调试
        print("⚠️ Token 过期，正在执行强制登出...");

        // 强制调用 logout
        // (listen: false 是必须的，因为我们是在函数里调用)
        Provider.of<AuthService>(context, listen: false).logout();
      }

      // 抛出异常，中断后续逻辑 (防止页面尝试解析错误的 JSON)
      throw Exception('会话已过期，请重新登录');
    }
  }

}
