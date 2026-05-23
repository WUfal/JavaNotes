-- 版本 1.0: (合并) 创建所有 17 张表
-- (这个文件合并了 V1, V1.2, V1.4, V1.6, V1.8, V1.10, V1.12, V1.14, V1.15, V1.16)

-- 1. 用户
CREATE TABLE app_user (
                          id bigserial NOT NULL,
                          username varchar(255) NOT NULL,
                          password varchar(255) NOT NULL,
                          selected_path varchar(20) NULL,
                          CONSTRAINT app_user_pkey PRIMARY KEY (id),
                          CONSTRAINT uk_username UNIQUE (username)
);

-- 2. B 路径 - 学习 (Learn)
CREATE TABLE module_group (
                              id bigserial NOT NULL,
                              sort_order integer NOT NULL,
                              title varchar(255) NOT NULL,
                              CONSTRAINT module_group_pkey PRIMARY KEY (id)
);
CREATE TABLE course_module (
                               id varchar(255) NOT NULL,
                               description text NULL,
                               title varchar(255) NOT NULL,
                               group_id bigint NULL,
                               CONSTRAINT course_module_pkey PRIMARY KEY (id),
                               CONSTRAINT fk_module_to_group FOREIGN KEY (group_id) REFERENCES module_group(id) ON DELETE SET NULL
);
CREATE TABLE module_content_block (
                                      id bigserial NOT NULL,
                                      content text NOT NULL,
                                      language varchar(255) NULL,
                                      sort_order integer NOT NULL,
                                      type varchar(255) NOT NULL,
                                      module_id varchar(255) NOT NULL,
                                      CONSTRAINT module_content_block_pkey PRIMARY KEY (id),
                                      CONSTRAINT fk_block_to_module FOREIGN KEY (module_id) REFERENCES course_module(id) ON DELETE CASCADE
);

-- 3. B 路径 - 项目 (Project)
CREATE TABLE project (
                         id varchar(255) NOT NULL,
                         title varchar(255) NOT NULL,
                         description text NULL,
                         tech_stack varchar(255) NOT NULL,
                         CONSTRAINT project_pkey PRIMARY KEY (id)
);
CREATE TABLE project_step (
                              id bigserial NOT NULL,
                              step_title varchar(255) NOT NULL,
                              sort_order integer NOT NULL,
                              project_id varchar(255) NOT NULL,
                              CONSTRAINT project_step_pkey PRIMARY KEY (id),
                              CONSTRAINT fk_step_to_project FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE
);
CREATE TABLE project_content_block (
                                       id bigserial NOT NULL,
                                       content text NOT NULL,
                                       language varchar(255) NULL,
                                       sort_order integer NOT NULL,
                                       type varchar(255) NOT NULL,
                                       step_id bigint NOT NULL,
                                       CONSTRAINT project_content_block_pkey PRIMARY KEY (id),
                                       CONSTRAINT fk_block_to_step FOREIGN KEY (step_id) REFERENCES project_step(id) ON DELETE CASCADE
);

-- 4. B 路径 - 算法 (Algorithm)
CREATE TABLE algorithm_problem (
                                   id varchar(255) NOT NULL,
                                   title varchar(255) NOT NULL,
                                   difficulty varchar(255) NOT NULL,
                                   CONSTRAINT algorithm_problem_pkey PRIMARY KEY (id)
);
CREATE TABLE algorithm_content_block (
                                         id bigserial NOT NULL,
                                         category varchar(255) NOT NULL,
                                         type varchar(255) NOT NULL,
                                         content text NOT NULL,
                                         language varchar(255) NULL,
                                         sort_order integer NOT NULL,
                                         problem_id varchar(255) NOT NULL,
                                         CONSTRAINT algorithm_content_block_pkey PRIMARY KEY (id),
                                         CONSTRAINT fk_block_to_problem FOREIGN KEY (problem_id) REFERENCES algorithm_problem(id) ON DELETE CASCADE
);

-- 5. A 路径 - 学习 (Learn)
CREATE TABLE beginner_level (
                                id bigserial NOT NULL,
                                title varchar(255) NOT NULL,
                                sort_order integer NOT NULL,
                                CONSTRAINT beginner_level_pkey PRIMARY KEY (id)
);
CREATE TABLE beginner_lesson (
                                 id bigserial NOT NULL,
                                 title varchar(255) NOT NULL,
                                 sort_order integer NOT NULL,
                                 level_id bigint NOT NULL,
                                 CONSTRAINT beginner_lesson_pkey PRIMARY KEY (id),
                                 CONSTRAINT fk_lesson_to_level FOREIGN KEY (level_id) REFERENCES beginner_level(id) ON DELETE CASCADE
);
CREATE TABLE beginner_lesson_content_block (
                                               id bigserial NOT NULL,
                                               content text NOT NULL,
                                               language varchar(255) NULL,
                                               sort_order integer NOT NULL,
                                               type varchar(255) NOT NULL,
                                               lesson_id bigint NOT NULL,
                                               CONSTRAINT beginner_lesson_content_block_pkey PRIMARY KEY (id),
                                               CONSTRAINT fk_block_to_lesson FOREIGN KEY (lesson_id) REFERENCES beginner_lesson(id) ON DELETE CASCADE
);

