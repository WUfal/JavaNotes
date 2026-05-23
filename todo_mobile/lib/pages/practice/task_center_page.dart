import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../../models/practice_generation_task.dart';
import '../../models/practice_question.dart';
import '../../services/api_service.dart';
import '../../providers/auth_service.dart';
import '../../utils/haptic_helper.dart';
import 'daily_question_page.dart';

class TaskCenterPage extends StatefulWidget {
  const TaskCenterPage({Key? key}) : super(key: key);

  @override
  State<TaskCenterPage> createState() => _TaskCenterPageState();
}

class _TaskCenterPageState extends State<TaskCenterPage> {
  List<PracticeGenerationTask> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // 加载任务列表
  Future<void> _loadTasks() async {
    final token = Provider.of<AuthService>(context, listen: false).token;
    final apiService = Provider.of<ApiService>(context, listen: false);

    try {
      final tasks = await apiService.fetchPracticeTasks(token);
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // 首次加载出错不弹窗，避免体验不好，只在控制台或 UI 状态体现即可
      }
    }
  }

  // 删除单个任务
  Future<void> _deleteTask(int taskId, int index) async {
    final token = Provider.of<AuthService>(context, listen: false).token;
    final apiService = Provider.of<ApiService>(context, listen: false);

    final removedTask = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });

    // 尝试震动反馈 (如果有这个工具类)
    try { HapticHelper.medium(context); } catch (_) {}

    try {
      await apiService.deletePracticeTask(token, taskId);
    } catch (e) {
      if (mounted) {
        // 恢复数据
        setState(() {
          _tasks.insert(index, removedTask);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("删除失败: $e")));
      }
    }
  }

  // 清空所有任务
  Future<void> _clearAllTasks() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("清空记录"),
        content: const Text("确定要删除所有历史任务吗？此操作不可恢复。"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("取消")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("清空", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final token = Provider.of<AuthService>(context, listen: false).token;
    final apiService = Provider.of<ApiService>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await apiService.clearAllPracticeTasks(token);
      if (mounted) {
        setState(() {
          _tasks.clear();
          _isLoading = false;
        });
        try { HapticHelper.heavy(context); } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("已清空所有任务"), behavior: SnackBarBehavior.floating)
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("清空失败: $e")));
      }
    }
  }

  // 点击任务
  void _handleTaskClick(PracticeGenerationTask task) {
    if (task.status == 'PENDING') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("AI 正在全力生成中，请稍候刷新..."),
            behavior: SnackBarBehavior.floating,
          )
      );
    } else if (task.status == 'FAILED') {
      // 优化：使用 BottomSheet 展示错误，比 Alert 更现代
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.error_outline, color: Colors.red, size: 28),
                  SizedBox(width: 12),
                  Text("任务生成失败", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.errorMessage ?? "未知错误，请稍后重试。",
                  style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("关闭"),
                ),
              )
            ],
          ),
        ),
      );
    } else if (task.status == 'COMPLETED') {
      try {
        List<dynamic> list = jsonDecode(task.questionsJson!);
        List<PracticeQuestion> questions = list.map((j) => PracticeQuestion.fromJson(j)).toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyQuestionPage(questions: questions),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("数据解析错误: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    // 背景色与配置页保持一致
    final bgColor = isDark
        ? colorScheme.surfaceVariant.withOpacity(0.3)
        : const Color(0xFFF8F9FC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("任务中心", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
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
        actions: [
          if (_tasks.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep_outlined, color: colorScheme.onSurfaceVariant),
              tooltip: "清空任务",
              onPressed: _clearAllTasks,
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : RefreshIndicator(
        onRefresh: _loadTasks,
        color: colorScheme.primary,
        child: _tasks.isEmpty
            ? _buildEmptyState(theme)
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            return _buildTaskItem(_tasks[index], index, theme, isDark);
          },
        ),
      ),
    );
  }

  // 优化后的空状态
  Widget _buildEmptyState(ThemeData theme) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.assignment_add, size: 60, color: theme.colorScheme.primary.withOpacity(0.4)),
              ),
              const SizedBox(height: 24),
              Text(
                "暂无生成记录",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "在配置页点击生成后，\nAI 将为你准备面试题目。",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 优化后的列表项
  Widget _buildTaskItem(PracticeGenerationTask task, int index, ThemeData theme, bool isDark) {
    final colorScheme = theme.colorScheme;

    IconData icon;
    Color statusColor;
    Color iconBgColor;
    String statusText;

    // 状态映射
    switch (task.status) {
      case 'PENDING':
        icon = Icons.hourglass_top_rounded;
        statusColor = Colors.orange;
        iconBgColor = Colors.orange.withOpacity(0.1);
        statusText = "生成中";
        break;
      case 'COMPLETED':
        icon = Icons.task_alt_rounded;
        statusColor = Colors.green;
        iconBgColor = Colors.green.withOpacity(0.1);
        statusText = "已就绪";
        break;
      case 'FAILED':
        icon = Icons.error_outline_rounded;
        statusColor = Colors.red;
        iconBgColor = Colors.red.withOpacity(0.1);
        statusText = "失败";
        break;
      default:
        icon = Icons.help_outline_rounded;
        statusColor = Colors.grey;
        iconBgColor = Colors.grey.withOpacity(0.1);
        statusText = task.status;
    }

    String timeStr;
    try {
      final DateTime dt = DateTime.parse(task.createdAt).toLocal();
      timeStr = DateFormat('MM-dd HH:mm').format(dt);
    } catch (e) {
      timeStr = "--:--";
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(task.id.toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text("删除", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.delete_outline, color: Colors.white, size: 28),
            ],
          ),
        ),
        // --- 核心优化：添加 confirmDismiss 进行二次确认 ---
        confirmDismiss: (direction) async {
          // 震动一下提醒用户
          try { HapticHelper.medium(context); } catch (_) {}

          return await showDialog<bool>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text("确认删除"),
                content: const Text("删除后将无法恢复此记录，确定要继续吗？"),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text("取消", style: TextStyle(color: colorScheme.secondary)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text("删除", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            },
          );
        },
        // -------------------------------------------
        onDismissed: (direction) {
          _deleteTask(task.id, index);
        },
        child: InkWell(
          onTap: () => _handleTaskClick(task),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              // 日间模式加淡边框，夜间模式透明
              border: Border.all(
                  color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.1),
                  width: 1
              ),
              // 增加轻微阴影
              boxShadow: isDark ? [] : [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // 左侧：状态图标块
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 16),

                  // 中间：标题和时间
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.summary,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: colorScheme.onSurface
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 12, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                            const SizedBox(width: 4),
                            Text(
                              timeStr,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.6)
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 右侧：状态标签
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 18, color: colorScheme.onSurfaceVariant.withOpacity(0.3)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}