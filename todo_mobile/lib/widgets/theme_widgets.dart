import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 记得导入你的 ThemeProvider 文件
import '../providers/theme_provider.dart';
import '../utils/haptic_helper.dart';

// 公共函数：显示外观设置弹窗
void showThemeSelectDialog(BuildContext context) {
  // 在这里查找 Provider，调用者不需要手动传
  final provider = Provider.of<ThemeProvider>(context, listen: false);

  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext context) {
      // 为了让弹窗内的 Switch 也能实时更新 UI，这里需要再包一层 Consumer
      // 或者直接使用 StatefulWidget，但用 Consumer 最简单
      return Consumer<ThemeProvider>(
        builder: (context, provider, _) {
          final colorScheme = Theme.of(context).colorScheme;

          bool isSystem = provider.themeMode == ThemeMode.system;
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
                  Text(
                    "外观设置",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 跟随系统开关
                  Container(
                    decoration: BoxDecoration(
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
                          color: colorScheme.surface,
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
                          HapticHelper.light(context);
                          provider.setTheme(ThemeMode.system);
                        } else {
                          HapticHelper.light(context);
                          provider.setTheme(isDarkDisplay ? ThemeMode.dark : ThemeMode.light);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 模式选择
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isSystem ? 0.5 : 1.0,
                    child: IgnorePointer(
                      ignoring: isSystem,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                    style: TextStyle(fontSize: 15, color: colorScheme.onSurface)
                                ),
                              ],
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: isDarkDisplay,
                                onChanged: (val) {
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
    },
  );
}
class ThemeSettingCard extends StatelessWidget {
  const ThemeSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final colorScheme = Theme.of(context).colorScheme;

        // 1. 准备数据
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

        // 2. 这里我写了一个标准的 ListTile 样式
        // 如果你有全局的 CommonCard 组件，也可以换成那个
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8), // 可选的外边距
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow, // 你的卡片背景色
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.03),
                  offset: const Offset(0, 4),
                  blurRadius: 12
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

            // 左侧图标
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest, // 图标背景
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: colorScheme.onSurfaceVariant),
            ),

            // 标题
            title: const Text(
                "外观设置",
                style: TextStyle(fontWeight: FontWeight.bold)
            ),

            // 右侧状态文字 + 箭头
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    statusText,
                    style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant)
                ),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 20, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
              ],
            ),

            // 点击事件：调用全局弹窗函数
            onTap: () {
              HapticHelper.light(context);
              showThemeSelectDialog(context);}
          ),
        );
      },
    );
  }
}