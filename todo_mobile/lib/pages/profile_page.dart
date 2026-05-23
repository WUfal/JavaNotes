import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_mobile/pages/badge_list_page.dart';
import 'package:todo_mobile/pages/practice_history_page.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_service.dart';
import '../utils/haptic_helper.dart';
import 'bookmark_list_page.dart';
import 'mistake_list_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dice_hexagram_page.dart';
import 'edit_profile_page.dart'; // 1. 导入编辑页面
import '../widgets/theme_widgets.dart';
class ProfilePage extends StatefulWidget {
  final bool isBeginner;
  const ProfilePage({Key? key, this.isBeginner = false}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _showLogoutDialog(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('确认退出', style: TextStyle(color: colorScheme.onSurface)),
          content: Text('你确定要退出登录吗？', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          actions: <Widget>[
            TextButton(
              child: Text('取消', style: TextStyle(color: colorScheme.onSurfaceVariant)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text(
                  '确认退出',
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.error)
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
            ),
          ],
        );
      },
    );
    if (didConfirm == true) {
      authService.logout();
    }
  }

  Future<void> _showSwitchPathDialog(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final newPath = widget.isBeginner ? "进阶" : "基础";
    final colorScheme = Theme.of(context).colorScheme;

    final bool? didConfirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('确认切换模式', style: TextStyle(color: colorScheme.onSurface)),
          content: Text('你确定要切换到 "$newPath" 模式吗？', style: TextStyle(color: colorScheme.onSurfaceVariant)),
          actions: <Widget>[
            TextButton(
              child: Text('取消', style: TextStyle(color: colorScheme.onSurfaceVariant)),
              onPressed: () => Navigator.of(dialogContext).pop(false),
            ),
            TextButton(
              child: Text(
                  '确认切换',
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)
              ),
              onPressed: () {
                  HapticHelper.medium(context);
                  Navigator.of(dialogContext).pop(true);}
            ),
          ],
        );
      },
    );
    if (didConfirm == true) {
      await authService.switchPath();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          '个人中心',
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_rounded, color: colorScheme.onSurfaceVariant),
            tooltip: '退出登录',
            onPressed: () => _showLogoutDialog(context),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // 头部个人信息卡片
          _buildProfileHeader(context),

          const SizedBox(height: 24),
          Text(
            "学习工具",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          if (widget.isBeginner) ..._buildBeginnerList(context) else ..._buildAdvancedList(context),
          const SizedBox(height: 24),
          Text(
            "设置与偏好",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          _buildSwitchPathCard(context),
          const SizedBox(height: 12),
          _buildDarkModeCard(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- 💡 核心部分：优化后的头部卡片 ---
  Widget _buildProfileHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 1. 外层 Container：负责“颜值”（渐变背景、圆角、阴影）
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary], // 动态渐变色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24), // 大圆角
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      // 2. Material：负责“画布”（透明背景，为了承载 InkWell 的水波纹）
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24), // 水波纹边界
          onTap: () {
            HapticHelper.light(context);
            // --- 跳转逻辑 ---
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfilePage(
                  // 可以在这里传入当前的昵称或头像 URL
                  // currentNickname: "新手学员",
                ),
              ),
            );
          },
          // 3. Padding：负责“内边距”
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // --- 左侧：头像区域 (带编辑徽章) ---
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colorScheme.onPrimary.withOpacity(0.5), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: colorScheme.surface,
                        // TODO: 绑定真实头像
                        child: Icon(Icons.person_rounded, size: 36, color: colorScheme.primary),
                      ),
                    ),
                    // 右下角的小编辑图标
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary, // 白色底
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit, size: 12, color: colorScheme.primary),
                      ),
                    )
                  ],
                ),

                const SizedBox(width: 16),

                // --- 中间：文字信息 ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO: 绑定真实昵称
                      Text(
                        widget.isBeginner ? "新手学员" : "进阶开发者",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "点击编辑资料",
                            style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.8), fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 10, color: colorScheme.onPrimary.withOpacity(0.8))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    Color? iconColor,
    Color? iconBgColor,
    required VoidCallback onTap,
    String? trailingText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final finalIconBg = iconBgColor ?? colorScheme.primaryContainer;
    final finalIconColor = iconColor ?? colorScheme.onPrimaryContainer;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.03),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: finalIconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: finalIconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                  ),
                ),
                if (trailingText != null)
                  Text(trailingText, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13)),
                Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBeginnerList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return [
      _buildMenuCard(
        title: '我的徽章',
        icon: Icons.emoji_events_rounded,
        iconColor: colorScheme.onTertiaryContainer,
        iconBgColor: colorScheme.tertiaryContainer,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgeListPage())),
      ),
      _buildMenuCard(
        title: '错题本',
        icon: Icons.edit_note_rounded,
        iconColor: colorScheme.onErrorContainer,
        iconBgColor: colorScheme.errorContainer,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MistakeListPage())),
      ),
      _buildMenuCard(
        title: '卦象',
        icon: FontAwesomeIcons.yinYang,
        iconColor: colorScheme.onSecondaryContainer,
        iconBgColor: colorScheme.secondaryContainer,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OraclePage())),
      )
    ];
  }

  List<Widget> _buildAdvancedList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return [
      _buildMenuCard(
        title: '我的收藏',
        icon: Icons.bookmark_rounded,
        iconColor: colorScheme.onSecondaryContainer,
        iconBgColor: colorScheme.secondaryContainer,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BookmarkListPage()));}
      ),
      _buildMenuCard(
        title: '刷题统计',
        icon: Icons.bar_chart_rounded,
        iconColor: colorScheme.onPrimaryContainer,
        iconBgColor: colorScheme.primaryContainer,
        onTap: ()  {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PracticeHistoryPage()));}
      ),
    ];
  }

  Widget _buildSwitchPathCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _buildMenuCard(
      title: widget.isBeginner ? '切换到进阶模式' : '切换到基础模式',
      icon: Icons.swap_horiz_rounded,
      iconColor: colorScheme.onSurfaceVariant,
      iconBgColor: colorScheme.surfaceContainerHighest,
      onTap: () => _showSwitchPathDialog(context),
      trailingText: widget.isBeginner ? 'B路径' : 'A路径',
    );
  }

  Widget _buildDarkModeCard(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final colorScheme = Theme.of(context).colorScheme;

        // 1. 根据当前模式，准备显示的文案和图标
        String statusText;
        IconData statusIcon;

        switch (provider.themeMode) {
          case ThemeMode.system:
            statusText = '跟随系统';
            statusIcon = Icons.brightness_auto_rounded;
            break;
          case ThemeMode.dark:
            statusText = '深色模式';
            statusIcon = Icons.dark_mode_rounded;
            break;
          case ThemeMode.light:
            statusText = '浅色模式';
            statusIcon = Icons.light_mode_rounded;
            break;
        }

        // 2. 直接复用你的 _buildMenuCard 组件
        return _buildMenuCard(
          title: '外观设置', // 标题
          icon: statusIcon, // 动态图标
          iconColor: colorScheme.onSurfaceVariant, // 与上面保持一致的配色
          iconBgColor: colorScheme.surfaceContainerHighest,
          trailingText: statusText, // 右侧显示当前状态
          onTap: () => _showThemeSelectDialog(context, provider), // 点击弹窗
        );
      },
    );
  }
  void _showThemeSelectDialog(BuildContext context, ThemeProvider provider) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true, // 允许自适应高度
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;

        // 获取当前状态
        bool isSystem = provider.themeMode == ThemeMode.system;
        // 如果是系统模式，从系统获取当前亮度；否则直接判断是否为 Dark
        bool isDarkDisplay = isSystem
            ? MediaQuery.of(context).platformBrightness == Brightness.dark
            : provider.themeMode == ThemeMode.dark;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 顶部小横条
                Center(
                  child: Container(
                    width: 32, height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // 标题（可选）
                Text(
                  "外观设置",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface
                  ),
                ),
                const SizedBox(height: 16),

                // ====================================================
                // 2. 跟随系统开关 (大卡片样式，对应你的路径切换样式)
                // ====================================================
                Container(
                  decoration: BoxDecoration(
                    // 使用较高的容器颜色，使其突显
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  child: SwitchListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.surface, // 图标背景
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.brightness_auto_rounded, color: colorScheme.primary),
                    ),
                    title: const Text("跟随系统", style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text("根据手机设置自动切换", style: TextStyle(fontSize: 12)),
                    value: isSystem,
                    activeColor: colorScheme.primary,
                    onChanged: (val) {
                      if (val) {
                        HapticHelper.medium(context); // 插入触觉反馈
                        provider.setTheme(ThemeMode.system);
                      } else {
                        // 关闭跟随系统时，保持当前的视觉亮度，平滑过渡
                        HapticHelper.medium(context); // 插入触觉反馈
                        provider.setTheme(isDarkDisplay ? ThemeMode.dark : ThemeMode.light);
                      }
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ====================================================
                // 3. 模式选择 (小的模式开关)
                // ====================================================
                // 使用 AnimatedOpacity 让禁用状态切换更丝滑
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isSystem ? 0.5 : 1.0, // 如果跟随系统，变半透明
                  child: IgnorePointer(
                    ignoring: isSystem, // 如果跟随系统，禁止点击
                    child: Container(
                      // 这里不加背景色或者加很淡的背景，显得比上面那个“小”
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 左侧说明
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              Icon(
                                isDarkDisplay ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                size: 20,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                  "深色模式",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: colorScheme.onSurface
                                  )
                              ),
                            ],
                          ),

                          // 右侧小开关
                          Transform.scale(
                            scale: 0.8, // 缩小开关尺寸，体现“小开关”的感觉
                            child: Switch(
                              value: isDarkDisplay,
                              onChanged: (val) {
                                HapticHelper.light(context); // 插入触觉反馈
                                provider.setTheme(val ? ThemeMode.dark : ThemeMode.light);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}