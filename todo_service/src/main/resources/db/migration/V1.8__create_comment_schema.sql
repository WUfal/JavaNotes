-- 版本 1.22: 创建通用评论表

CREATE TABLE comment (
                         id bigserial NOT NULL,
                         app_user_id bigint NOT NULL,
                         content text NOT NULL,
                         target_type varchar(50) NOT NULL, -- "PROJECT", "ALGORITHM", ...
                         target_id varchar(255) NOT NULL,  -- "1", "core_oop", ...
                         created_at timestamp with time zone NOT NULL,

                         CONSTRAINT comment_pkey PRIMARY KEY (id),
                         CONSTRAINT fk_comment_to_user FOREIGN KEY (app_user_id) REFERENCES app_user(id) ON DELETE CASCADE
);

-- 创建索引以加速查询 (查找某个项目下的所有评论)
CREATE INDEX idx_comment_target ON comment (target_type, target_id);