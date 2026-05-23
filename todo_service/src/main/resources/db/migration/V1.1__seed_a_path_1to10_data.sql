-- 版本 1.1: (合并) 填充 A 路径 (小白) 的所有数据 (丰富版)

-----------------------------------------------------
-- 1. A 路径：学习 (Learn)
-----------------------------------------------------

-- 1a. 大关卡 (Level)
INSERT INTO beginner_level (id, title, sort_order) VALUES
                                                       (1, '第1关：Java 基础语法', 1),
                                                       (2, '第2关：流程控制', 2);

-- 1b. 小关卡 (Lesson)
-- (第1关)
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (1, '1.1 什么是 Java?', 1, 1),
                                                                  (2, '1.2 第一个程序: Hello World', 2, 1),
                                                                  (3, '1.3 变量 (Variables)', 3, 1),
                                                                  (4, '1.4 数据类型 (Data Types)', 4, 1);
-- (第2关)
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (5, '2.1 算术运算符 (+, -, *, /)', 1, 2),
                                                                  (6, '2.2 比较和逻辑运算符', 2, 2);

-- 1c. 关卡内容 (Content Blocks)
-- (关卡 1.1 - 纯文本)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (1, 'text', 'Java 是一种高级编程语言...', NULL, 1),
                                                                                               (1, 'text', '它被设计为“一次编写，到处运行”...', NULL, 2),
                                                                                               (1, 'sub-header', 'Java 的特点', NULL, 3),
                                                                                               (1, 'text', E'1. **面向对象 (OOP)**: ...\n2. **平台独立性**: ...\n3. **强大的生态系统**: ...', NULL, 4);

-- (关卡 1.2 - 可运行的 Hello World)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (2, 'text', '在Java中，打印 "Hello, World!" 到控制台是所有学习的开始。这是你的第一个 Java 程序。', NULL, 1),
-- (这是 'code' 类型，是可运行的完整程序)
                                                                                               (2, 'code', E'public class HelloWorld {\n    public static void main(String[] args) {\n        // 这是打印语句, 它会把 "Hello, World!" 显示在控制台\n        System.out.println("Hello, World!");\n    }\n}', 'java', 2),
                                                                                               (2, 'text', '点击上方的“运行”按钮，看看会发生什么！', NULL, 3);

-- (关卡 1.3 - 不可运行的代码片段)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (3, 'text', '变量是用来存储数据的“容器”。...', NULL, 1),
                                                                                               (3, 'sub-header', '声明变量', NULL, 2),
                                                                                               (3, 'text', '声明变量需要“类型”和“名称”。例如，声明一个用来存整数（int）的变量，名为 `age`：', NULL, 3),
-- (关键修复：改为 'text' 类型，并用 Markdown 包裹)
                                                                                               (3, 'text', E'```java\nint age;\n\n// 声明后，你可以给它赋值\nage = 25;\n```', NULL, 4),
                                                                                               (3, 'sub-header', '声明并赋值 (初始化)', NULL, 5),
                                                                                               (3, 'text', '你也可以在声明时就立即给它一个值，这被称为“初始化”：', NULL, 6),
-- (关键修复：改为 'text' 类型，并用 Markdown 包裹)
                                                                                               (3, 'text', E'```java\n// 声明一个整数类型 (int) 变量 score, 并赋值为 100\nint score = 100;\n\n// 声明一个字符串类型 (String) 变量 name, 并赋值为 "Java"\nString name = "Java";\n```', NULL, 7);

-- (关卡 1.4 - 不可运行的代码片段)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (4, 'text', 'Java 是一种“强类型”语言。...', NULL, 1),
                                                                                               (4, 'sub-header', '基本数据类型 (Primitive Types)', NULL, 2),
                                                                                               (4, 'text', '这是 Java 内置的 8 种基础类型...', NULL, 3),
