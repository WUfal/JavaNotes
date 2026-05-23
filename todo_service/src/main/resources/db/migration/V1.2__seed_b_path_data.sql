-- 版本 1.3: (优化版) 丰富 'text' 内容并支持 Markdown 格式 (Part 1/6)

-----------------------------------------------------
-- 1. B 路径：学习 (Learn) - (Groups 1-3)
-----------------------------------------------------

-- 1a. 学习分组 (ModuleGroup)
INSERT INTO module_group (id, title, sort_order) VALUES
                                                     (1, '核心基础 (复习)', 1),
                                                     (2, '高级主题 (进阶)', 2),
                                                     (3, '主流框架与生态', 3);

-- 1b. 课程模块 (CourseModule)
INSERT INTO course_module (id, title, description, group_id) VALUES
                                                                 ('core_oop', '面向对象 (OOP)', '深入理解封装、继承和多态', 1),
                                                                 ('core_collections', '集合框架 (Collections)', 'List, Map, Set, HashMap 源码分析', 1),
                                                                 ('adv_jvm', 'JVM 虚拟机', '内存模型 (JMM), 垃圾收集 (GC), 类加载', 2),
                                                                 ('adv_concurrency', '并发编程 (JUC)', 'volatile, synchronized, AQS, 线程池', 2),
                                                                 ('frm_springboot', 'Spring Boot 核心', '自动配置原理, Starter, Actuator', 3),
                                                                 ('frm_spring', 'Spring 框架', 'IoC, AOP, 事务管理', 3);

-- 1c. 模块内容 (Content Blocks)

-- (模块: core_oop - 丰富内容)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('core_oop', 'text', E'面向对象编程 (OOP) 是 Java 语言的基石。它允许我们将现实世界的事物抽象为代码中的“对象”。\n\nOOP 主要基于三个核心原则：', NULL, 1),
                                                                                      ('core_oop', 'sub-header', '1. 封装 (Encapsulation)', NULL, 2),
                                                                                      ('core_oop', 'text', E'封装（Encapsulation）是将数据（**私有变量**）和操作这些数据的方法（**公共方法**）捆绑在一个“类” (Class) 中的机制。\n\n* **目的**：隐藏内部实现细节，只暴露必要的接口。\n* **实现**：主要通过 `private` 关键字实现数据隐藏，通过 `public` getter/setter 方法暴露操作。', NULL, 3),
                                                                                      ('core_oop', 'code', E'public class Car {\n    // "private" 实现了封装\n    private int speed;\n\n    // "public" 方法暴露操作\n    public void setSpeed(int speed) {\n        if (speed > 0) {\n            this.speed = speed;\n        }\n    }\n\n    public int getSpeed() {\n        return this.speed;\n    }\n}', 'java', 4),
                                                                                      ('core_oop', 'sub-header', '2. 继承 (Inheritance)', NULL, 5),
                                                                                      ('core_oop', 'text', E'继承（Inheritance）允许一个类（**子类** / Subclass）自动获取另一个类（**父类** / Superclass）的非私有属性和方法。\n\n* **目的**：实现代码复用，并建立“is-a”的关系 (例如 `Car` **is a** `Vehicle`)。\n* **实现**：使用 `extends` 关键字。Java 只支持“单继承”。', NULL, 6),
                                                                                      ('core_oop', 'code', E'// 父类\nclass Vehicle {\n    String brand = "Ford";\n}\n\n// 子类继承了 Vehicle\nclass Car extends Vehicle {\n    public static void main(String[] args) {\n        Car myCar = new Car();\n        // "brand" 属性是从 Vehicle 继承来的\n        System.out.println(myCar.brand); \n    }\n}', 'java', 7),
                                                                                      ('core_oop', 'sub-header', '3. 多态 (Polymorphism)', NULL, 8),
                                                                                      ('core_oop', 'text', E'多态（Polymorphism）意味着“多种形态”。它允许“父类引用”指向“子类对象”，并在运行时根据对象的“实际类型”来调用相应的方法。\n\n* **实现方式**：\n    1.  **方法重写 (Overriding)**：子类重写父类的方法。\n    2.  **接口实现 (Implementing)**：不同的类实现同一个接口。\n* **好处**：极大地提高了代码的灵活性和可扩展性。', NULL, 9),
                                                                                      ('core_oop', 'code', E'interface Animal {\n    void animalSound(); // 接口方法\n}\n\nclass Pig implements Animal {\n    public void animalSound() {\n        System.out.println("猪叫: wee wee");\n    }\n}\n\nclass Dog implements Animal {\n    public void animalSound() {\n        System.out.println("狗叫: bow wow");\n    }\n}', 'java', 10);

-- (模块: core_collections - 丰富内容)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('core_collections', 'text', E'Java 集合框架 (Collections Framework) 提供了一套标准、高效的数据结构，用于存储和操作对象组。\n\n所有集合都位于 `java.util` 包下，核心接口包括 `Collection` 和 `Map`。', NULL, 1),
                                                                                      ('core_collections', 'sub-header', '1. List (列表)', NULL, 2),
                                                                                      ('core_collections', 'text', E'`List` 是一个**有序**的集合（元素按插入顺序存储），并且**允许重复**元素。\n\n* `ArrayList`：(常用) 基于**动态数组**实现。**查询（get）** 速度快 (O(1))，**增删** 慢 (O(n))。\n* `LinkedList`：(少用) 基于**双向链表**实现。**头尾增删** 速度快 (O(1))，**查询** 慢 (O(n))。', NULL, 3),
                                                                                      ('core_collections', 'code', E'List<String> fruits = new ArrayList<>();\nfruits.add("Apple");\nfruits.add("Banana");\nfruits.add("Apple"); // 允许重复\n\nSystem.out.println(fruits.get(1)); // 输出 "Banana"', 'java', 4),
                                                                                      ('core_collections', 'sub-header', '2. Map (映射)', NULL, 5),
                                                                                      ('core_collections', 'text', E'`Map` 存储“键值对” (key-value pairs)。键 (Key) 必须是**唯一**的，值 (Value) 可以重复。\n\n* `HashMap`：(常用) 基于哈希表实现，**无序**，提供 O(1) 的平均存取时间。允许 `null` 键和 `null` 值。\n* `TreeMap`：基于红黑树实现，**有序**（按 Key 排序）。\n* `ConcurrentHashMap`：(并发) 线程安全的 `HashMap`。', NULL, 6),
                                                                                      ('core_collections', 'code', E'Map<String, Integer> studentGrades = new HashMap<>();\nstudentGrades.put("Alice", 95);\nstudentGrades.put("Bob", 88);\n\nSystem.out.println(studentGrades.get("Alice")); // 输出 95', 'java', 7),
                                                                                      ('core_collections', 'sub-header', '3. Set (集合)', NULL, 8),
                                                                                      ('core_collections', 'text', E'`Set` 是一个**不允许重复**元素的集合。它不保证顺序（除非使用特定实现）。\n\n* `HashSet`：(常用) 基于 `HashMap` 实现（它只使用 Key，Value 存一个虚拟对象），**无序**。\n* `TreeSet`：基于 `TreeMap` 实现，**有序**。', NULL, 9),
                                                                                      ('core_collections', 'code', E'Set<String> uniqueFruits = new HashSet<>();\nuniqueFruits.add("Apple");\nuniqueFruits.add("Banana");\nuniqueFruits.add("Apple"); // 这个 "Apple" 会被忽略\n\nSystem.out.println(uniqueFruits.size()); // 输出 2', 'java', 10);

-- (模块: adv_jvm - 丰富内容)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('adv_jvm', 'text', E'JVM (Java Virtual Machine) 是 Java 虚拟机的缩写。它是一个抽象的计算模型，是 Java 实现“**一次编译，到处运行**” (Write Once, Run Anywhere) 的核心。\n\n它负责加载 `.class` 字节码文件，将其解释或编译为特定平台的机器码并执行。', NULL, 1),
                                                                                      ('adv_jvm', 'sub-header', '1. JVM 内存区域', NULL, 2),
                                                                                      ('adv_jvm', 'text', E'根据 Java 虚拟机规范 (Java Virtual Machine Specification)，JVM 在运行时管理的内存区域（**JMM，Java 内存模型**）分为两大部分：', NULL, 3),
                                                                                      ('adv_jvm', 'code', E'// 线程私有 (Thread-Private): (每个线程独享)\n1. 程序计数器 (PC Register)\n2. Java 虚拟机栈 (VM Stack)\n3. 本地方法栈 (Native Method Stack)\n\n// 线程共享 (Thread-Shared): (所有线程共享)\n1. Java 堆 (Java Heap)\n2. 方法区 (Method Area) (JDK 8+ 为 Metaspace)', 'plaintext', 4),
                                                                                      ('adv_jvm', 'sub-header', '2. Java 堆 (Heap)', NULL, 5),
                                                                                      ('adv_jvm', 'text', E'Java 堆 (Heap) 是 JVM 中最大的一块内存区域，被所有线程共享。\n\n* **用途**：**几乎所有**的“对象实例” (`new Object()`) 和“数组”都在这里分配内存。\n* **特点**：它是垃圾收集器 (GC) 管理的主要区域。堆内存大小可以通过 `-Xms` (初始) 和 `-Xmx` (最大) 参数调整。', NULL, 6);

-- (模块: adv_concurrency - 丰富内容)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('adv_concurrency', 'text', E'Java 提供了强大的并发 (Concurrency) 工具包 `java.util.concurrent` (简称 **JUC**)，用于高效、安全地处理多线程编程。它提供了比 `synchronized` 和 `wait/notify` 更高级的工具。', NULL, 1),
                                                                                      ('adv_concurrency', 'sub-header', '1. 线程池 (ExecutorService)', NULL, 2),
                                                                                      ('adv_concurrency', 'text', E'创建和销毁线程的开销很大。**线程池** (Thread Pool) 允许我们复用已创建的线程，来执行多个任务，从而提高性能和响应速度。\n\n* **核心优势**：\n    1.  `降低资源消耗`：复用线程，避免频繁创建和销毁。\n    2.  `提高响应速度`：任务到达时，无需等待线程创建。\n    3.  `管理线程`：统一分配、调优和监控线程。', NULL, 3),
                                                                                      ('adv_concurrency', 'code', E'// 创建一个固定大小为 5 的线程池\nExecutorService executor = Executors.newFixedThreadPool(5);\n\n// 提交一个任务 (Runnable)\nexecutor.submit(() -> {\n    System.out.println("在线程池中运行: " + Thread.currentThread().getName());\n});\n\n// (必须) 关闭线程池\nexecutor.shutdown();', 'java', 4);

-- (模块: frm_springboot - 丰富内容)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('frm_springboot', 'text', E'Spring Boot 是一个开源的 Java 框架，它构建于 Spring 框架之上，用于快速、轻松地创建“**独立的、生产级的、基于 Spring 的**”应用程序。\n\n* **核心理念**：**“约定优于配置”** (Convention over Configuration)。', NULL, 1),
                                                                                      ('frm_springboot', 'sub-header', '核心特性', NULL, 2),
                                                                                      ('frm_springboot', 'code', E'1. 自动配置 (Auto-configuration):\n   (核心) Spring Boot 会根据你添加的 "starter" 依赖，自动配置你的应用。\n   例如：如果 `spring-boot-starter-web` 在类路径上，它会自动配置 Tomcat 和 Spring MVC。\n\n2. "Starter" 依赖:\n   "Starters" 是一组方便的依赖描述符。你只需添加一个 starter，它会自动将其所需的所有相关依赖（如 Tomcat, Jackson）都引入进来，避免了版本冲突。\n\n3. 嵌入式服务器 (Embedded Server):\n   默认嵌入 Tomcat (或 Jetty/Undertow)，不再需要部署 WAR 包，你可以直接运行一个 JAR 文件 (`java -jar app.jar`)。', 'plaintext', 3);

-- (模块: frm_spring - 丰富内容)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('frm_spring', 'text', E'Spring 框架是 Java EE (企业版) 开发的“事实标准”和基石。它是一个**轻量级的、非侵入式**的容器，提供了全面的基础架构支持。', NULL, 1),
                                                                                      ('frm_spring', 'sub-header', '1. IoC (Inversion of Control) 控制反转', NULL, 2),
                                                                                      ('frm_spring', 'text', E'IoC 是一种设计原则，它将“创建和管理对象”的控制权从你的代码转移到了“Spring 容器”。\n\n* **依赖注入 (DI)**：是实现 IoC 的主要方式。\n* **传统方式**：`UserService` 内部自己 `new UserDao()`。`UserService` 依赖于 `UserDao` 的具体实现。\n* **IoC/DI 方式**：你不再需要自己 `new`。你只需要告诉 Spring：“我需要一个 `UserDao`”，Spring 容器就会自动把它创建好并“注入”(Inject) 给你（通过 `@Autowired`）。\n\n这极大地降低了组件之间的**耦合度**。', NULL, 3),
                                                                                      ('frm_spring', 'sub-header', '2. AOP (Aspect-Oriented Programming) 面向切面编程', NULL, 4),
                                                                                      ('frm_spring', 'text', E'AOP 是一种编程范式，它允许你将“**横切关注点**”（Cross-Cutting Concerns）从你的“**核心业务逻辑**”中分离出来。\n\n* **核心业务**：例如“下单”、“转账”。\n* **横切关注点**：例如“**日志记录**”、“**事务管理**”、“**安全检查**”。\n\nAOP 允许你定义一个“切面” (Aspect)，并将这些关注点“织入” (Weave) 到你的业务代码中，而无需修改业务代码本身。', NULL, 5);
-- (模块: frm_spring - 续写 AOP 示例和事务)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('frm_spring', 'sub-header', 'AOP 示例：日志切面', NULL, 6),
                                                                                      ('frm_spring', 'text', E'我们可以创建一个“**切面**” (Aspect) 来定义“在什么时候” (例如 `Pointcut` 切点) 和“做什么” (例如 `Advice` 通知)。\n\n* `JoinPoint` (连接点)：程序执行的某个点 (如方法执行)。\n* `Pointcut` (切点)：定义了“哪些”连接点会被拦截。\n* `Advice` (通知)：在切点上执行的代码 (如 `@Before`, `@After`)。', NULL, 7),
                                                                                      ('frm_spring', 'code', E'@Aspect\n@Component\npublic class LoggingAspect {\n\n    // 定义一个 "切点" (Pointcut)，匹配 com.example.service 包下的所有方法\n    @Before("execution(* com.example.service.*.*(..))")\n    public void logBefore(JoinPoint joinPoint) {\n        System.out.println("LOG: 方法开始执行: " + joinPoint.getSignature().getName());\n    }\n}', 'java', 8),
                                                                                      ('frm_spring', 'sub-header', '3. 事务管理 (Transaction Management)', NULL, 9),
                                                                                      ('frm_spring', 'text', E'Spring 提供了强大的**声明式事务管理**。这是 AOP 的一个完美应用。\n\n你不再需要手动编写 `try-catch-commit-rollback` 的 JDBC 事务代码，只需在你的 Service 方法上添加一个 `@Transactional` 注解。', NULL, 10),
                                                                                      ('frm_spring', 'code', E'// 在服务层 (Service) 方法上添加注解\n@Service\npublic class UserService {\n\n    @Autowired\n    private UserRepository userRepository;\n\n    @Transactional\n    public void createUserAndLog(User user) {\n        // 1. 保存用户\n        userRepository.save(user);\n\n        // 2. 记录日志 (假设这步失败了)\n        if (true) {\n            throw new RuntimeException("日志记录失败！");\n        }\n        \n        // 因为 @Transactional，当异常抛出时，第 1 步的"保存用户"操作会自动“回滚” (Rollback)\n    }\n}', 'java', 11);