-- 6. A 路径 - 测验 (Quiz)
CREATE TABLE quiz_chapter (
                              id bigserial NOT NULL,
                              title varchar(255) NOT NULL,
                              sort_order integer NOT NULL,
                              CONSTRAINT quiz_chapter_pkey PRIMARY KEY (id)
);
CREATE TABLE quiz_question (
                               id bigserial NOT NULL,
                               text text NOT NULL,
                               chapter_id bigint NOT NULL,
                               CONSTRAINT quiz_question_pkey PRIMARY KEY (id),
                               CONSTRAINT fk_question_to_chapter FOREIGN KEY (chapter_id) REFERENCES quiz_chapter(id) ON DELETE CASCADE
);
CREATE TABLE quiz_option (
                             id bigserial NOT NULL,
                             text varchar(255) NOT NULL,
                             is_correct boolean NOT NULL,
                             question_id bigint NOT NULL,
                             CONSTRAINT quiz_option_pkey PRIMARY KEY (id),
                             CONSTRAINT fk_option_to_question FOREIGN KEY (question_id) REFERENCES quiz_question(id) ON DELETE CASCADE
);

-- 7. A 路径 - 编程 (Logic)
CREATE TABLE beginner_logic_problem (
                                        id bigserial NOT NULL,
                                        title varchar(255) NOT NULL,
                                        sort_order integer NOT NULL,
                                        CONSTRAINT beginner_logic_problem_pkey PRIMARY KEY (id)
);
CREATE TABLE beginner_logic_content_block (
                                              id bigserial NOT NULL,
                                              category varchar(255) NOT NULL,
                                              type varchar(255) NOT NULL,
                                              content text NOT NULL,
                                              language varchar(255) NULL,
                                              sort_order integer NOT NULL,
                                              problem_id bigint NOT NULL,
                                              CONSTRAINT beginner_logic_content_block_pkey PRIMARY KEY (id),
                                              CONSTRAINT fk_block_to_logic_problem FOREIGN KEY (problem_id) REFERENCES beginner_logic_problem(id) ON DELETE CASCADE
);

-- 8. 进度与收藏 (Progress & Bookmarks)
CREATE TABLE bookmark (
                          id bigserial NOT NULL,
                          app_user_id bigint NOT NULL,
                          bookmark_type varchar(50) NOT NULL,
                          bookmarked_id varchar(255) NOT NULL,
                          title varchar(255) NOT NULL,
                          created_at timestamp with time zone NOT NULL,
                          CONSTRAINT bookmark_pkey PRIMARY KEY (id),
                          CONSTRAINT fk_bookmark_to_user FOREIGN KEY (app_user_id) REFERENCES app_user(id) ON DELETE CASCADE,
                          CONSTRAINT uk_user_bookmark UNIQUE (app_user_id, bookmark_type, bookmarked_id)
);
CREATE TABLE beginner_lesson_progress (
                                          id bigserial NOT NULL,
                                          app_user_id bigint NOT NULL,
                                          beginner_lesson_id bigint NOT NULL,
                                          completed_at timestamp with time zone NOT NULL,
                                          CONSTRAINT beginner_lesson_progress_pkey PRIMARY KEY (id),
                                          CONSTRAINT fk_progress_to_user FOREIGN KEY (app_user_id) REFERENCES app_user(id) ON DELETE CASCADE,
                                          CONSTRAINT fk_progress_to_lesson FOREIGN KEY (beginner_lesson_id) REFERENCES beginner_lesson(id) ON DELETE CASCADE,
                                          CONSTRAINT uk_user_lesson_progress UNIQUE (app_user_id, beginner_lesson_id)
);
CREATE TABLE quiz_mistake (
                              id bigserial NOT NULL,
                              app_user_id bigint NOT NULL,
                              quiz_question_id bigint NOT NULL,
                              last_answered_at timestamp with time zone NOT NULL,
                              CONSTRAINT quiz_mistake_pkey PRIMARY KEY (id),
                              CONSTRAINT fk_mistake_to_user FOREIGN KEY (app_user_id) REFERENCES app_user(id) ON DELETE CASCADE,
                              CONSTRAINT fk_mistake_to_question FOREIGN KEY (quiz_question_id) REFERENCES quiz_question(id) ON DELETE CASCADE,
                              CONSTRAINT uk_user_question_mistake UNIQUE (app_user_id, quiz_question_id)
);

-- 1. 徽章定义表
CREATE TABLE badge (
                       id varchar(100) NOT NULL,
                       title varchar(255) NOT NULL,
                       description text NOT NULL,
                       icon_name varchar(100) NOT NULL,
                       CONSTRAINT badge_pkey PRIMARY KEY (id),
                       CONSTRAINT uk_badge_title UNIQUE (title)
);

-- 2. 用户徽章连接表
CREATE TABLE user_badge (
                            id bigserial NOT NULL,
                            app_user_id bigint NOT NULL,
                            badge_id varchar(100) NOT NULL,
                            earned_at timestamp with time zone NOT NULL,

                            CONSTRAINT user_badge_pkey PRIMARY KEY (id),
                            CONSTRAINT fk_user_badge_to_user FOREIGN KEY (app_user_id) REFERENCES app_user(id) ON DELETE CASCADE,
                            CONSTRAINT fk_user_badge_to_badge FOREIGN KEY (badge_id) REFERENCES badge(id) ON DELETE CASCADE,
                            CONSTRAINT uk_user_badge UNIQUE (app_user_id, badge_id) -- 唯一约束
);