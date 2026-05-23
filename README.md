# JavaNotes 智能学习助手

JavaNotes 是一套面向 Java 自学场景的全栈学习系统，移动端负责学习体验，后端负责课程内容、认证、AI 能力、代码运行与数据持久化。项目希望把“看课程、问问题、写代码、做练习、复盘错题、沉淀笔记”串成一个完整闭环。

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-6DB33F?logo=springboot)
![Java](https://img.shields.io/badge/Java-17-ED8B00?logo=openjdk)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-4169E1?logo=postgresql)
![Redis](https://img.shields.io/badge/Redis-cache-DC382D?logo=redis)

## 在线展示

- GitHub Pages: `https://wufal.github.io/JavaNotes/`
- [项目 HTML 首页](index.html)
- [技术报告](docs/technical-report.html)
- [功能展示页](docs/screenshots-report.html)

> 开源版本已移除公网服务器地址、APK 下载链接、数据库密码、AI Key、JWT Secret 等敏感信息。运行时请使用自己的环境变量和服务地址。

## 项目亮点

- A/B 双路径学习：零基础闯关路径与进阶项目/算法路径并行。
- AI 智能助教：支持上下文问答、代码解释、纠错建议和每日练习生成。
- 在线代码沙盒：在移动端编写并运行 Java 代码，形成即时反馈。
- 算法可视化：通过 WebView 加载动态演示资源，辅助理解复杂算法。
- 本地知识库：离线优先的 Markdown 笔记系统，适合沉淀学习内容。
- 学习激励体系：错题本、收藏、徽章、评论和个人资料组成完整学习社区。

## 仓库结构

```text
JavaNotes
├── todo_mobile/     # Flutter 移动端
├── todo_service/    # Spring Boot 后端
├── docs/            # 脱敏后的 HTML 报告页
├── index.html       # 项目介绍页
└── README.md
```

## 技术栈

| 模块 | 技术 |
| --- | --- |
| 移动端 | Flutter, Provider, Sqflite, WebView Flutter |
| 后端 | Spring Boot 3.x, Spring Security, Spring Data JPA |
| 数据 | PostgreSQL, Flyway, Redis |
| 认证 | JWT |
| AI | 可切换 Mock/真实 LLM 服务 |
| 代码运行 | Java Compiler API |

## 后端配置

敏感配置不提交到仓库，请通过环境变量注入。

| 变量 | 说明 |
| --- | --- |
| `DB_URL` | PostgreSQL JDBC 地址 |
| `DB_USERNAME` | 数据库用户名 |
| `DB_PASSWORD` | 数据库密码 |
| `AI_SERVICE_MODE` | `mock` 或 `real` |
| `AI_LLM_API_KEY` | 大模型 API Key |
| `JWT_SECRET` | JWT 签名密钥 |
| `REDIS_HOST` | Redis 主机 |
| `REDIS_PORT` | Redis 端口 |

本地启动后端：

```bash
cd todo_service
./mvnw spring-boot:run
```

Windows 可以使用：

```bash
cd todo_service
mvnw.cmd spring-boot:run
```

## 移动端运行

Android 模拟器访问本机后端时，默认地址为 `http://10.0.2.2:8080`。也可以通过 `--dart-define` 指定自己的后端地址。

```bash
cd todo_mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

## 核心模块

### AI 助教与每日一练

后端将大模型生成流程设计为异步任务，避免移动端等待时间过长。用户提交练习配置后，服务端创建任务、后台调用 AI、更新任务状态，移动端再轮询或刷新获取结果。

### 在线代码沙盒

后端基于 Java Compiler API 运行用户提交的 Java 代码，用于支撑闯关练习和代码片段验证。

### 算法可视化

算法动画作为静态资源放在后端，移动端通过 WebView 加载，并根据运行环境拼接服务地址。

### 本地知识库

移动端使用 Sqflite 存储笔记和练习记录，支持离线查看与编辑。

## 安全说明

本仓库中的配置均为开源占位值。生产部署前请务必设置高强度 `JWT_SECRET`，替换数据库密码，妥善保管 AI Key，并避免将任何 `.env` 或 IDE 本地配置提交到仓库。
