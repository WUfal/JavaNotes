import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/bookmark_list_page.dart';
import '../pages/notebook/notebook_home_page.dart';
import '../pages/practice/daily_practice_config_page.dart';
import '../pages/settings_page.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../pages/practice/daily_practice_config_page.dart';
import '../pages/practice/daily_practice_config_page.dart';
import '../utils/haptic_helper.dart';
class AppDrawer extends StatelessWidget {
  final int currentTab;

  const AppDrawer({Key? key, this.currentTab = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          // 1. 头部
          _buildHeader(context, colorScheme),

          // 2. 菜单列表
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildSectionTitle(context, "主要功能"),
                _buildDrawerItem(
                  context,
                  icon: Icons.school_rounded,
                  label: "学习中心",
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.edit_note_rounded,
                  label: "学习记录本",
                  subtitle: "记录心得，导出 PDF",
                  onTap: () {
                    HapticHelper.light(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotebookHomePage()),
                    );
                  },
                ),

                const SizedBox(height: 16),
                _buildSectionTitle(context, "快捷入口"),
                _buildDrawerItem(
                  context,
                  icon: Icons.whatshot_rounded,
                  label: "每日一练",
                  onTap: () {
                    HapticHelper.light(context);
                    Navigator.pop(context); // 关闭侧边栏
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DailyPracticeConfigPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.bookmark_rounded,
                  label: "我的收藏",
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BookmarkListPage()),
                    );
                  },
                ),

                const Divider(height: 32),

                _buildDrawerItem(
                  context,
                  icon: Icons.settings_rounded,
                  label: "设置",
                    onTap: () {
                      HapticHelper.light(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                      );
                    }
                ),
              ],
            ),
          ),

          // 3. 底部
          _buildFooter(context, colorScheme, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
      ),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final profile = userProvider.userProfile;

          // 获取数据
          final String displayName = profile?.nickname ?? "Java 学习助手";
          final String subTitle = profile?.username ?? "坚持学习，每天进步";
          final String avatarId = profile?.avatarId ?? "default";

          return Row(
            children: [
              // 头像区域
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary, width: 2),
                ),
                // 调用您的头像构建逻辑，并传入较大的 radius (例如 30)
                child: _buildAvatar(avatarId, displayName, colorScheme, radius: 30),
              ),
              const SizedBox(width: 16),

              // 文字信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 💡 核心修改：采用了您提供的头像逻辑 (增加了 radius 参数以便调整大小)
  Widget _buildAvatar(String avatarId, String username, ColorScheme colorScheme, {double radius = 20}) {
    // 1. 默认头像 (显示首字母)
    if (avatarId == 'default' || avatarId.isEmpty) {
      return CircleAvatar(
        radius: radius,
        // 使用 Primary Container 颜色，保证对比度
        backgroundColor: colorScheme.primaryContainer,
        child: Text(
          username.isNotEmpty ? username[0].toUpperCase() : '?',
          // 使用 On Primary Container 颜色，保证文字清晰
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.8, // 字体大小随半径自适应
          ),
        ),
      );
    }

    // 2. 图片头像 (Asset)
    return CircleAvatar(
      // 给图片头像也加一个底色，防止透明图片在黑底上看不清
      backgroundColor: colorScheme.surfaceContainerHighest,
      radius: radius,
      child: Transform.scale(
        scale: 2.4, // 您的缩放参数
        child: Image.asset(
          'assets/images/$avatarId.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // 如果图片加载失败，回退到默认图标
            return Icon(Icons.person, color: colorScheme.onSurfaceVariant);
          },
        ),
      ),
    );
  }

  // ... 其他辅助构建方法保持不变 ...
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        String? subtitle,
        required VoidCallback onTap,
        bool isSelected = false,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: isSelected ? colorScheme.secondaryContainer : null,
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        leading: Icon(
            icon,
            color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurface,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant))
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<ThemeProvider>(
            builder: (context, provider, _) {
              final mode = provider.themeMode;

              // 1. 判断是否处于“跟随系统”状态
              final isSystem = mode == ThemeMode.system;

              // 2. 获取当前实际显示的颜色（关键步骤）
              // 如果是 System 模式，通过 MediaQuery 获取手机当前的亮度
              // 如果是 Manual 模式，直接判断是否是 Dark
              final isActuallyDark = isSystem
                  ? MediaQuery.of(context).platformBrightness == Brightness.dark
                  : mode == ThemeMode.dark;

              return Row(
                children: [
                  IconButton(
                    // 3. 交互逻辑：
                    // 如果是系统模式 (isSystem为true)，onPressed 设为 null，按钮变灰不可点
                    // 如果是手动模式，点击则取反
                    onPressed: isSystem
                        ? null
                        : () {
                      // 在 深色 和 浅色 之间反复横跳
                      provider.setTheme(isActuallyDark ? ThemeMode.light : ThemeMode.dark);
                    },

                    // 4. 图标逻辑：只根据“实际看起来是黑是白”来显示，不显示 Auto 图标
                    icon: Icon(isActuallyDark ? Icons.dark_mode : Icons.light_mode),

                    // 5. 颜色微调（可选）：
                    // 如果是系统模式（disabled），Icon默认会变灰。
                    // 如果你想让它在系统模式下依然高亮，可以在这里强行指定颜色，
                    // 但通常建议保留 disable 状态让用户知道现在不能点。
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    style: IconButton.styleFrom(
                      // 正常状态的前景色
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                      // 禁用状态的前景色 (设为和正常颜色一样，就不会变灰了)
                      disabledForegroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    // 提示文案
                    tooltip: isSystem ? "当前跟随系统设置" : "切换深色/浅色",
                  ),
                  const SizedBox(width: 8),

                  // 6. 文字逻辑
                  Text(
                    isActuallyDark ? "深色" : "浅色",
                    style: TextStyle(
                      fontSize: 12,
                      // 如果是系统模式，文字颜色也可以淡一点，表示不可操作
                      color: isSystem
                          ? Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(1.0)
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),

                  // (可选) 如果是系统模式，加个小尾巴提示用户
                  if (isSystem)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(Icons.auto_awesome, size: 6, color: Theme.of(context).colorScheme.primary),
                    ),
                ],
              );
            },
          ),
          Text(
            "v1.0.0",
            style: TextStyle(color: colorScheme.outline, fontSize: 12),
          ),
        ],
      ),
    );
  }
}