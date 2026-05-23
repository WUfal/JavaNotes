import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
// (导入)
import '../models/search_result.dart';
import '../providers/auth_service.dart';
import '../services/api_service.dart';
import '../widgets/placeholder_widget.dart';
import '../widgets/skeleton_loader.dart';

// (导入 B 路径详情页)
import 'content_detail_page.dart';
import 'project_detail_page.dart';
import 'algorithm_detail_page.dart';

// (导入 B 路径摘要模型)
import '../models/project.dart';
import '../models/algorithm.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ApiService _apiService;
  String? _token;
  final TextEditingController _searchController = TextEditingController();
  Future<List<SearchResult>>? _resultsFuture;
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // (依赖注入)
    _apiService = Provider.of<ApiService>(context, listen: false);
    _token = Provider.of<AuthService>(context, listen: false).token;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // (搜索防抖逻辑 - 不变)
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          _resultsFuture = _apiService.search(_token, query);
        });
      } else {
        setState(() {
          _resultsFuture = null;
        });
      }
    });
  }

  // (辅助) 获取图标
  IconData _getIconForType(String type) {
    switch (type) {
      case "COURSE_MODULE": return Icons.school;
      case "PROJECT": return Icons.code;
      case "ALGORITHM": return Icons.computer;
      default: return Icons.bookmark;
    }
  }

  // (辅助) 导航
  void _navigateToDetail(BuildContext context, SearchResult result) {
    // (这个逻辑和 bookmark_list_page *完全一样*)
    switch (result.type) {
      case "COURSE_MODULE":
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ContentDetailPage(
            moduleId: result.id,
            moduleTitle: result.title,
          ),
        ));
        break;
      case "PROJECT":
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProjectDetailPage(
            projectSummary: ProjectSummary(
              id: result.id,
              title: result.title,
              description: result.snippet, // (使用摘要作为描述)
              techStack: '',
            ),
          ),
        ));
        break;
      case "ALGORITHM":
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => AlgorithmDetailPage(
            summary: AlgorithmSummary(
              id: result.id,
              title: result.title,
              difficulty: result.snippet, // (使用摘要作为难度)
            ),
          ),
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // (AppBar 搜索框 - 不变)
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '搜索课程、项目和算法...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _onSearchChanged('');
            },
          )
        ],
      ),
      body: _buildResultsBody(),
    );
  }

  // (辅助) 构建结果列表
  Widget _buildResultsBody() {
    if (_resultsFuture == null) {
      return const PlaceholderWidget(
        icon: Icons.search,
        title: '开始搜索',
        message: '输入关键词以查找 B 路径（进阶）中的所有内容。',
      );
    }

    return FutureBuilder<List<SearchResult>>(
      future: _resultsFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          // (我们用 Shimmer 骨架屏)
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          return Shimmer.fromColors(
            baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
            child: ListView(
              children: const [ListTileSkeleton(), ListTileSkeleton(), ListTileSkeleton()],
            ),
          );
        }

        // --- ⬇️ (关键修复) ⬇️ ---
        // (恢复到 *不* 包含 SessionExpiredException 的简单逻辑)
        if (snapshot.hasError) {
          return PlaceholderWidget(
            icon: Icons.error_outline,
            title: '搜索失败',
            message: '无法连接到服务器。\n(${snapshot.error})',
            // (我们不在这里提供 _retry，让用户通过修改搜索词来重试)
          );
        }
        // --- ⬆️ (修复结束) ⬆️ ---

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return PlaceholderWidget(
            icon: Icons.search_off,
            title: '未找到结果',
            message: '没有找到与 "${_searchController.text}" 匹配的内容。',
          );
        }

        // (成功)
        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            return ListTile(
              leading: Icon(_getIconForType(result.type)),
              title: Text(result.title),
              subtitle: Text(result.snippet, maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => _navigateToDetail(context, result),
            );
          },
        );
      },
    );
  }
}