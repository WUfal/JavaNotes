-- 版本 1.3: (续写) 添加 10 个新关卡 (11-20)，并详细填充第 5 关和第 6 关

-----------------------------------------------------
-- 1. A 路径：学习 (Learn)
-----------------------------------------------------

-- 1a. 大关卡 (Level)
-- (新增 10 个新关卡, 11-20)
INSERT INTO beginner_level (id, title, sort_order) VALUES
                                                       (11, '第11关：接口与抽象类', 11),
                                                       (12, '第12关：异常处理 (Try-Catch)', 12),
                                                       (13, '第13关：核心数据结构 (HashMap)', 13),
                                                       (14, '第14关：Java 泛型 (<T>)', 14),
                                                       (15, '第15关：文件与 IO 流', 15),
                                                       (16, '第16关：枚举 (Enums) 与 Final', 16),
                                                       (17, '第17关：Lambda 表达式入门', 17),
                                                       (18, '第18关：基础并发 (Threads)', 18),
                                                       (19, '第19关：Java 集合框架 (Framework)', 19),
                                                       (20, '第20关：后续学习 (Maven/Gradle)', 20);

-- 1b. 小关卡 (Lesson)
-- (第5关: 数组)
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (13, '5.1 什么是数组?', 1, 5),
                                                                  (14, '5.2 遍历数组 (for 循环)', 2, 5),
                                                                  (15, '5.3 增强型 for 循环 (For-Each)', 3, 5);
-- (第6关: 方法)
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (16, '6.1 什么是方法 (Method)?', 1, 6),
                                                                  (17, '6.2 方法参数与返回值', 2, 6),
                                                                  (18, '6.3 方法重载 (Overloading)', 3, 6);

-- 1c. 关卡内容 (Content Blocks)
-- (关卡 5.1 - 什么是数组?)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (13, 'text', '数组 (Array) 是一种“容器”，它可以在一个变量中存储*多个*相同类型的值。', NULL, 1),
                                                                                               (13, 'text', '想象一个鸡蛋盒，它有 12 个位置，每个位置只能放鸡蛋。数组就像这个盒子，它有固定的大小，且只能存储同一种数据类型（如 `int` 或 `String`）。', NULL, 2),
                                                                                               (13, 'sub-header', '声明数组 (方式一：指定大小)', NULL, 3),
                                                                                               (13, 'text', '`new int[5]` 表示创建一个可以存放 5 个 `int` 的数组。', NULL, 4),
                                                                                               (13, 'text', E'```java\n// 声明一个能存放 5 个整数的数组\nint[] scores = new int[5];\n\n// 数组的“索引” (Index) 从 0 开始！\n// 访问和赋值 (第 1 个元素)\nscores[0] = 95;\n// 访问和赋值 (第 5 个元素，索引为 4)\nscores[4] = 88;\n\n// 尝试访问不存在的索引 (scores[5]) 将导致程序崩溃 (ArrayIndexOutOfBoundsException)\n```', NULL, 5),
                                                                                               (13, 'sub-header', '声明数组 (方式二：初始值)', NULL, 6),
                                                                                               (13, 'text', '你也可以在声明时直接用 `{}` 提供所有初始值。', NULL, 7),
                                                                                               (13, 'text', E'```java\n// 声明一个 String 数组并立即初始化\nString[] fruits = {"Apple", "Banana", "Orange"};\n\n// 访问第 2 个元素 (索引为 1)\nSystem.out.println(fruits[1]); // 打印 "Banana"\n```', NULL, 8);

-- (关卡 5.2 - 遍历数组 (for 循环))
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (14, 'text', '“遍历” (Iterate) 指的是访问数组中的每一个元素。最标准的方式是使用 `for` 循环和数组的 `length` 属性。', NULL, 1),
                                                                                               (14, 'sub-header', '`.length` 属性', NULL, 2),
                                                                                               (14, 'text', '`length` 是数组的一个属性 (注意：不是方法，没有 `()`!)，它告诉你数组的总容量。', NULL, 3),
                                                                                               (14, 'text', E'```java\nint[] numbers = {10, 20, 30, 40, 50};\n\n// numbers.length 的值是 5\n// 索引 i 从 0 循环到 4 (因为 i < 5)\nfor (int i = 0; i < numbers.length; i++) {\n    // 依次打印 numbers[0], numbers[1], ..., numbers[4]\n    System.out.println("索引 " + i + " 的值是: " + numbers[i]);\n}\n```', NULL, 4),
                                                                                               (14, 'sub-header', '重要：索引从 0 开始', NULL, 5),
                                                                                               (14, 'text', '一个长度为 5 (`length = 5`) 的数组，其有效的索引范围是 `0` 到 `4`。', NULL, 6);

