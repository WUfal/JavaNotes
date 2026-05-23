-- V1.6__add_project_chat_app_steps.sql
-- -----------------------------------------------------
-- Java C/S Chat Room Project SQL Insertion Script
-- -----------------------------------------------------
-- Project ID: 'proj_chat_app' (MUST exist in 'project' table)
-- Step IDs start from 18.
-- -----------------------------------------------------
-----------------------------------------------------
-- 2. B 路径：项目 (Project)
-----------------------------------------------------

-- Step 18: 整体说明 (Overall Introduction)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (18, 'Java 简易聊天室全流程 - 整体说明', 18, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'一、整体说明', NULL, 1, 'sub-header', 18),
    (E'架构： C/S（客户端/服务器）', NULL, 2, 'text', 18),
    (E'核心技术：TCP Socket（可靠连接）、Java 多线程（处理多客户端并发）、Swing（客户端图形界面）', NULL, 3, 'text', 18),
    (E'核心功能：服务器监听连接、多客户端同时在线、消息广播（发给所有在线用户）、单人消息发送、连接/断开通知', NULL, 4, 'text', 18),
    (E'开发环境：JDK 8+、IDE（IDEA/Eclipse，推荐IDEA）', NULL, 5, 'text', 18);

-- Step 19: 步骤1：环境准备 (Step 1: Environment Prep)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (19, '步骤1：环境准备', 19, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'二、全流程步骤（共7步）', NULL, 1, 'sub-header', 19),
    (E'步骤1：环境准备', NULL, 2, 'sub-header', 19),
    (E'安装JDK 8+，配置环境变量（ JAVA_HOME 、 Path ）', NULL, 3, 'text', 19),
    (E'验证：命令行输入  java -version ，显示版本号则成功', NULL, 4, 'text', 19),
    (E'打开IDE，创建Java项目（命名： SimpleChatRoom ）', NULL, 5, 'text', 19),
    (E'项目结构规划：', NULL, 6, 'text', 19),
    (E'SimpleChatRoom/\n├── src/\n│   ├── client/\n│   │   ├── ChatClient.java       (客户端主类, Swing界面)\n│   │   └── MessageListener.java  (客户端消息监听线程)\n│   └── server/\n│       ├── ChatServer.java         (服务器主类, 监听)\n│       ├── ClientHandler.java      (服务器端, 客户端处理线程)\n│       └── ClientManager.java      (服务器端, 客户端管理工具)\n└── out/ (编译输出目录)\n', 'text', 7, 'code', 19);

-- Step 20: 步骤2：需求分析 (Step 2: Requirements)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (20, '步骤2：需求分析', 20, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'步骤2：需求分析（明确核心功能）', NULL, 1, 'sub-header', 20),
    (E'**服务器端：**\n* 启动后监听指定端口（如8888）\n* 接收新客户端连接，为每个客户端创建独立线程\n* 接收客户端消息，广播给所有在线客户端（或转发给指定用户）\n* 检测客户端断开连接，移除该客户端并通知其他用户', NULL, 2, 'text', 20),
    (E'**客户端：**\n* 输入服务器IP（本地测试用 127.0.0.1 ）和端口，连接服务器\n* 输入用户名（唯一标识）\n* 图形界面：显示聊天记录、输入消息、发送按钮\n* 发送消息给服务器，接收服务器广播的消息并显示\n* 断开连接时通知服务器', NULL, 3, 'text', 20);