-- (模块: frm_springboot - 续写核心特性)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('frm_springboot', 'sub-header', '2. @SpringBootApplication 注解', NULL, 4),
                                                                                      ('frm_springboot', 'text', E'这是 Spring Boot 应用的入口注解。它实际上是三个核心注解的“组合体”：', NULL, 5),
                                                                                      ('frm_springboot', 'code', E'1. @Configuration: 标记该类为 JavaConfig 配置类 (替代 XML)。\n2. @EnableAutoConfiguration: 启用 Spring Boot 的“自动配置”机制。\n3. @ComponentScan: 自动扫描当前包及其子包下的组件 (如 @Service, @Controller, @Repository)。', 'plaintext', 6),
                                                                                      ('frm_springboot', 'code', E'// Spring Boot 的主启动类\n@SpringBootApplication\npublic class MyApplication {\n\n    public static void main(String[] args) {\n        SpringApplication.run(MyApplication.class, args);\n    }\n\n}', 'java', 7),
                                                                                      ('frm_springboot', 'sub-header', '3. 常用 "Starters"', NULL, 8),
                                                                                      ('frm_springboot', 'text', E'Starters 是 Spring Boot 的“依赖启动器”，它们极大地简化了 Maven/Gradle 配置。你只需要引入一个 Starter，所有相关依赖和版本都会被自动管理。', NULL, 9),
                                                                                      ('frm_springboot', 'code', E'\n<dependency>\n    <groupId>org.springframework.boot</groupId>\n    <artifactId>spring-boot-starter-web</artifactId>\n</dependency>\n\n\n<dependency>\n    <groupId>org.springframework.boot</groupId>\n    <artifactId>spring-boot-starter-data-jpa</artifactId>\n</dependency>', 'xml', 10),
                                                                                      ('frm_springboot', 'sub-header', '4. 配置文件 (application.properties)', NULL, 11),
                                                                                      ('frm_springboot', 'text', E'Spring Boot 允许你在 `src/main/resources/application.properties` (或 `.yml`) 文件中集中管理所有配置，覆盖自动配置的默认值。\n\nYAML (`.yml`) 格式因其“层次清晰”而更受欢迎。', NULL, 12),
                                                                                      ('frm_springboot', 'code', E'# 修改内置 Tomcat 服务器的端口号\nserver.port=8080\n\n# 配置数据库连接\nspring.datasource.url=jdbc:mysql://localhost:3306/mydb\nspring.datasource.username=root\nspring.datasource.password=secret', 'properties', 13),
                                                                                      ('frm_springboot', 'sub-header', '5. 创建一个 REST Controller', NULL, 14),
                                                                                      ('frm_springboot', 'text', E'使用 `@RestController` (它是 `@Controller` 和 `@ResponseBody` 的组合)，你可以轻松创建处理 JSON 数据的 RESTful API 接口。', NULL, 15),
                                                                                      ('frm_springboot', 'code', E'@RestController\npublic class HelloController {\n\n    // 映射到 HTTP GET /hello 请求\n    @GetMapping("/hello")\n    public String sayHello() {\n        return "Hello, Spring Boot!";\n    }\n\n    // 映射到 GET /greet?name=Gemini\n    @GetMapping("/greet")\n    public String greet(@RequestParam String name) {\n        return "Hello, " + name + "!";\n    }\n}', 'java', 16);

-- (模块: adv_jvm - 续写 GC 和类加载)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('adv_jvm', 'sub-header', '3. 垃圾收集 (Garbage Collection, GC)', NULL, 7),
                                                                                      ('adv_jvm', 'text', E'GC 的主要任务是自动识别并释放“不再被引用”的对象所占用的内存，防止内存泄漏 (Memory Leak)。它主要工作在 Java 堆上。\n\n* **核心算法**：**可达性分析** (Reachability Analysis)。\n* **GC Roots**：(起点) 包括虚拟机栈中引用的对象、静态变量引用的对象、JNI 引用的对象等。\n* **判定**：从 GC Roots 开始遍历，凡是“无法到达”的对象，都被认为是垃圾。', NULL, 8),
                                                                                      ('adv_jvm', 'code', E'// 常见的垃圾收集器: \n// Serial (新生代, 串行)\n// Parallel Scavenge (新生代, 并行, 吞吐量优先)\n// CMS (老年代, 并发, 已废弃)\n// G1 (G1, 分代, 停顿时间可控, JDK 9+ 默认)\n// ZGC / Shenandoah (JDK 11+ , 低延迟)', 'plaintext', 9),
                                                                                      ('adv_jvm', 'sub-header', '4. 类加载 (Class Loading)', NULL, 10),
                                                                                      ('adv_jvm', 'text', E'类加载器 (ClassLoader) 负责在运行时将 `.class` 文件（字节码）加载到 JVM 的方法区，并转换为 `java.lang.Class` 对象。\n\n* **核心机制**：**双亲委派模型** (Parent-Delegation Model)。\n* **目的**：避免类被重复加载，并保证 Java 核心库 (如 `java.lang.String`) 的安全，防止被恶意替换。', NULL, 11),
                                                                                      ('adv_jvm', 'code', E'// 加载过程: \n1. 加载 (Loading): 获取 .class 字节流\n2. 验证 (Verification): 确保符合 JVM 规范\n3. 准备 (Preparation): 为“静态变量”分配内存并设置零值\n4. 解析 (Resolution): 符号引用 -> 直接引用\n5. 初始化 (Initialization): (核心) 执行 <clinit>() 方法 (静态代码块和静态变量赋值)', 'plaintext', 12);


-- (模块: adv_concurrency - 续写 volatile, synchronized 和 AQS)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('adv_concurrency', 'sub-header', '2. volatile 关键字', NULL, 5),
                                                                                      ('adv_concurrency', 'text', E'`volatile` 是一个轻量级的同步机制。它主要保证两件事：', NULL, 6),
                                                                                      ('adv_concurrency', 'code', E'1. 可见性 (Visibility):\n   (核心) 当一个线程修改了 volatile 变量的值，新值对其他线程是“立即可见的”。它强制线程每次都从“主内存”读取，而不是用“工作内存”的缓存。\n\n2. 禁止指令重排序 (Ordering):\n   通过“内存屏障” (Memory Barrier) 保证 `volatile` 变量前后的指令不会被重排序，用于解决 DCL (双重检查锁定) 的有序性问题。', 'plaintext', 7),
                                                                                      ('adv_concurrency', 'text', E'**注意**：`volatile` **不保证**原子性（例如 `i++` 操作，该操作不是原子的）。', NULL, 8),
                                                                                      ('adv_concurrency', 'code', E'// 适用于 "一个线程写，多个线程读" 的场景 (例如状态标志)\nprivate volatile boolean stopFlag = false;\n\n// 写线程\npublic void stop() {\n    this.stopFlag = true;\n}\n\n// 读线程\npublic void run() {\n    while (!stopFlag) {\n        // ... do work ...\n    }\n}', 'java', 9),
                                                                                      ('adv_concurrency', 'sub-header', '3. synchronized 关键字', NULL, 10),
                                                                                      ('adv_concurrency', 'text', E'`synchronized` 是 Java 提供的内置锁（也称为监视器锁或“重量级锁”）。它提供了“**原子性**”和“**可见性**”。\n\n它是一种“**可重入**”锁 (Reentrant)，即一个线程可以多次获取同一个锁。', NULL, 11),
                                                                                      ('adv_concurrency', 'text', E'它有三种使用方式：', NULL, 12),
                                                                                      ('adv_concurrency', 'code', E'// 1. 同步实例方法 (锁住 this 对象)\npublic synchronized void safeIncrement() {\n    count++;\n}\n\n// 2. 同步静态方法 (锁住 Class 对象)\npublic static synchronized void safeStaticIncrement() {\n    staticCount++;\n}\n\n// 3. 同步代码块 (可以指定任意锁对象)\nprivate final Object lock = new Object();\n\npublic void safeBlockIncrement() {\n    synchronized (lock) {\n        count++;\n    }\n}', 'java', 13),
                                                                                      ('adv_concurrency', 'sub-header', '4. AQS (AbstractQueuedSynchronizer)', NULL, 14),
                                                                                      ('adv_concurrency', 'text', E'AQS (抽象队列同步器) 是 JUC (java.util.concurrent) 包中绝大多数锁（如 `ReentrantLock`, `CountDownLatch`, `Semaphore`）的构建基石。', NULL, 15),
                                                                                      ('adv_concurrency', 'text', E'它是一个抽象框架，核心思想是：\n1.  使用一个 `volatile int state` 变量来表示“锁的状态”。\n2.  使用一个“**CLH 队列**”（一个虚拟的双向队列）来管理所有“等待获取锁”的线程。\n\n当线程获取锁失败时，会被封装成 `Node` 放入 CLH 队列中“排队”并挂起 (Park)。当锁被释放时，AQS 会唤醒 (Unpark) 队列的头部节点去尝试获取锁。', NULL, 16),
                                                                                      ('adv_concurrency', 'code', E'// ReentrantLock (可重入锁) 就是基于 AQS 实现的\n// 相比 synchronized，它提供了更多功能 (如公平/非公平、可中断、tryLock)\nprivate final ReentrantLock aqsLock = new ReentrantLock();\n\npublic void safeOperation() {\n    aqsLock.lock(); // 获取锁\n    try {\n        // ... 需要保护的临界区代码 ...\n    } finally {\n        aqsLock.unlock(); // (重要) 必须在 finally 中释放锁\n    }\n}', 'java', 17);

-- 版本 1.3: (优化版) 丰富 'text' 内容并支持 Markdown 格式 (Part 2/6)

-----------------------------------------------------
-- 4. B 路径：学习 (Learn) - (Group 4)
-----------------------------------------------------

-- 4a. 学习分组 (ModuleGroup)
INSERT INTO module_group (id, title, sort_order) VALUES
    (4, '数据库与持久化', 4);

-- 4b. 课程模块 (CourseModule)
INSERT INTO course_module (id, title, description, group_id) VALUES
                                                                 -- 组 4: 数据库
                                                                 ('db_sql', 'SQL 与数据库基础', '关系型数据库原理, DDL, DML, 事务', 4),
                                                                 ('db_jdbc', 'JDBC 与连接池', 'Java Database Connectivity 详解, HikariCP', 4),
                                                                 ('db_mybatis', '持久层框架 MyBatis', 'SQL 映射框架, 动态 SQL, 一二级缓存', 4),
                                                                 ('db_jpa', 'Spring Data JPA', 'ORM 规范, Repository 接口, @Entity', 4);

-- 4c. 模块内容 (Content Blocks)

-- (模块: db_sql - SQL 基础)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('db_sql', 'text', E'数据库是后端应用的核心，用于**持久化**（Persistence）存储数据。SQL (Structured Query Language) 是与**关系型数据库** (RDBMS, 如 MySQL, PostgreSQL) 交互的标准语言。', NULL, 1),
                                                                                      ('db_sql', 'sub-header', '1. DML (数据操作语言)', NULL, 2),
                                                                                      ('db_sql', 'text', E'DML (Data Manipulation Language) 用于查询和修改数据，是日常开发中使用最频繁的。', NULL, 3),
                                                                                      ('db_sql', 'code', E'-- 查询 (SELECT)\nSELECT name, age FROM users WHERE age > 18;\n\n-- 插入 (INSERT)\nINSERT INTO users (id, name, age) VALUES (1, ''Alice'', 20);\n\n-- 更新 (UPDATE)\nUPDATE users SET age = 21 WHERE name = ''Alice'';\n\n-- 删除 (DELETE)\nDELETE FROM users WHERE id = 1;', 'sql', 4),
                                                                                      ('db_sql', 'sub-header', '2. DDL (数据定义语言)', NULL, 5),
                                                                                      ('db_sql', 'text', E'DDL (Data Definition Language) 用于定义和修改数据库“结构”（表、索引、约束等）。', NULL, 6),
                                                                                      ('db_sql', 'code', E'-- 创建表 (CREATE TABLE)\nCREATE TABLE users (\n    id INT PRIMARY KEY,\n    name VARCHAR(100) NOT NULL,\n    age INT\n);\n\n-- 修改表 (ALTER TABLE)\nALTER TABLE users ADD COLUMN email VARCHAR(100);\n\n-- 删除表 (DROP TABLE)\nDROP TABLE users;', 'sql', 7),
                                                                                      ('db_sql', 'sub-header', '3. 事务 (Transaction)', NULL, 8),
                                                                                      ('db_sql', 'text', E'事务 (Transaction) 是一个“**不可分割**”的工作单元，它包含了一系列数据库操作。事务必须具备 **ACID** 四大特性：\n\n* **A (Atomicity)**: 原子性。事务中的所有操作，要么**全部成功**，要么**全部失败**（回滚）。\n* **C (Consistency)**: 一致性。事务必须使数据库从一个一致状态转移到另一个一致状态。\n* **I (Isolation)**: 隔离性。多个并发事务之间互不干扰。\n* **D (Durability)**: 持久性。事务一旦提交，其结果就是永久性的。', NULL, 9),
                                                                                      ('db_sql', 'code', E'START TRANSACTION;\n\n-- (操作 1)\nUPDATE accounts SET balance = balance - 100 WHERE name = ''A'';\n-- (操作 2)\nUPDATE accounts SET balance = balance + 100 WHERE name = ''B'';\n\nCOMMIT; -- 提交事务\n-- ROLLBACK; -- (如果出错则回滚)', 'sql', 10);

-- (模块: db_jdbc - JDBC 与连接池)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('db_jdbc', 'text', E'JDBC (Java Database Connectivity) 是 Java 官方提供的一套 API 规范，用于在 Java 程序中访问各种数据库。', NULL, 1),
                                                                                      ('db_jdbc', 'sub-header', '1. JDBC 核心步骤 (原生)', NULL, 2),
                                                                                      ('db_jdbc', 'text', E'原生的 JDBC 步骤非常繁琐，且容易导致资源泄漏。', NULL, 3),
                                                                                      ('db_jdbc', 'code', E'// 1. 加载驱动 (Class.forName)\n// 2. 获取连接 (DriverManager.getConnection)\n// 3. 创建语句 (Connection.prepareStatement)\n// 4. 执行 SQL (Statement.executeQuery / executeUpdate)\n// 5. 处理结果集 (ResultSet)\n// 6. (必须在 finally 中) 关闭资源 (ResultSet, Statement, Connection)', 'plaintext', 4),
                                                                                      ('db_jdbc', 'sub-header', '2. 连接池 (Connection Pool)', NULL, 5),
                                                                                      ('db_jdbc', 'text', E'每次 `getConnection()` 都是一个昂贵的 I/O 操作（涉及 TCP 握手和数据库认证）。\n\n**连接池** (如 HikariCP, Druid) 会预先创建并管理一组数据库连接。应用需要时“**借用**”(Borrow) 连接，用完后“**归还**”(Return)，而不是关闭。\n\n这极大地提升了数据库访问性能。', NULL, 6),
                                                                                      ('db_jdbc', 'text', E'Spring Boot 2.x 默认使用 **HikariCP** (号称最快的连接池)。你几乎不需要手动配置 JDBC，只需要在 `application.properties` 中配置数据源 (Datasource) 即可。', NULL, 7);

-- (模块: db_mybatis - MyBatis 框架)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('db_mybatis', 'text', E'MyBatis 是一个“**半自动**”的 ORM 框架，它封装了绝大部分繁琐的 JDBC 代码。\n\n* **核心思想**：允许开发者将 SQL 语句直接写在 XML 文件或注解中，实现了“**SQL 与 Java 代码的分离**”。\n* **优点**：开发者可以完全掌控 SQL，适合复杂的、需要优化的 SQL 查询。', NULL, 1),
                                                                                      ('db_mybatis', 'sub-header', '1. Mapper 接口 (Java)', NULL, 2),
                                                                                      ('db_mybatis', 'text', E'你只需要定义一个 Java 接口 (Mapper)，MyBatis 会通过动态代理自动为你生成实现类。', NULL, 3),
                                                                                      ('db_mybatis', 'code', E'public interface UserMapper {\n    // 1. 通过注解 (简单 SQL)\n    @Select("SELECT * FROM users WHERE id = #{id}")\n    User findById(long id);\n\n    // 2. (推荐) 通过 XML (复杂 SQL)\n    void insertUser(User user);\n}', 'java', 3),
                                                                                      ('db_mybatis', 'sub-header', '2. Mapper XML (XML)', NULL, 4),
                                                                                      ('db_mybatis', 'text', E'XML 提供了与 Java 接口方法绑定的能力，并使用 `#{}` 作为参数占位符 (会自动转换为 `?`，防止 SQL 注入)。', NULL, 5),
                                                                                      ('db_mybatis', 'code', E'\n<mapper namespace="com.example.UserMapper">\n  <insert id="insertUser" parameterType="com.example.User">\n    INSERT INTO users (id, name, age)\n    VALUES (#{id}, #{name}, #{age})\n  </insert>\n</mapper>', 'xml', 5),
                                                                                      ('db_mybatis', 'sub-header', '3. 动态 SQL', NULL, 6),
                                                                                      ('db_mybatis', 'text', E'MyBatis 强大的特性之一是**动态 SQL**，允许你使用 `<if>`, `<foreach>`, `<where>` 等标签在 XML 中灵活拼接 SQL，避免在 Java 代码中写出恶心的 `if-else`。', NULL, 7);

