import 'package:flutter/material.dart';
import 'dart:collection';
import '../models/bookmark.dart';
import '../services/api_service.dart';

class BookmarkProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Bookmark> _bookmarks = [];
  Set<String> _bookmarkIds = HashSet<String>();
  bool _isLoading = false;
  String? _error;

  // 1. (关键新增)
  String? loadedToken;

  List<Bookmark> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isBookmarked(String type, String id) {
    return _bookmarkIds.contains(_hashId(type, id));
  }
  String _hashId(String type, String id) => "$type-$id";

  Future<void> loadBookmarks(String? token) async {
    if (token == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookmarks = await _apiService.fetchBookmarks(token);
      _bookmarkIds = _bookmarks.map((b) => _hashId(b.type, b.bookmarkedId)).toSet();
      loadedToken = token; // (关键：标记这个 token 的数据已加载)
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 5. (核心) 添加收藏
  Future<void> addBookmark(String? token, String type, String id, String title) async {
    if (token == null || isBookmarked(type, id)) return; // (防止重复添加)

    try {
      // (1. 先更新后端)
      final newBookmark = await _apiService.addBookmark(token, type, id, title);

      // (2. 再更新本地状态)
      _bookmarks.insert(0, newBookmark); // (添加到列表顶部)
      _bookmarkIds.add(_hashId(type, id));

      notifyListeners(); // (广播状态变更)
    } catch (e) {
      print("Failed to add bookmark: $e");
      // (可以添加一个错误提示)
    }
  }

  // 6. (核心) 移除收藏
  Future<void> removeBookmark(String? token, String type, String id) async {
    if (token == null || !isBookmarked(type, id)) return;

    try {
      // (1. 先更新后端)
      await _apiService.removeBookmark(token, type, id);

      // (2. 再更新本地状态)
      _bookmarks.removeWhere((b) => b.type == type && b.bookmarkedId == id);
      _bookmarkIds.remove(_hashId(type, id));

      notifyListeners(); // (广播状态变更)
    } catch (e) {
      print("Failed to remove bookmark: $e");
      // (可以添加一个错误提示)
    }
  }

  // 7. (关键) 在登出时清除
  void clearOnLogout() {
    _bookmarks = [];
    _bookmarkIds = HashSet<String>();
    _error = null;
    _isLoading = false;
    loadedToken = null; // (关键：重置)
  }
}