import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart'; // <--- (你提到的 import)

// (导入所有 Providers 和 Pages - 不变)
import '../providers/auth_service.dart';
import '../providers/settings_provider.dart';
import 'advanced_learn_page.dart';
import 'project_page.dart';
import 'algorithm_page.dart';
import 'profile_page.dart';
import 'beginner_learn_page.dart';
import 'exercise_page.dart';
// (我们不再需要 'ai_chat_page.dart' 的导入，因为它在详情页)
import '../widgets/app_drawer.dart';
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  // (用于“记住”上一个路径)
  String? _previousPath;

  // (A 路径的页面和 GNav 按钮 - 不变)
  final List<Widget> _beginnerPages = [
    const BeginnerLearnPage(),
    const ExercisePage(),
    const ProfilePage(isBeginner: true),
  ];
  final List<GButton> _beginnerTabs = const [
    GButton(icon: Icons.play_circle_fill, text: '学习'),
    GButton(icon: Icons.fitness_center, text: '练习'),
    GButton(icon: Icons.person, text: '我的'),
  ];

  // (B 路径的页面和 GNav 按钮 - 不变)
  final List<Widget> _advancedPages = [
    const AdvancedLearnPage(),
    const ProjectPage(),
    const AlgorithmPage(),
    const ProfilePage(isBeginner: false),
  ];
  final List<GButton> _advancedTabs = const [
    GButton(icon: Icons.school, text: '学习'),
    GButton(icon: Icons.code, text: '项目'),
    GButton(icon: Icons.computer, text: '算法'),
    GButton(icon: Icons.person, text: '我的'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    // (初始化“上一个路径”)
    _previousPath = Provider.of<AuthService>(context, listen: false).selectedPath;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    // (根据路径选择 UI)
    final String? currentPath = Provider.of<AuthService>(context).selectedPath;
    List<Widget> pages;
    List<GButton> tabs;

    // --- ⬇️ (关键修复) 3. 检查路径是否已切换 ⬇️ ---
    if (_previousPath != currentPath) {
      // (路径已改变！)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _currentIndex = 0; // (重置索引到“学习”页)
          _pageController.jumpToPage(0); // (强制 PageView 跳转到第 0 页)
          _previousPath = currentPath; // (更新“上一个路径”的记忆)
        });
      });
    }
    // --- ⬆️ (修复结束) ⬆️ ---

    if (currentPath == "BEGINNER") {
      pages = _beginnerPages;
      tabs = _beginnerTabs;
    } else {
      pages = _advancedPages;
      tabs = _advancedTabs;
    }

    if (_currentIndex >= pages.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      drawer: const AppDrawer(),
      // (PageView - 不变)
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      // (GNav 导航栏 - 不变)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              haptic: settings.enableHapticFeedback,
              tabs: tabs,
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },

              gap: 8,
              activeColor: Theme.of(context).colorScheme.onPrimary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            ),
          ),
        ),
      ),
    );
  }
}