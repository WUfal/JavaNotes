import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart'; // 1. 导入插件
import '../providers/settings_provider.dart';

class HapticHelper {

  // 内部辅助：尝试使用插件震动，失败则回退到原生
  static Future<void> _vibrate({int duration = 10}) async {
    // 检查设备是否支持自定义震动
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: duration);
    } else {
      // 如果不支持（比如部分旧手机），回退到原生触感
      HapticFeedback.lightImpact();
    }
  }

  static void slight(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.enableHapticFeedback) {
      _vibrate(duration: 1);
    }
  }
  /// 触发轻微震动 (适合普通点击) -> 改为 10ms
  static void light(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.enableHapticFeedback) {
      _vibrate(duration: 10);
    }
  }

  /// 触发中等震动 (适合成功操作、开关) -> 改为 30ms
  static void medium(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.enableHapticFeedback) {
      _vibrate(duration: 30);
    }
  }

  /// 触发重震动 (适合删除、报错) -> 改为 50ms
  static void heavy(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    if (settings.enableHapticFeedback) {
      _vibrate(duration: 50);
    }
  }
}