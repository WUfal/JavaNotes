// (在 lib/providers/progress_provider.dart)
import 'package:flutter/material.dart';
import 'dart:collection';
import '../services/api_service.dart';

class ProgressProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Set<int> _completedLessonIds = HashSet<int>();
  bool _isLoading = false;
  String? _error;

  // 1. (关键新增)
  String? loadedToken; // (用于防止 main.dart 重复加载)

  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isLessonCompleted(int lessonId) {
    return _completedLessonIds.contains(lessonId);
  }

  Future<void> loadProgress(String? token) async {
    if (token == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _completedLessonIds = await _apiService.fetchCompletedLessonIds(token);
      loadedToken = token; // (关键：标记这个 token 的数据已加载)
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markLessonAsComplete(String? token, int lessonId) async {
    if (token == null || isLessonCompleted(lessonId)) return;

    _completedLessonIds.add(lessonId);
    notifyListeners(); // (UI 立即显示“对勾”)

    try {
      await _apiService.markLessonAsComplete(token, lessonId);
    } catch (e) {
      _completedLessonIds.remove(lessonId);
      notifyListeners(); // (如果后端失败，回滚“对勾”)
      print("Failed to mark complete: $e");
    }
  }

  void clearOnLogout() {
    _completedLessonIds = HashSet<int>();
    _error = null;
    _isLoading = false;
    loadedToken = null; // (关键：重置)
  }
}