-- Step 21: 步骤3：服务器端开发 (ClientManager)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (21, '步骤3：服务器端开发 (ClientManager)', 21, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'步骤3：服务器端开发（核心：多线程处理并发）', NULL, 1, 'sub-header', 21),
    (E'3.1 编写客户端管理工具（共享资源，线程安全）', NULL, 2, 'sub-header', 21),
    (E'先创建一个工具类，管理所有在线客户端的输出流（用于广播），确保线程安全：', NULL, 3, 'text', 21),
    (E'package server;\nimport java.io.PrintWriter;\nimport java.util.concurrent.ConcurrentHashMap;\n\n/**\n * 客户端管理工具 (线程安全)\n * 存储所有在线的客户端 (用户名 -> 输出流)\n */\npublic class ClientManager {\n    // 使用 ConcurrentHashMap 确保线程安全\n    private static ConcurrentHashMap<String, PrintWriter> clients = new ConcurrentHashMap<>();\n\n    // 添加客户端\n    public static void addClient(String username, PrintWriter writer) {\n        clients.put(username, writer);\n        System.out.println(username + " 加入了聊天室, 当前在线: " + clients.size());\n    }\n\n    // 移除客户端\n    public static void removeClient(String username) {\n        clients.remove(username);\n        System.out.println(username + " 离开了聊天室, 当前在线: " + clients.size());\n    }\n\n    // 广播消息 (给所有客户端)\n    public static void broadcastMessage(String sender, String message) {\n        // 遍历所有客户端并发送消息\n        for (PrintWriter writer : clients.values()) {\n            writer.println(sender + ": " + message);\n            writer.flush(); // 确保消息立即发送\n        }\n    }\n\n    // (扩展: 获取所有在线用户名, 用于私聊或列表)\n    public static boolean isUsernameTaken(String username) {\n        return clients.containsKey(username);\n    }\n}\n', 'java', 4, 'code', 21);

-- Step 22: 步骤3：服务器端开发 (ClientHandler)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (22, '步骤3：服务器端开发 (ClientHandler)', 22, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'3.2 编写客户端处理线程（ ClientHandler.java ）', NULL, 1, 'sub-header', 22),
    (E'每个客户端连接后，服务器启动一个该线程，负责：\n* 读取客户端消息\n* 处理用户名验证\n* 广播消息\n* 处理客户端断开', NULL, 2, 'text', 22),
    (E'package server;\nimport java.io.BufferedReader;\nimport java.io.InputStreamReader;\nimport java.io.PrintWriter;\nimport java.net.Socket;\nimport java.nio.charset.StandardCharsets;\n\n/**\n * 客户端处理线程\n * 负责与单个客户端通信\n */\npublic class ClientHandler extends Thread {\n    private Socket socket;\n    private BufferedReader reader;\n    private PrintWriter writer;\n    private String username;\n\n    public ClientHandler(Socket socket) {\n        this.socket = socket;\n    }\n\n    @Override\n    public void run() {\n        try {\n            // 1. 初始化 IO 流\n            reader = new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8));\n            writer = new PrintWriter(socket.getOutputStream(), true, StandardCharsets.UTF_8);\n\n            // 2. 验证用户名 (第一条消息必须是用户名)\n            while (true) {\n                username = reader.readLine();\n                if (username == null || username.trim().isEmpty()) {\n                    writer.println("SERVER_ERROR: 用户名不能为空!");\n                    continue;\n                }\n                if (ClientManager.isUsernameTaken(username)) {\n                    writer.println("SERVER_ERROR: 用户名已被占用!");\n                    continue;\n                }\n                // 验证通过\n                ClientManager.addClient(username, writer);\n                writer.println("SERVER_SUCCESS: 连接成功!");\n                break;\n            }\n            \n            // 3. 广播该用户上线\n            ClientManager.broadcastMessage("系统通知", username + " 上线了!");\n\n            // 4. 持续读取并广播消息\n            String message;\n            while ((message = reader.readLine()) != null) {\n                ClientManager.broadcastMessage(username, message);\n            }\n\n        } catch (Exception e) {\n            // 客户端异常断开\n            System.out.println("连接异常: " + e.getMessage());\n        } finally {\n            // 5. 清理资源, 广播下线\n            if (username != null) {\n                ClientManager.removeClient(username);\n                ClientManager.broadcastMessage("系统通知", username + " 下线了。");\n            }\n            try {\n                if (socket != null) socket.close();\n            } catch (Exception e) {\n                e.printStackTrace();\n            }\n        }\n    }\n}\n', 'java', 3, 'code', 22);

