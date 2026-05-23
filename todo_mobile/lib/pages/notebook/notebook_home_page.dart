import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../../models/local_note.dart';
import '../../providers/note_provider.dart';
import 'notebook_editor_page.dart';

class NotebookHomePage extends StatefulWidget {
  const NotebookHomePage({Key? key}) : super(key: key);

  @override
  State<NotebookHomePage> createState() => _NotebookHomePageState();
}

class _NotebookHomePageState extends State<NotebookHomePage> {
  bool _groupByType = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getFriendlyDateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final noteDate = DateTime(dt.year, dt.month, dt.day);

    if (noteDate == today) return "今天";
    if (noteDate == yesterday) return "昨天";

    final difference = today.difference(noteDate).inDays;
    if (difference < 7) return "本周";
    if (difference < 30) return "本月";

    return DateFormat('yyyy年 MM月').format(dt);
  }

  List<Widget> _buildSliverList(List<LocalNote> notes, ColorScheme colorScheme) {
    final filteredNotes = notes.where((n) {
      return n.title.toLowerCase().contains(_searchText) ||
          n.summary.toLowerCase().contains(_searchText) ||
          n.type.toLowerCase().contains(_searchText);
    }).toList();

    if (filteredNotes.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded, size: 64, color: colorScheme.outlineVariant.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text("没有找到相关笔记", style: TextStyle(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        )
      ];
    }

    Map<String, List<LocalNote>> groupedNotes;
    if (_groupByType) {
      groupedNotes = groupBy(filteredNotes, (note) => note.type.isEmpty ? "未分类" : note.type);
    } else {
      groupedNotes = groupBy(filteredNotes, (note) {
        final dt = DateTime.parse(note.createdAt);
        return _getFriendlyDateLabel(dt);
      });
    }

    var sortedKeys = groupedNotes.keys.toList();
    if (_groupByType) sortedKeys.sort();

    return sortedKeys.map((key) {
      final groupItems = groupedNotes[key]!;
      return SliverMainAxisGroup(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverHeaderDelegate(
              title: key,
              count: groupItems.length,
              colorScheme: colorScheme,
              icon: _groupByType ? Icons.folder_open_rounded : Icons.calendar_month_rounded,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _NoteCard(note: groupItems[index]),
                childCount: groupItems.length,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              // 1. 沉浸式大标题
              SliverAppBar.large(
                title: Text("我的笔记", style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                backgroundColor: colorScheme.surface,
                scrolledUnderElevation: 0, // 滚动时不改变背景色，保持纯净
                actions: [
                  IconButton(
                    icon: Icon(_groupByType ? Icons.access_time_rounded : Icons.grid_view_rounded),
                    tooltip: _groupByType ? "按时间视图" : "按分类视图",
                    style: IconButton.styleFrom(foregroundColor: colorScheme.onSurfaceVariant),
                    onPressed: () => setState(() => _groupByType = !_groupByType),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // 2. 搜索栏 (使用 M3 SearchBar)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: "搜索笔记...",
                    hintStyle: MaterialStatePropertyAll(TextStyle(color: colorScheme.onSurfaceVariant)),
                    leading: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
                    elevation: MaterialStateProperty.all(0),
                    // 使用 surfaceContainerHigh 区分于背景
                    backgroundColor: MaterialStateProperty.all(colorScheme.surfaceContainerHigh),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
                  ),
                ),
              ),

              // 3. 内容区
              if (provider.isLoading)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (provider.notes.isEmpty && _searchText.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_alt_outlined, size: 80, color: colorScheme.primaryContainer),
                        const SizedBox(height: 24),
                        Text("开始记录你的第一篇笔记", style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                )
              else
                ..._buildSliverList(provider.notes, colorScheme),

              const SliverToBoxAdapter(child: SizedBox(height: 100)), // 底部留白
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotebookEditorPage())),
        icon: const Icon(Icons.edit_rounded),
        label: const Text("新笔记"),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 4,
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final LocalNote note;
  const _NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dt = DateTime.parse(note.createdAt);
    final timeStr = DateFormat('MM-dd HH:mm').format(dt);

    return Dismissible(
      key: Key(note.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_forever_rounded, color: colorScheme.onError),
      ),
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: colorScheme.surfaceContainerHigh,
            title: const Text("删除笔记"),
            content: const Text("此操作无法撤销，确定要删除吗？"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("取消")),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("删除", style: TextStyle(color: colorScheme.error))),
            ],
          ),
        );
      },
      onDismissed: (_) => Provider.of<NoteProvider>(context, listen: false).deleteNote(note.id!),
      child: Card(
        // 核心修复：亮色模式下，surfaceContainer 提供了必要的色差
        // M3 推荐：Card 应该使用 surfaceContainerLow (最低层级) 或 surfaceContainer
        color: colorScheme.surfaceContainer,
        elevation: 0, // M3 风格通常也是平的，靠颜色区分
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          // 增强对比度：添加一个极淡的边框，这在亮色模式下对区分卡片边界非常有用
          side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.6), width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotebookEditorPage(existingNote: note))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        note.title.isEmpty ? "无标题" : note.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 时间戳
                    Text(
                      timeStr,
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note.summary.isEmpty ? "无内容" : note.summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // 底部标签栏
                Row(
                  children: [
                    // 分类胶囊
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        // 使用 Tertiary 色系来强调标签，与背景区分
                        color: colorScheme.tertiaryContainer.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.tertiaryContainer, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.folder_outlined, size: 14, color: colorScheme.onTertiaryContainer),
                          const SizedBox(width: 4),
                          Text(
                            note.type.isEmpty ? "未分类" : note.type,
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final int count;
  final ColorScheme colorScheme;
  final IconData icon;

  _SliverHeaderDelegate({required this.title, required this.count, required this.colorScheme, required this.icon});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // 头部背景使用 surface，但带有一点点透明度，滚动时有模糊效果会更高级(这里简单处理)
      color: colorScheme.surface.withOpacity(0.95),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.primary)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
            child: Text("$count", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer)),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48.0;
  @override
  double get minExtent => 48.0;
  @override
  bool shouldRebuild(_SliverHeaderDelegate old) => title != old.title || count != old.count;
}