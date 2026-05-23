import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_service.dart';
import '../services/api_service.dart'; // 我们的“刷卡”服务

class PathSelectionPage extends StatefulWidget {
  const PathSelectionPage({Key? key}) : super(key: key);

  @override
  State<PathSelectionPage> createState() => _PathSelectionPageState();
}

class _PathSelectionPageState extends State<PathSelectionPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  // (关键) 处理路径选择
  Future<void> _selectPath(String path) async {
    setState(() { _isLoading = true; });

    try {
      // 1. (关键) 从 AuthService 获取当前用户的 Token
      //    (listen: false) 因为我们在一个回调函数中
      final String? token = Provider.of<AuthService>(context, listen: false).token;

      if (token == null) {
        throw Exception("User is not authenticated.");
      }

      // 2. (关键) 调用我们新创建的 API，将选择保存到后端
      bool success = await _apiService.saveUserPath(token, path);

      if (success && mounted) {
        // 3. (关键) 通知本地 AuthService，“路径已更新！”
        //    (listen: false)
        Provider.of<AuthService>(context, listen: false).updatePath(path);

        // (AuthService 会 notifyListeners, main.dart 的“门卫”会
        //  自动把我们切换到 MainPage, 所以我们不需要在这里 Navigator.push)
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("保存失败: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '你的Java学习之旅',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '你目前的编程基础是？',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 48),

              // --- 按钮 A (小白) ---
              ElevatedButton.icon(
                icon: const Icon(Icons.baby_changing_station, size: 28),
                label: const Text('我是编程小白', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _selectPath("BEGINNER"), // <--- (注意)
              ),

              const SizedBox(height: 24),

              // --- 按钮 B (进阶) ---
              ElevatedButton.icon(
                icon: const Icon(Icons.school, size: 28),
                label: const Text('我有一些基础', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _selectPath("ADVANCED"), // <--- (注意)
              ),
            ],
          ),
        ),
      ),
    );
  }
}