-- (模块: db_jpa - Spring Data JPA)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('db_jpa', 'text', E'JPA (Java Persistence API) 是 Java 官方的 **ORM** (对象关系映射) 规范。Hibernate 是 JPA 最著名的实现。\n\n**Spring Data JPA** 是 Spring 对 JPA 规范的再次封装，它极大简化了数据访问层的代码，是目前 Java 中最“自动化”的数据库框架。', NULL, 1),
                                                                                      ('db_jpa', 'sub-header', '1. 实体 (Entity)', NULL, 2),
                                                                                      ('db_jpa', 'text', E'使用 `@Entity` 注解将一个 Java POJO (普通 Java 对象) 映射到数据库表。JPA 会自动根据实体创建或更新表结构。', NULL, 3),
                                                                                      ('db_jpa', 'code', E'@Entity\n@Table(name = "users")\npublic class User {\n    @Id\n    @GeneratedValue\n    private Long id;\n\n    private String name;\n    private int age;\n    // ... getters and setters\n}', 'java', 4),
                                                                                      ('db_jpa', 'sub-header', '2. 仓库 (Repository)', NULL, 5),
                                                                                      ('db_jpa', 'text', E'这是 Spring Data JPA 最神奇的地方。你只需要定义一个接口继承 `JpaRepository`，它会自动为你实现所有 CRUD (增删改查) 和分页方法。\n\n你**不需要写任何实现类**！', NULL, 6),
                                                                                      ('db_jpa', 'code', E'// 你不需要写任何实现类！\npublic interface UserRepository extends JpaRepository<User, Long> {\n\n    // JPA 还会根据“方法名”自动生成 SQL 查询 (Query Methods)\n    List<User> findByAgeGreaterThan(int age);\n\n    // 也可以用 @Query 自定义 HQL/SQL\n    @Query("SELECT u FROM User u WHERE u.name = :name")\n    User findByNameCustom(String name);\n}', 'java', 7);

-- 版本 1.3: (优化版) 丰富 'text' 内容并支持 Markdown 格式 (Part 3/6)

-----------------------------------------------------
-- 5. B 路径：学习 (Learn) - (Groups 5-6)
-----------------------------------------------------

-- 5a. 学习分组 (ModuleGroup)
INSERT INTO module_group (id, title, sort_order) VALUES
                                                     (5, '核心中间件：缓存', 5),
                                                     (6, '核心中间件：消息队列', 6);

-- 5b. 课程模块 (CourseModule)
INSERT INTO course_module (id, title, description, group_id) VALUES
                                                                 -- 组 5: 缓存
                                                                 ('mw_cache_theory', '缓存理论与设计', '缓存穿透, 缓存雪崩, 旁路缓存模式', 5),
                                                                 ('mw_redis_basic', 'Redis 核心数据结构', 'String, List, Hash, Set, ZSet', 5),
                                                                 ('mw_redis_adv', 'Redis 高级特性', '持久化 (RDB/AOF), 事务, 分布式锁', 5),
                                                                 ('mw_redis_spring', 'Spring Boot 集成 Redis', 'RedisTemplate, @Cacheable 注解', 5),

                                                                 -- 组 6: 消息队列
                                                                 ('mw_mq_theory', 'MQ 理论与选型', '消息队列的“削峰填谷”与“异步解耦”', 6),
                                                                 ('mw_rabbitmq', 'RabbitMQ 实践', 'AMQP 协议, 交换机 (Exchange) 类型', 6),
                                                                 ('mw_kafka_basic', 'Kafka 核心概念', 'Producer, Consumer, Broker, Topic, Partition', 6),
                                                                 ('mw_rocketmq', 'RocketMQ 入门', '阿里系 MQ, 顺序消息, 事务消息', 6);

-- 5c. 模块内容 (Content Blocks)

-- (模块: mw_cache_theory - 缓存理论)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mw_cache_theory', 'text', E'缓存是提升系统性能的第一利器。它利用“**空间换时间**”的思想，将高频访问、低频修改的数据存储在更快的介质（如内存）中，以减少对慢速 I/O (如磁盘、网络) 的访问。', NULL, 1),
                                                                                      ('mw_cache_theory', 'sub-header', '1. 缓存读写模式：Cache-Aside (旁路缓存)', NULL, 2),
                                                                                      ('mw_cache_theory', 'text', E'这是最常用的模式，它将“缓存”作为“数据库”的“旁路”。业务代码需要自己维护缓存和数据库的一致性。', NULL, 3),
                                                                                      ('mw_cache_theory', 'code', E'// 读操作 (Read):\n1. 读缓存 (e.g., Redis)\n2. 缓存命中 (Hit) -> 直接返回\n3. 缓存未命中 (Miss) -> 读数据库 (e.g., MySQL)\n4. 将数据写入缓存 (回填)\n5. 返回数据\n\n// 写操作 (Write/Update):\n1. (重要) 先更新数据库\n2. (重要) 再删除缓存\n\n(Q: 为什么是“删除缓存”而不是“更新缓存”？ A: 懒加载思想，且能解决“并发写”导致的脏数据问题)', 'plaintext', 4),
                                                                                      ('mw_cache_theory', 'sub-header', '2. 缓存三大问题 (面试核心)', NULL, 5),
                                                                                      ('mw_cache_theory', 'text', E'**1. 缓存穿透 (Cache Penetration)**\n* **现象**: 查询一个“**一定不存在**”的数据 (DB 和缓存中都没有)，导致请求次次都绕过缓存，直接打到数据库。\n* **解决**：① 缓存空对象 (设置较短过期时间)；② 布隆过滤器 (Bloom Filter)。', NULL, 6),
                                                                                      ('mw_cache_theory', 'text', E'**2. 缓存雪崩 (Cache Avalanche)**\n* **现象**: **大面积**的缓存 Key 在“**同一时间**”集体失效 (e.g., 凌晨 0 点)，导致所有请求瞬间涌入数据库，造成 DB 宕机。\n* **解决**：在 Key 的过期时间上加一个“**随机值**”，打散失效时间。', NULL, 7),
                                                                                      ('mw_cache_theory', 'text', E'**3. 缓存击穿 (Cache Breakdown)**\n* **现象**: (也叫热点 Key 问题) **一个**“**热点 Key**”突然失效，导致“**大量并发**”请求该 Key，瞬间打到数据库。\n* **解决**：使用**分布式锁** (如 `SETNX`)，只让一个请求去DB 回填缓存，其他请求等待。', NULL, 8);

-- (模块: mw_redis_basic - Redis 核心数据结构)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mw_redis_basic', 'text', E'Redis (REmote DIctionary Server) 是基于内存的、**单线程**的、高性能 Key-Value 数据库，是目前分布式缓存和中间件的首选。\n\n(注：Redis 的“单线程”是指其处理网络请求的 I/O 线程是单线程的，这避免了上下文切换和锁开销。它通过 **I/O 多路复用** (epoll) 实现了高并发。)', NULL, 1),
                                                                                      ('mw_redis_basic', 'sub-header', '1. String (字符串)', NULL, 2),
                                                                                      ('mw_redis_basic', 'text', E'最基本的数据类型，可以存字符串、数字、甚至二进制数据 (如图片)。\n* **应用**：缓存 (JSON 字符串)、计数器 ( `INCR` )、分布式锁 ( `SETNX` )。', NULL, 3),
                                                                                      ('mw_redis_basic', 'code', E'> SET user:1:name "Alice"\n> GET user:1:name\n"Alice"\n\n> INCR article:1:views\n(integer) 1', 'bash', 4),
                                                                                      ('mw_redis_basic', 'sub-header', '2. Hash (哈希)', NULL, 5),
                                                                                      ('mw_redis_basic', 'text', E'适合存储“对象”。一个 Key 对应多个 field-value 对。相比 String 存 JSON，Hash 可以单独修改对象的某个字段。\n* **应用**：缓存对象 (如用户信息、购物车)。', NULL, 6),
                                                                                      ('mw_redis_basic', 'code', E'> HSET user:1 name "Alice" age 20\n> HGET user:1 name\n"Alice"\n> HGETALL user:1', 'bash', 7),
                                                                                      ('mw_redis_basic', 'sub-header', '3. List (列表)', NULL, 8),
                                                                                      ('mw_redis_basic', 'text', E'有序的字符串列表（底层是 `quicklist`，结合了链表和 `ziplist`）。\n* **应用**：消息队列 ( `LPUSH`/`RPOP` )、栈 ( `LPUSH`/`LPOP` )、最新消息列表。', NULL, 9),
                                                                                      ('mw_redis_basic', 'code', E'> LPUSH tasks "task1"\n> LPUSH tasks "task2"\n> RPOP tasks\n"task1"', 'bash', 10),
                                                                                      ('mw_redis_basic', 'sub-header', '4. Set (集合)', NULL, 11),
                                                                                      ('mw_redis_basic', 'text', E'无序、唯一的字符串集合。\n* **应用**：去重、共同好友 ( `SINTER` )、抽奖 ( `SRANDMEMBER` )。', NULL, 12),
                                                                                      ('mw_redis_basic', 'sub-header', '5. ZSet (有序集合)', NULL, 13),
                                                                                      ('mw_redis_basic', 'text', E'在 Set 的基础上，给每个元素关联一个 `score` (分数)，Redis 会根据 `score` 自动排序。\n* **应用**：(核心) 排行榜、范围查询 (如工资范围)。', NULL, 14),
                                                                                      ('mw_redis_basic', 'code', E'> ZADD leaderboard 100 "Alice"\n> ZADD leaderboard 95 "Bob"\n> ZREVRANGE leaderboard 0 -1\n1) "Alice"\n2) "Bob"', 'bash', 15);

-- (模块: mw_redis_adv - Redis 高级特性)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mw_redis_adv', 'text', E'除了作为缓存，Redis 还提供了持久化、事务和分布式锁等高级功能，使其可以充当轻量级的数据库或中间件。', NULL, 1),
                                                                                      ('mw_redis_adv', 'sub-header', '1. 持久化 RDB 与 AOF', NULL, 2),
                                                                                      ('mw_redis_adv', 'text', E'1. **RDB (Snapshotting)**: (默认) 在某个时间点将内存数据的“快照” (snapshot) 写入磁盘 (`dump.rdb`)。由 `fork()` 子进程执行，恢复速度快，但可能丢失最后一次快照后的数据。\n2. **AOF (Append-Only File)**: (推荐) 将所有“写命令”追加到文件 (`appendonly.aof`) 末尾。数据更安全（最多丢 1s），但文件体积大，恢复慢。\n\n(生产环境推荐 **RDB + AOF** 混合使用)。', NULL, 3),
                                                                                      ('mw_redis_adv', 'sub-header', '2. 事务 (MULTI/EXEC)', NULL, 4),
                                                                                      ('mw_redis_adv', 'text', E'Redis 事务能将一组命令打包执行，保证“原子性”（队列中的命令要么都执行，要么都不执行）。\n\n**注意**：Redis 事务**不支持回滚** (Rollback)。如果队列中某个命令语法错误，整个队列失败；如果某个命令运行时错误 (如对 String 用 `HSET`)，其他命令照常执行。', NULL, 5),
                                                                                      ('mw_redis_adv', 'sub-header', '3. 分布式锁 (SETNX)', NULL, 6),
                                                                                      ('mw_redis_adv', 'text', E'在分布式系统中，`synchronized` 无法跨 JVM。Redis 提供了 `SET key value NX EX seconds` (Set if Not eXists with Expiration) 原子命令。\n\n* `NX`: (Not eXists) 只有 Key 不存在时才设置成功（加锁）。\n* `EX`: (Expiration) 设置自动过期时间，防止死锁。\n* (释放锁需要用 Lua 脚本保证“判断-删除”的原子性)。', NULL, 7);

-- (模块: mw_redis_spring - Spring 集成 Redis)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mw_redis_spring', 'text', E'Spring Boot 提供了 `spring-boot-starter-data-redis` 来快速集成 Redis，它底层依赖 **Lettuce** (一个高性能、异步的 Redis 客户端)。', NULL, 1),
                                                                                      ('mw_redis_spring', 'sub-header', '1. RedisTemplate (编程式)', NULL, 2),
                                                                                      ('mw_redis_spring', 'text', E'Spring 封装了 `RedisTemplate`，提供了操作各种数据结构的方法 (`opsFor...`)，是**编程式**操作 Redis 的首选。\n\n(注意：默认序列化器是 `JdkSerializationRedisSerializer`，会导致 Key 乱码，通常需要手动配置为 `StringRedisSerializer` 和 `Jackson2JsonRedisSerializer`)。', NULL, 3),
                                                                                      ('mw_redis_spring', 'code', E'@Autowired\nprivate RedisTemplate<String, Object> redisTemplate;\n\npublic void cacheUser(User user) {\n    // 操作 Hash\n    redisTemplate.opsForHash().put("user:", user.getId(), user);\n}\n\npublic User getUser(String id) {\n    return (User) redisTemplate.opsForHash().get("user:", id);\n}', 'java', 4),
                                                                                      ('mw_redis_spring', 'sub-header', '2. Spring Cache (声明式)', NULL, 5),
                                                                                      ('mw_redis_spring', 'text', E'Spring 提供了基于 AOP 的**声明式**缓存，对业务代码**无侵入**。\n\n* `@Cacheable`：(查) 执行前检查缓存，有则返回，无则执行方法并存入缓存。\n* `@CachePut`：(改) 无论如何都执行方法，并**更新**缓存。\n* `@CacheEvict`：(删) 执行方法，并**删除**缓存。', NULL, 6),
                                                                                      ('mw_redis_spring', 'code', E'// 在启动类上加 @EnableCaching\n\n@Service\npublic class UserService {\n\n    // "userCache" 是缓存名，key 是方法的参数 id\n    @Cacheable(value = "userCache", key = "#id")\n    public User findById(Long id) {\n        // 第一次调用会执行此方法，并从 DB 查询\n        // 之后调用会直接从 Redis (userCache) 中返回，不再执行此方法\n        return userRepository.findById(id).orElse(null);\n    }\n\n    // 当用户更新时，从缓存中删除\n    @CacheEvict(value = "userCache", key = "#user.id")\n    public void updateUser(User user) {\n        userRepository.save(user);\n    }\n}', 'java', 7);

-- (模块: mw_mq_theory - MQ 理论)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mw_mq_theory', 'text', E'消息队列 (Message Queue) 是分布式系统中用于组件间通信的核心中间件，它实现了**生产者-消费者** (Producer-Consumer) 模式。', NULL, 1),
                                                                                      ('mw_mq_theory', 'sub-header', '1. 核心功能：异步 (Asynchronous)', NULL, 2),
                                                                                      ('mw_mq_theory', 'text', E'例如：用户注册。主流程（写数据库）完成后，可以将“发送欢迎邮件”、“发放新人优惠券”等“**非核心、耗时**”的任务作为消息扔进 MQ。\n\n* **好处**：主流程（注册接口）的响应时间极大降低，提升用户体验。', NULL, 3),
                                                                                      ('mw_mq_theory', 'sub-header', '2. 核心功能：解耦 (Decoupling)', NULL, 4),
                                                                                      ('mw_mq_theory', 'text', E'例如：订单服务在创建订单后，只需向 MQ 发送一条 `"OrderCreated"` 消息。\n\n下游的“库存服务”、“物流服务”、“积分服务”可以各自**独立地**订阅此消息并处理，互不干扰。如果未来新增一个“数据分析服务”，只需订阅该消息即可，**无需修改**订单服务的代码。', NULL, 5),
                                                                                      ('mw_mq_theory', 'sub-header', '3. 核心功能：削峰填谷 (Peak Shaving)', NULL, 6),
                                                                                      ('mw_mq_theory', 'text', E'例如：秒杀活动。瞬间的巨大流量（10万次下单/秒）如果直接打到数据库，数据库必垮。\n\n* **流程**：将 10 万次请求先全部快速涌入 MQ (如 Kafka，吞吐量极高)。下游的订单服务再根据自己的实际处理能力（如 5000 QPS）**平稳地**从 MQ 中拉取消息并处理，防止系统被瞬时流量打垮。', NULL, 7);

-- (模块: mw_rabbitmq - RabbitMQ)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mw_rabbitmq', 'text', E'RabbitMQ 是基于 **AMQP** (高级消息队列协议) 的、功能丰富的消息队列，以其可靠性、灵活性（强大的路由）和成熟的社区著称。', NULL, 1),
                                                                                      ('mw_rabbitmq', 'sub-header', '1. AMQP 核心模型', NULL, 2),
                                                                                      ('mw_rabbitmq', 'text', E'RabbitMQ 的模型比 Kafka 复杂，它引入了“交换机” (Exchange) 和“绑定” (Binding)。\n\nProducer (生产者) -> **Exchange (交换机)** -> **Binding (绑定)** -> Queue (队列) -> Consumer (消费者)\n\n* **核心**：生产者不直接把消息发给队列，而是发给“交换机”。交换机根据“路由键” (`RoutingKey`) 和“绑定规则” (`BindingKey`)，决定将消息路由到哪个队列。', NULL, 3),
                                                                                      ('mw_rabbitmq', 'sub-header', '2. Exchange (交换机) 类型', NULL, 4),
                                                                                      ('mw_rabbitmq', 'text', E'1. **Direct**: 精确匹配。消息的 `RoutingKey` 必须与 `BindingKey` **完全一致**。\n2. **Fanout**: 广播。**忽略** `RoutingKey`，将消息发送给所有绑定到该交换机的队列。\n3. **Topic**: (最灵活) 模式匹配。使用 `*` (匹配一个词) 和 `#` (匹配零个或多个词) 来灵活路由。', NULL, 5),
                                                                                      ('mw_rabbitmq', 'code', E'// 示例：Topic 交换机\n// RoutingKey = "order.created.cn"\n// BindingKey = "order.created.*" -> (匹配)\n// BindingKey = "order.#" -> (匹配)\n// BindingKey = "order.paid.*" -> (不匹配)', 'plaintext', 6);

