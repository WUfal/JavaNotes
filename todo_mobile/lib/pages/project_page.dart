import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/project.dart';
import '../utils/haptic_helper.dart';
import 'project_detail_page.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/placeholder_widget.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);
  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> with AutomaticKeepAliveClientMixin {
  Future<List<ProjectSummary>>? _projectsFuture;
  late ApiService _apiService;
  String? _token;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;
    if (_projectsFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _projectsFuture = _apiService.fetchProjects(_token);
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _projectsFuture = _apiService.fetchProjects(_token);
    });
    await _projectsFuture;
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
        padding: const EdgeInsets.only(top: 16),
        itemCount: 3,
        itemBuilder: (_, __) => Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(20)),
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
        title: Row(
          children: [
            Text(
              '实战项目',
              style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.tertiary.withOpacity(0.2))
              ),
              child: Text(
                "Pro",
                style: TextStyle(color: colorScheme.onTertiaryContainer, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      body: FutureBuilder<List<ProjectSummary>>(
        future: _projectsFuture,
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
            return PlaceholderWidget(
              icon: Icons.rocket_launch_outlined,
              title: '暂无项目',
              message: '新项目正在开发中...',
              onRetry: _retry,
            );
          }

          final projects = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: colorScheme.primary,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return PortfolioProjectCard(
                  title: project.title,
                  description: project.description,
                  techStack: project.techStack,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailPage(projectSummary: project)));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PortfolioProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final String techStack;
  final VoidCallback onTap;

  const PortfolioProjectCard({Key? key, required this.title, required this.description, required this.techStack, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.06),
            offset: const Offset(0, 8),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        // 使用 Tertiary 色系来强调项目
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colorScheme.tertiary.withOpacity(0.1), width: 1)
                      ),
                      child: Icon(Icons.rocket_launch_rounded, color: colorScheme.onTertiaryContainer, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface, height: 1.2)),
                          const SizedBox(height: 6),
                          Text(description, style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant.withOpacity(0.5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Icon(Icons.terminal_rounded, size: 16, color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        techStack,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurfaceVariant, fontFamily: "monospace"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("开始实战", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.onTertiaryContainer)),
                          const SizedBox(width: 2),
                          Icon(Icons.arrow_forward_rounded, size: 12, color: colorScheme.onTertiaryContainer)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}