-- Step 23: 步骤3：服务器端开发 (ChatServer)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (23, '步骤3：服务器端开发 (ChatServer)', 23, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'3.3 编写服务器主类（ ChatServer.java ）', NULL, 1, 'sub-header', 23),
    (E'负责启动服务器，监听端口，接收客户端连接并创建线程：', NULL, 2, 'text', 23),
    (E'package server;\nimport java.net.ServerSocket;\nimport java.net.Socket;\n\n/**\n * 聊天室服务器主类\n */\npublic class ChatServer {\n    private static final int PORT = 8888; // 监听端口\n\n    public static void main(String[] args) {\n        try (ServerSocket serverSocket = new ServerSocket(PORT)) {\n            System.out.println("聊天室服务器已启动，监听端口：" + PORT + "（等待客户端连接...）");\n\n            while (true) {\n                // 1. 接受客户端连接 (阻塞)\n                Socket clientSocket = serverSocket.accept();\n                System.out.println("新客户端连接: " + clientSocket.getRemoteSocketAddress());\n                \n                // 2. 为每个客户端启动一个新线程\n                ClientHandler clientHandler = new ClientHandler(clientSocket);\n                clientHandler.start();\n            }\n        } catch (Exception e) {\n            System.out.println("服务器启动失败! 端口可能被占用。");\n            e.printStackTrace();\n        }\n    }\n}\n', 'java', 3, 'code', 23);

-- Step 24: 步骤4：客户端开发 (MessageListener)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (24, '步骤4：客户端开发 (MessageListener)', 24, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'步骤4：客户端开发（核心：Swing界面+消息监听线程）', NULL, 1, 'sub-header', 24),
    (E'4.1 编写消息监听线程（ MessageListener.java ）', NULL, 2, 'sub-header', 24),
    (E'客户端连接服务器后，启动该线程，持续监听服务器消息并更新界面：', NULL, 3, 'text', 24),
    (E'package client;\nimport javax.swing.JTextArea;\nimport javax.swing.SwingUtilities;\nimport java.io.BufferedReader;\n\n/**\n * 消息监听线程\n * 负责持续从服务器读取消息, 并更新到 JTextArea\n */\npublic class MessageListener extends Thread {\n    private BufferedReader reader;\n    private JTextArea chatArea; // (UI组件)\n\n    public MessageListener(BufferedReader reader, JTextArea chatArea) {\n        this.reader = reader;\n        this.chatArea = chatArea;\n    }\n\n    @Override\n    public void run() {\n        try {\n            String message;\n            while ((message = reader.readLine()) != null) {\n                // (重要) 更新UI必须在 Swing Event Dispatch Thread (EDT) 中执行\n                final String finalMessage = message;\n                SwingUtilities.invokeLater(() -> {\n                    chatArea.append(finalMessage + "\n");\n                    // 自动滚动到底部\n                    chatArea.setCaretPosition(chatArea.getDocument().getLength());\n                });\n            }\n        } catch (Exception e) {\n            // (当客户端主动断开连接时, reader.readLine() 会抛出异常)\n            System.out.println("与服务器断开连接: " + e.getMessage());\n            SwingUtilities.invokeLater(() -> chatArea.append("--- 已与服务器断开连接 ---\n"));\n        }\n    }\n}\n', 'java', 4, 'code', 24);

