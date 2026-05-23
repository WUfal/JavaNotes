import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  static const String _themeKey = 'theme_mode';

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  // 1. 初始化逻辑 (保持大部分不变，但要确保能处理 'system')
  ThemeProvider(String? preloadedTheme) {
    if (preloadedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (preloadedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      // 如果没有存储过，或者存储的是 'system'，就跟随系统
      _themeMode = ThemeMode.system;
    }
  }

  // 2. (核心修改) 不再使用 toggleTheme，而是使用 setTheme
  // 允许传入三个选项：ThemeMode.system, ThemeMode.light, ThemeMode.dark
  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;

    String themeValue;
    if (mode == ThemeMode.dark) {
      themeValue = 'dark';
    } else if (mode == ThemeMode.light) {
      themeValue = 'light';
    } else {
      themeValue = 'system'; // 存入 system 标记
    }

    // 保存设置
    try {
      await _storage.write(key: _themeKey, value: themeValue);
    } catch (e) {
      print("Failed to save theme: $e");
    }

    notifyListeners();
  }
// 在 ThemeProvider 类中增加这个方法
  void nextThemeMode() {
    if (_themeMode == ThemeMode.system) {
      // 1. 如果当前是跟随系统 -> 切换到浅色
      setTheme(ThemeMode.light);
    } else if (_themeMode == ThemeMode.light) {
      // 2. 如果当前是浅色 -> 切换到深色
      setTheme(ThemeMode.dark);
    } else {
      // 3. 如果当前是深色 -> 切换回跟随系统
      setTheme(ThemeMode.system);
    }
  }
// 3. (可选) 如果你非要用 toggle (开关)，你需要决定开关关闭时是“变亮”还是“变自动”
// 但通常建议在 UI 上使用 下拉菜单 或 单选框 来切换这三种状态
}