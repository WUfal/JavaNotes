-- 版本 1.11: 创建“每日一练”异步任务表
-- 用于解决 AI 生成时间过长的问题

CREATE TABLE practice_generation_task (
                                          id bigserial NOT NULL,
                                          app_user_id bigint NOT NULL,

    -- 任务状态: "PENDING"(生成中), "COMPLETED"(完成), "FAILED"(失败)
                                          status varchar(20) NOT NULL,

    -- 任务描述 (显示在列表上，例如: "中等 / Java集合 / 选择题")
                                          summary varchar(255) NOT NULL,

    -- 生成结果 (存 JSON 字符串，生成前为空)
                                          questions_json text,

    -- 错误信息 (如果有)
                                          error_message text,

                                          created_at timestamp with time zone NOT NULL,
                                          updated_at timestamp with time zone NOT NULL,

                                          CONSTRAINT practice_generation_task_pkey PRIMARY KEY (id),
                                          CONSTRAINT fk_task_to_user FOREIGN KEY (app_user_id) REFERENCES app_user(id) ON DELETE CASCADE
);

-- 索引：方便查询用户的所有任务，按时间倒序
CREATE INDEX idx_task_user_time ON practice_generation_task (app_user_id, created_at DESC);