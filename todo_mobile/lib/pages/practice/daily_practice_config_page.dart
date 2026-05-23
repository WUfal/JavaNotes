import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../providers/auth_service.dart';
import '../../services/api_service.dart';
import 'task_center_page.dart';

class DailyPracticeConfigPage extends StatefulWidget {
  const DailyPracticeConfigPage({Key? key}) : super(key: key);

  @override
  State<DailyPracticeConfigPage> createState() => _DailyPracticeConfigPageState();
}

class _DailyPracticeConfigPageState extends State<DailyPracticeConfigPage> with TickerProviderStateMixin {
  // 表单状态
  String _selectedDifficulty = "中等";
  String _selectedType = "RANDOM";
  String _selectedTopic = "Java 基础";
  final TextEditingController _extraReqController = TextEditingController();

  bool _isGenerating = false;

  // 动画 Keys
  final GlobalKey _buttonKey = GlobalKey();
  final GlobalKey _targetIconKey = GlobalKey();

  final List<String> _topics = [
    "Java 基础", "集合框架", "多线程 & 并发", "JVM", "Spring Boot", "数据库 & SQL", "算法 & 数据结构"
  ];

  @override
  void dispose() {
    _extraReqController.dispose();
    super.dispose();
  }

  // --- ⬇️ 动画逻辑 (保持不变) ⬇️ ---
  void _runFlyAnimation() {
    final RenderBox? buttonRender = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? targetRender = _targetIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (buttonRender == null || targetRender == null) return;

    final buttonPos = buttonRender.localToGlobal(Offset.zero);
    final targetPos = targetRender.localToGlobal(Offset.zero);

    final startOffset = Offset(
      buttonPos.dx + buttonRender.size.width / 2,
      buttonPos.dy + buttonRender.size.height / 2,
    );
    final endOffset = Offset(
      targetPos.dx + targetRender.size.width / 2,
      targetPos.dy + targetRender.size.height / 2,
    );

    late OverlayEntry entry;
    AnimationController animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final Animation<Offset> positionAnimation = Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeInOutCubic));

    final Animation<double> scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeIn));

    entry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: animController,
          builder: (context, child) {
            return Positioned(
              left: positionAnimation.value.dx - 24,
              top: positionAnimation.value.dy - 24,
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))
                      ]
                  ),
                  child: const Icon(Icons.description, color: Colors.white, size: 32),
                ),
              ),
            );
          },
        );
      },
    );

    Overlay.of(context).insert(entry);
    animController.forward().then((_) {
      entry.remove();
      animController.dispose();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text("任务已加入后台队列"),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    });
  }
  // --- ⬆️ 动画逻辑结束 ⬆️ ---

  Future<void> _generate() async {
    setState(() => _isGenerating = true);
    // 收起键盘
    FocusScope.of(context).unfocus();

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final token = Provider.of<AuthService>(context, listen: false).token;

      await apiService.createPracticeTask(
        token,
        _selectedDifficulty,
        _selectedTopic,
        _selectedType,
        _extraReqController.text.trim(),
      );

      if (!mounted) return;

      setState(() => _isGenerating = false);
      _runFlyAnimation();

    } catch (e) {
      setState(() => _isGenerating = false);
      String errorMsg = e.toString();
      if (errorMsg.startsWith("Exception: ")) {
        errorMsg = errorMsg.substring(11);
      }
      if (errorMsg.contains("任务正在生成中")) {
        errorMsg = "队列中已有任务，请先处理完再生成。";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("创建失败: $errorMsg"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // 自定义背景色：日间模式更清爽的灰白，夜间模式保持原样
    final bgColor = isDark
        ? colorScheme.surfaceVariant.withOpacity(0.3)
        : const Color(0xFFF8F9FC);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("每日一练", style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0, // 防止滚动时 AppBar 变色影响观感

        systemOverlayStyle: SystemUiOverlayStyle(
          // 1. 设置状态栏背景为透明
          statusBarColor: Colors.transparent,

          // 2. Android 设置：
          // 如果是暗黑模式(isDark)，图标要亮的(白色) -> Brightness.light
          // 如果是白天模式(!isDark)，图标要暗的(黑色) -> Brightness.dark  <-- 这就是您需要的效果
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,

          // 3. iOS 设置 (逻辑通常是反的，控制的是背景亮度感知)：
          // 白天模式下，告诉 iOS 背景是亮的(Light)，它就会自动把字变成黑色
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        actions: [
          Container(
            key: _targetIconKey,
            margin: const EdgeInsets.only(right: 16),
            child: IconButton.filledTonal(
              // 日间模式下 IconButton 背景改淡一点
              style: IconButton.styleFrom(
                backgroundColor: isDark ? null : colorScheme.primaryContainer.withOpacity(0.3),
              ),
              icon: Icon(Icons.assignment_outlined, color: colorScheme.onSurfaceVariant),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskCenterPage()));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),

            // --- 卡片 1: 基础配置 ---
            _buildSectionLabel(theme, "基础配置", Icons.tune),
            Card(
              elevation: 0,
              // 日间模式纯白，夜间模式深色
              color: isDark ? colorScheme.surface : Colors.white,
              // 日间模式加一个极淡的边框，增强立体感
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.1),
                    width: 1
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("难度选择", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          visualDensity: VisualDensity.compact,
                          // 调整未选中时的背景色
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.selected)) {
                              return colorScheme.secondaryContainer;
                            }
                            return isDark ? null : Colors.grey.shade50;
                          }),
                        ),
                        segments: const [
                          ButtonSegment(value: "初级", label: Text("🌱 初级")),
                          ButtonSegment(value: "中等", label: Text("🔥 中等")),
                          ButtonSegment(value: "高级", label: Text("🚀 高级")),
                        ],
                        selected: {_selectedDifficulty},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() => _selectedDifficulty = newSelection.first);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text("题目类型", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _buildTypeChoice("随机混合", "RANDOM", Icons.shuffle, isDark),
                        _buildTypeChoice("选择题", "CHOICE", Icons.check_box_outlined, isDark),
                        _buildTypeChoice("编程题", "CODE", Icons.code, isDark),
                        _buildTypeChoice("简答题", "QA", Icons.short_text, isDark),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- 卡片 2: 知识领域 ---
            _buildSectionLabel(theme, "知识领域", Icons.category_outlined),
            Card(
              elevation: 0,
              color: isDark ? colorScheme.surface : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                    color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.1),
                    width: 1
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: _topics.map((topic) => _buildTopicChip(theme, topic, isDark)).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- 卡片 3: 额外要求 ---
            _buildSectionLabel(theme, "AI 定制指令", Icons.auto_awesome_outlined),
            Container(
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isDark ? colorScheme.outline.withOpacity(0.1) : Colors.grey.withOpacity(0.2)
                ),
                boxShadow: isDark ? [] : [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: TextField(
                controller: _extraReqController,
                maxLines: 4,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: "告诉 AI 面试官你的具体需求...\n例如：'请重点考察 Java 8 Stream API 的使用'",
                  hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      fontSize: 14
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 生成按钮
            _buildActionFloatButton(context, isDark),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI 组件封装 ---

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("开启今天的挑战", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text("定制专属面试题，保持技术手感。", style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant
        )),
      ],
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(text, style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface
          )),
        ],
      ),
    );
  }

  // 优化后的题型选择
  Widget _buildTypeChoice(String label, String value, IconData icon, bool isDark) {
    final isSelected = _selectedType == value;
    final colorScheme = Theme.of(context).colorScheme;

    // 日间模式下，未选中的背景改白，边框改灰
    final unselectedBg = isDark ? colorScheme.surfaceVariant.withOpacity(0.5) : Colors.white;
    final unselectedBorder = isDark ? Colors.transparent : Colors.grey.withOpacity(0.3);

    return InkWell(
      onTap: () => setState(() => _selectedType = value),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? colorScheme.primary : unselectedBorder,
              width: 1.5
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                icon,
                size: 18,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant
            ),
            const SizedBox(width: 8),
            Text(
                label,
                style: TextStyle(
                    color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                )
            ),
          ],
        ),
      ),
    );
  }

  // 优化后的主题 Chip
  Widget _buildTopicChip(ThemeData theme, String topic, bool isDark) {
    final isSelected = _selectedTopic == topic;
    final colorScheme = theme.colorScheme;

    // 日间模式未选中状态：白底+灰边框
    final unselectedBg = isDark ? colorScheme.surface : Colors.white;
    final unselectedBorderColor = isDark ? colorScheme.outline.withOpacity(0.2) : Colors.grey.withOpacity(0.3);

    return FilterChip(
      label: Text(topic),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) setState(() => _selectedTopic = topic);
      },
      selectedColor: theme.colorScheme.secondaryContainer,
      checkmarkColor: theme.colorScheme.onSecondaryContainer,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: isSelected ? Colors.transparent : unselectedBorderColor
        ),
      ),
      backgroundColor: unselectedBg,
      showCheckmark: false,
      avatar: isSelected ? const Icon(Icons.check, size: 18) : null,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    );
  }

  Widget _buildActionFloatButton(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: _buttonKey,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: _isGenerating
              ? [Colors.grey, Colors.grey]
              : [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: _isGenerating ? [] : [
          // 日间模式下阴影稍微淡一点
          BoxShadow(
            color: colorScheme.primary.withOpacity(isDark ? 0.4 : 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _isGenerating ? null : _generate,
          child: Center(
            child: _isGenerating
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                SizedBox(width: 12),
                Text("AI 正在思考...", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.auto_awesome, color: Colors.white),
                SizedBox(width: 8),
                Text("立即生成题目", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}