import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart'; // <--- 1. (新增) 导入
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// (导入所有 Providers 和 Services)
import 'services/api_service.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_service.dart';
import 'providers/bookmark_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/chat_provider.dart';

// (导入所有页面)
import 'pages/main_page.dart';
import 'pages/login_page.dart';
import 'pages/path_selection_page.dart';
import 'providers/badge_provider.dart';
// (我们 *不* 导入 session_expired_page.dart)
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/note_provider.dart';
// (更稳妥的方式是只用这一行，下面的 delegates 直接引用)
import 'package:flutter_quill/flutter_quill.dart';
import 'providers/user_provider.dart';
import 'providers/practice_history_provider.dart';
import 'providers/settings_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // 4. (新增) 在 App 运行 *前*，预加载主题设置
  const storage = FlutterSecureStorage();
  final results = await Future.wait([
    storage.read(key: 'theme_mode'),
    storage.readAll(), // 读取所有设置
  ]);
  final String? preloadedTheme = await storage.read(key: 'theme_mode');
  final Map<String, String> allSettings = results[1] as Map<String, String>;
  runApp(
    MultiProvider(
      providers: [
        // (我们的 Provider 列表 - 100% 正确)

        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider(preloadedTheme)),
        ChangeNotifierProvider(create: (context) => AuthService()),

        Provider(create: (context) => ApiService()),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(allSettings),
        ),
        ChangeNotifierProxyProvider<AuthService, BookmarkProvider>(
          create: (context) => BookmarkProvider(),
          update: (context, authService, provider) {
            final bookmarkProvider = provider ?? BookmarkProvider();
            if (authService.isAuthenticated && authService.selectedPath == "ADVANCED") {
              if (bookmarkProvider.loadedToken != authService.token) {
                bookmarkProvider.loadBookmarks(authService.token);
              }
            } else {
              bookmarkProvider.clearOnLogout();
            }
            return bookmarkProvider;
          },
        ),
        ChangeNotifierProxyProvider<AuthService, ProgressProvider>(
          create: (context) => ProgressProvider(),
          update: (context, authService, provider) {
            final progressProvider = provider ?? ProgressProvider();
            if (authService.isAuthenticated && authService.selectedPath == "BEGINNER") {
              if (progressProvider.loadedToken != authService.token) {
                progressProvider.loadProgress(authService.token);
              }
            } else {
              progressProvider.clearOnLogout();
            }
            return progressProvider;
          },
        ),
        ChangeNotifierProxyProvider<AuthService, ChatProvider>(
          create: (context) => ChatProvider(
              context.read<ApiService>(),
              context.read<AuthService>().token
          ),
          update: (context, authService, provider) {
            provider!.updateAuth(authService.token);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthService, UserProvider>(
          create: (context) => UserProvider(
              context.read<ApiService>(),
              context.read<AuthService>().token
          ),
          update: (context, authService, provider) {
            final userProvider = provider ?? UserProvider(context.read<ApiService>(), authService.token);
            userProvider.updateAuth(authService.token);

            // 登录成功后，自动加载用户信息
            if (authService.isAuthenticated && userProvider.userProfile == null) {
              userProvider.loadProfile();
            }
            return userProvider;
          },
        ),
        ChangeNotifierProvider(create: (context) => PracticeHistoryProvider()),
        // (A 路径 - 徽章) - 监听 AuthService
        ChangeNotifierProxyProvider<AuthService, BadgeProvider>(
          create: (context) => BadgeProvider(
              context.read<ApiService>(), // (注入 ApiService)
              context.read<AuthService>().token
          ),
          update: (context, authService, provider) {
            final badgeProvider = provider ?? BadgeProvider(context.read<ApiService>(), authService.token);

            badgeProvider.updateAuth(authService.token); // (更新 Token)

            // (关键：只在 A 路径时加载)
            if (authService.isAuthenticated && authService.selectedPath == "BEGINNER") {
              // (只在 token 变化时 (新登录) 才加载)
              if (badgeProvider.loadedToken != authService.token) {
                badgeProvider.loadMyBadges(authService.token);
              }
            }
            // (登出逻辑已在 updateAuth 中处理)

            return badgeProvider;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// 2. (新增) 定义我们的“回退”颜色
const _brandBlue = Colors.blue;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 3. (关键) 监听 ThemeProvider (不变)
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {

        // 4. (关键新增) 使用 DynamicColorBuilder 包裹 MaterialApp
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {

            // 5. (关键逻辑) 决定我们的配色方案
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              // (情况 A: 成功获取到系统配色)
              lightColorScheme = lightDynamic.harmonized();
              darkColorScheme = darkDynamic.harmonized();
            } else {
              // (情况 B: 未获取到，在 iOS 或旧版 Android)
              // (我们使用“回退”的蓝色)
              lightColorScheme = ColorScheme.fromSeed(seedColor: _brandBlue);
              darkColorScheme = ColorScheme.fromSeed(
                  seedColor: _brandBlue,
                  brightness: Brightness.dark
              );
            }

            // 6. (构建 MaterialApp)
            return MaterialApp(
              navigatorKey: navigatorKey,
              title: 'JavaNotes',

              themeMode: themeProvider.themeMode,

              // --- ⬇️ (关键修改) 7. 亮色主题 ⬇️ ---
              theme: ThemeData(
                colorScheme: lightColorScheme, // (使用动态或回退的配色)
                useMaterial3: true,
                canvasColor: lightColorScheme.background,
                // (导航栏主题 - 动态化)
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: lightColorScheme.background,
                  selectedItemColor: lightColorScheme.primary,
                  unselectedItemColor: lightColorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
              // --- ⬆️ (修改结束) ⬆️ ---

              // --- ⬇️ (关键修改) 8. 暗色主题 ⬇️ ---
              darkTheme: ThemeData(
                colorScheme: darkColorScheme, // (使用动态或回退的配色)
                useMaterial3: true,
                // (导航栏主题 - 动态化)
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: darkColorScheme.surface,
                  selectedItemColor: darkColorScheme.onSurface,
                  unselectedItemColor: darkColorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
              // --- ⬆️ (修改结束) ⬆️ ---

              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                // (关键) 添加 Quill 的代理
                FlutterQuillLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'), // 英文
                Locale('zh', 'CN'), // 中文 (可选，推荐加上)
              ],
              // --- ⬇️ (关键) 我们的“门卫”逻辑 (不包含 isSessionExpired) ⬇️ ---
              home: Consumer<AuthService>(
                builder: (context, authService, _) {
                  if (authService.isLoading) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  // (没有 'isSessionExpired' 检查)
                  if (!authService.isAuthenticated) {
                    return const LoginPage();
                  }
                  if (authService.selectedPath == null) {
                    return const PathSelectionPage();
                  }
                  return MainPage();
                },
              ),
              // --- ⬆️ (修复结束) ⬆️ ---
            );
          },
        );
      },
    );
  }
}