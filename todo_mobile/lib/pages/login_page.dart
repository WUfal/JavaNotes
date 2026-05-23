import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. 导入我们需要的服务
import '../providers/auth_service.dart';
import '../services/auth_api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoginMode = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // 2. 实例化 API 服务
  final AuthApiService _authApiService = AuthApiService();
  final TextEditingController _confirmPasswordController = TextEditingController();
  // 3. (关键) 真实的提交方法
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() { _isLoading = true; });

    try {
      // --- 从表单获取数据 ---
      final username = _usernameController.text;
      final password = _passwordController.text;

      if (_isLoginMode) {
        // --- 模式：登录 ---
        final response = await _authApiService.login(username, password);

        if (response['success']) {
          // 登录成功！
          // 4. (关键) 调用 AuthService.login() 保存 Token
          //    (listen: false) 因为我们在一个回调函数中
          Provider.of<AuthService>(context, listen: false)
              .login(response['token'],
              response['selectedPath']);

          // (AuthService 会 notifyListeners, main.dart 的“门卫”会
          //  自动把我们切换到 MainPage, 所以我们不需要在这里 Navigator.push)

        } else {
          // 登录失败
          _showErrorDialog(response['message']);
        }

      } else {
        // --- 模式：注册 ---
        final response = await _authApiService.register(username, password);

        if (response['success']) {
          // 注册成功！
          _showSuccessDialog("注册成功！请使用新账户登录。");
          // 自动切换到登录模式
          _switchAuthMode();

        } else {
          // 注册失败 (例如，用户名已存在)
          _showErrorDialog(response['message']);
        }
      }
    } catch (e) {
      // 捕获网络异常等
      _showErrorDialog("发生未知错误: $e");
    } finally {
      // 确保无论成功失败，都关闭加载动画
      if (mounted) { // 检查 widget 是否还在树上
        setState(() { _isLoading = false; });
      }
    }
  }

  // --- 辅助方法：切换模式 ---
  void _switchAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  // --- 辅助方法：显示错误弹窗 ---
  void _showErrorDialog(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  // --- 辅助方法：显示成功弹窗 ---
  void _showSuccessDialog(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (build 方法里的 UI 部分保持 100% 不变) ...
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isLoginMode ? '欢迎回来' : '创建账户',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoginMode ? '请登录以继续' : '注册新用户',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: '用户名',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入用户名';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: '密码',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入密码';
                    }
                    if (value.length < 6) {
                      return '密码至少需要6位';
                    }
                    return null;
                  },
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: (
                      // (只在“注册”模式下显示)
                      !_isLoginMode
                          ? Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: '确认密码',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请再次输入密码';
                            }
                            // (关键验证)
                            if (value != _passwordController.text) {
                              return '两次输入的密码不一致';
                            }
                            return null;
                          },
                        ),
                      )
                          : const SizedBox.shrink() // (登录模式下，不占空间)
                  ),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isLoginMode ? '登 录' : '注 册',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _isLoginMode
                        ? '还没有账户？去注册'
                        : '已有账户？去登录',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}