-- Step 25: 步骤4：客户端开发 (ChatClient)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (25, '步骤4：客户端开发 (ChatClient)', 25, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'4.2 编写客户端界面+核心逻辑（ ChatClient.java ）', NULL, 1, 'sub-header', 25),
    (E'用Swing构建图形界面，实现连接服务器、发送消息、断开连接功能：', NULL, 2, 'text', 25),
    (E'package client;\n\nimport javax.swing.*;\nimport java.awt.*;\nimport java.awt.event.ActionEvent;\nimport java.awt.event.ActionListener;\nimport java.awt.event.WindowAdapter;\nimport java.awt.event.WindowEvent;\nimport java.io.BufferedReader;\nimport java.io.InputStreamReader;\nimport java.io.PrintWriter;\nimport java.net.Socket;\nimport java.nio.charset.StandardCharsets;\n\n/**\n * 聊天室客户端主类 (Swing 界面)\n */\npublic class ChatClient {\n    private JFrame frame;\n    private JTextArea chatArea;\n    private JTextField msgField;\n    private JTextField ipField;\n    private JTextField portField;\n    private JTextField usernameField;\n    private JButton connectButton;\n    private JButton sendButton;\n\n    private Socket socket;\n    private BufferedReader reader;\n    private PrintWriter writer;\n    private MessageListener messageListener;\n\n    public static void main(String[] args) {\n        // 确保UI在EDT中创建\n        SwingUtilities.invokeLater(() -> new ChatClient().buildUI());\n    }\n\n    private void buildUI() {\n        frame = new JFrame("Java 简易聊天室 - 客户端");\n        frame.setSize(600, 400);\n        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);\n\n        // 1. 连接面板 (顶部)\n        JPanel topPanel = new JPanel(new FlowLayout());\n        topPanel.add(new JLabel("IP:"));\n        ipField = new JTextField("127.0.0.1", 10);\n        topPanel.add(ipField);\n        topPanel.add(new JLabel("Port:"));\n        portField = new JTextField("8888", 5);\n        topPanel.add(portField);\n        topPanel.add(new JLabel("用户名:"));\n        usernameField = new JTextField("User" + (int) (Math.random() * 1000), 8);\n        topPanel.add(usernameField);\n        connectButton = new JButton("连接");\n        topPanel.add(connectButton);\n        frame.add(topPanel, BorderLayout.NORTH);\n\n        // 2. 聊天区域 (中部)\n        chatArea = new JTextArea();\n        chatArea.setEditable(false);\n        chatArea.setLineWrap(true);\n        JScrollPane scrollPane = new JScrollPane(chatArea);\n        frame.add(scrollPane, BorderLayout.CENTER);\n\n        // 3. 发送面板 (底部)\n        JPanel bottomPanel = new JPanel(new BorderLayout());\n        msgField = new JTextField();\n        bottomPanel.add(msgField, BorderLayout.CENTER);\n        sendButton = new JButton("发送");\n        bottomPanel.add(sendButton, BorderLayout.EAST);\n        frame.add(bottomPanel, BorderLayout.SOUTH);\n\n        // 4. 设置初始状态 (未连接)\n        setConnectionStatus(false);\n\n        // 5. 添加事件监听\n        addListeners();\n\n        frame.setVisible(true);\n    }\n\n    private void addListeners() {\n        // 连接/断开 按钮\n        connectButton.addActionListener(new ActionListener() {\n            @Override\n            public void actionPerformed(ActionEvent e) {\n                if (socket == null || socket.isClosed()) {\n                    connectToServer();\n                } else {\n                    disconnect();\n                }\n            }\n        });\n\n        // 发送按钮\n        ActionListener sendListener = new ActionListener() {\n            @Override\n            public void actionPerformed(ActionEvent e) {\n                sendMessage();\n            }\n        };\n        sendButton.addActionListener(sendListener);\n        msgField.addActionListener(sendListener); // 按回车也发送\n\n        // 关闭窗口时 (断开连接)\n        frame.addWindowListener(new WindowAdapter() {\n            @Override\n            public void windowClosing(WindowEvent e) {\n                if (socket != null && !socket.isClosed()) {\n                    disconnect();\n                }\n            }\n        });\n    }\n\n    // (核心) 连接服务器\n    private void connectToServer() {\n        try {\n            String ip = ipField.getText().trim();\n            int port = Integer.parseInt(portField.getText().trim());\n            String username = usernameField.getText().trim();\n\n            if (ip.isEmpty() || username.isEmpty()) {\n                JOptionPane.showMessageDialog(frame, "IP 和 用户名 不能为空", "连接错误", JOptionPane.ERROR_MESSAGE);\n                return;\n            }\n\n            // 1. 建立连接\n            socket = new Socket(ip, port);\n            reader = new BufferedReader(new InputStreamReader(socket.getInputStream(), StandardCharsets.UTF_8));\n            writer = new PrintWriter(socket.getOutputStream(), true, StandardCharsets.UTF_8);\n\n            // 2. 发送用户名 (第一条消息)\n            writer.println(username);\n\n            // 3. 启动消息监听线程\n            messageListener = new MessageListener(reader, chatArea);\n            messageListener.start();\n            \n            // (假设第一条消息由 MessageListener 处理)\n            // 我们只更新UI状态\n            setConnectionStatus(true);\n            chatArea.append("--- 连接服务器 " + ip + ":" + port + " 成功 ---\n");\n\n        } catch (Exception e) {\n            e.printStackTrace();\n            JOptionPane.showMessageDialog(frame, "连接服务器失败: " + e.getMessage(), "连接错误", JOptionPane.ERROR_MESSAGE);\n        }\n    }\n\n    // (核心) 发送消息\n    private void sendMessage() {\n        String msg = msgField.getText().trim();\n        if (!msg.isEmpty() && writer != null) {\n            writer.println(msg);\n            writer.flush();\n            msgField.setText(""); // 清空输入框\n        }\n    }\n\n    // (核心) 断开连接\n    private void disconnect() {\n        try {\n            // 关闭Socket会导致 MessageListener 中的 readLine 抛出异常, 从而终止线程\n            if (socket != null) socket.close();\n            // (reader 和 writer 会随 socket 关闭)\n        } catch (Exception e) {\n            e.printStackTrace();\n        } finally {\n            setConnectionStatus(false);\n            chatArea.append("--- 已断开连接 ---\n");\n        }\n    }\n    \n    // 更新UI状态\n    private void setConnectionStatus(boolean connected) {\n        ipField.setEnabled(!connected);\n        portField.setEnabled(!connected);\n        usernameField.setEnabled(!connected);\n        connectButton.setText(connected ? "断开" : "连接");\n        \n        chatArea.setEnabled(connected);\n        msgField.setEnabled(connected);\n        sendButton.setEnabled(connected);\n    }\n}\n', 'java', 3, 'code', 25);