-- (模块: mw_kafka_basic - Kafka 核心)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mw_kafka_basic', 'text', E'Kafka (Apache Kafka) 是一个分布式的、高吞吐量的“**发布-订阅**”消息系统（更准确地说是“**分布式流平台**”）。它常用于大数据日志收集和实时流处理。', NULL, 1),
                                                                                      ('mw_kafka_basic', 'sub-header', '1. 核心概念 (数据结构)', NULL, 2),
                                                                                      ('mw_kafka_basic', 'text', E'1. **Topic (主题)**: 消息的分类 (如 `OrderLogs`)。\n2. **Partition (分区)**: (核心) Topic 的物理分组。一个 Topic 可以有多个 Partition。Kafka 通过“分区”实现**水平扩展**和**高吞吐**。消息在分区内是**有序**的。\n3. **Broker (代理)**: 一台 Kafka 服务器。\n4. **Offset (偏移量)**: 消息在 Partition 中的唯一编号（递增），Consumer 通过 Offset 追踪消费位置。', NULL, 3),
                                                                                      ('mw_kafka_basic', 'sub-header', '2. 消费者组 (Consumer Group)', NULL, 4),
                                                                                      ('mw_kafka_basic', 'text', E'多个 Consumer (消费者) 可以组成一个“消费者组”来共同消费一个 Topic。\n\n* **核心规则**：一个 Topic 的一个 Partition，在同一时间“**只能**”被组内的“**一个**” Consumer 消费。\n* **好处**：通过增加 Consumer 数量（不能超过 Partition 数量）来**并发**消费，提高消费能力。', NULL, 5);

-- (模块: mw_rocketmq - RocketMQ 入门)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mw_rocketmq', 'text', E'RocketMQ 是阿里巴巴开源的消息中间件，用 Java 编写，在电商、金融等对“**高可靠性**”和“**事务性**”要求极高的场景中有广泛应用。', NULL, 1),
                                                                                      ('mw_rocketmq', 'sub-header', '1. 核心优势 (企业级特性)', NULL, 2),
                                                                                      ('mw_rocketmq', 'text', E'1. **事务消息**: (杀手锏) 提供了强大的“**两阶段提交**”事务消息功能，非常适合解决分布式事务（如订单和支付一致性）问题。\n2. **顺序消息**: 提供了机制来严格保证消息的“全局有序”或“分区有序”。\n3. **定时/延迟消息**: 支持精确到秒级的延迟消息。\n4. **高吞吐量**: 性能出色，支持亿级消息堆积。', NULL, 3),
                                                                                      ('mw_rocketmq', 'sub-header', '2. 与 Kafka 对比', NULL, 4),
                                                                                      ('mw_rocketmq', 'text', E'**Kafka**: 追求的是极致的“**吞吐量**”。模型简单，适合日志、大数据、流计算 (ELK, Flink)。\n\n**RocketMQ**: 追求的是“**业务可靠性**”。模型更复杂，提供了更多企业级特性（如事务、定时），更适合复杂的“业务交易”场景。', NULL, 5);

-- 版本 1.3: (优化版) 丰富 'text' 内容并支持 Markdown 格式 (Part 4/6)

-----------------------------------------------------
-- 6. B 路径：学习 (Learn) - (Groups 7-9)
-----------------------------------------------------

-- 6a. 学习分组 (ModuleGroup)
INSERT INTO module_group (id, title, sort_order) VALUES
                                                     (7, '微服务架构 (Spring Cloud)', 7),
                                                     (8, '分布式系统与协调', 8),
                                                     (9, '容器化与部署 (DevOps)', 9);

-- 6b. 课程模块 (CourseModule)
INSERT INTO course_module (id, title, description, group_id) VALUES
                                                                 -- 组 7: 微服务
                                                                 ('ms_theory', '微服务理论与拆分', 'CAP 理论, BASE 理论, 康威定律', 7),
                                                                 ('ms_nacos', '服务注册与配置 (Nacos)', '服务发现 (Discovery), 配置中心 (Config)', 7),
                                                                 ('ms_feign', '服务间调用 (Feign)', '声明式的 REST 客户端', 7),
                                                                 ('ms_sentinel', '服务熔断与限流 (Sentinel)', '高可用性, 熔断, 降级, 流量控制', 7),
                                                                 ('ms_gateway', 'API 网关 (Gateway)', '路由, 鉴权, 限流, 跨域', 7),

                                                                 -- 组 8: 分布式
                                                                 ('dist_zookeeper', '分布式协调 (ZooKeeper)', 'ZAB 协议, Watcher 机制, 节点类型', 8),
                                                                 ('dist_lock', '分布式锁', 'Redis (SETNX) vs ZK (临时顺序节点)', 8),
                                                                 ('dist_transaction', '分布式事务', 'Seata (AT/TCC), 消息最终一致性', 8),

                                                                 -- 组 9: 容器化
                                                                 ('ci_linux', 'Linux 基础 (必备)', '常用命令 (ls, cd, grep, awk), Shell 脚本', 9),
                                                                 ('ci_docker', 'Docker 容器化', '镜像 (Image), 容器 (Container), Dockerfile', 9),
                                                                 ('ci_k8s_basic', 'Kubernetes (K8s) 基础', 'Pod, Service, Deployment, Namespace', 9),
                                                                 ('ci_cicd', 'CI/CD 自动化', 'Jenkins / GitLab CI 流程', 9);

-- 6c. 模块内容 (Content Blocks)

-- (模块: ms_theory - 微服务理论)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ms_theory', 'text', E'微服务 (Microservices) 是一种架构风格，它将一个大型的“**单体应用**”(Monolith) 拆分为一组小型的、**独立部署**的、围绕“**业务能力**”构建的服务。\n\n* **优点**：技术异构、独立扩缩容、高内聚低耦合。\n* **挑战**：分布式事务、服务治理、运维复杂性。', NULL, 1),
                                                                                      ('ms_theory', 'sub-header', '1. CAP 理论 (分布式核心)', NULL, 2),
                                                                                      ('ms_theory', 'text', E'一个分布式系统在同一时间“**最多**”只能满足以下三项中的两项：', NULL, 3),
                                                                                      ('ms_theory', 'code', E'1. C (Consistency): 一致性\n   (所有节点在同一时间读取到“相同”的最新数据)\n2. A (Availability): 可用性\n   (每次请求都能收到“非错误”的响应，但不保证是最新数据)\n3. P (Partition tolerance): 分区容错性\n   (节点间网络通信失败时，系统仍能继续工作)\n\n(P 是必须满足的，因此系统通常在 CP 或 AP 之间做取舍)', 'plaintext', 4),
                                                                                      ('ms_theory', 'sub-header', '2. BASE 理论 (AP 的实现)', NULL, 5),
                                                                                      ('ms_theory', 'text', E'BASE 理论是 CAP 中 AP 方案 (牺牲强一致性，保证可用性) 的延伸，强调“**最终一致性**”：', NULL, 6),
                                                                                      ('ms_theory', 'code', E'1. BA (Basically Available): 基本可用\n   (允许部分功能降级，如双 11 期间非核心功能不可用)\n2. S (Soft state): 软状态\n   (允许数据在不同节点间存在短暂不一致)\n3. E (Eventually consistent): 最终一致性\n   (数据最终会达到一致，例如通过 MQ 异步同步)', 'plaintext', 7);

-- (模块: ms_nacos - Nacos)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ms_nacos', 'text', E'Nacos (来自阿里巴巴) 是 Spring Cloud Alibaba 生态中的核心组件，提供了“**服务发现**”和“**配置管理**”两大功能，是微服务治理的基石。', NULL, 1),
                                                                                      ('ms_nacos', 'sub-header', '1. 服务发现 (Service Discovery)', NULL, 2),
                                                                                      ('ms_nacos', 'text', E'在微服务中，服务实例是动态启动/销毁的 (IP/端口会变)。Nacos 充当“**注册中心**” (Registry)：\n\n1.  **服务提供者 (Provider)**: 启动时，将自己的 (IP:Port) **注册**到 Nacos。\n2.  **服务消费者 (Consumer)**: 向 Nacos “**订阅**” (Subscribe) Provider 的地址列表。\n3.  **心跳 (Heartbeat)**: Nacos 会“心跳”检测 Provider，自动摘除失效实例，并“推送” (Push) 更新给 Consumer。', NULL, 3),
                                                                                      ('ms_nacos', 'sub-header', '2. 配置中心 (Configuration)', NULL, 4),
                                                                                      ('ms_nacos', 'text', E'Nacos 允许我们将所有微服务的配置（如数据库连接、开关、阈值）集中存储。', NULL, 5),
                                                                                      ('ms_nacos', 'text', E'**好处**：修改 Nacos 上的配置后，Nacos 可以“**实时推送**” (Push) 更新给所有订阅该配置的服务实例，**无需重启应用**即可生效，实现了配置的动态管理。', NULL, 6);

-- (模块: ms_feign - OpenFeign)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ms_feign', 'text', E'OpenFeign 是一个“**声明式**” (Declarative) 的 Web 服务客户端 (HTTP 调用工具)。\n\n它使得编写 HTTP 客户端变得非常简单，你只需要定义一个 Java 接口并添加注解，**就像调用本地 Java 方法一样**，Feign 会自动帮你发起 HTTP 请求、处理参数和解析响应。', NULL, 1),
                                                                                      ('ms_feign', 'text', E'它会自动集成 Nacos (服务发现) 和 Sentinel (熔断)，是 Spring Cloud 中服务间调用的“**最佳实践**”。', NULL, 2),
                                                                                      ('ms_feign', 'sub-header', '示例：调用用户服务', NULL, 3),
                                                                                      ('ms_feign', 'code', E'// 1. 在启动类上加 @EnableFeignClients\n\n// 2. 定义一个 Feign 接口\n// "user-service" 是对方在 Nacos 上的注册名，Feign 会自动去 Nacos 拉取地址\n@FeignClient("user-service")\npublic interface UserClient {\n\n    // 只需要定义方法签名，Feign 会自动生成 HTTP 请求\n    @GetMapping("/users/{id}")\n    User findById(@PathVariable("id") Long id);\n}\n\n// 3. 在你的 Service 中直接注入并使用\n@Service\npublic class OrderService {\n    @Autowired\n    private UserClient userClient;\n\n    public void createOrder(Long userId) {\n        // 像调用本地方法一样调用远程 HTTP API\n        User user = userClient.findById(userId);\n        // ...\n    }\n}', 'java', 4);

-- (模块: ms_sentinel - Sentinel)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ms_sentinel', 'text', E'Sentinel (来自阿里巴巴) 是面向微服务的“**流量控制**”和“**熔断降级**”组件，是保障系统**高可用性** (HA) 的“最后一道防线”。', NULL, 1),
                                                                                      ('ms_sentinel', 'sub-header', '1. 流量控制 (限流)', NULL, 2),
                                                                                      ('ms_sentinel', 'text', E'例如：设置 `/api/hot` 接口的 **QPS (每秒查询率)** 不超过 100。当第 101 次请求在 1 秒内到达时，Sentinel 会立即拒绝该请求（或排队等待），防止后端服务被瞬时流量打垮。', NULL, 3),
                                                                                      ('ms_sentinel', 'sub-header', '2. 熔断降级 (Hystrix 替代者)', NULL, 4),
                                                                                      ('ms_sentinel', 'text', E'当服务 A 依赖的服务 B 出现大量“**慢调用**”或“**调用异常**”时，Sentinel 会“**熔断**”对服务 B 的调用（暂时关闭开关）。', NULL, 5),
                                                                                      ('ms_sentinel', 'text', E'在熔断期间，服务 A 不再请求服务 B，而是执行一个预设的“**降级逻辑**”(Fallback)，如返回默认值、缓存数据或友好提示。这可以防止因服务 B 故障导致服务 A 也被拖垮，避免“**雪崩效应**”。', NULL, 6);

-- (模块: ms_gateway - Spring Cloud Gateway)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ms_gateway', 'text', E'API 网关 (API Gateway) 是所有微服务请求的“**唯一入口**”。它充当了客户端 (Web, App) 和后端服务集群之间的“**防火墙**”和“**路由器**”。\n\n(Spring Cloud Gateway 是替代 Netflix Zuul 的新一代网关，基于 Spring WebFlux 和 Netty，性能更强)。', NULL, 1),
                                                                                      ('ms_gateway', 'sub-header', '网关的核心职责', NULL, 2),
                                                                                      ('ms_gateway', 'code', E'1. 路由 (Routing): (核心) 将 /api/user/** 请求转发到 "user-service"。\n2. 鉴权 (Authentication): (核心) 统一检查 Token 或 JWT，只有网关认证通过的请求才能进入后端服务。\n3. 限流 (Rate Limiting): 对外部请求进行统一限流，保护后端。\n4. 跨域 (CORS): 统一解决跨域问题。\n5. 聚合 (Aggregation): (可选) 将多个微服务的调用结果聚合后一次性返回给客户端。', 'plaintext', 3);

-- (模块: dist_zookeeper - ZooKeeper)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('dist_zookeeper', 'text', E'ZooKeeper (ZK) 是一个为分布式应用提供“**一致性**”服务的软件 (基于 CP)。它是一个高可用的“**文件系统**”(树形结构 Znode)，用于存储少量的“**元数据**”。\n\n(ZK 是 Hadoop 的核心组件，也是 Kafka, Dubbo 等早期依赖的注册中心)。', NULL, 1),
                                                                                      ('dist_zookeeper', 'sub-header', '1. Znode 节点类型', NULL, 2),
                                                                                      ('dist_zookeeper', 'text', E'1. **持久节点** (Persistent): 节点创建后，即使 ZK 重启也存在。\n2. **临时节点** (Ephemeral): (核心) 节点的生命周期与“**客户端会话**” (Session) 绑定。会话断开，节点被自动删除。\n3. **顺序节点** (Sequential): 创建节点时，ZK 会自动在路径后附加一个递增的序号。', NULL, 3),
                                                                                      ('dist_zookeeper', 'sub-header', '2. Watcher 机制 (核心)', NULL, 4),
                                                                                      ('dist_zookeeper', 'text', E'客户端可以“**监听**” (Watch) 某个 Znode。当该 Znode 发生变化（如被删除、数据被修改）时，ZK 会“**异步通知**”监听该节点的客户端。\n\n**注意**：Watcher 是“**一次性**”的 (One-time trigger)。触发后必须重新注册 Watcher。\n\n(Nacos 的服务发现 和 分布式锁 均基于 ZK 的 临时节点 + Watcher 机制实现)。', NULL, 5);

-- (模块: dist_lock - 分布式锁)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('dist_lock', 'text', E'在分布式系统中，`synchronized` 和 `ReentrantLock` 只在单个 JVM 内有效。跨 JVM (跨多台服务器) 锁定资源，需要**分布式锁**。\n\n* **场景**：秒杀场景下防止“超卖”，多个实例同时更新同一个商品库存。', NULL, 1),
                                                                                      ('dist_lock', 'sub-header', '1. 基于 Redis (SETNX)', NULL, 2),
                                                                                      ('dist_lock', 'text', E'利用 `SET key value NX EX seconds` (原子命令)。\n\n* **加锁**: `SET lock:product:101 "uuid" NX EX 30` (设置成功即加锁成功)。\n* **解锁**: (使用 Lua 脚本) 判断 value 是否为自己的 "uuid"，是则 `DEL` (防止误删他锁)。\n* **优点**: 性能极高 (内存操作)，实现简单。\n* **缺点**: (锁过期) 锁过期时间不好评估。如果业务没执行完锁就过期了，会导致并发问题。(需要 Redisson 等框架的 "看门狗" (Watchdog) 机制来自动续期)。', NULL, 3),
                                                                                      ('dist_lock', 'sub-header', '2. 基于 ZooKeeper (临时顺序节点)', NULL, 5),
                                                                                      ('dist_lock', 'text', E'利用“**临时节点**”和“**顺序节点**”特性。\n\n1.  所有客户端在 `/locks` 节点下创建“**临时顺序节点**” (如 `/locks/lock-001`)。\n2.  序号**最小**的客户端获得锁。\n3.  其他客户端 Watch 自己序号“**前一位**”的节点。\n4.  当锁释放（会话断开，临时节点被删除），ZK 通知下一位客户端，避免“惊群效应”。\n* **优点**: 可靠性极高 (利用临时节点自动释放锁，避免死锁)。\n* **缺点**: 性能不如 Redis (需要多次网络 I/O)。', NULL, 6);

