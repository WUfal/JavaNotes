import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todo_mobile/pages/practice/practice_history_detail_page.dart';

import '../../providers/practice_history_provider.dart';
import '../../models/practice_record.dart';
import 'package:flutter/services.dart';
class PracticeHistoryPage extends StatefulWidget {
  const PracticeHistoryPage({Key? key}) : super(key: key);

  @override
  State<PracticeHistoryPage> createState() => _PracticeHistoryPageState();
}

class _PracticeHistoryPageState extends State<PracticeHistoryPage> {
  @override
  void initState() {
    super.initState();
    // 页面进入时刷新数据
    Future.microtask(() =>
        Provider.of<PracticeHistoryProvider>(context, listen: false).loadRecords());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 统一背景色
    final bgColor = isDark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
        : const Color(0xFFF8F9FC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("刷题统计", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // ⬇️⬇️⬇️ 关键修改在这里 ⬇️⬇️⬇️
        systemOverlayStyle: SystemUiOverlayStyle(
          // 1. 设置状态栏背景为透明
          statusBarColor: Colors.transparent,

          // 2. Android 设置：
          // 如果是暗黑模式(isDark)，图标要亮的(白色) -> Brightness.light
          // 如果是白天模式(!isDark)，图标要暗的(黑色) -> Brightness.dark  <-- 这就是您需要的效果
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,

          // 3. iOS 设置 (逻辑通常是反的，控制的是背景亮度感知)：
          // 白天模式下，告诉 iOS 背景是亮的(Light)，它就会自动把字变成黑色
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        // ⬆️⬆️⬆️ 关键修改结束 ⬆️⬆️⬆️
      ),
      body: Consumer<PracticeHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.records.isEmpty) {
            return _buildEmptyState(context);
          }

          // 按时间倒序排列 (如果 Provider 没排的话)
          // provider.records.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: provider.records.length,
            separatorBuilder: (ctx, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = provider.records[index];
              return _buildHistoryCard(context, record, isDark);
            },
          );
        },
      ),
    );
  }

  // --- UI 组件封装 ---

  Widget _buildHistoryCard(BuildContext context, PracticeRecord record, bool isDark) {
    final theme = Theme.of(context);
    final date = DateTime.parse(record.createdAt);

    // 评分颜色逻辑
    final bool isPass = record.score >= 6;
    final Color statusColor = isPass ? Colors.green : Colors.orange;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PracticeHistoryDetailPage(record: record),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.1),
          ),
          boxShadow: isDark ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // 左侧：分数块
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${record.score}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: statusColor,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    "分",
                    style: TextStyle(
                        fontSize: 10,
                        color: statusColor.withOpacity(0.8),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // 中间：信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.onSurface
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // 类型标签
                      _buildTag(context, record.type),
                      const SizedBox(width: 10),
                      // 时间显示
                      Icon(Icons.access_time, size: 12, color: theme.colorScheme.outline),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MM-dd HH:mm').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 右侧：箭头
            Icon(Icons.chevron_right, color: theme.colorScheme.outline.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }

  // 类型标签组件
  Widget _buildTag(BuildContext context, String type) {
    String label;
    Color color;

    switch (type) {
      case 'CHOICE':
        label = "选择题";
        color = Colors.purple;
        break;
      case 'CODE':
        label = "编程题";
        color = Colors.blue;
        break;
      case 'QA':
        label = "简答题";
        color = Colors.orange;
        break;
      default:
        label = type;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 空状态组件
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_edu, size: 64, color: theme.colorScheme.primary.withOpacity(0.4)),
          ),
          const SizedBox(height: 24),
          Text(
            "暂无练习记录",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7)
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "去完成每日一练，\n在这里回顾你的成长足迹。",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}