-- (关卡 5.3 - 增强型 for 循环 (For-Each))
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (15, 'text', 'Java 5 引入了一种更简洁的循环语法，称为“增强型 for 循环”或 “for-each” 循环。', NULL, 1),
                                                                                               (15, 'text', '当你只是想“依次访问”数组中的每个元素，而*不关心*索引 `i` 是多少时，强烈推荐使用它。', NULL, 2),
                                                                                               (15, 'text', E'```java\nString[] fruits = {"Apple", "Banana", "Orange"};\n\n// 语法: for (元素类型 临时变量名 : 数组名)\n// 读作: "对于 (for) 数组 (fruits) 中的 每一个 (each) 字符串 (String) fruit ..."\n\nfor (String fruit : fruits) {\n    // 循环第一次: fruit = "Apple"\n    // 循环第二次: fruit = "Banana"\n    // 循环第三次: fruit = "Orange"\n    System.out.println(fruit);\n}\n```', NULL, 3),
                                                                                               (15, 'sub-header', '局限性', NULL, 4),
                                                                                               (15, 'text', E'1. **只读**: 你不能通过 for-each 循环来*修改*数组中的值（特别是基本类型）。\n2. **没有索引**: 你无法知道当前是第几个元素 (i)。\n3. **只能正向**: 只能从头到尾遍历。', NULL, 5);

-- (关卡 6.1 - 什么是方法?)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (16, 'text', '方法 (Method) 是一段可重复使用的代码块，它被赋予一个名称，以便你可以在需要时“调用”(Call) 它。', NULL, 1),
                                                                                               (16, 'text', '方法是 Java 组织代码的基本单元，它实现了“Don''t Repeat Yourself” (DRY) 原则。', NULL, 2),
                                                                                               (16, 'sub-header', '定义和调用 (void)', NULL, 3),
                                                                                               (16, 'text', '`void` 关键字意味着这个方法“不返回任何结果”，它只是执行一个动作（例如打印到控制台）。', NULL, 4),
                                                                                               (16, 'text', E'```java\npublic class Solution {\n\n    // 1. 定义一个方法，名为 "greet"\n    // public static: 现在保持这个写法，我们稍后解释\n    // void: 它不返回任何值\n    // (): 它不需要任何输入数据\n    public static void greet() {\n        System.out.println("Hello! 欢迎来到方法的世界。");\n        System.out.println("我是一个可重复使用的代码块。");\n    }\n\n    // main 方法也是一个方法！它是程序的入口\n    public static void main(String[] args) {\n        System.out.println("程序开始。");\n\n        // 2. 调用 (Call) greet 方法\n        // 程序会跳转到 greet() { ... }，执行完后再回来\n        greet();\n\n        System.out.println("程序中间。");\n\n        // 我们可以多次调用它！\n        greet();\n\n        System.out.println("程序结束。");\n    }\n}\n```', NULL, 5);

-- (关卡 6.2 - 方法参数与返回值)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (17, 'text', '方法真正的威力在于它们可以接收数据（“参数”）和返回数据（“返回值”）。', NULL, 1),
                                                                                               (17, 'sub-header', '参数 (Parameters) - 传入数据', NULL, 2),
                                                                                               (17, 'text', '参数定义在 `()` 中，它们就像是方法内部的“局部变量”，在方法被调用时接收外部传入的值。', NULL, 3),
                                                                                               (17, 'text', E'```java\n// 定义一个方法，它接受一个 String 类型的参数 "name"\npublic static void greetUser(String name) {\n    System.out.println("Hello, " + name + "!");\n}\n\npublic static void main(String[] args) {\n    // 调用时，我们必须提供一个 String 值\n    greetUser("Java");  // "name" 变量在此时被赋值为 "Java"\n    greetUser("Android"); // "name" 变量在此时被赋值为 "Android"\n}\n// 输出:\n// Hello, Java!\n// Hello, Android!\n```', NULL, 4),
                                                                                               (17, 'sub-header', '返回值 (Return) - 传出数据', NULL, 5),
                                                                                               (17, 'text', '如果你希望方法计算出一个结果并将其“传回”给调用者，你需要：\n1. 将 `void` 替换为实际的返回数据类型 (如 `int`)\n2. 使用 `return` 关键字返回一个该类型的值。', NULL, 6),
                                                                                               (17, 'text', E'```java\n// 这个方法返回一个 int 类型的结果\npublic static int add(int a, int b) {\n    int sum = a + b;\n    return sum; // 返回计算结果\n    // 一旦 return，方法立即结束\n}\n\npublic static void main(String[] args) {\n    // 我们调用 add 方法，并将返回的值存储在 "result" 变量中\n    int result = add(5, 3);\n    \n    System.out.println("5 + 3 = " + result); // 打印 "5 + 3 = 8"\n}\n```', NULL, 7);