-- (模块: dist_transaction - 分布式事务)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('dist_transaction', 'text', E'在微服务中，一个业务（如下单）可能跨越多个服务（订单服务、库存服务、积分服务）。必须保证它们“**要么都成功，要么都失败**”，这就是分布式事务。', NULL, 1),
                                                                                      ('dist_transaction', 'sub-header', '1. 强一致性：Seata (AT/TCC 模式)', NULL, 2),
                                                                                      ('dist_transaction', 'text', E'Seata (阿里巴巴) 提供了“一站式”分布式事务解决方案。\n\n* **AT 模式**: (推荐) 自动补偿，对业务**无侵入**。它通过代理数据源，在“阶段一”自动记录 `undo_log`，在“阶段二”根据全局事务状态自动“提交”或“回滚” (通过 `undo_log`)。\n* **TCC 模式**: (性能好，侵入高) 手动实现 Try (预留资源), Confirm (确认), Cancel (回滚) 三个接口。', NULL, 3),
                                                                                      ('dist_transaction', 'sub-header', '2. 最终一致性：消息队列 (MQ)', NULL, 4),
                                                                                      ('dist_transaction', 'text', E'这是最常用、最解耦的模式 (基于 BASE 理论)。\n\n* **流程**：订单服务在“**本地事务**”中完成订单创建，并“**同时**”向 MQ 发送一条“订单已创建”消息 (这步需要用 **RocketMQ 事务消息** 保证)。\n* **下游**：库存服务和积分服务订阅此消息，并执行各自的本地事务。\n* **要求**：这依赖 MQ 的“可靠投递”和下游消费者的“**幂等性**”保证。', NULL, 5);

-- (模块: ci_linux - Linux 基础)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ci_linux', 'text', E'Linux 是现代服务器操作系统的基石。所有 Java 应用（打包成 JAR 或 Docker 镜像）最终都会部署在 Linux 服务器上。', NULL, 1),
                                                                                      ('ci_linux', 'sub-header', '1. 常用命令 (定位问题)', NULL, 2),
                                                                                      ('ci_linux', 'code', E'# 查看日志 (实时滚动)\ntail -f /app/logs/spring.log\n\n# 查看日志 (关键字过滤)\ngrep "ERROR" /app/logs/spring.log\n\n# 查看 Java 进程 (并显示完整命令)\nps -ef | grep java\n\n# 查看端口占用 (8080)\nnetstat -tulnp | grep 8080\n\n# 查看内存/CPU (动态)\ntop / htop\n\n# 查看磁盘空间\ndf -h\n\n# 查看当前目录文件大小\ndu -sh *', 'bash', 3);

-- (模块: ci_docker - Docker 容器化)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ci_docker', 'text', E'Docker 是一种“**容器化**”技术。它解决了“**在我电脑上能跑**”的环境一致性问题。\n\n它将应用及其所有依赖 (OS、JDK、Lib) 打包到一个轻量级的、可移植的“**容器**”中。', NULL, 1),
                                                                                      ('ci_docker', 'sub-header', '1. 镜像 (Image) vs 容器 (Container)', NULL, 2),
                                                                                      ('ci_docker', 'text', E'1. **Image (镜像)**: 一个“**只读**”的模板，包含了应用运行所需的一切。(类比：Java 的 `.class` 文件)。\n2. **Container (容器)**: 镜像的“**运行实例**”。(类比：Java 的 `new` 对象实例)。容器是相互隔离的，拥有自己的文件系统、网络和进程空间。', NULL, 3),
                                                                                      ('ci_docker', 'sub-header', '2. Dockerfile (构建 Spring Boot 镜像)', NULL, 4),
                                                                                      ('ci_docker', 'text', E'Dockerfile 是一个“**构建指令**”文本文件，用于自动化创建镜像。', NULL, 5),
                                                                                      ('ci_docker', 'code', E'# 1. 使用一个包含 Java 17 的基础镜像\nFROM openjdk:17-jdk-slim\n\n# 2. 将本地的 JAR 包添加到镜像中\nARG JAR_FILE=target/*.jar\nCOPY ${JAR_FILE} app.jar\n\n# 3. 暴露端口 (与 Spring Boot 的 server.port 一致)\nEXPOSE 8080\n\n# 4. (重要) 容器启动时执行的命令\nENTRYPOINT ["java","-jar","/app.jar"]', 'dockerfile', 5);

-- (模块: ci_k8s_basic - K8s 基础)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ci_k8s_basic', 'text', E'Kubernetes (K8s) 是一个“**容器编排**” (Container Orchestration) 平台。如果 Docker 是集装箱，K8s 就是自动化码头、货轮和吊装系统。', NULL, 1),
                                                                                      ('ci_k8s_basic', 'text', E'K8s 负责自动化**部署**、**扩展** (Scaling) 和**管理** (Management) 容器化应用，是云原生 (Cloud Native) 时代的事实标准。', NULL, 2),
                                                                                      ('ci_k8s_basic', 'sub-header', '1. Pod (最小单元)', NULL, 3),
                                                                                      ('ci_k8s_basic', 'text', E'K8s 管理的**最小部署单元**。一个 Pod 包含一个或多个紧密相关的容器 (通常是一个)，它们共享网络和存储。', NULL, 4),
                                                                                      ('ci_k8s_basic', 'sub-header', '2. Deployment (部署)', NULL, 5),
                                                                                      ('ci_k8s_basic', 'text', E'你向 K8s 描述你的“**期望状态**”（例如：我需要 3 个 Nginx 实例）。Deployment 会自动创建 Pod，并监控它们。\n\n* **核心能力**：**自愈** (Self-healing)。如果一个 Pod 挂了，Deployment 会自动拉起一个新的来替代它。', NULL, 6),
                                                                                      ('ci_k8s_basic', 'sub-header', '3. Service (服务)', NULL, 7),
                                                                                      ('ci_k8s_basic', 'text', E'Pod 是动态的（IP 会变）。Service 提供了一个“**固定的入口地址**” (ClusterIP) 和“**负载均衡**”，用于访问一组 Pod (例如，由 Deployment 管理的 Pod)。', NULL, 8);

-- (模块: ci_cicd - CI/CD)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('ci_cicd', 'text', E'CI/CD 是一种通过“**自动化**”来频繁向客户交付应用的实践，是 DevOps 文化的核心。', NULL, 1),
                                                                                      ('ci_cicd', 'sub-header', '1. CI (Continuous Integration) 持续集成', NULL, 2),
                                                                                      ('ci_cicd', 'text', E'开发者提交代码 (`git push`) -> 自动化工具 (如 Jenkins, GitLab CI) 自动拉取 -> **自动编译** -> **自动运行单元测试** -> **自动构建 Docker 镜像**。\n\n* **目的**：尽早发现集成错误。', NULL, 3),
                                                                                      ('ci_cicd', 'sub-header', '2. CD (Continuous Delivery/Deployment) 持续交付/部署', NULL, 4),
                                                                                      ('ci_cicd', 'text', E'在 CI 成功的基础上，自动将 Docker 镜像部署到环境。\n\n* **持续交付 (Delivery)**: 自动部署到“测试环境”，部署到“生产环境”**需要手动按键确认**。\n* **持续部署 (Deployment)**: (更高阶) 自动部署到“生产环境”，**无需人工干预** (依赖强大的自动化测试)。', NULL, 5);

-- 版本 1.3: (优化版) 丰富 'text' 内容并支持 Markdown 格式 (Part 5/6)

-----------------------------------------------------
-- 8. B 路径：学习 (Learn) - (Groups 10-12)
-----------------------------------------------------

-- 8a. 学习分组 (ModuleGroup)
INSERT INTO module_group (id, title, sort_order) VALUES
                                                     (10, '监控、日志与链路追踪', 10),
                                                     (11, '搜索引擎与大数据（选修）', 11),
                                                     (12, '应用安全与认证', 12);

-- 8b. 课程模块 (CourseModule)
INSERT INTO course_module (id, title, description, group_id) VALUES
                                                                 -- 组 10: 监控
                                                                 ('mon_metrics', '应用监控 (Prometheus)', 'Metrics 指标, Exporter, PromQL 查询', 10),
                                                                 ('mon_logging', '日志聚合 (ELK/EFK)', 'Logstash/Fluentd, Elasticsearch, Kibana', 10),
                                                                 ('mon_tracing', '链路追踪 (SkyWalking)', '分布式 TraceID, Span, APM 性能分析', 10),

                                                                 -- 组 11: 搜索与大数据
                                                                 ('search_es', 'Elasticsearch 核心', '倒排索引, DSL 查询, 分布式搜索', 11),
                                                                 ('search_es_java', 'Java 操作 Elasticsearch', 'RestHighLevelClient, Spring Data ES', 11),
                                                                 ('big_hadoop', 'Hadoop 生态 (HDFS/MR)', '分布式存储 HDFS, MapReduce 计算模型', 11),
                                                                 ('big_spark', 'Spark 内存计算', 'RDD, DataFrame, Spark Streaming', 11),

                                                                 -- 组 12: 安全
                                                                 ('sec_theory', 'Web 安全基础 (OWASP)', 'XSS 跨站脚本, SQL 注入, CSRF', 12),
                                                                 ('sec_spring', 'Spring Security', '认证 (Authentication) 与 授权 (Authorization)', 12),
                                                                 ('sec_jwt', 'JWT (JSON Web Token)', '无状态认证, Token 结构 (Header/Payload/Sig)', 12),
                                                                 ('sec_oauth2', 'OAuth 2.0 协议', '第三方授权, 授权码模式', 12);

-- 8c. 模块内容 (Content Blocks)

-- (模块: mon_metrics - Prometheus)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mon_metrics', 'text', E'Prometheus (普罗米修斯) 是一个开源的“**监控告警**”系统，是 CNCF (云原生计算基金会) 的毕业项目，已成为云原生时代的监控“事实标准”。\n\n* **核心模型**：它通过 **"拉 (Pull)"** 模式，周期性地从“**目标 (Exporter)**” (如应用、服务器) 抓取 **Metrics (指标)**。', NULL, 1),
                                                                                      ('mon_metrics', 'sub-header', '1. Metrics (指标) 类型', NULL, 2),
                                                                                      ('mon_metrics', 'text', E'1. **Counter**: 计数器 (只增不减，如 HTTP 请求总数)。\n2. **Gauge**: 仪表盘 (可增可减，如当前内存使用量、CPU 使用率)。\n3. **Histogram**: 直方图 (用于统计分布，如 99% 响应时间)。\n4. **Summary**: 摘要 (类似 Histogram，但用于客户端计算)。', NULL, 3),
                                                                                      ('mon_metrics', 'sub-header', '2. PromQL (查询语言)', NULL, 4),
                                                                                      ('mon_metrics', 'text', E'Prometheus 提供了强大灵活的“**PromQL**” (Prometheus Query Language) 用于数据查询和告警。', NULL, 5),
                                                                                      ('mon_metrics', 'code', E'# 计算 http_requests_total (Counter 类型) 在 5 分钟内的平均“增长率” (QPS)\nrate(http_requests_total[5m])\n\n# 查询 JVM 堆内存使用 (Gauge 类型) 超过 1GB 的实例\njvm_memory_used_bytes{area="heap"} > 1 * 1024 * 1024 * 1024', 'plaintext', 6);

-- (模块: mon_logging - ELK)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mon_logging', 'text', E'ELK (或 EFK) 是分布式“**日志聚合**”解决方案，帮助你集中管理和搜索所有微服务的海量日志。', NULL, 1),
                                                                                      ('mon_logging', 'sub-header', '1. ELK 技术栈', NULL, 2),
                                                                                      ('mon_logging', 'text', E'1. **E (Elasticsearch)**: (核心) 基于 Lucene 的分布式搜索引擎，用于**存储**和**索引**海量日志。\n2. **L (Logstash)**: (重) 日志**收集**和**处理**引擎，负责解析、过滤、转换日志。\n3. **K (Kibana)**: (核心) 数据**可视化**平台，提供了强大的 Web UI 来搜索和展示日志。', NULL, 3),
                                                                                      ('mon_logging', 'sub-header', '2. 替代方案：EFK / Loki', NULL, 4),
                                                                                      ('mon_logging', 'text', E'**EFK**: 使用 `Fluentd` 或 `Fluent-bit` (F) 替代 Logstash (L)。Fluentd 更轻量，资源占用更少，常用于 K8s 环境。\n\n**Loki**: (Grafana 出品) 是一个更轻量、成本更低的选择，它不索引日志“全文”，只索引“**标签**” (Labels)，日志正文存在对象存储中。', NULL, 5);

-- (模块: mon_tracing - SkyWalking)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('mon_tracing', 'text', E'APM (Application Performance Management)，如 SkyWalking 或 Zipkin，专注于“**分布式链路追踪**”。', NULL, 1),
                                                                                      ('mon_tracing', 'sub-header', '1. 解决了什么问题？', NULL, 2),
                                                                                      ('mon_tracing', 'text', E'一个请求（如 /api/order）可能流经了 A, B, C, D 四个微服务。如果请求变慢或报错，APM 可以告诉你：\n\n1.  请求的**全链路**（A -> B -> C...）。\n2.  在“**哪个**”服务、“**哪个**”方法上花费了“**多少**”时间。\n3.  在“**哪个**”环节报错。\n\n这是排查分布式系统性能瓶颈和故障的“神器”。', NULL, 3),
                                                                                      ('mon_tracing', 'sub-header', '2. TraceID 和 Span', NULL, 4),
                                                                                      ('mon_tracing', 'text', E'APM 使用 **Java Agent** (字节码增强) 技术**无侵入**地自动在 HTTP 请求和 MQ 消息中注入 `TraceID`。\n\n1.  **TraceID**: 标记一个完整的请求链路。\n2.  **Span**: 标记链路中的一个“跨度”（如一次 Feign 调用、一次 JDBC 查询）。', NULL, 5);

-- (模块: search_es - Elasticsearch 核心)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('search_es', 'text', E'Elasticsearch (ES) 是一个基于 **Lucene** 的、分布式的、RESTful 风格的“**搜索引擎**”和“**分析引擎**”。\n\n(它也是 ELK 日志栈的核心存储)。', NULL, 1),
                                                                                      ('search_es', 'sub-header', '1. 倒排索引 (Inverted Index)', NULL, 2),
                                                                                      ('search_es', 'text', E'传统数据库（如 MySQL）通过 ID 找内容。搜索引擎相反，它通过“**内容**”找 ID。\n\n**正排索引 (DB)**:\n`Doc 1 -> "Java is the best"`\n`Doc 2 -> "I love Java"`\n\n**倒排索引 (ES)**: (对文档内容“分词”后建立索引)\n`"Java"  -> [Doc 1, Doc 2]`\n`"best"  -> [Doc 1]`\n`"love"  -> [Doc 2]`\n\n这就是 ES 能够实现“**全文检索**”的核心原理。', NULL, 3),
                                                                                      ('search_es', 'sub-header', '2. DSL (Domain Specific Language)', NULL, 4),
                                                                                      ('search_es', 'text', E'ES 提供了基于 JSON 的查询语言 (DSL)，用于执行复杂的全文检索、过滤和聚合分析。', NULL, 5),
                                                                                      ('search_es', 'code', E'// 查询 "content" 字段包含 "Spring Boot" 并且 "status" 为 "published" 的文档\n{\n  "query": {\n    "bool": {\n      "must": [\n        { "match": { "content": "Spring Boot" } } // 全文检索\n      ],\n      "filter": [\n        { "term": { "status": "published" } } // 精确匹配 (不分词)\n      ]\n    }\n  }\n}', 'json', 6);

-- (模块: search_es_java - Java 操作 ES)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('search_es_java', 'text', E'在 Java 中，我们主要使用 Spring Boot 提供的 `spring-boot-starter-data-elasticsearch` 来与 ES 交互。', NULL, 1),
                                                                                      ('search_es_java', 'sub-header', 'Spring Data Elasticsearch', NULL, 2),
                                                                                      ('search_es_java', 'text', E'它提供了类似 Spring Data JPA 的体验，通过 `Repository` 接口自动实现 ES 的 CRUD。', NULL, 3),
                                                                                      ('search_es_java', 'code', E'// 1. 定义文档实体\n// @Document 标记这是一个 ES 文档，存储在 "products" 索引中\n@Document(indexName = "products")\npublic class Product {\n    @Id\n    private String id;\n\n    // @Field 标记字段类型，"ik_smart" 是中文分词器\n    @Field(type = FieldType.Text, analyzer = "ik_smart")\n    private String title;\n\n    @Field(type = FieldType.Double)\n    private Double price;\n}\n\n// 2. 定义 Repository 接口\npublic interface ProductRepository extends ElasticsearchRepository<Product, String> {\n    // 自动实现方法名查询\n    List<Product> findByTitle(String title);\n}', 'java', 4);

