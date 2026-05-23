import 'package:flutter/material.dart';

// 一个可复用的 Widget，用于显示“空”、“错误”或“无内容”
class PlaceholderWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry; // (可选) 用于显示“重试”按钮

  const PlaceholderWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. 图标
            Icon(
              icon,
              size: 80,
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
            ),
            const SizedBox(height: 24),

            // 2. 标题
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 3. 消息
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),

            // 4. (可选) 重试按钮
            if (onRetry != null)
              FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('重 试'),
                onPressed: onRetry,
              )
          ],
        ),
      ),
    );
  }
}