-- (关卡 6.3 - 方法重载 (Overloading))
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (18, 'text', '方法重载 (Overloading) 允许你在同一个类中定义多个“同名”的方法，只要它们的“参数列表”不同即可。', NULL, 1),
                                                                                               (18, 'text', '参数列表不同，指的是：\n1. 参数的*数量*不同。\n2. 参数的*类型*不同。\n3. 参数的*顺序*不同 (如果类型不同)。', NULL, 2),
                                                                                               (18, 'text', '注意：重载与“返回值”无关。', NULL, 3),
                                                                                               (18, 'text', E'```java\npublic class Solution {\n\n    // 1. 没有参数\n    public static void printInfo() {\n        System.out.println("没有信息。");\n    }\n\n    // 2. 重载: 1 个 int 参数 (类型不同)\n    public static void printInfo(int age) {\n        System.out.println("年龄: " + age);\n    }\n\n    // 3. 重载: 1 个 String 参数 (类型不同)\n    public static void printInfo(String name) {\n        System.out.println("名字: " + name);\n    }\n\n    // 4. 重载: 2 个参数 (数量不同)\n    public static void printInfo(String name, int age) {\n        System.out.println("名字: " + name + ", 年龄: " + age);\n    }\n\n    public static void main(String[] args) {\n        // Java 会根据你提供的参数，自动匹配正确的方法\n        printInfo();           // 调用 1\n        printInfo("Java");       // 调用 3\n        printInfo(25);           // 调用 2\n        printInfo("Android", 12); // 调用 4\n    }\n}\n```', NULL, 4);

-----------------------------------------------------
-- 2. A 路径：测验 (Quiz)
-----------------------------------------------------

-- 2a. 测验章节 (Chapter)
-- (新增 10 个新章节, 11-20)
INSERT INTO quiz_chapter (id, title, sort_order) VALUES
                                                     (11, '第11关：接口 (测验)', 11),
                                                     (12, '第12关：异常 (测验)', 12),
                                                     (13, '第13关：HashMap (测验)', 13),
                                                     (14, '第14关：泛型 (测验)', 14),
                                                     (15, '第15关：IO (测验)', 15),
                                                     (16, '第16关：Enums (测验)', 16),
                                                     (17, '第17关：Lambda (测验)', 17),
                                                     (18, '第18关：并发 (测验)', 18),
                                                     (19, '第19关：集合框架 (测验)', 19),
                                                     (20, '第20关：下一步 (测验)', 20);

-- 2b. 测验问题 (Question)
-- (第5关 - 数组)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (13, '`int[] scores = new int[10];` 这行代码创建的数组，其最后一个元素的索引是多少？', 5),
                                                     (14, '如何获取一个数组 `arr` 的长度（即它能容纳多少个元素）？', 5),
                                                     (15, '当你只关心元素的值，不关心索引时，最简洁的遍历方式是？', 5),
                                                     (16, '`int[] nums = new int[5];` 在没有赋值的情况下，`nums[0]` 的默认值是什么？', 5);
-- (第6关 - 方法)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (17, '在方法定义中，`void` 关键字代表什么？', 6),
                                                     (18, '在 `public static int add(int a, int b)` 中，`a` 和 `b` 被称为什么？', 6),
                                                     (19, '在同一个类中，定义两个同名但参数列表（类型或数量）不同的方法，这种特性叫什么？', 6);

-- 2c. 测验选项 (Option)
-- (问题 13-16 / 关卡 5)
INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('A. 10', false, 13), ('B. 9', true, 13), ('C. 1', false, 13), ('D. 11', false, 13),
                                                            ('A. arr.size()', false, 14), ('B. arr.length()', false, 14), ('C. arr.length', true, 14), ('D. arr.count', false, 14),
                                                            ('A. `for (int i=0; ...)` 循环', false, 15), ('B. `while` 循环', false, 15), ('C. 增强型 `for-each` 循环', true, 15), ('D. `switch` 语句', false, 15),
                                                            ('A. 0', true, 16), ('B. null', false, 16), ('C. -1', false, 16), ('D. 编译错误', false, 16);