-- (关键修复：改为 'text' 类型，并用 Markdown 包裹)
                                                                                               (4, 'text', E'```java\n// 整数 (Integers)\nint myInt = 10;\nlong myLong = 10000L;\n\n// 浮点数 (Floating-Point)\ndouble myDouble = 5.75;\nfloat myFloat = 5.75f;\n\n// 字符 (Character)\nchar myChar = ''A'';\n\n// 布尔值 (Boolean)\nboolean isJavaFun = true;\nboolean isFinished = false;\n```', NULL, 4),
                                                                                               (4, 'sub-header', '引用数据类型 (Reference Types)', NULL, 5),
                                                                                               (4, 'text', '最常用的引用类型是 `String` (字符串)...', NULL, 6),
-- (关键修复：改为 'text' 类型，并用 Markdown 包裹)
                                                                                               (4, 'text', E'```java\nString greeting = "Hello World";\n```', NULL, 7);

-- (关卡 2.1 - 丰富内容)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (5, 'text', '算术运算符用于执行基本的数学运算。', NULL, 1),
                                                                                               (5, 'code', E'int sum = 5 + 3; // 加法: 结果是 8\nint difference = 5 - 3; // 减法: 结果是 2\nint product = 5 * 3; // 乘法: 结果是 15\nint division = 10 / 2; // 除法: 结果是 5\n\n// (取余数/模)\nint remainder = 10 % 3; // 10 除以 3 余 1, 结果是 1', 'java', 2),
                                                                                               (5, 'sub-header', '自增 (++) 和 自减 (--) (A)', NULL, 3),
                                                                                               (5, 'text', '`++` 是一个特殊的运算符，它把变量的值加 1。`a++` (后缀) 和 `++a` (前缀) 有细微差别，我们将在测验中探讨。', NULL, 4),
                                                                                               (5, 'code', E'int a = 5;\na++; // 现在 a 等于 6\n\nint b = 10;\nb--; // 现在 b 等于 9', 'java', 5);

-- (关卡 2.2 - 丰富内容)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (6, 'text', '比较运算符用于比较两个值，并返回一个布尔值 (true 或 false)。它们是 `if` 语句的核心。', NULL, 1),
                                                                                               (6, 'code', E'int x = 10;\nint y = 5;\n\nboolean isEqual = (x == 10); // 等于: true\nboolean isNotEqual = (x != y); // 不等于: true\nboolean isGreater = (x > y); // 大于: true\nboolean isLessOrEqual = (y <= 5); // 小于等于: true', 'java', 2),
                                                                                               (6, 'sub-header', '逻辑运算符', NULL, 3),
                                                                                               (6, 'text', '逻辑运算符用于连接多个“布尔”表达式。', NULL, 4),
                                                                                               (6, 'code', E'// (&&) 逻辑与: *两个* 都为 true, 结果才为 true\nboolean test1 = (5 > 3) && (1 < 10); // true && true = true\n\n// (||) 逻辑或: *只要一个* 为 true, 结果就为 true\nboolean test2 = (1 == 0) || (2 > 1); // false || true = true\n\n// (!) 逻辑非: 反转布尔值\nboolean test3 = !(1 == 0); // !(false) = true', 'java', 5);

-----------------------------------------------------
-- 2. A 路径：测验 (Quiz)
-----------------------------------------------------

-- 2a. 测验章节 (Chapter)
INSERT INTO quiz_chapter (id, title, sort_order) VALUES
                                                     (1, '第1关：基础语法 (测验)', 1),
                                                     (2, '第2关：流程控制 (测验)', 2);

-- 2b. 测验问题 (Question)
-- (第1关)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (1, '在Java中，哪种类型用于存储整数（如 10）？', 1),
                                                     (2, '哪一行代码是有效的变量声明和初始化？', 1),
                                                     (3, '`System.out.println()` 的作用是什么？', 1),
                                                     (4, '在Java中，"String" 类型是用来存储什么的？', 1);
-- (第2关)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (5, '`a++` 和 `++a` 的主要区别是什么？', 2),
                                                     (6, '`==` 和 `.equals()` 在比较“对象”时的主要区别是什么？', 2);

