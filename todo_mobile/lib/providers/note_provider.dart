import 'package:flutter/foundation.dart';
import '../models/local_note.dart';
import '../services/database_helper.dart';

class NoteProvider with ChangeNotifier {
  List<LocalNote> _notes = [];
  bool _isLoading = false;

  List<LocalNote> get notes => _notes;
  bool get isLoading => _isLoading;

  // 加载所有笔记
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    final dataList = await DatabaseHelper.instance.readAllNotes();
    _notes = dataList.map((json) => LocalNote.fromJson(json)).toList();

    _isLoading = false;
    notifyListeners();
  }

  // 保存笔记 (新增或更新)
// ...
  Future<void> saveNote({
    int? id,
    required String title,
    required String contentJson,
    required String summary,
    required String type, // (新增参数)
    String? existingCreatedAt, // (新增参数：如果是编辑，传入旧的创建时间)
  }) async {

    final now = DateTime.now().toIso8601String();

    // 如果是编辑，使用旧的创建时间；如果是新建，使用当前时间
    final String createdAt = existingCreatedAt ?? now;

    final note = LocalNote(
      id: id,
      title: title,
      content: contentJson,
      summary: summary,
      updatedAt: now,       // 总是更新为当前时间
      createdAt: createdAt, // 保持不变 或 设为当前时间
      type: type.isEmpty ? "未分类" : type, // 处理空分类
    );

    if (id == null) {
      await DatabaseHelper.instance.create(note.toJson());
    } else {
      await DatabaseHelper.instance.update(note.toJson());
    }

    await loadNotes();
  }
  // ...

  // 删除笔记
  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadNotes();
  }
}