-- (模块: big_hadoop - Hadoop 生态)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('big_hadoop', 'text', E'Hadoop (Apache Hadoop) 是大数据时代的基石，是一个“**离线**”批处理框架，提供了两大核心：HDFS (存储) 和 MapReduce (计算)。', NULL, 1),
                                                                                      ('big_hadoop', 'sub-header', '1. HDFS (Hadoop Distributed File System)', NULL, 2),
                                                                                      ('big_hadoop', 'text', E'一个高容错的“**分布式文件系统**”，用于存储海量数据 (TB/PB 级别) 在廉价的商用硬件上。\n\n* **核心**：采用“**主从**” (Master/Slave) 架构，由 `NameNode` (主节点，存元数据) 和 `DataNode` (从节点，存数据块) 组成。', NULL, 3),
                                                                                      ('big_hadoop', 'sub-header', '2. MapReduce (MR)', NULL, 4),
                                                                                      ('big_hadoop', 'text', E'一个“**分而治之**”的计算模型。它将大型计算任务分解为两个阶段：\n\n1.  **Map (映射)**: 并行处理数据，进行“局部”计算 (如 WordCount 中的“分词”和“局部计数”)。\n2.  **Reduce (规约)**: 对 Map 阶段的结果进行“全局”汇总。', NULL, 5);

-- (模块: big_spark - Spark)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('big_spark', 'text', E'Spark (Apache Spark) 是继 MapReduce 之后的新一代大数据计算引擎，支持“**内存计算**”，极大提升了处理速度。', NULL, 1),
                                                                                      ('big_spark', 'sub-header', 'Spark vs MapReduce', NULL, 2),
                                                                                      ('big_spark', 'text', E'**核心区别**:\n\n* **MapReduce**: (慢) “**基于磁盘**”的计算。Map 和 Reduce 之间的中间结果需要写入 HDFS 磁盘，I/O 开销巨大。\n* **Spark**: (快) “**基于内存**”的计算。它将数据加载到内存中形成 **RDD** (弹性分布式数据集)，计算速度比 MR 快 10 到 100 倍。', NULL, 3),
                                                                                      ('big_spark', 'sub-header', '2. Spark Streaming', NULL, 4),
                                                                                      ('big_spark', 'text', E'提供了“**准实时**”的流处理能力 (Micro-batching)。\n\n它将实时数据流（如 Kafka）切分为很小的时间片（如 1 秒），然后用 Spark 引擎批量处理这些“小批次”(DStream)。', NULL, 5);

-- (模块: sec_theory - Web 安全基础)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('sec_theory', 'text', E'OWASP (开放式 Web 应用程序安全项目) 每年会发布 Top 10 Web 安全风险。作为 Java 开发者，必须了解并防御最常见的攻击。', NULL, 1),
                                                                                      ('sec_theory', 'sub-header', '1. SQL 注入 (Injection)', NULL, 2),
                                                                                      ('sec_theory', 'text', E'**攻击**：攻击者在输入框提交恶意 SQL (如 `'' OR 1=1 --`) 来绕过验证或窃取数据。\n\n**防御**：**永远**使用 `PreparedStatement` (MyBatis/JPA 默认使用)，**绝不**手动拼接 SQL (`Statement`)。', NULL, 3),
                                                                                      ('sec_theory', 'sub-header', '2. XSS (Cross-Site Scripting) 跨站脚本', NULL, 4),
                                                                                      ('sec_theory', 'text', E'**攻击**：攻击者将恶意 `<script>` 脚本注入到你的网页中。其他用户访问时，脚本在其浏览器上执行，用于窃取 Cookie/Token。\n\n**防御**：对所有“用户输入”并需要“展示在页面”的内容进行**HTML 转义** (如 `>` 转为 `&gt;`)。', NULL, 5),
                                                                                      ('sec_theory', 'sub-header', '3. CSRF (Cross-Site Request Forgery) 跨站请求伪造', NULL, 6),
                                                                                      ('sec_theory', 'text', E'**攻击**：攻击者诱导“已登录”的用户点击一个恶意链接（如 `bank.com/transfer?to=hacker&amount=1000`）。浏览器会自动带上用户的 Cookie，导致在用户不知情下完成操作。\n\n**防御**：使用 **Anti-CSRF Token** (服务器生成随机 Token，前端提交时带上) 或 **SameSite Cookie** 策略。', NULL, 7);

-- (模块: sec_spring - Spring Security)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('sec_spring', 'text', E'Spring Security 是 Spring 官方的“安全框架”，提供了全面的**认证**和**授权**功能，是 Java 安全的行业标准。\n\n它通过一系列“**过滤器链**” (FilterChain) 来拦截请求并执行安全检查。', NULL, 1),
                                                                                      ('sec_spring', 'sub-header', '1. 认证 (Authentication)', NULL, 2),
                                                                                      ('sec_spring', 'text', E'“**你是谁？**” —— 验证用户身份的过程（如检查用户名和密码是否正确）。\n\n* **核心接口**：`AuthenticationManager`, `UserDetailsService` (用于加载用户数据)。', NULL, 3),
                                                                                      ('sec_spring', 'sub-header', '2. 授权 (Authorization)', NULL, 4),
                                                                                      ('sec_spring', 'text', E'“**你能干什么？**” —— 验证“已认证”的用户是否有权访问某个资源（如检查用户是否有 `ROLE_ADMIN` 角色）。\n\n* **实现**：通过 `@PreAuthorize("hasRole(''ADMIN'')")` 或 `HttpSecurity` 配置。', NULL, 5),
                                                                                      ('sec_spring', 'code', E'// Spring Security 5.x+ 推荐使用 Java 配置\n@Configuration\n@EnableWebSecurity\npublic class SecurityConfig extends WebSecurityConfigurerAdapter {\n\n    @Override\n    protected void configure(HttpSecurity http) throws Exception {\n        http\n            .authorizeRequests(authz -> authz\n                // /admin/** 路径需要 ADMIN 角色\n                .antMatchers("/admin/**").hasRole("ADMIN")\n                // /api/** 路径需要已认证 (登录)\n                .antMatchers("/api/**").authenticated()\n                // /public/** 和 /login 路径允许所有人访问\n                .anyRequest().permitAll()\n            )\n            .formLogin(); // 启用表单登录\n    }\n}', 'java', 6);

-- (模块: sec_jwt - JWT)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('sec_jwt', 'text', E'JWT (JSON Web Token) 是一种用于“**无状态认证**” (Stateless Authentication) 的令牌 (Token) 规范。特别适用于微服务和前后端分离架构。', NULL, 1),
                                                                                      ('sec_jwt', 'sub-header', 'JWT vs Session', NULL, 2),
                                                                                      ('sec_jwt', 'text', E'**Session**: (有状态) 登录信息存储在“服务器端”。微服务集群中需要“Session 共享”(如 Redis)，增加了复杂性。\n\n**JWT**: (无状态) 登录信息（如 UserID, Roles）被加密签名后存储在“**客户端 Token**”中。服务器端**无需存储**，只需验证 Token 签名即可。', NULL, 3),
                                                                                      ('sec_jwt', 'sub-header', '2. JWT 结构 (Header.Payload.Signature)', NULL, 4),
                                                                                      ('sec_jwt', 'code', E'JWT (格式: xxxx.yyyy.zzzz)\n\n1. Header (头部): (Base64编码)\n   { "alg": "HS256", "typ": "JWT" } \n\n2. Payload (载荷): (Base64编码)\n   { "sub": "12345", "roles": ["ADMIN"] } \n   (包含用户信息，不要存敏感数据)\n\n3. Signature (签名): (核心)\n   (使用“密钥” (Secret) 对 Header 和 Payload 进行加密签名)\n   HMACSHA256(Base64(Header) + "." + Base64(Payload), Secret)\n\n(服务器通过验证签名，来确保 Payload 没有被客户端篡改)', 'plaintext', 5);

-- (模块: sec_oauth2 - OAuth 2.0)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('sec_oauth2', 'text', E'OAuth 2.0 是一个“**授权**” (Authorization) 框架，用于“**第三方应用**”获取“**用户资源**”的访问权限，而**无需**用户提供“**用户名和密码**”。', NULL, 1),
                                                                                      ('sec_oauth2', 'sub-header', '1. 典型场景 (三方登录)', NULL, 2),
                                                                                      ('sec_oauth2', 'text', E'你（**资源所有者**）登录一个第三方网站A（**客户端应用**），该网站提示：“是否允许我们使用你的 Google/GitHub 账号（**资源服务器**）登录？”', NULL, 3),
                                                                                      ('sec_oauth2', 'sub-header', '2. 授权码模式 (Authorization Code)', NULL, 4),
                                                                                      ('sec_oauth2', 'text', E'这是最常用、最安全的模式 (如微信扫码登录)：\n\n1.  用户被重定向到“**授权服务器**”（如微信）登录。\n2.  微信回调第三方应用，并附带一个临时的“**授权码 (Code)**”。\n3.  第三方应用（**后端**）使用该 Code，向微信服务器换取“**访问令牌 (Access Token)**”。\n4.  第三方应用使用 Access Token，向微信服务器请求用户的基本信息（资源）。', NULL, 5);

-- 版本 1.3: (优化版) 丰富 'text' 内容并支持 Markdown 格式 (Part 6/6)

-----------------------------------------------------
-- 10. B 路径：学习 (Learn) - (Groups 13-15)
-----------------------------------------------------

-- 10a. 学习分组 (ModuleGroup)
INSERT INTO module_group (id, title, sort_order) VALUES
                                                     (13, '设计模式 (Design Patterns)', 13),
                                                     (14, '数据结构与算法 (复习)', 14),
                                                     (15, '性能调优与最佳实践', 15);

-- 10b. 课程模块 (CourseModule)
INSERT INTO course_module (id, title, description, group_id) VALUES
                                                                 -- 组 13: 设计模式
                                                                 ('dp_solia', 'SOLID 设计原则', '单一职责, 开闭, 里氏替换, 接口隔离, 依赖倒置', 13),
                                                                 ('dp_creational', '创建型模式', '单例 (Singleton), 工厂 (Factory), 建造者 (Builder)', 13),
                                                                 ('dp_structural', '结构型模式', '代理 (Proxy), 装饰器 (Decorator), 适配器 (Adapter)', 13),
                                                                 ('dp_behavioral', '行为型模式', '策略 (Strategy), 模板方法 (Template), 观察者 (Observer)', 13),
                                                                 ('dp_spring', 'Spring 中的设计模式', 'Spring 源码中如何应用设计模式', 13),

                                                                 -- 组 14: 算法
                                                                 ('alg_complexity', '算法复杂度分析', 'O(n), O(n log n), O(log n) 时间与空间复杂度', 14),
                                                                 ('alg_structure', '核心数据结构 (复习)', '数组, 链表, 栈, 队列, 哈希表, 树', 14),
                                                                 ('alg_common', '常见算法', '排序 (快排/归并), 二分查找, 递归, 回溯', 14),

                                                                 -- 组 15: 性能调优
                                                                 ('perf_jvm', 'JVM 调优 (GC)', 'JConsole/JVisualVM, 堆转储 (Heap Dump) 分析', 15),
                                                                 ('perf_sql', 'SQL 调优 (索引)', 'Explain 执行计划, 索引失效场景, 慢查询', 15),
                                                                 ('perf_tomcat', 'Web 服务器调优', 'Tomcat 线程池, Nginx 静态资源分离', 15),
                                                                 ('perf_pressure', '性能压测与工具', 'JMeter, Arthas (阿尔萨斯) 诊断', 15);

-- 10c. 模块内容 (Content Blocks)

-- (模块: dp_solia - SOLID 原则)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('dp_solia', 'text', E'SOLID 是面向对象设计的五大基本原则，由 Robert C. Martin (Uncle Bob) 提出。它们是写出“**高内聚、低耦合**”、易于维护和扩展代码的基础。', NULL, 1),
                                                                                      ('dp_solia', 'sub-header', '1. S - 单一职责原则 (Single Responsibility)', NULL, 2),
                                                                                      ('dp_solia', 'text', E'一个类只应该负责一项职责（即只有一个引起它变化的原因）。', NULL, 3),
                                                                                      ('dp_solia', 'sub-header', '2. O - 开闭原则 (Open-Closed)', NULL, 4),
                                                                                      ('dp_solia', 'text', E'对“**扩展**”开放，对“**修改**”关闭。新增功能时，应通过“**增加**”新代码 (如新类) 实现，而不是“**修改**”已有的老代码。', NULL, 5),
                                                                                      ('dp_solia', 'sub-header', '3. L - 里氏替换原则 (Liskov Substitution)', NULL, 6),
                                                                                      ('dp_solia', 'text', E'子类必须可以替换掉它们的父类，而程序功能不受影响 (即子类不能破坏父类的行为)。', NULL, 7),
                                                                                      ('dp_solia', 'sub-header', '4. I - 接口隔离原则 (Interface Segregation)', NULL, 8),
                                                                                      ('dp_solia', 'text', E'客户端不应依赖它不需要的接口。一个“大而全”的接口应拆分为多个“小而精”的接口。', NULL, 9),
                                                                                      ('dp_solia', 'sub-header', '5. D - 依赖倒置原则 (Dependency Inversion)', NULL, 10),
                                                                                      ('dp_solia', 'text', E'高层模块不应依赖底层模块，二者都应依赖“**抽象**”。(例如：Service 层应依赖 `UserDao` **接口**，而不是 `UserDaoImpl` **实现类**)。Spring 的 IoC/DI 就是该原则的最佳实践。', NULL, 11);

-- (模块: dp_creational - 创建型模式)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('dp_creational', 'text', E'创建型模式关注“**如何创建对象**”，将对象的创建与使用解耦，提高灵活性。', NULL, 1),
                                                                                      ('dp_creational', 'sub-header', '1. 单例模式 (Singleton)', NULL, 2),
                                                                                      ('dp_creational', 'text', E'保证一个类在 JVM 中“**只有一个实例**”，并提供一个全局访问点。(**Spring Bean 默认就是单例**)', NULL, 3),
                                                                                      ('dp_creational', 'code', E'// 推荐：静态内部类 (线程安全、懒加载)\npublic class Singleton {\n    private Singleton() {}\n\n    private static class SingletonHolder {\n        private static final Singleton INSTANCE = new Singleton();\n    }\n\n    public static Singleton getInstance() {\n        return SingletonHolder.INSTANCE;\n    }\n}', 'java', 4),
                                                                                      ('dp_creational', 'sub-header', '2. 工厂方法模式 (Factory Method)', NULL, 5),
                                                                                      ('dp_creational', 'text', E'定义一个创建对象的接口，但让**子类**决定要实例化哪一个类。', NULL, 6),
                                                                                      ('dp_creational', 'sub-header', '3. 建造者模式 (Builder)', NULL, 7),
                                                                                      ('dp_creational', 'text', E'用于创建“**属性众多**”的复杂对象。可以将“创建过程”和“表示”分离，允许链式调用 `(.build())`，使代码更易读。(例如 Lombok 的 `@Builder`)', NULL, 8);

-- (模块: dp_structural - 结构型模式)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('dp_structural', 'text', E'结构型模式关注“**如何组合类和对象**”以形成更大的、更灵活的结构。', NULL, 1),
                                                                                      ('dp_structural', 'sub-header', '1. 代理模式 (Proxy)', NULL, 2),
                                                                                      ('dp_structural', 'text', E'为其他对象提供一种“代理”以控制对这个对象的访问。代理对象可以在“**不修改**”原对象的情况下，增加额外的功能 (如权限检查、日志)。\n\n(例如 **Spring AOP** (JDK 动态代理/CGLIB) 就是典型的代理模式)。', NULL, 3),
                                                                                      ('dp_structural', 'sub-header', '2. 装饰器模式 (Decorator)', NULL, 4),
                                                                                      ('dp_structural', 'text', E'**动态地**给一个对象添加一些额外的职责。比“继承”更灵活。(例如 Java I/O 中的 `BufferedInputStream` 装饰 `FileInputStream`，增加了“缓冲”功能)。', NULL, 5),
                                                                                      ('dp_structural', 'sub-header', '3. 适配器模式 (Adapter)', NULL, 6),
                                                                                      ('dp_structural', 'text', E'将一个类的接口转换成客户希望的另一个接口。解决“**接口不兼容**”问题。(例如 `Arrays.asList()` )。', NULL, 7);