-- 2c. 测验选项 (Option)
-- (问题 1-4)
INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('A. String', false, 1), ('B. int', true, 1), ('C. double', false, 1), ('D. boolean', false, 1),
                                                            ('A. int number = 100;', true, 2), ('B. number = 100;', false, 2), ('C. int number;', false, 2), ('D. String 100 = number;', false, 2),
                                                            ('A. 声明一个变量', false, 3), ('B. 计算数学公式', false, 3), ('C. 在控制台打印信息', true, 3), ('D. 暂停程序', false, 3),
                                                            ('A. 浮点数 (e.g., 3.14)', false, 4), ('B. 单个字符 (e.g., ''c'')', false, 4), ('C. 文本字符串 (e.g., "Hello")', true, 4), ('D. 逻辑值 (true/false)', false, 4);
-- (问题 5-6)
INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('A. 没有区别', false, 5), ('B. `a++` 先使用再自增, `++a` 先自增再使用', true, 5), ('C. `a++` 是加法, `++a` 是乘法', false, 5),
                                                            ('A. `==` 比较内存地址, `.equals()` 比较内容', true, 6), ('B. `==` 比较内容, `.equals()` 比较内存地址', false, 6), ('C. 它们没有区别', false, 6);

-----------------------------------------------------
-- 3. A 路径：编程逻辑 (Logic)
-----------------------------------------------------

-- 3a. 编程题目 (Problem)
INSERT INTO beginner_logic_problem (id, title, sort_order) VALUES
                                                               (1, 'P1. 打印 1 到 10', 1),
                                                               (2, 'P2. 数组求和', 2);

-- 3b. 题目内容 (Content Blocks)
-- (P1)
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (1, 'DESCRIPTION', 'text', '请使用 `for` 循环，在控制台从 1 打印到 10，每个数字占一行。', NULL, 1),
                                                                                                         (1, 'DESCRIPTION', 'sub-header', '预期输出:', NULL, 2),
                                                                                                         (1, 'DESCRIPTION', 'code', E'1\n2\n3\n4\n5\n6\n7\n8\n9\n10', 'plaintext', 3),
                                                                                                         (1, 'STUB', 'code', E'public class Solution {\n    public static void main(String[] args) {\n        // TODO: 在这里编写你的 for 循环\n        \n    }\n}', 'java', 1);

-- (P2)
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (2, 'DESCRIPTION', 'text', '请编写一个 Java `main` 方法，计算一个整数数组中所有元素的总和并打印出来。', NULL, 1),
                                                                                                         (2, 'DESCRIPTION', 'sub-header', '示例:', NULL, 2),
                                                                                                         (2, 'DESCRIPTION', 'code', E'int[] numbers = {10, 20, 30, 40};\n// 预期输出: 100', 'plaintext', 3),
                                                                                                         (2, 'STUB', 'code', E'public class Solution {\n    public static void main(String[] args) {\n        int[] numbers = {10, 20, 30, 40};\n        int sum = 0;\n\n        // TODO: 在这里编写你的 for 循环来计算 sum\n\n\n        System.out.println(sum);\n    }\n}', 'java', 1);

-- 版本 1.2: (续写) 填充 A 路径 (小白) 的 3-10 关卡
-- (详细填充第 3 关和第 4 关)

-----------------------------------------------------
-- 1. A 路径：学习 (Learn)
-----------------------------------------------------

-- 1a. 大关卡 (Level)
-- (新增 8 个大关卡, 总共 10 关)
INSERT INTO beginner_level (id, title, sort_order) VALUES
                                                       (3, '第3关：条件语句 (If / Switch)', 3),
                                                       (4, '第4关：循环语句 (For / While)', 4),
                                                       (5, '第5关：数组 (Arrays)', 5),
                                                       (6, '第6关：方法 (Methods)', 6),
                                                       (7, '第7关：面向对象 (OOP) - 类和对象', 7),
                                                       (8, '第8关：面向对象 (OOP) - 继承与多态', 8),
                                                       (9, '第9关：常用类 (String, Math)', 9),
                                                       (10, '第10关：集合入门 (ArrayList)', 10);

