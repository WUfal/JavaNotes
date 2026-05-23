-- 版本 1.23: 为用户表添加 昵称 和 头像 字段

ALTER TABLE app_user
    ADD COLUMN nickname varchar(50),
    ADD COLUMN avatar_id varchar(50);

-- (可选) 设置默认值，防止旧数据为 null
UPDATE app_user SET nickname = username WHERE nickname IS NULL;
UPDATE app_user SET avatar_id = 'default' WHERE avatar_id IS NULL;