// --- ⬇️ (关键修复) ⬇️ ---
// (我们不再导入 "material.dart"，
// 而是导入更基础的 "foundation.dart"，它包含了 ChangeNotifier)
import 'package:flutter/foundation.dart';
// --- ⬆️ (修复结束) ⬆️ ---

import 'dart:collection'; // (用于 UnmodifiableListView)
import '../models/badge.dart';
import '../services/api_service.dart';

class BadgeProvider with ChangeNotifier {

  final ApiService _apiService;
  String? _token;

  List<Badge> _badges = [];
  bool _isLoading = false;
  String? _error;
  String? loadedToken;

  // Getters
  UnmodifiableListView<Badge> get badges => UnmodifiableListView(_badges);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // 构造函数
  BadgeProvider(this._apiService, this._token);

  // (由 ProxyProvider 调用的“更新”方法)
  void updateAuth(String? token) {
    this._token = token;
    if (token == null) {
      clearOnLogout();
    }
  }

  // (核心) 从 API 加载徽章
  Future<void> loadMyBadges(String? token) async {
    if (token == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _badges = await _apiService.fetchMyBadges(token);
      loadedToken = token; // (标记这个 token 的数据已加载)
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // (登出时清除)
  void clearOnLogout() {
    _badges = [];
    _error = null;
    _isLoading = false;
    loadedToken = null; // (重置)
  }
}