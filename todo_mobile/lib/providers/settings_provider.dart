import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  // --- 1. 编辑器设置 ---
  double _editorFontSize = 14.0;
  bool _showLineNumbers = true;
  bool _autoSave = true; // 默认开启
  String _defaultLanguage = 'java'; // 新增：默认语言

  // --- 2. 交互与体验 ---
  bool _enableHapticFeedback = true; // 新增：震动反馈

  // --- 3. AI 设置 ---
  String _aiPersona = 'gentle'; // 新增：AI 人设 (gentle/strict/geek)

  // --- Getters ---
  double get editorFontSize => _editorFontSize;
  bool get showLineNumbers => _showLineNumbers;
  bool get autoSave => _autoSave;
  String get defaultLanguage => _defaultLanguage;
  bool get enableHapticFeedback => _enableHapticFeedback;
  String get aiPersona => _aiPersona;

  // --- 构造函数 (预加载) ---
  SettingsProvider(Map<String, String> initialValues) {
    if (initialValues['fontSize'] != null) {
      _editorFontSize = double.tryParse(initialValues['fontSize']!) ?? 14.0;
    }
    if (initialValues['showLineNumbers'] != null) {
      _showLineNumbers = initialValues['showLineNumbers'] == 'true';
    }
    if (initialValues['autoSave'] != null) {
      _autoSave = initialValues['autoSave'] == 'true';
    }
    if (initialValues['haptic'] != null) {
      _enableHapticFeedback = initialValues['haptic'] == 'true';
    }
    if (initialValues['language'] != null) {
      _defaultLanguage = initialValues['language']!;
    }
    if (initialValues['persona'] != null) {
      _aiPersona = initialValues['persona']!;
    }
  }

  // --- Actions (修改并保存) ---

  Future<void> setEditorFontSize(double value) async {
    _editorFontSize = value;
    notifyListeners();
    await _storage.write(key: 'fontSize', value: value.toString());
  }

  Future<void> setShowLineNumbers(bool value) async {
    _showLineNumbers = value;
    notifyListeners();
    await _storage.write(key: 'showLineNumbers', value: value.toString());
  }

  Future<void> setAutoSave(bool value) async {
    _autoSave = value;
    notifyListeners();
    await _storage.write(key: 'autoSave', value: value.toString());
  }

  Future<void> setHapticFeedback(bool value) async {
    _enableHapticFeedback = value;
    notifyListeners(); // 通知所有监听者 (包括 HapticHelper)
    await _storage.write(key: 'setting_haptic', value: value.toString());
  }

  Future<void> setDefaultLanguage(String value) async {
    _defaultLanguage = value;
    notifyListeners();
    await _storage.write(key: 'language', value: value);
  }

  Future<void> setAiPersona(String value) async {
    _aiPersona = value;
    notifyListeners();
    await _storage.write(key: 'persona', value: value);
  }
}