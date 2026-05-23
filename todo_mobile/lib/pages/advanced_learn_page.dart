import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/course_module.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import '../utils/haptic_helper.dart';
import 'content_detail_page.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';
import 'search_page.dart';

class AdvancedLearnPage extends StatefulWidget {
  const AdvancedLearnPage({Key? key}) : super(key: key);
  @override
  State<AdvancedLearnPage> createState() => _AdvancedLearnPageState();
}

class _AdvancedLearnPageState extends State<AdvancedLearnPage> with AutomaticKeepAliveClientMixin {
  Future<List<ModuleGroup>>? _modulesFuture;
  late ApiService _apiService;
  String? _token;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;
    if (_modulesFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _modulesFuture = _apiService.fetchAdvancedModules(_token);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _modulesFuture = _apiService.fetchAdvancedModules(_token);
    });
    await _modulesFuture;
  }

  void _retry() {
    _loadData();
  }

  Widget _buildLoadingShimmer() {
    final colorScheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 24, width: 120, color: colorScheme.surface),
            const SizedBox(height: 16),
            Container(height: 80, decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 12),
            Container(height: 80, decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(16))),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
          "进阶学习",
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
            tooltip: '搜索',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu), // 汉堡菜单图标
          tooltip: '打开侧边栏',
          onPressed: () {
            // 打开 MainPage (父级 Scaffold) 的 Drawer
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: FutureBuilder<List<ModuleGroup>>(
        future: _modulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return _buildLoadingShimmer();
          if (snapshot.hasError) {
            return PlaceholderWidget(
              icon: Icons.error_outline,
              title: '加载失败',
              message: '无法连接到服务器',
              onRetry: _retry,
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const PlaceholderWidget(
              icon: Icons.school_outlined,
              title: '暂无课程',
              message: '我们正在努力准备课程',
            );
          }

          final List<ModuleGroup> moduleGroups = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: colorScheme.primary,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: moduleGroups.length,
              itemBuilder: (context, groupIndex) {
                final group = moduleGroups[groupIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGroupHeader(group.groupTitle, colorScheme),
                    ...group.items.map((item) {
                      return ModernModuleCard(
                        title: item.title,
                        description: item.description,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContentDetailPage(moduleId: item.id, moduleTitle: item.title),
                            ),
                          );
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class ModernModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const ModernModuleCard({Key? key, required this.title, required this.description, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    // 使用 Secondary Container 区别于基础课程
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.library_books_rounded, color: colorScheme.onSecondaryContainer, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(description, style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant.withOpacity(0.5), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}