-- 1b. 小关卡 (Lesson)
-- (第3关: 条件语句)
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (7, '3.1 if 语句', 1, 3),
                                                                  (8, '3.2 else 和 else if', 2, 3),
                                                                  (9, '3.3 switch 语句', 3, 3);
-- (第4关: 循环语句)
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (10, '4.1 for 循环', 1, 4),
                                                                  (11, '4.2 while 循环', 2, 4),
                                                                  (12, '4.3 break 和 continue', 3, 4);

-- 1c. 关卡内容 (Content Blocks)
-- (关卡 3.1 - if 语句)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (7, 'text', '`if` 语句是 Java 中最基本的控制流程语句。它允许你的程序根据一个“条件”是否为 `true` 来决定是否执行某段代码。', NULL, 1),
                                                                                               (7, 'sub-header', '语法', NULL, 2),
                                                                                               (7, 'text', '如果 `()` 中的条件为 `true`，则执行 `{}` 中的代码。', NULL, 3),
                                                                                               (7, 'text', E'```java\nint age = 20;\n\n// 检查 age 是否大于 18\nif (age > 18) {\n    // 如果为 true, 执行这里\n    System.out.println("你已经是成年人了。");\n}\n\n// 这句话总会执行，因为它在 if 语句之外\nSystem.out.println("程序结束。");\n```', NULL, 4);

-- (关卡 3.2 - else 和 else if)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (8, 'text', '`else` 语句必须跟在 `if` 语句之后。它提供了一个“备选”方案：当 `if` 的条件为 `false` 时，执行 `else` 块中的代码。', NULL, 1),
                                                                                               (8, 'sub-header', 'if-else 语法', NULL, 2),
                                                                                               (8, 'text', E'```java\nint temperature = 15;\n\nif (temperature > 25) {\n    System.out.println("今天很热，穿T恤。");\n} else {\n    // if 条件 (temperature > 25) 为 false 时执行这里\n    System.out.println("今天有点凉，穿外套。");\n}\n```', NULL, 3),
                                                                                               (8, 'sub-header', 'if-else if-else 链', NULL, 4),
                                                                                               (8, 'text', '当你需要检查多个条件时，可以使用 `else if`。程序会从上到下检查，一旦找到一个为 `true` 的条件，执行完后就会跳过所有后续的 `else if` 和 `else`。', NULL, 5),
                                                                                               (8, 'text', E'```java\nint score = 85;\n\nif (score >= 90) {\n    System.out.println("优秀 (A)");\n} else if (score >= 80) {\n    // 90 > score >= 80\n    System.out.println("良好 (B)");\n} else if (score >= 60) {\n    // 80 > score >= 60\n    System.out.println("及格 (C)");\n} else {\n    // score < 60\n    System.out.println("不及格 (F)");\n}\n// 将打印 "良好 (B)"\n```', NULL, 6);

-- (关卡 3.3 - switch 语句)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (9, 'text', '`switch` 语句提供了一种更清晰的方式来替代“检查单个变量是否等于多个特定值”的 `if-else if` 链。', NULL, 1),
                                                                                               (9, 'sub-header', '语法 (重要: break)', NULL, 2),
                                                                                               (9, 'text', '`switch` 语句会比较变量 (`dayOfWeek`) 的值和每个 `case` 后的值。匹配成功后，它会执行该 `case` 下的所有代码，直到遇到 `break` 语句才会跳出 `switch`。', NULL, 3),
                                                                                               (9, 'text', E'```java\nint dayOfWeek = 3;\nString dayName;\n\nswitch (dayOfWeek) {\n    case 1:\n        dayName = "星期一";\n        break; // 必须有 break，否则会“穿透”到下一个 case\n    case 2:\n        dayName = "星期二";\n        break;\n    case 3:\n        dayName = "星期三";\n        break; // 匹配成功 (3)，执行代码，遇到 break，跳出 switch\n    case 4:\n        dayName = "星期四";\n        break;\n    case 5:\n        dayName = "星期五";\n        break;\n    case 6:\n    case 7: // 多个 case 可以共享代码块\n        dayName = "周末";\n        break;\n    default: // 如果以上都不匹配，执行 default\n        dayName = "无效的日期";\n        break;\n}\n\nSystem.out.println(dayName); // 打印 "星期三"\n```', NULL, 4);

