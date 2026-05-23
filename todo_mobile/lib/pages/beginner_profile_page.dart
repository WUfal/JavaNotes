import 'package:flutter/material.dart';
import 'profile_page.dart'; // 我们可以复用 B 路径的 ProfilePage

// [A路径-我的] Tab的占位页面
// (我们暂时复用 B 路径的 ProfilePage，因为它们很像，
// 只是里面的列表项不同，我们稍后可以给它传一个参数)
class BeginnerProfilePage extends StatelessWidget {
  const BeginnerProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 稍后创建 A 路径专用的 Profile Page
    // 目前暂时复用 B 路径的，但把标题改一下
    return const ProfilePage(isBeginner: true); // (我们需要去修改 ProfilePage)
  }
}