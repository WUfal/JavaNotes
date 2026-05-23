import 'package:flutter/material.dart';

// 这是一个通用的“灰色骨架块”
class SkeletonLoader extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;

  const SkeletonLoader({
    Key? key,
    this.height,
    this.width,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// 这是一个专门“模仿”我们 ListTile 的骨架
class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // (左侧图标的骨架)
          const SkeletonLoader(height: 24, width: 24, borderRadius: 24),
          const SizedBox(width: 16),
          // (右侧文字的骨架)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader(height: 16, width: 150), // 标题
                const SizedBox(height: 8),
                const SkeletonLoader(height: 14, width: 250), // 描述
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// --- ⬇️ (新增) 专门“模仿”我们 Project Card 的骨架 ⬇️ ---
class ProjectCardSkeleton extends StatelessWidget {
  const ProjectCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 模仿标题
            const SkeletonLoader(height: 18, width: 200),
            const SizedBox(height: 16),

            // 2. 模仿描述
            const SkeletonLoader(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            const SkeletonLoader(height: 14, width: 250),
            const SizedBox(height: 16),

            // 3. 模仿 Chip (技术栈)
            const SkeletonLoader(height: 32, width: 120, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}
// --- ⬇️ (新增) 专门“模仿”我们 ExpansionTile (闯关) 的骨架 ⬇️ ---
class ExpansionTileSkeleton extends StatelessWidget {
  const ExpansionTileSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // (这是对我们 ExpansionTile + ListTile 结构的模仿)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 模仿 "大关卡" (ExpansionTile 的标题)
          Row(
            children: const [
              Expanded(
                child: SkeletonLoader(height: 20, width: 200), // 标题
              ),
              SizedBox(width: 16),
              SkeletonLoader(height: 24, width: 24), // 展开箭头
            ],
          ),
          const SizedBox(height: 16),

          // 2. 模仿展开后的 "小关卡" (ListTile)
          //    (我们复用 ListTileSkeleton，但去掉它的外边距)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: const [
                ListTileSkeleton(),
                ListTileSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}