-- (关卡 4.1 - for 循环)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (10, 'text', '`for` 循环是 Java 中最常用的循环结构。当你“确切知道要循环多少次”时（例如，循环 10 次，或者遍历数组的所有元素），它非常有用。', NULL, 1),
                                                                                               (10, 'sub-header', '语法三要素', NULL, 2),
                                                                                               (10, 'text', E'`for` 循环的 `()` 中包含三个部分，用分号 `;` 隔开：\n1. **初始化 (Initialization)**: 循环开始前执行一次（例如 `int i = 0`）。\n2. **条件 (Condition)**: 每次循环开始前检查（例如 `i < 5`）。如果为 `true`，执行循环体；如果为 `false`，退出循环。\n3. **迭代 (Iteration)**: 每次循环体执行*之后*执行（例如 `i++`）。', NULL, 3),
                                                                                               (10, 'text', E'```java\n// 打印 0, 1, 2, 3, 4\n// 1. 初始化: i = 0\n// 2. 条件: (0 < 5) ? 是, 执行循环体 (打印 0)\n// 3. 迭代: i++ (i 变为 1)\n// 2. 条件: (1 < 5) ? 是, 执行循环体 (打印 1)\n// 3. 迭代: i++ (i 变为 2)\n// ...\n// 2. 条件: (4 < 5) ? 是, 执行循环体 (打印 4)\n// 3. 迭代: i++ (i 变为 5)\n// 2. 条件: (5 < 5) ? 否, 退出循环。\n\nfor (int i = 0; i < 5; i++) {\n    System.out.println(i);\n}\n```', NULL, 4);

-- (关卡 4.2 - while 循环)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (11, 'text', '`while` 循环（“当...时”）用于当你不知道要循环多少次，但知道“循环应该在什么时候停止”的场景。', NULL, 1),
                                                                                               (11, 'sub-header', '语法', NULL, 2),
                                                                                               (11, 'text', '只要 `()` 中的条件为 `true`，`while` 循环就会一直执行 `{}` 中的代码。', NULL, 3),
                                                                                               (11, 'text', E'```java\nint count = 1;\n\n// 只要 count <= 5，就一直循环\nwhile (count <= 5) {\n    System.out.println("Count is: " + count);\n    count++; // (重要!) 必须在循环体内更新条件变量，否则会成为“死循环”！\n}\n// 将依次打印 1, 2, 3, 4, 5\n```', NULL, 4),
                                                                                               (11, 'sub-header', 'do-while 循环 (A)', NULL, 5),
                                                                                               (11, 'text', '`do-while` 循环是 `while` 的一个变体，它保证循环体*至少执行一次*，因为它在循环*末尾*才检查条件。', NULL, 6),
                                                                                               (11, 'text', E'```java\nint x = 100;\n\ndo {\n    System.out.println("即使条件为 false, 我也至少执行一次。");\n} while (x < 10); // 条件 (100 < 10) 为 false, 循环结束。\n```', NULL, 7);