-- (模块: dp_behavioral - 行为型模式)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('dp_behavioral', 'text', E'行为型模式关注“**对象之间的通信与职责分配**”。', NULL, 1),
                                                                                      ('dp_behavioral', 'sub-header', '1. 策略模式 (Strategy)', NULL, 2),
                                                                                      ('dp_behavioral', 'text', E'定义一系列算法，将它们一个个封装起来（作为策略类），并使它们可以**相互替换**。\n\n(例如：不同的支付方式 `PaypalStrategy`, `CreditCardStrategy`；不同的排序算法)。', NULL, 3),
                                                                                      ('dp_behavioral', 'sub-header', '2. 模板方法模式 (Template Method)', NULL, 4),
                                                                                      ('dp_behavioral', 'text', E'在一个方法中定义一个算法的“**骨架**”（固定流程），而将一些步骤“**延迟**”到子类中实现。\n\n(例如 `AbstractList` 中的 `add(E e)` 和 `add(int index, E element)`)。', NULL, 5),
                                                                                      ('dp_behavioral', 'sub-header', '3. 观察者模式 (Observer)', NULL, 6),
                                                                                      ('dp_behavioral', 'text', E'定义对象间的一种“**一对多**”的依赖关系。当一个对象（被观察者）的状态发生改变时，所有依赖它的对象（观察者）都会得到通知并自动更新。(例如 Spring 的事件监听机制 `ApplicationEvent`)。', NULL, 7);

-- (模块: dp_spring - Spring 中的设计模式)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('dp_spring', 'text', E'Spring 框架本身就是设计模式的集大成者。', NULL, 1),
                                                                                      ('dp_spring', 'code', E'1. 工厂模式 (Factory):\n   `ApplicationContext` 和 `BeanFactory` 就是用于创建和管理 Bean 的工厂。\n\n2. 单例模式 (Singleton):\n   Spring IoC 容器中管理的 Bean 默认都是单例的。\n\n3. 代理模式 (Proxy):\n   (核心) Spring AOP (事务 `@Transactional`, 日志) 的核心实现。\n\n4. 模板方法 (Template):\n   Spring JDBC (`JdbcTemplate`) 和 Redis (`RedisTemplate`) 中广泛使用，封装了固定流程。\n\n5. 观察者模式 (Observer):\n   Spring 的事件监听机制 (`ApplicationListener`)。\n\n6. 适配器模式 (Adapter):\n   Spring MVC 中的 `HandlerAdapter` (用于适配不同类型的 Handler)。', 'plaintext', 2);

-- (模块: alg_complexity - 算法复杂度)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('alg_complexity', 'text', E'复杂度分析用于衡量算法的“**效率**”，是数据结构与算法的“标尺”。它关注的是算法效率与“**数据规模 N**”之间的关系，忽略常数项。', NULL, 1),
                                                                                      ('alg_complexity', 'sub-header', '1. 时间复杂度 (Time Complexity)', NULL, 2),
                                                                                      ('alg_complexity', 'text', E'估算算法执行时间与“数据规模 N”之间的关系。', NULL, 3),
                                                                                      ('alg_complexity', 'code', E'O(1): 常数时间 (如 HashMap 的 get)\nO(log n): 对数时间 (如二分查找)\nO(n): 线性时间 (如遍历数组)\nO(n log n): 线性对数时间 (如快速排序、归并排序)\nO(n^2): 平方时间 (如冒泡排序、双层循环)\nO(2^n): 指数时间 (如递归计算斐波那契数列)\nO(k!): 阶乘时间 (全排列)', 'plaintext', 4),
                                                                                      ('alg_complexity', 'sub-header', '2. 空间复杂度 (Space Complexity)', NULL, 5),
                                                                                      ('alg_complexity', 'text', E'估算算法所需“**额外**”存储空间与“数据规模 N”之间的关系。', NULL, 6);

-- (模块: alg_structure - 核心数据结构)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('alg_structure', 'text', E'程序 = 数据结构 + 算法。数据结构是算法的“基石”，是数据在内存中的组织方式。', NULL, 1),
                                                                                      ('alg_structure', 'sub-header', '1. 数组 vs 链表', NULL, 2),
                                                                                      ('alg_structure', 'text', E'**数组 (Array)**: ( `ArrayList` 底层) **连续**内存。“**查询**”快 (O(1))，“**增删**”慢 (O(n)，需移动元素)。\n\n**链表 (LinkedList)**: ( `LinkedList` 底层) **分散**内存（靠指针链接）。“**查询**”慢 (O(n))，“**头尾增删**”快 (O(1))。', NULL, 3),
                                                                                      ('alg_structure', 'sub-header', '2. 栈 vs 队列', NULL, 4),
                                                                                      ('alg_structure', 'text', E'**栈 (Stack)**: **后进先出 (LIFO)**。(用于方法调用、括号匹配)。\n\n**队列 (Queue)**: **先进先出 (FIFO)**。(用于线程池、消息队列、广度优先搜索 BFS)。', NULL, 5),
                                                                                      ('alg_structure', 'sub-header', '3. 哈希表 (HashMap)', NULL, 6),
                                                                                      ('alg_structure', 'text', E'（核心）通过 Hash 函数将 Key 映射到数组下标，实现“增删查”平均 **O(1)** 的复杂度。\n\nJDK 8+ 采用“**数组 + 链表 + 红黑树**”解决 Hash 冲突（链表 > 8 且数组 > 64 时树化）。', NULL, 7),
                                                                                      ('alg_structure', 'sub-header', '4. 树 (Tree)', NULL, 8),
                                                                                      ('alg_structure', 'text', E'**二叉搜索树 (BST)**: 左子节点 < 根 < 右子节点。\n**红黑树 (R-B Tree)**: 一种**自平衡**的二叉搜索树。( `HashMap`, `TreeMap` 底层)。', NULL, 9);

-- (模块: alg_common - 常见算法)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('alg_common', 'text', E'掌握常见的算法是解决复杂问题的基础。', NULL, 1),
                                                                                      ('alg_common', 'sub-header', '1. 二分查找 (Binary Search)', NULL, 2),
                                                                                      ('alg_common', 'text', E'前提：数组“**必须有序**”。每次将搜索范围缩小一半，复杂度 **O(log n)**。', NULL, 3),
                                                                                      ('alg_common', 'sub-header', '2. 排序 (Sort)', NULL, 4),
                                                                                      ('alg_common', 'text', E'**快速排序 (Quick Sort)**: (常用) 基于“**分治**”思想 (选取 Pivot)，平均 O(n log n)，不稳定。\n**归并排序 (Merge Sort)**: (常用) 同样基于“分治” (先分后合)，O(n log n)，空间 O(n)，**稳定**。', NULL, 5),
                                                                                      ('alg_common', 'sub-header', '3. 递归与回溯 (Recursion & Backtracking)', NULL, 6),
                                                                                      ('alg_common', 'text', E'**递归**：函数调用自身。(如树的遍历)。\n**回溯**：一种“**试错**”的搜索算法（如 **DFS 深度优先搜索**），用于解决组合、排列、N 皇后等问题。', NULL, 7);

-- (模块: perf_jvm - JVM 调优)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('perf_jvm', 'text', E'JVM 调优的核心是“**GC 调优**”，目标是减少“**Full GC**” (FGC) 的频率和时间，因为 FGC 会导致“**Stop-The-World**” (STW)，即应用卡顿。', NULL, 1),
                                                                                      ('perf_jvm', 'sub-header', '1. 调优目标 (吞吐量 vs 延迟)', NULL, 2),
                                                                                      ('perf_jvm', 'text', E'**高吞吐 (Throughput)**: ( `Parallel GC` ) 适合后台计算、数据分析。允许较长但频率低的 FGC。\n**低延迟 (Latency)**: ( `G1`, `ZGC` ) 适合 Web API、交易系统。要求停顿时间 (STW) 极短。', NULL, 3),
                                                                                      ('perf_jvm', 'sub-header', '2. 常用工具 (JMX)', NULL, 4),
                                                                                      ('perf_jvm', 'text', E'**JConsole / JVisualVM**: JDK 自带，用于实时监控 JVM 内存、线程、CPU。\n\n**MAT (Memory Analyzer Tool)**: (重点) 用于分析 `Heap Dump` (堆转储文件)，定位“**内存泄漏**” (Memory Leak) 和“**内存溢出**” (OOM)。', NULL, 5),
                                                                                      ('perf_jvm', 'sub-header', '3. 常见 OOM (OutOfMemoryError)', NULL, 6),
                                                                                      ('perf_jvm', 'text', E'1. `java.lang.OutOfMemoryError: Java heap space` (堆溢出): (最常见) 堆内存不足。\n2. `java.lang.OutOfMemoryError: Metaspace` (元空间溢出): (JDK 8+) 加载的类过多。\n3. `java.lang.StackOverflowError` (SOF): 栈溢出 (通常是递归太深)。', NULL, 7);

-- (模块: perf_sql - SQL 调优)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('perf_sql', 'text', E'数据库是系统最常见的性能瓶颈。SQL 调优的核心是“**索引 (Index)**”。', NULL, 1),
                                                                                      ('perf_sql', 'sub-header', '1. EXPLAIN (执行计划)', NULL, 2),
                                                                                      ('perf_sql', 'text', E'在 SQL 语句前加 `EXPLAIN`，查看 MySQL 如何执行这条 SQL。', NULL, 3),
                                                                                      ('perf_sql', 'text', E'关注：\n* `type`: (性能) `system > const > eq_ref > ref > range > index > all` ( `all` 是全表扫描)。\n* `key`: 实际使用的索引。\n* `Extra`: 是否 `Using filesort` (文件排序) / `Using temporary` (临时表)。', NULL, 4),
                                                                                      ('perf_sql', 'sub-header', '2. 索引失效场景 (重点)', NULL, 5),
                                                                                      ('perf_sql', 'text', E'即使建立了索引，以下情况也可能导致索引失效（退化为全表扫描）：', NULL, 6),
                                                                                      ('perf_sql', 'code', E'1. (最左前缀) 联合索引 (a,b,c)，查询条件未使用 a (如 `WHERE b=1`)。\n2. (函数/计算) `WHERE YEAR(create_time) = 2025` (应改为 `WHERE create_time BETWEEN ...`)\n3. (类型转换) `WHERE phone_number = 12345` (phone_number 是 varchar，但传了数字)\n4. (OR 条件) `WHERE a=1 OR b=2` (b 未索引)\n5. (LIKE) `WHERE name LIKE ''%Java''` (以 % 开头)', 'sql', 7);

-- (模块: perf_tomcat - Web 服务器调优)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('perf_tomcat', 'text', E'Web 服务器（如 Spring Boot 内嵌的 Tomcat）是请求的入口，也需要调优。调优的核心是“**线程池**”。', NULL, 1),
                                                                                      ('perf_tomcat', 'sub-header', '1. Tomcat 线程池调优', NULL, 2),
                                                                                      ('perf_tomcat', 'text', E'在 `application.properties` (或 `.yml`) 中调整 Tomcat 的核心参数：', NULL, 3),
                                                                                      ('perf_tomcat', 'code', E'# (关键) 最大工作线程数 (默认 200)。\n# 不是越大越好，取决于 CPU 核心数和 I/O 类型。\n# CPU 密集型: CPU 核数 + 1\n# I/O 密集型: CPU 核数 * (1 + 线程等待时间/CPU计算时间)\nserver.tomcat.threads.max=200\n\n# 最小备用线程数\nserver.tomcat.threads.min-spare=10\n\n# 最大连接数 (等待队列 + 工作线程)\nserver.tomcat.max-connections=10000\n\n# (等待队列) 最大排队数\nserver.tomcat.accept-count=100', 'properties', 4);

-- (模块: perf_pressure - 性能压测与诊断)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('perf_pressure', 'text', E'调优必须基于“**数据**”，而不是“**猜测**”。压测和诊断是获取数据的手段。', NULL, 1),
                                                                                      ('perf_pressure', 'sub-header', '1. JMeter (性能压测)', NULL, 2),
                                                                                      ('perf_pressure', 'text', E'Apache JMeter 是最主流的性能测试工具。用于模拟大量用户并发请求，测试系统的 **QPS** (每秒查询)、**RT** (响应时间) 和**错误率**，找到系统的“**性能拐点**”。', NULL, 3),
                                                                                      ('perf_pressure', 'sub-header', '2. Arthas (Java 在线诊断)', NULL, 4),
                                                                                      ('perf_pressure', 'text', E'Arthas (阿尔萨斯，阿里出品) 是 Java 线上“**神级**”诊断工具。', NULL, 5),
                                                                                      ('perf_pressure', 'text', E'它可以在“**不重启服务**”的情况下，通过 `attach` 到 Java 进程，实时查看：\n\n* `trace`: 哪个方法调用慢。\n* `watch`: 方法的入参和返回值。\n* `thread`: 线程堆栈，定位死锁。\n* `jvm`: 实时 JVM 信息。\n* `jad`: 反编译线上代码。', NULL, 6);

-----------------------------------------------------
-- 12. B 路径：学习 (Learn) - (Groups 16-18)
-----------------------------------------------------

-- 12a. 学习分组 (ModuleGroup)
INSERT INTO module_group (id, title, sort_order) VALUES
                                                     (16, 'Java 核心类库 (深潜)', 16),
                                                     (17, 'Java 核心机制 (深潜)', 17),
                                                     (18, '核心组件面试点 (复习)', 18);

-- 12b. 课程模块 (CourseModule)
INSERT INTO course_module (id, title, description, group_id) VALUES
                                                                 -- 组 16: 核心类库
                                                                 ('core_string_immutable', 'String 不可变性与常量池', 'String, StringBuffer, StringBuilder 对比', 16),
                                                                 ('core_arraylist', 'ArrayList 源码与特性', '动态扩容机制, 常用方法', 16),
                                                                 ('core_linkedlist', 'LinkedList 与 List 对比', 'ArrayList vs LinkedList 区别', 16),

                                                                 -- 组 17: 核心机制
                                                                 ('core_hashmap', 'HashMap 底层实现 (JDK 1.8+)', '数组+链表+红黑树, Put 流程, 扩容', 17),
                                                                 ('core_threadsafe_map', '线程安全集合 (JUC)', 'ConcurrentHashMap, CopyOnWriteArrayList', 17),
                                                                 ('core_jvm_heap', 'JVM 堆、栈与常量池', '内存区域划分, 对象创建过程', 17),

                                                                 -- 组 18: 面试复习
                                                                 ('review_db_interview', '数据库面试核心', '事务 (ACID), 隔离级别, 索引 (B+树)', 18),
                                                                 ('review_redis_interview', 'Redis 面试核心', '为什么快, 数据类型, 持久化, 缓存问题', 18),
                                                                 ('review_mq_interview', '消息队列面试核心', '为什么用MQ, 消息可靠性, 幂等性', 18);

-- 12c. 模块内容 (Content Blocks)

-- (模块: core_string_immutable - String/StringBuffer/Builder)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('core_string_immutable', 'text', E'String 是 Java 中最特殊和最常用的类之一。', NULL, 1),
                                                                                      ('core_string_immutable', 'sub-header', '1. String (不可变性)', NULL, 2),
                                                                                      ('core_string_immutable', 'text', E'`String` 对象一旦被创建就是“**不可变的**” (Immutable)。其底层由 `private final byte[]` (JDK 9+) 数组存储。\n\n**任何**对 String 对象的修改 (如 `+`, `substring()`, `replace()`) 都会**创建并返回一个新 String 对象**。', NULL, 3),
                                                                                      ('core_string_immutable', 'text', E'**好处**：\n1.  **线程安全**: 无需同步。\n2.  **安全**: 可用于方法参数 (如数据库密码)，防止被篡改。\n3.  **可池化**: 因为不可变，**字符串常量池** (String Constant Pool) 才能实现。', NULL, 4),
                                                                                      ('core_string_immutable', 'sub-header', '2. 字符串常量池 (SCP)', NULL, 5),
                                                                                      ('core_string_immutable', 'text', E'这是面试高频点。JVM 为 `String` 单独开辟的区域 (JDK 7+ 在堆中)。', NULL, 6),
                                                                                      ('core_string_immutable', 'code', E'// s1 和 s2 指向“常量池”中的同一个 "Java" 对象\nString s1 = "Java";\nString s2 = "Java";\nSystem.out.println(s1 == s2); // true\n\n// s3 在“堆”中创建了一个新对象 (s1, s2 != s3)\nString s3 = new String("Java");\nSystem.out.println(s1 == s3); // false\n\n// s4 也在“堆”中创建了一个新对象 (s3 != s4)\nString s4 = new String("Java");\nSystem.out.println(s3 == s4); // false\n\n// s5 是由变量拼接，在“堆”中创建新对象\nString s6 = "World";\nString s5 = "Hello" + s6;\nSystem.out.println(s5 == "HelloWorld"); // false', 'java', 7),
                                                                                      ('core_string_immutable', 'sub-header', '3. StringBuffer vs StringBuilder', NULL, 8),
                                                                                      ('core_string_immutable', 'text', E'由于 String 不可变，大量“拼接”操作 (如 `s = s + "a"` ) 会产生大量垃圾对象。因此需要使用可变的字符串类。', NULL, 9),
                                                                                      ('core_string_immutable', 'code', E'// 1. StringBuilder (可变, 性能高, 线程不安全)\n// (推荐！) 用于单线程、方法内部的字符串拼接。\n\n// 2. StringBuffer (可变, 性能低, 线程安全)\n// (基本已淘汰) 所有方法使用 synchronized 关键字加锁，开销大。\n\n// 编译器优化：\n// String s = "a" + "b" + "c"; // 编译时直接合并为 "abc"\n// String s = s1 + s2; // (JDK 5+) 编译器自动优化为 StringBuilder.append()', 'java', 10);

