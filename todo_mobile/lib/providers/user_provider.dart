import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService;
  String? _token;

  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;
  String? _loadedToken;

  // Getters
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  UserProvider(this._apiService, this._token);

  void updateAuth(String? token) {
    _token = token;
    if (token == null) {
      _userProfile = null;
      _loadedToken = null;
      notifyListeners();
    }
  }

  // 加载用户信息
  Future<void> loadProfile() async {
    if (_token == null) return;

    _isLoading = true;
    // notifyListeners(); // 避免在 build 期间频繁刷新导致报错，这里可以不通知，静默加载

    try {
      _userProfile = await _apiService.fetchUserProfile(_token);
      _loadedToken = _token;
    } catch (e) {
      _error = e.toString();
      print("加载用户信息失败: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // 加载完成，通知侧边栏刷新
    }
  }
}