-- (关卡 4.3 - break 和 continue)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (12, 'text', '`break` 和 `continue` 是两个关键字，用于在循环内部提供更精细的控制。', NULL, 1),
                                                                                               (12, 'sub-header', 'break: 立即跳出循环', NULL, 2),
                                                                                               (12, 'text', '`break` 用于完全终止并跳出*整个*循环（`for` 或 `while`）。', NULL, 3),
                                                                                               (12, 'text', E'```java\n// 寻找 1 到 10 之间第一个能被 7 整除的数\nfor (int i = 1; i <= 10; i++) {\n    if (i % 7 == 0) {\n        System.out.println("找到了: " + i);\n        break; // 找到后，立即跳出 for 循环\n    }\n}\n// 打印 "找到了: 7" 后程序结束\n```', NULL, 4),
                                                                                               (12, 'sub-header', 'continue: 跳过本次迭代', NULL, 5),
                                                                                               (12, 'text', '`continue` 用于跳过*当前*迭代中剩余的代码，并立即开始*下一次*迭代。', NULL, 6),
                                                                                               (12, 'text', E'```java\n// 打印 1 到 10 之间的所有奇数\nfor (int i = 1; i <= 10; i++) {\n    if (i % 2 == 0) {\n        // 如果 i 是偶数 (e.g., 2, 4, 6...)\n        continue; // 跳过本次循环中剩下的代码 (System.out.println)\n    }\n    // 只有奇数会执行到这里\n    System.out.println(i);\n}\n// 打印 1, 3, 5, 7, 9\n```', NULL, 7);

-----------------------------------------------------
-- 2. A 路径：测验 (Quiz)
-----------------------------------------------------

-- 2a. 测验章节 (Chapter)
INSERT INTO quiz_chapter (id, title, sort_order) VALUES
                                                     (3, '第3关：条件语句 (测验)', 3),
                                                     (4, '第4关：循环 (测验)', 4);
-- (为 5-10 关创建占位符)
INSERT INTO quiz_chapter (id, title, sort_order) VALUES
                                                     (5, '第5关：数组 (测验)', 5),
                                                     (6, '第6关：方法 (测验)', 6),
                                                     (7, '第7关：OOP (测验)', 7),
                                                     (8, '第8关：OOP (测验)', 8),
                                                     (9, '第9关：常用类 (测验)', 9),
                                                     (10, '第10关：集合 (测验)', 10);

-- 2b. 测验问题 (Question)
-- (第3关)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (7, '当 `if` 条件为 `false` 时，哪个关键字用来执行“备选”代码？', 3),
                                                     (8, '在 `switch` 语句中，哪个关键字用于防止“穿透”到下一个 `case`？', 3),
                                                     (9, '`if (score = 90)` 这行代码最可能是什么问题？', 3);
-- (第4关)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (10, '当你“确切知道要循环 10 次”时，使用哪种循环最好？', 4),
                                                     (11, '在循环中，哪个关键字用于“跳过本次迭代，开始下一次”？', 4),
                                                     (12, '`while(true) { ... }` 会导致什么？', 4);

-- 2c. 测验选项 (Option)
-- (问题 7-9)
INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('A. else if', false, 7), ('B. else', true, 7), ('C. default', false, 7), ('D. case', false, 7),
                                                            ('A. continue', false, 8), ('B. return', false, 8), ('C. break', true, 8), ('D. stop', false, 8),
                                                            ('A. 语法正确，没有问题', false, 9), ('B. 应该是 `if (score == 90)` (比较)', true, 9), ('C. 应该是 `if (score != 90)` (不等)', false, 9), ('D. `score` 必须是布尔值', false, 9);
-- (问题 10-12)
INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('A. for 循环', true, 10), ('B. while 循环', false, 10), ('C. do-while 循环', false, 10), ('D. switch 语句', false, 10),
                                                            ('A. break', false, 11), ('B. continue', true, 11), ('C. skip', false, 11), ('D. next', false, 11),
                                                            ('A. 循环 1 次', false, 12), ('B. 语法错误', false, 12), ('C. 死循环 (Infinite Loop)', true, 12), ('D. 循环 0 次', false, 12);

-----------------------------------------------------
-- 3. A 路径：编程逻辑 (Logic)
-----------------------------------------------------

-- 3a. 编程题目 (Problem)
INSERT INTO beginner_logic_problem (id, title, sort_order) VALUES
                                                               (3, 'P3. 判断奇偶数', 3),
                                                               (4, 'P4. 寻找第一个能被 5 整除的数', 4);