-- (模块: core_arraylist - ArrayList)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('core_arraylist', 'text', E'`ArrayList` 是 Java 集合框架 (Collections) 中最常用的 `List` 实现。', NULL, 1),
                                                                                      ('core_arraylist', 'sub-header', '1. 底层实现', NULL, 2),
                                                                                      ('core_arraylist', 'text', E'`ArrayList` 的底层是一个“**动态数组**” (`Object[] elementData`)。它允许快速的“**随机访问**”（通过索引 `get(i)`)。', NULL, 3),
                                                                                      ('core_arraylist', 'sub-header', '2. 常用方法 (复杂度)', NULL, 4),
                                                                                      ('core_arraylist', 'code', E'List<String> list = new ArrayList<>();\n\n// 增 (Add) (在末尾)\nlist.add("Apple"); // O(1) (平均)\n\n// 增 (Add) (在中间)\nlist.add(1, "Banana"); // O(n) (需移动后续所有元素)\n\n// 删 (Remove) (在中间)\nlist.remove(0); // O(n) (需移动后续所有元素)\n\n// 查 (Get) - 核心优势\nString fruit = list.get(0); // O(1) (速度极快)\n\n// 改 (Set)\nlist.set(0, "Peach"); // O(1)', 'java', 5),
                                                                                      ('core_arraylist', 'sub-header', '3. 动态扩容 (核心)', NULL, 6),
                                                                                      ('core_arraylist', 'text', E'当 `add()` 时，如果数组已满，`ArrayList` 会自动扩容。\n\n1.  **初始化**：`new ArrayList()` 时，数组为空。`elementData` 是空数组 `{}`。\n2.  **首次 `add()`**：扩容到默认容量 **10**。\n3.  **再次满时**：触发 `grow()` 方法，新容量 = 旧容量 + (旧容量 >> 1)，即扩容为旧容量的 **1.5 倍**。\n4.  **扩容开销**：扩容涉及 `Arrays.copyOf()` (数组复制)，是昂贵操作。如果能预估大小，推荐使用 `new ArrayList(capacity)` 初始化。', NULL, 7);

-- (模块: core_linkedlist - LinkedList 与对比)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('core_linkedlist', 'text', E'`LinkedList` 是 `List` 接口的另一个实现，底层是“**双向链表**”。', NULL, 1),
                                                                                      ('core_linkedlist', 'sub-header', '1. 底层实现', NULL, 2),
                                                                                      ('core_linkedlist', 'text', E'它由一个个 `Node` 组成，每个 `Node` 包含三个信息：`prev` (指向前一个 Node), `item` (数据), `next` (指向后一个 Node)。', NULL, 3),
                                                                                      ('core_linkedlist', 'sub-header', '2. 常用方法 (作为队列/栈)', NULL, 4),
                                                                                      ('core_linkedlist', 'text', E'`LinkedList` 因为其“**头尾操作 O(1)**” 的特性，常被用作“**队列**”或“**栈**”。 (它也实现了 `Deque` 接口)。', NULL, 5),
                                                                                      ('core_linkedlist', 'code', E'LinkedList<String> list = new LinkedList<>();\n\n// 作为队列 (FIFO)\nlist.addLast("A");\nlist.addLast("B");\nString first = list.removeFirst(); // "A"\n\n// 作为栈 (LIFO)\nlist.addFirst("A");\nlist.addFirst("B");\nString top = list.removeFirst(); // "B"', 'java', 6),
                                                                                      ('core_linkedlist', 'sub-header', '3. (面试核心) ArrayList vs LinkedList', NULL, 7),
                                                                                      ('core_linkedlist', 'text', E'1. **结构**: `ArrayList` 是动态数组；`LinkedList` 是双向链表。\n2. **随机访问 (Get)**: `ArrayList` 是 O(1)，极快；`LinkedList` 是 O(n)，极慢 (需遍历)。\n3. **头尾增删 (AddFirst/Last)**: `ArrayList` 是 O(n) (需移动数组)；`LinkedList` 是 O(1)，极快。\n4. **中间增删 (Add/Remove at index)**: 两者“平均”都是 O(n)。( `ArrayList` 慢在“移动”， `LinkedList` 慢在“遍历定位”)。\n5. **空间**: `ArrayList` 空间连续；`LinkedList` 额外需要 `prev/next` 指针，内存开销更大。', NULL, 8),
                                                                                      ('core_linkedlist', 'text', E'**结论**: 绝大多数 (99%) 场景，**优先使用 ArrayList**。只有当“严格需要” O(1) 的头尾增删（如实现 `Deque`）时，才考虑 `LinkedList`。', NULL, 9);

-- (模块: core_hashmap - HashMap)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('core_hashmap', 'text', E'`HashMap` 是 Java 中使用最频繁的 `Map` 实现，是面试“**必考**”知识点。它**线程不安全**，**无序**，且允许 `null` 键和 `null` 值。', NULL, 1),
                                                                                      ('core_hashmap', 'sub-header', '1. 底层实现 (JDK 1.8+)', NULL, 2),
                                                                                      ('core_hashmap', 'text', E'`HashMap` 的底层数据结构是：**数组 + 链表 + 红黑树**。\n\n( `Node[] table` 数组，每个 `Node` 节点是一个“桶”(Bucket)，用于存放发生 Hash 冲突的元素)。', NULL, 3),
                                                                                      ('core_hashmap', 'sub-header', '2. Put 方法流程 (核心)', NULL, 4),
                                                                                      ('core_hashmap', 'text', E'1.  计算 `key` 的 `hashCode()`。\n2.  (扰动) `(h = key.hashCode()) ^ (h >>> 16)` 高 16 位与低 16 位异或，增加随机性，减少冲突。\n3.  (定位) `(n - 1) & hash` (n 是数组长度) 找到数组（桶）的索引 `i`。\n4.  (情况 1) 如果 `table[i]` 为 null，直接创建 `Node` 放入。\n5.  (情况 2) 如果 `table[i]` 不为 null (发生 Hash 冲突)：\n    a.  如果 Key 相同 ( `equals()` )，则**覆盖** Value。\n    b.  如果是 `TreeNode` (红黑树)，则按树的方式插入。\n    c.  (默认) 是链表，遍历链表，追加到末尾。\n6.  (树化) 如果链表长度 **> 8** (TREEIFY_THRESHOLD)，并且数组总长度 **> 64**，则将链表“树化”为红黑树 (O(log n))。\n7.  (扩容) Put 之后，如果 `size` > `loadFactor * capacity` (负载因子 0.75)，触发 `resize()` (扩容为 **2 倍**)。', NULL, 5);

-- (模块: core_threadsafe_map - 线程安全集合)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('core_threadsafe_map', 'text', E'`ArrayList` 和 `HashMap` 都是“**线程不安全**”的。在并发环境下，如果多线程同时“写” (put/add)，会导致数据错乱或 `ConcurrentModificationException`。\n\n必须使用 JUC (java.util.concurrent) 包下的线程安全集合。', NULL, 1),
                                                                                      ('core_threadsafe_map', 'sub-header', '1. ConcurrentHashMap (代替 HashMap)', NULL, 2),
                                                                                      ('core_threadsafe_map', 'text', E'（面试核心）`ConcurrentHashMap` 是 JUC 的明星。它如何保证线程安全？', NULL, 3),
                                                                                      ('core_threadsafe_map', 'text', E'JDK 1.8+ 放弃了 1.7 的“分段锁”，改用 **CAS + synchronized**。\n\n* `get()` 操作：**不加锁** (利用 `volatile` 保证可见性)。\n* `put()` 操作：\n    * (无冲突) 当桶 (table[i]) 为 null 时，使用 **CAS** (无锁) 尝试写入。\n    * (有冲突) 当发生冲突时，只 `synchronized` 锁住“**桶的头节点**” (`table[i]`)，**而不是锁住“整个 Map”**。\n* 这种“**锁粒度**”极细的方式，使得并发性能极高。', NULL, 4),
                                                                                      ('core_threadsafe_map', 'sub-header', '2. CopyOnWriteArrayList (代替 ArrayList)', NULL, 5),
                                                                                      ('core_threadsafe_map', 'text', E'适用于“**读多写少**”的场景 (如配置、黑名单)。', NULL, 6),
                                                                                      ('core_threadsafe_map', 'text', E'“**写时复制**” (Copy-On-Write)：\n\n* **读 (get)**: **不加锁**，直接读老数组 (性能极高)。\n* **写 (add/remove)**: (加重锁) \n    1.  复制一份新数组。\n    2.  在新数组上修改。\n    3.  将 `array` 引用指向新数组。\n\n* **缺点**：写操作开销大；数据“**最终一致性**”（读线程可能看不到刚写入的数据）。', NULL, 7);

-- (模块: core_jvm_heap - JVM 内存)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('core_jvm_heap', 'text', E'JVM 内存模型 (JMM) 是 Java 跨平台运行的基础。', NULL, 1),
                                                                                      ('core_jvm_heap', 'sub-header', '1. 线程私有 (Private to Thread)', NULL, 2),
                                                                                      ('core_jvm_heap', 'text', E'1. **程序计数器 (PC Register)**: (无 OOM) 指向当前执行的字节码指令。\n2. **Java 虚拟机栈 (Stack)**: (有 SOF) 存储“**栈帧**” (Stack Frame)。每次“**方法调用**”都会创建一个栈帧。栈帧包含：**局部变量表**、操作数栈等。', NULL, 3),
                                                                                      ('core_jvm_heap', 'sub-header', '2. 线程共享 (Shared)', NULL, 4),
                                                                                      ('core_jvm_heap', 'text', E'1. **Java 堆 (Heap)**: (重点, OOM) **所有** `new` 出来的**对象实例**和**数组**都在这里。是 GC (垃圾收集) 的主要区域。\n   * 堆分为：**新生代** (Young Gen: Eden, S0, S1) 和 **老年代** (Old Gen)。\n2. **方法区 (Method Area)**: (JDK 8+ 为 **Metaspace**, 元空间) 存储：**类信息** (Class)、**静态变量** (Static)、**运行时常量池** (Runtime Constant Pool)。', NULL, 5),
                                                                                      ('core_jvm_heap', 'sub-header', '3. (面试点) 对象创建过程', NULL, 6),
                                                                                      ('core_jvm_heap', 'text', E'`new User()` 时发生了什么？\n\n1.  (类加载) 检查类是否已加载。\n2.  (分配内存) 在“**堆**”中分配内存 (优先在 **Eden 区**)。\n3.  (零值初始化) 内存空间“零值”初始化 (如 int 为 0)。\n4.  (设置头) 设置**对象头** (Object Header, 包含 MarkWord, Class 指针)。\n5.  (执行 init) 执行 `<init>` 构造方法。\n6.  (栈指向堆) 在“**栈**”中创建 `user` 引用，指向“**堆**”中的地址。', NULL, 7);

-- (模块: review_db_interview - 数据库面试点)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('review_db_interview', 'text', E'数据库是后端服务的基石，事务和索引是面试的重中之重。', NULL, 1),
                                                                                      ('review_db_interview', 'sub-header', '1. 事务 ACID', NULL, 2),
                                                                                      ('review_db_interview', 'text', E'**A**tomicity (原子性), **C**onsistency (一致性), **I**solation (隔离性), **D**urability (持久性)。', NULL, 3),
                                                                                      ('review_db_interview', 'sub-header', '2. 隔离级别 (Isolation)', NULL, 4),
                                                                                      ('review_db_interview', 'text', E'1. **Read Uncommitted** (读未提交): 产生“**脏读**”。\n2. **Read Committed** (读已提交): (Oracle 默认) 解决脏读，产生“**不可重复读**”。\n3. **Repeatable Read** (可重复读): (MySQL 默认) 解决不可重复读，产生“**幻读**”。\n4. **Serializable** (串行化): (最慢) 全部解决。', NULL, 5),
                                                                                      ('review_db_interview', 'sub-header', '3. 索引 (Index) - B+ 树', NULL, 6),
                                                                                      ('review_db_interview', 'text', E'MySQL (InnoDB) 默认使用 **B+ 树** 作为索引结构。', NULL, 7),
                                                                                      ('review_db_interview', 'text', E'**为什么不用 B 树？**\n1.  **I/O 次数更少**：B+ 树“**非叶子节点**”不存数据 (data)，只存 key，因此树更“**矮胖**”，一个磁盘块能存更多索引，减少 I/O。\n2.  **范围查询更优**：B+ 树“**叶子节点**”包含了所有数据，并且是一个“**双向链表**”，非常利于范围查询 ( `WHERE age > 20` )。', NULL, 8);

-- (模块: review_redis_interview - Redis 面试点)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('review_redis_interview', 'text', E'Redis 是 Java 后端必备的缓存中间件。', NULL, 1),
                                                                                      ('review_redis_interview', 'sub-header', '1. 为什么 Redis 这么快？', NULL, 2),
                                                                                      ('review_redis_interview', 'text', E'1.  (核心) 完全“**基于内存**”操作。\n2.  (核心) **I/O 多路复用** (Multiplexing) 和非阻塞 I/O (epoll)。\n3.  (核心) 采用“**单线程**”模型 (处理网络请求)，避免了多线程上下文切换和锁竞争的开销。\n(注：AOF 刷盘等操作是后台线程)。', NULL, 3),
                                                                                      ('review_redis_interview', 'sub-header', '2. 持久化 (RDB vs AOF)', NULL, 4),
                                                                                      ('review_redis_interview', 'text', E'**RDB**: (快照) 存某一时刻的“数据”，恢复快，但可能丢数据。\n**AOF**: (日志) 存执行的“命令”，数据最安全，但文件大，恢复慢。', NULL, 5),
                                                                                      ('review_redis_interview', 'sub-header', '3. 缓存三大问题 (复习)', NULL, 6),
                                                                                      ('review_redis_interview', 'text', E'**穿透** (查空值：缓存空对象、布隆过滤器)。\n**击穿** (热点 Key：分布式锁)。\n**雪崩** (大面积失效：过期时间加随机值)。', NULL, 7);

-- (模块: review_mq_interview - MQ 面试点)
INSERT INTO module_content_block (module_id, type, content, language, sort_order) VALUES
                                                                                      ('review_mq_interview', 'text', E'消息队列 (MQ) 是分布式架构的“粘合剂”。', NULL, 1),
                                                                                      ('review_mq_interview', 'sub-header', '1. 为什么用 MQ？(复习)', NULL, 2),
                                                                                      ('review_mq_interview', 'text', E'**异步** (提升响应速度)，**解耦** (服务间)，**削峰** (扛住瞬时流量)。', NULL, 3),
                                                                                      ('review_mq_interview', 'sub-header', '2. 如何保证消息不丢失？', NULL, 4),
                                                                                      ('review_mq_interview', 'text', E'1. **Producer (生产者)**: 开启 `Confirm` 机制 (同步或异步)，确保消息被 Broker 签收。\n2. **Broker (MQ 服务)**: (Kafka/RocketMQ) 开启持久化 (刷盘)，配置多副本 (Replica)。\n3. **Consumer (消费者)**: (关键) **关闭“自动 Ack”**，改为“**手动 Ack**”。必须在“业务处理成功后”，才 Ack 消息。', NULL, 5),
                                                                                      ('review_mq_interview', 'sub-header', '3. 如何处理重复消费 (幂等性)？', NULL, 6),
                                                                                      ('review_mq_interview', 'text', E'MQ 只能保证“**At-Least-Once**” (至少一次)，无法保证“**Exactly-Once**”。消费者必须自己实现“**幂等性**”。', NULL,7),
                                                                                      ('review_mq_interview', 'text', E'**方法**：\n1.  (DB 唯一键) 利用数据库主键或唯一索引 (如订单号)。\n2.  (Redis) `SETNX`，消费前检查是否已处理过 (如用 MessageID 作 Key)。\n3.  (状态机) `UPDATE orders SET status=1 WHERE status=0` (利用乐观锁或状态)。', NULL, 8);


-----------------------------------------------------
-- (重要) 更新所有序列号
-----------------------------------------------------
SELECT setval('module_group_id_seq', (SELECT MAX(id) FROM module_group));
SELECT setval('module_content_block_id_seq', (SELECT MAX(id) FROM module_content_block));