-- (问题 17-19 / 关卡 6)
INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('A. 该方法必须返回一个 void 类型对象', false, 17), ('B. 该方法不需要任何参数', false, 17), ('C. 该方法不返回任何值', true, 17), ('D. 这是一个私有方法', false, 17),
                                                            ('A. 返回值 (Return Values)', false, 18), ('B. 参数 (Parameters)', true, 18), ('C. 变量 (Variables)', false, 18), ('D. 重载 (Overloads)', false, 18),
                                                            ('A. 方法重写 (Overriding)', false, 19), ('B. 方法重载 (Overloading)', true, 19), ('C. 继承 (Inheritance)', false, 19), ('D. 封装 (Encapsulation)', false, 19);

-----------------------------------------------------
-- 3. A 路径：编程逻辑 (Logic)
-----------------------------------------------------

-- 3a. 编程题目 (Problem)
-- (新增 10 个新题目, 11-20)
INSERT INTO beginner_logic_problem (id, title, sort_order) VALUES
                                                               (11, 'P11. 实现一个接口', 11),
                                                               (12, 'P12. 处理数字格式异常', 12),
                                                               (13, 'P13. 统计单词频率 (HashMap)', 13),
                                                               (14, 'P14. 编写泛型方法', 14),
                                                               (15, 'P15. 读取文件内容', 15),
                                                               (16, 'P16. 使用 Enum (Switch)', 16),
                                                               (17, 'P17. 使用 Lambda 排序', 17),
                                                               (18, 'P18. 启动一个新线程', 18),
                                                               (19, 'P19. 遍历 Set 和 Map', 19),
                                                               (20, 'P20. 综合练习', 20);

-- 3b. 题目内容 (Content Blocks)
-- (P5 - 数组最大值)
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (5, 'DESCRIPTION', 'text', '请编写一个 Java `main` 方法，找到给定整数数组 `numbers` 中的最大值并打印出来。', NULL, 1),
                                                                                                         (5, 'DESCRIPTION', 'sub-header', '要求:', NULL, 2),
                                                                                                         (5, 'DESCRIPTION', 'text', '你不能使用任何内置的 `Math.max` 或排序功能，必须使用 `for` 循环来比较。', NULL, 3),
                                                                                                         (5, 'DESCRIPTION', 'sub-header', '提示:', NULL, 4),
                                                                                                         (5, 'DESCRIPTION', 'text', '1. 创建一个变量 `max`，并将其*初始化*为数组的第一个元素 (`numbers[0]`)。\n2. 循环遍历数组（可以从索引 1 开始）。\n3. 在循环中，如果当前元素 `numbers[i]` 大于 `max`，则更新 `max = numbers[i]`。', NULL, 5),
                                                                                                         (5, 'STUB', 'code', E'public class Solution {\n    public static void main(String[] args) {\n        int[] numbers = {4, 1, 9, 3, 10, 2};\n        \n        // TODO: 假设第一个元素是最大的\n        int max = numbers[0];\n\n        // TODO: 在这里编写 for 循环 (从索引 1 开始遍历)\n        // ...\n\n        System.out.println("最大值是: " + max);\n    }\n}', 'java', 1);

-- (P6 - 编写求和方法)
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (6, 'DESCRIPTION', 'text', '这个挑战是练习编写一个可重用的“方法”。', NULL, 1),
                                                                                                         (6, 'DESCRIPTION', 'sub-header', '要求:', NULL, 2),
                                                                                                         (6, 'DESCRIPTION', 'text', '请在 `main` 方法*外部*，但在 `Solution` 类*内部*，编写一个 `public static int add(int a, int b)` 方法。', NULL, 3),
                                                                                                         (6, 'DESCRIPTION', 'text', '这个方法必须接受两个 `int` 类型的参数，并返回它们的和。', NULL, 4),
                                                                                                         (6, 'DESCRIPTION', 'text', '`main` 方法（我们已经为你写好）将调用你的 `add` 方法来测试它。', NULL, 5),
                                                                                                         (6, 'STUB', 'code', E'public class Solution {\n\n    // TODO: 在这里编写你的 public static int add(int a, int b) 方法\n    // 它应该返回 a + b\n    \n\n\n    // --- 不要修改下面的 main 方法 ---\n    public static void main(String[] args) {\n        int result1 = add(5, 10); // 预期 15\n        int result2 = add(-1, 8);  // 预期 7\n        \n        System.out.println("测试 1 (5+10): " + result1);\n        System.out.println("测试 2 (-1+8): " + result2);\n    }\n    // --- 不要修改上面的 main 方法 --- \n}', 'java', 1);

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