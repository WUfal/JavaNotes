class ModuleItem {
  final String id;
  final String title;
  final String description;

  ModuleItem({
    required this.id,
    required this.title,
    required this.description,
  });

  // 工厂构造函数，用于从JSON解析
  factory ModuleItem.fromJson(Map<String, dynamic> json) {
    return ModuleItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}

class ModuleGroup {
  final String groupTitle;
  final List<ModuleItem> items;

  ModuleGroup({required this.groupTitle, required this.items});

  factory ModuleGroup.fromJson(Map<String, dynamic> json) {
    // 解析 'items' 列表
    var itemsList = json['items'] as List;
    List<ModuleItem> items = itemsList
        .map((itemJson) => ModuleItem.fromJson(itemJson))
        .toList();

    return ModuleGroup(
      groupTitle: json['groupTitle'],
      items: items,
    );
  }
}


class ContentBlock {
  final String type;
  final String content;
  final String? language; // 可为空

  ContentBlock({
    required this.type,
    required this.content,
    this.language,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: json['type'],
      content: json['content'],
      language: json['language'],
    );
  }
}

// --- 新增：对应Java的ModuleDetail ---
class ModuleDetail {
  final String id;
  final String title;
  final List<ContentBlock> blocks;

  ModuleDetail({
    required this.id,
    required this.title,
    required this.blocks,
  });

  factory ModuleDetail.fromJson(Map<String, dynamic> json) {
    var blocksList = json['blocks'] as List;
    List<ContentBlock> blocks = blocksList
        .map((blockJson) => ContentBlock.fromJson(blockJson))
        .toList();

    return ModuleDetail(
      id: json['id'],
      title: json['title'],
      blocks: blocks,
    );
  }
}