-- Step 26: 步骤5 & 6：编译与测试 (Steps 5 & 6: Compile/Test)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (26, '步骤5 & 6：编译与测试', 26, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'步骤5：代码编译（IDE自动完成）\n* 在IDE中，右键项目 ->  Build Project （或快捷键 Ctrl+F9 ）\n* 编译成功后， out 目录下会生成 .class 文件（无需手动处理）', NULL, 1, 'text', 26),
    (E'步骤6：测试运行（关键步骤）', NULL, 2, 'sub-header', 26),
    (E'**6.1 启动服务器**\n* 找到 ChatServer.java  -> 右键 ->  Run \'ChatServer.main()\'\n* 控制台输出： 聊天室服务器已启动，监听端口：8888（等待客户端连接...） ，表示服务器启动成功', NULL, 3, 'text', 26),
    (E'**6.2 启动客户端（多实例测试）**\n* 找到 ChatClient.java  -> 右键 ->  Run \'ChatClient.main()\' ，启动第一个客户端\n* 再启动1-2个客户端（IDEA中： Run  ->  Run...  -> 选择 ChatClient  -> 点击 Run ）\n* **客户端操作：**\n    * 每个客户端输入不同的用户名（避免重复）\n    * 点击「连接」按钮（默认IP 127.0.0.1 ，端口 8888 ，本地测试无需修改）\n    * 连接成功后，在输入框输入消息，点击「发送」或按回车\n    * 观察所有客户端是否能收到广播消息\n    * 关闭某个客户端，观察其他客户端是否收到「下线通知」', NULL, 4, 'text', 26),
    (E'**6.3 测试场景验证**\n* **多客户端连接**: 服务器控制台显示新连接，客户端显示「连接成功」\n* **发送消息**: 所有在线客户端都能收到该消息\n* **用户名重复**: 后连接的客户端收到「用户名已被占用」提示\n* **客户端断开连接**: 其他客户端收到「XXX已下线」通知\n* **服务器关闭**: 所有客户端显示「与服务器断开连接」\n', NULL, 5, 'text', 26);

