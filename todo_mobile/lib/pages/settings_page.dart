import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 用于震动 HapticFeedback
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/auth_service.dart';
import '../utils/haptic_helper.dart';
import 'edit_profile_page.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../widgets/theme_widgets.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // 震动反馈辅助方法
  void _tryHaptic(BuildContext context) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);

    if (settings.enableHapticFeedback) {
      // 1. 检查设备是否支持震动
      if (await Vibration.hasVibrator() ?? false) {
        // 2. 强制震动 50 毫秒 (短促有力的“嗡”一下)
        // (你可以调整这个数值，30-50ms 手感最好，超过 100ms 会像来电)
        Vibration.vibrate(duration: 100);
      }
    }
  }

  Future<void> _clearCache(BuildContext context) async {
    _tryHaptic(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );
    await Future.delayed(const Duration(milliseconds: 1000));
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ 缓存清理成功！"))
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    _tryHaptic(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("退出登录"),
        content: const Text("确定要退出当前账号吗？"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("取消")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("退出", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settings = Provider.of<SettingsProvider>(context); // 监听设置变化

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text("设置", style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            backgroundColor: colorScheme.surface,
          ),
          SliverList(
            delegate: SliverChildListDelegate([

              // 1. 外观
              _buildSectionHeader("外观与显示", colorScheme),
              const ThemeSettingCard(),

              // 2. AI 设置 (新功能)
              _buildSectionHeader("AI 助教设置", colorScheme),
              ListTile(
                leading: Icon(Icons.psychology, color: colorScheme.onSurfaceVariant),
                title: const Text("AI 人设风格"),
                subtitle: Text(_getPersonaName(settings.aiPersona)),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: settings.aiPersona,
                    onChanged: (val) {
                      if (val != null) settings.setAiPersona(val);
                    },
                    items: const [
                      DropdownMenuItem(value: 'gentle', child: Text('🌸 温柔老师')),
                      DropdownMenuItem(value: 'strict', child: Text('🔥 严厉面试官')),
                      DropdownMenuItem(value: 'geek', child: Text('💻 极客风格')),
                      DropdownMenuItem(value: 'original', child: Text('🤖 原始风格')),
                    ],
                  ),
                ),
              ),

              // 3. 编辑器偏好
              _buildSectionHeader("编辑器偏好", colorScheme),

              // 字体大小
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.format_size, color: colorScheme.onSurfaceVariant),
                    title: const Text("代码字体大小"),
                    trailing: Text("${settings.editorFontSize.toInt()} px",
                        style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                  ),
                  Slider(
                    value: settings.editorFontSize,
                    min: 10, max: 24, divisions: 14,
                    activeColor: colorScheme.primary,
                    onChanged: (val) {
                      HapticHelper.light(context);
                      settings.setEditorFontSize(val);}
                  ),
                ],
              ),

              // 显示行号
              SwitchListTile(
                secondary: Icon(Icons.format_list_numbered, color: colorScheme.onSurfaceVariant),
                title: const Text("显示行号"),
                value: settings.showLineNumbers,
                onChanged: (val) {
                  HapticHelper.light(context);
                  settings.setShowLineNumbers(val);}
              ),

              // 自动保存
              SwitchListTile(
                secondary: Icon(Icons.save_as, color: colorScheme.onSurfaceVariant),
                title: const Text("自动保存笔记"),
                subtitle: const Text("退出编辑器时自动保存"),
                value: settings.autoSave,
                onChanged: (val) {
                  HapticHelper.light(context);
                  settings.setAutoSave(val);}
              ),

              // 默认语言 (新功能)
              ListTile(
                leading: Icon(Icons.code, color: colorScheme.onSurfaceVariant),
                title: const Text("默认编程语言"),
                subtitle: Text(settings.defaultLanguage.toUpperCase()),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context, settings),
              ),

              // 4. 交互
              _buildSectionHeader("交互体验", colorScheme),
              SwitchListTile(
                secondary: Icon(Icons.vibration, color: colorScheme.onSurfaceVariant),
                title: const Text("震动反馈"),
                subtitle: const Text("按键时的触感反馈"),
                value: settings.enableHapticFeedback,
                onChanged: (val) {
                    HapticHelper.light(context);
                    settings.setHapticFeedback(val); }
              ),

              // 5. 其他
              _buildSectionHeader("其他", colorScheme),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("个人资料"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage())),
              ),
              ListTile(
                leading: const Icon(Icons.cleaning_services),
                title: const Text("清除缓存"),
                onTap: () => _clearCache(context),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("退出登录", style: TextStyle(color: Colors.red)),
                onTap: () => _showLogoutDialog(context),
              ),

              const SizedBox(height: 50),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 8),
      child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary)),
    );
  }

  String _getPersonaName(String key) {
    switch (key) {
      case 'strict': return '🔥严厉面试官';
      case 'geek': return '💻极客风格';
      case 'original': return '🤖 原始风格'; // <--- (新增)
      default: return '🌸温柔老师';
    }
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("选择默认语言"),
        children: ['java'].map((lang) {
          return SimpleDialogOption(
            onPressed: () {
              settings.setDefaultLanguage(lang);
              Navigator.pop(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(lang.toUpperCase()),
            ),
          );
        }).toList(),
      ),
    );
  }
}