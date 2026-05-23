import 'dart:convert';
import 'dart:io'; // (用于 SocketException)
import 'package:http/http.dart' as http;

class AuthApiService {

  static const String _domain = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
  static const String _baseUrl = "$_domain/api/auth";

  // (辅助方法：返回更清晰的错误)
  Map<String, dynamic> _handleError(dynamic e) {
    if (e is SocketException) {
      return {'success': false, 'message': '连接失败：请检查服务器 IP 和防火墙设置。 (SocketException)'};
    }
    if (e is http.ClientException) {
      return {'success': false, 'message': '连接被拒绝：请确保手机和电脑在同一 WiFi 下。 (ClientException)'};
    }
    return {'success': false, 'message': '未知网络错误: $e'};
  }

  // 1. 注册方法 (已升级 try-catch)
  Future<Map<String, dynamic>> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        // (返回后端 *真实* 的错误, e.g., "Username is already taken!")
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // 2. 登录方法 (已升级 try-catch)
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return {'success': true, 'token': responseData['token'], 'selectedPath': responseData['selectedPath']};
      } else {
        // (后端 401 错误)
        return {'success': false, 'message': '用户名或密码错误'};
      }
    } catch (e) {
      return _handleError(e);
    }
  }
}
