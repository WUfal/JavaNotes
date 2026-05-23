-- 版本 1.4: 填充徽章定义表 (badge)

INSERT INTO badge (id, title, description, icon_name)
VALUES
    ('FIRST_COMPLETION', '初来乍到', '完成了你的第一个 A 路径关卡', 'school'), -- (icon: Icons.school)

    ('QUIZ_MASTER_1', '小试牛刀', '在 "第1关" 测验中获得 100%', 'emoji_events'), -- (icon: Icons.emoji_events)

    ('CODE_RUNNER', '运行！', '第一次成功运行 A 路径沙盒代码', 'play_arrow');

-- (我们暂时只定义 3 个，稍后可以添加更多)