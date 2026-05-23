import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart'; // (确保导入)

class AuthService with ChangeNotifier {

  final _storage = const FlutterSecureStorage();
  // (ApiService 实例，用于调用 saveUserPath)
  // (我们假设 ApiService 也是通过 Provider 注入的，
  //  但为了 auth_service 独立，我们在这里 new 一个实例)
  // (更正：我们之前已经把 ApiService 注入了，
  //  但 AuthService 是在 ApiService *之前* 创建的，
  //  所以 AuthService *不能* 依赖 Provider.of<ApiService>)
  // (结论：在这里 new 一个 ApiService 是正确的)
  final ApiService _apiService = ApiService();

  String? _token;
  String? _selectedPath;
  bool _isAuthenticated = false;
  bool _isLoading = true; // (保持 isLoading)

  String? get token => _token;
  String? get selectedPath => _selectedPath;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  static const String _tokenKey = 'jwt_token';
  static const String _pathKey = 'user_path';

  AuthService() {
    initAuth();
  }

  Future<void> initAuth() async {
    _token = await _storage.read(key: _tokenKey);
    _selectedPath = await _storage.read(key: _pathKey);

    if (_token != null) {
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
      _selectedPath = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String token, String? path) async {
    await _storage.write(key: _tokenKey, value: token);
    if (path != null) {
      await _storage.write(key: _pathKey, value: path);
    } else {
      await _storage.delete(key: _pathKey);
    }

    _token = token;
    _selectedPath = path;
    _isAuthenticated = true;

    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _pathKey);

    _token = null;
    _selectedPath = null;
    _isAuthenticated = false;

    notifyListeners();
  }

  // (这是 PathSelectionPage 调用的方法)
  Future<void> updatePath(String path) async {
    if (!_isAuthenticated) return;

    await _storage.write(key: _pathKey, value: path);
    _selectedPath = path;
    notifyListeners(); // (广播路径已更新)
  }

  // (这是 ProfilePage 调用的方法)
  Future<void> switchPath() async {
    if (!_isAuthenticated || _token == null) return;

    // 1. 确定新路径
    final String newPath = (_selectedPath == "BEGINNER") ? "ADVANCED" : "BEGINNER";

    try {
      // 2. (调用 API) 保存到后端
      await _apiService.saveUserPath(_token!, newPath);

      // 3. (调用内部方法) 更新本地状态
      //    (这一步会自动 notifyListeners)
      await updatePath(newPath);

    } catch (e) {
      print("Failed to switch path: $e");
      // (TODO: 我们可以向用户显示一个 SnackBar 错误提示)
    }
  }
}