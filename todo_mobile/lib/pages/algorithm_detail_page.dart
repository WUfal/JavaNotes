import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/algorithm.dart';
import '../models/course_module.dart';
import '../services/api_service.dart';
import '../widgets/code_block_widget.dart';
import '../providers/auth_service.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/placeholder_widget.dart';
import 'ai_chat_page.dart';
import '../providers/chat_provider.dart';
import '../widgets/comment_section.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
class AlgorithmDetailPage extends StatefulWidget {
  final AlgorithmSummary summary;
  const AlgorithmDetailPage({Key? key, required this.summary}) : super(key: key);

  @override
  State<AlgorithmDetailPage> createState() => _AlgorithmDetailPageState();
}

class _AlgorithmDetailPageState extends State<AlgorithmDetailPage> {
  Future<AlgorithmDetail>? _detailFuture;
  late ApiService _apiService;
  String? _token;

  WebViewController? _webController;
  bool _showVizTab = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _apiService = Provider.of<ApiService>(context, listen: false);
    final String? currentToken = Provider.of<AuthService>(context, listen: false).token;

    if (_detailFuture == null || _token != currentToken) {
      _token = currentToken;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _detailFuture = _apiService.fetchAlgorithmDetail(_token, widget.summary.id);

      _detailFuture!.then((detail) {
        _initWebViewIfAvailable(detail);
      }).catchError((error) {
        debugPrint("Data load error: $error");
      });
    });
  }

  void _initWebViewIfAvailable(AlgorithmDetail detail) async {
    String? url = detail.visualizationUrl;

    debugPrint("Backend returned URL: $url");

    if (url != null && url.isNotEmpty) {
      if (url.startsWith('/')) {
        final domain = _apiService.baseUrlDomain;
        final cleanDomain = domain.endsWith('/')
            ? domain.substring(0, domain.length - 1)
            : domain;
        url = "$cleanDomain$url";
      }

      debugPrint("Final WebView URL: $url");

      // 1. 初始化 Controller
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (error) =>
                debugPrint("WebView Error: ${error.description}"),
          ),
        )
        ..loadRequest(Uri.parse(url));

      // ⬇️⬇️⬇️ 核心修改：删除这块报错的代码 ⬇️⬇️⬇️
      /* 在 webview_flutter 4.0+ (android 3.16+) 中，
       默认就是 SurfaceAndroidView (Hybrid Composition)，
       不需要也不支持手动 setDisplayMode 了。

       如果有调试需求需要开启调试模式，可以保留下面这几行：
    */

      // 如果你需要开启安卓下的 Chrome 调试功能（可选）：
      if (controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        // (注意：enableDebugging 是静态方法，或者根据具体版本可能需要通过 controller.platform 调用，
        // 但绝大多数情况下，不要调用 setDisplayMode)
      }
      // ⬆️⬆️⬆️ 删除结束 ⬆️⬆️⬆️

      if (mounted) {
        setState(() {
          _webController = controller;
          _showVizTab = true;
        });
      }
    }
  }
  // --- ⬆️ --------------------------- ⬆️ ---

  void _openAiChat(BuildContext context) {
    // AI 聊天相关逻辑 (保持不变)
    Provider.of<ChatProvider>(context, listen: false)
        .startNewChat("viewing: ${widget.summary.id}", widget.summary.title);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FractionallySizedBox(
        heightFactor: 0.85,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: const AiChatPage(),
        ),
      ),
    );
  }

  // ... 骨架屏代码 _buildLoadingShimmer (保持不变) ...
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(height: 20, width: 200, color: Colors.white),
          const SizedBox(height: 10),
          Container(height: 100, width: double.infinity, color: Colors.white),
        ],
      ),
    );
  }

  // ... 内容渲染代码 _buildContentBlockList (保持不变) ...
  Widget _buildContentBlockList(List<ContentBlock>? blocks, ColorScheme colorScheme) {
    final safeBlocks = blocks ?? [];
    if (safeBlocks.isEmpty) return const Center(child: Text("暂无内容"));

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: safeBlocks.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == safeBlocks.length) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text("讨论区", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              CommentSection(targetType: "ALGORITHM", targetId: widget.summary.id),
            ],
          );
        }
        final block = safeBlocks[index];
        // 简单处理不同类型
        if (block.type == 'code') {
          return CodeBlockWidget(codeContent: block.content, language: block.language ?? 'java');
        }
        return MarkdownBody(data: block.content);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      // 动态控制 Tab 数量：如果有 VizUrl 则显示 3 个，否则 2 个
      length: _showVizTab ? 3 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.summary.title),
          bottom: TabBar(
            tabs: [
              const Tab(text: '题目描述'),
              const Tab(text: '题解思路'),
              // 仅当有动画时才显示此 Tab
              if (_showVizTab) const Tab(text: '✨ 演示动画'),
            ],
          ),
          actions: [
            // 书签按钮逻辑...
            Consumer<BookmarkProvider>(
              builder: (ctx, provider, _) {
                final isMarked = provider.isBookmarked("ALGORITHM", widget.summary.id);
                return IconButton(
                  icon: Icon(isMarked ? Icons.bookmark : Icons.bookmark_border),
                  onPressed: () {
                    // ... 书签逻辑
                  },
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.smart_toy),
          onPressed: () => _openAiChat(context),
        ),
        body: FutureBuilder<AlgorithmDetail>(
          future: _detailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return _buildLoadingShimmer();
            if (snapshot.hasError) return const Center(child: Text("加载失败"));
            if (!snapshot.hasData) return const Center(child: Text("无数据"));

            final detail = snapshot.data!;

            return TabBarView(
              physics: const NeverScrollableScrollPhysics(), // 禁止滑动切换，防止WebView冲突
              children: [
                _buildContentBlockList(detail.descriptionBlocks, colorScheme),
                _buildContentBlockList(detail.solutionBlocks, colorScheme),

                // 仅当 _showVizTab 为 true 时渲染 WebView
                if (_showVizTab && _webController != null)
                  WebViewWidget(controller: _webController!),
              ],
            );
          },
        ),
      ),
    );
  }
}