-- Step 27: 步骤7：常见问题排查 (Step 7: Troubleshooting)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (27, '步骤7：常见问题排查', 27, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'步骤7：常见问题排查', NULL, 1, 'sub-header', 27),
    (E'**端口被占用**：\n* 错误提示： 服务器启动失败！端口可能被占用。\n* 解决：修改 ChatServer.java 中的 PORT （如改为8889），同时客户端端口输入框也改为对应端口', NULL, 2, 'text', 27),
    (E'**连接失败**：\n* 检查服务器IP是否正确（本地测试用 127.0.0.1 ，局域网测试用服务器真实IP）\n* 检查服务器是否已启动\n* 检查防火墙是否阻止了端口（关闭防火墙或开放8888端口）', NULL, 3, 'text', 27),
    (E'**消息乱码**：\n* 确保所有流的编码都是 UTF-8 （代码中已设置，无需修改）', NULL, 4, 'text', 27),
    (E'**客户端界面无响应**：\n* 确保消息监听线程是独立线程（代码中已实现，避免UI线程阻塞）', NULL, 5, 'text', 27);

-- Step 28: 扩展优化与总结 (Extensions & Summary)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (28, '扩展优化与核心技术总结', 28, 'proj_chat_app');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (E'三、扩展优化（可选）\n* 增加「私聊功能」：消息格式改为 @用户名:消息内容 ，服务器解析后转发给指定用户\n* 增加「在线用户列表」：客户端界面添加 JList ，服务器定时推送在线用户，客户端更新列表\n* 增加「消息记录保存」：将聊天记录写入本地文件（如 chat.log ）\n* 增加「表情/文件传输」：扩展消息格式，支持二进制文件传输（需处理流的二进制读写）\n* 优化界面：添加皮肤、消息气泡样式、字体颜色等', NULL, 1, 'text', 28),
    (E'四、核心技术总结\n* **Socket编程**： ServerSocket （服务器监听）、 Socket （客户端连接），基于TCP协议实现可靠通信\n* **多线程**：服务器用 ClientHandler 线程处理每个客户端，避免单线程阻塞；客户端用 MessageListener 线程监听消息，避免UI线程卡死\n* **IO流**： BufferedReader （读文本消息）、 PrintWriter （写文本消息），指定 UTF-8 编码避免乱码\n* **Swing**：基于AWT的图形界面框架，用 JFrame 、 JTextArea 、 JButton 等组件构建客户端界面，注意UI线程安全（ SwingUtilities.invokeLater ）\n* **线程安全**：用 ConcurrentHashMap 存储在线客户端，避免多线程并发修改问题', NULL, 2, 'text', 28),
    (E'通过以上步骤，你已经实现了一个功能完整的Java简易聊天室！', NULL, 3, 'text', 28);


-- -----------------------------------------------------
-- (重要) 更新所有被修改表的序列号
-- -----------------------------------------------------

SELECT setval('project_step_id_seq', (SELECT MAX(id) FROM project_step));
SELECT setval('project_content_block_id_seq', (SELECT MAX(id) FROM project_content_block));