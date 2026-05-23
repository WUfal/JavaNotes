import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../models/local_note.dart';
import '../../providers/note_provider.dart';

class NotebookEditorPage extends StatefulWidget {
  final LocalNote? existingNote;
  const NotebookEditorPage({Key? key, this.existingNote}) : super(key: key);

  @override
  State<NotebookEditorPage> createState() => _NotebookEditorPageState();
}

class _NotebookEditorPageState extends State<NotebookEditorPage> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  int _wordCount = 0;
  String _lastModified = "新笔记";
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _setupEditor();
  }

  void _setupEditor() {
    if (widget.existingNote != null) {
      _titleController.text = widget.existingNote!.title;
      _typeController.text = widget.existingNote!.type;
      _lastModified = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.existingNote!.updatedAt));
      try {
        final json = jsonDecode(widget.existingNote!.content);
        _controller = QuillController(document: Document.fromJson(json), selection: const TextSelection.collapsed(offset: 0));
      } catch (e) {
        _controller = QuillController.basic();
      }
    } else {
      _controller = QuillController.basic();
      _typeController.text = "学习笔记";
      _lastModified = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    }

    _controller.document.changes.listen((event) {
      _updateWordCount();
      if (!_isDirty) setState(() => _isDirty = true);
    });
    _updateWordCount();
  }

  void _updateWordCount() {
    final text = _controller.document.toPlainText();
    setState(() {
      _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _typeController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _exportToPdf() async {
    // 显示加载提示，因为下载字体可能需要几秒钟
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("正在准备 PDF，请稍候..."), duration: Duration(seconds: 1)),
    );

    final pdf = pw.Document();
    final String textContent = _controller.document.toPlainText();

    // 关键修复：加载支持中文的字体 (Noto Sans SC)
    // 注意：这需要设备联网下载字体。如果需要完全离线，需要将字体文件放入 assets 并通过 rootBundle 加载
    final font = await PdfGoogleFonts.notoSansSCRegular();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        // 关键修复：设置 PDF 主题字体
        theme: pw.ThemeData.withFont(
          base: font,
          bold: font, // 暂时用同一个字体作为粗体回退
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(_titleController.text.isEmpty ? "未命名笔记" : _titleController.text, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text("分类: ${_typeController.text}", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                pw.Divider(color: PdfColors.grey300),
              ]),
            ),
            pw.Padding(padding: const pw.EdgeInsets.only(top: 20), child: pw.Paragraph(text: textContent, style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5))),
          ];
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Future<void> _saveNote() async {
    FocusScope.of(context).unfocus();
    final String contentJson = jsonEncode(_controller.document.toDelta().toJson());
    final String plainText = _controller.document.toPlainText().trim();
    final String title = _titleController.text.trim();
    final String type = _typeController.text.trim();

    if (title.isEmpty && plainText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("不能保存空笔记")));
      return;
    }

    try {
      await Provider.of<NoteProvider>(context, listen: false).saveNote(
        id: widget.existingNote?.id,
        title: title.isEmpty ? "无标题笔记" : title,
        contentJson: contentJson,
        summary: plainText.length > 50 ? plainText.substring(0, 50).replaceAll('\n', ' ') : plainText.replaceAll('\n', ' '),
        type: type,
        existingCreatedAt: widget.existingNote?.createdAt,
      );

      if (mounted) {
        setState(() {
          _isDirty = false;
          _lastModified = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("✅ 笔记已保存"), behavior: SnackBarBehavior.floating, backgroundColor: Theme.of(context).colorScheme.primary)
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ 保存失败: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.ios_share_rounded, color: colorScheme.onSurfaceVariant),
            tooltip: "导出 PDF",
            onPressed: _exportToPdf,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: FilledButton.icon(
              onPressed: _saveNote,
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text(_isDirty ? "保存" : "已保存"),
              style: FilledButton.styleFrom(
                backgroundColor: _isDirty ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                foregroundColor: _isDirty ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. 顶部工具栏 (独立背景色)
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer, // 区分工具栏和内容区
              border: Border(bottom: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5))),
            ),
            child: QuillSimpleToolbar(
              controller: _controller,
              config: QuillSimpleToolbarConfig(
                showAlignmentButtons: true,
                showHeaderStyle: true,
                showListNumbers: true,
                showListBullets: true,
                showBoldButton: true,
                showItalicButton: true,
                showUnderLineButton: true,
                showStrikeThrough: true,
                showColorButton: true,
                showBackgroundColorButton: true,
                showClearFormat: true,
                showLink: true,
                showCodeBlock: true,
                showQuote: true,
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                    iconTheme: QuillIconTheme(
                      iconButtonSelectedData: IconButtonData(
                        style: IconButton.styleFrom(backgroundColor: colorScheme.primaryContainer, foregroundColor: colorScheme.onPrimaryContainer),
                      ),
                      iconButtonUnselectedData: IconButtonData(
                        style: IconButton.styleFrom(foregroundColor: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. 滚动编辑区
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // --- 标题 ---
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: "无标题笔记",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 28, fontWeight: FontWeight.w900),
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(color: colorScheme.onSurface, fontSize: 28, fontWeight: FontWeight.w900),
                          maxLines: null,
                          onChanged: (_) { if (!_isDirty) setState(() => _isDirty = true); },
                        ),

                        const SizedBox(height: 16),

                        // --- 元数据行 ---
                        Row(
                          children: [
                            // 分类标签 (带背景的可编辑 Chip)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.tag, size: 14, color: colorScheme.onSecondaryContainer),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller: _typeController,
                                      style: TextStyle(fontSize: 13, color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.w600),
                                      decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero, hintText: "分类"),
                                      onChanged: (_) { if (!_isDirty) setState(() => _isDirty = true); },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.edit_calendar_rounded, size: 14, color: colorScheme.outline),
                            const SizedBox(width: 4),
                            Text(_lastModified, style: TextStyle(fontSize: 12, color: colorScheme.outline)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Divider(height: 1, color: colorScheme.outlineVariant.withOpacity(0.5)),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // --- 正文 ---
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: QuillEditor.basic(
                      controller: _controller,
                      focusNode: _focusNode,
                      config: QuillEditorConfig(
                        placeholder: '在此输入内容...',
                        padding: const EdgeInsets.only(bottom: 100),
                        autoFocus: false,
                        scrollable: false,
                        expands: false,
                        customStyles: DefaultStyles(
                          paragraph: DefaultTextBlockStyle(
                            TextStyle(fontSize: 16, color: colorScheme.onSurface, height: 1.6),
                            const HorizontalSpacing(0, 0), const VerticalSpacing(0, 0), const VerticalSpacing(0, 0), null,
                          ),
                          h1: DefaultTextBlockStyle(
                            TextStyle(fontSize: 24, color: colorScheme.onSurface, fontWeight: FontWeight.bold),
                            const HorizontalSpacing(0, 0), const VerticalSpacing(16, 0), const VerticalSpacing(0, 0), null,
                          ),
                          code: DefaultTextBlockStyle(
                            TextStyle(
                              color: isDark ? Colors.red[200] : Colors.red[700],
                              fontFamily: 'monospace',
                              backgroundColor: colorScheme.surfaceContainerHighest,
                            ),
                            const HorizontalSpacing(0, 0), const VerticalSpacing(0, 0), const VerticalSpacing(0, 0), null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. 底部状态条
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.2))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Text("$_wordCount 字", style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                  const Spacer(),
                  if (_isDirty)
                    Text("未保存更改", style: TextStyle(fontSize: 12, color: colorScheme.error, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}