-- (为 5-10 关创建占位符)
INSERT INTO beginner_logic_problem (id, title, sort_order) VALUES
                                                               (5, 'P5. 数组最大值', 5),
                                                               (6, 'P6. 编写求和方法', 6),
                                                               (7, 'P7. 创建你的第一个类 (Dog)', 7),
                                                               (8, 'P8. 模拟动物叫', 8),
                                                               (9, 'P9. 统计字符串长度', 9),
                                                               (10, 'P10. 遍历 ArrayList', 10);

-- 3b. 题目内容 (Content Blocks)
-- (P3)
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (3, 'DESCRIPTION', 'text', '请编写一个 Java `main` 方法，检查变量 `number` 是奇数还是偶数。', NULL, 1),
                                                                                                         (3, 'DESCRIPTION', 'sub-header', '要求:', NULL, 2),
                                                                                                         (3, 'DESCRIPTION', 'text', E'1. 如果 `number` 是偶数 (e.g., 4, 10, 0)，打印 "Even"\n2. 如果 `number` 是奇数 (e.g., 7, 11, -3)，打印 "Odd"', NULL, 3),
                                                                                                         (3, 'DESCRIPTION', 'sub-header', '提示:', NULL, 4),
                                                                                                         (3, 'DESCRIPTION', 'text', '使用取余运算符 `%`。 `number % 2` 在 `number` 是偶数时结果为 0。', NULL, 5),
                                                                                                         (3, 'STUB', 'code', E'public class Solution {\n    public static void main(String[] args) {\n        int number = 7;\n\n        // TODO: 在这里编写 if-else 语句\n        // 检查 number % 2 是否等于 0\n\n    }\n}', 'java', 1);

-- (P4)
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (4, 'DESCRIPTION', 'text', '给定一个整数数组 `numbers`。请使用 `for` 循环遍历该数组，找到*第一个*能被 5 整除的数，打印它，然后*立即停止*循环。', NULL, 1),
                                                                                                         (4, 'DESCRIPTION', 'sub-header', '预期输出:', NULL, 2),
                                                                                                         (4, 'DESCRIPTION', 'text', '对于给定的模板，输出应该是：', NULL, 3),
                                                                                                         (4, 'DESCRIPTION', 'code', E'Found: 25', 'plaintext', 4),
                                                                                                         (4, 'DESCRIPTION', 'sub-header', '提示:', NULL, 5),
                                                                                                         (4, 'DESCRIPTION', 'text', '你需要 `if` (检查 `num % 5 == 0`) 和 `break` (找到后停止)。', NULL, 6),
                                                                                                         (4, 'STUB', 'code', E'public class Solution {\n    public static void main(String[] args) {\n        int[] numbers = {1, 3, 12, 25, 30, 40};\n\n        // TODO: 在这里编写 for 循环遍历 numbers\n        // (可以使用 for-each 循环: for (int num : numbers))\n\n    }\n}', 'java', 1);

-----------------------------------------------------
-- 4. (重要) 更新所有序列号
-- (确保这些值大于你插入的 MAX ID)
-----------------------------------------------------
SELECT setval('beginner_level_id_seq', (SELECT MAX(id) FROM beginner_level));
SELECT setval('beginner_lesson_id_seq', (SELECT MAX(id) FROM beginner_lesson));
SELECT setval('beginner_lesson_content_block_id_seq', (SELECT MAX(id) FROM beginner_lesson_content_block));
SELECT setval('quiz_chapter_id_seq', (SELECT MAX(id) FROM quiz_chapter));
SELECT setval('quiz_question_id_seq', (SELECT MAX(id) FROM quiz_question));
SELECT setval('quiz_option_id_seq', (SELECT MAX(id) FROM quiz_option));
SELECT setval('beginner_logic_problem_id_seq', (SELECT MAX(id) FROM beginner_logic_problem));
SELECT setval('beginner_logic_content_block_id_seq', (SELECT MAX(id) FROM beginner_logic_content_block));