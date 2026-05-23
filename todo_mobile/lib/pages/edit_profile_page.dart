import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_service.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  final String? currentNickname;
  final String? currentAvatarId;

  const EditProfilePage({
    Key? key,
    this.currentNickname,
    this.currentAvatarId
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nicknameController;
  late String _selectedAvatarId;
  bool _isSubmitting = false;

  // (预设头像列表 - 确保这些文件名在你的 assets/images/ 中存在)
  final List<String> _avatarList = [
    'default',
    'avatar_0', 'avatar_1', 'avatar_2',
    'avatar_3', 'avatar_4', 'avatar_5',
    'avatar_6', 'avatar_7', 'avatar_8',
    'avatar_9', 'avatar_10', 'avatar_11',
    'avatar_12', 'avatar_13', 'avatar_14',
    'avatar_15', 'avatar_16', 'avatar_17',
    'avatar_18', 'avatar_19', 'avatar_20',
    'avatar_21', 'avatar_22', 'avatar_23',
    'avatar_24', 'avatar_25','avatar_26',
    'avatar_27', 'avatar_28','avatar_29',
    'avatar_30', 'avatar_31','avatar_32',
    'avatar_33'
  ];

  @override
  void initState() {
    super.initState();
    // 1. (优化) 预填充当前昵称，方便用户修改
    _nicknameController = TextEditingController(text: widget.currentNickname ?? "");
    _selectedAvatarId = widget.currentAvatarId ?? "default";
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSubmitting = true);

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      final token = Provider.of<AuthService>(context, listen: false).token;

      // 2. (优化) 智能处理昵称
      // 如果用户清空了输入框，或者没改动，我们传给后端空字符串
      // 后端的逻辑是 "if (nickname != null && !nickname.isBlank())"，所以传空字符串 = 不更新
      // 这完美符合 "不想改昵称" 的需求
      String nicknameToSend = _nicknameController.text.trim();

      await apiService.updateProfile(token, nicknameToSend, _selectedAvatarId);

      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).loadProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("个人资料已更新！")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("更新失败: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // (辅助) 构建头像组件 (带容错)
  Widget _buildAvatarItem(String avatarId) {
    bool isSelected = _selectedAvatarId == avatarId;

    return InkWell(
      onTap: () {
        setState(() => _selectedAvatarId = avatarId);
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // 选中时显示高亮边框
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 3)
              : Border.all(color: Colors.transparent, width: 3),
        ),
        padding: const EdgeInsets.all(2),
        child: ClipOval(
          child: avatarId == 'default'
              ? Container(
            color: Colors.grey[200],
            child: const Icon(Icons.person, color: Colors.grey, size: 30),
          )
              : Image.asset(
            'assets/images/$avatarId.png',
            fit: BoxFit.cover,
            // 3. (关键优化) 图片加载失败时的兜底显示
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.broken_image, size: 20, color: Colors.red),
                    Text("缺失", style: TextStyle(fontSize: 10, color: Colors.red)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("编辑个人资料"),
        actions: [
          TextButton(
            // 4. (优化) 只要没在提交中，随时可以点击保存
            onPressed: _isSubmitting ? null : _saveProfile,
            child: _isSubmitting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text("保存", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("昵称", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                // 5. (优化) 如果清空了，显示提示
                hintText: "请输入你的昵称",
                helperText: "留空则保持原昵称不变", // 明确告知用户
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.badge),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _nicknameController.clear(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text("选择头像", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("如果图片显示为破碎图标，说明资源文件缺失",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: _avatarList.length,
              itemBuilder: (context, index) {
                return _buildAvatarItem(_avatarList[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}