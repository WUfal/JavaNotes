-- =====================================================
-- Java 学习路径补全与重构 V1.9.2
-- Part 1: Level 7 - Level 12 (OOP 基础与核心语法)
-- =====================================================

-----------------------------------------------------
-- Level 7: OOP - 类和对象
-----------------------------------------------------
-- 1. 课程小节定义
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (19, '7.1 什么是类与对象?', 1, 7),
                                                                  (20, '7.2 创建你的第一个对象', 2, 7),
                                                                  (21, '7.3 构造方法 (Constructor)', 3, 7);

-- 2. 课程详细内容
-- 7.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (19, 'text', '欢迎来到 Java 最核心的部分：**面向对象编程 (OOP)**。', NULL, 1),
                                                                                               (19, 'sub-header', '蓝图与房子', NULL, 2),
                                                                                               (19, 'text', E'* **类 (Class)**: 是**设计图纸**（蓝图）。它规定了房子有几扇窗、什么颜色，但它本身不能住人。\n* **对象 (Object)**: 是根据图纸盖出来的**真实的房子**（实例）。', NULL, 3),
                                                                                               (19, 'code', E'class Car {\n    String color;\n    int speed;\n    void drive() {\n        System.out.println("车在跑！");\n    }\n}', 'java', 4);

-- 7.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (20, 'text', '有了类之后，我们需要使用 `new` 关键字来创建对象。', NULL, 1),
                                                                                               (20, 'code', E'public class Main {\n    public static void main(String[] args) {\n        // 类名 变量名 = new 类名();\n        Car myCar = new Car();\n        myCar.color = "红色";\n        myCar.drive();\n    }\n}', 'java', 2);

-- 7.3
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (21, 'text', '构造方法 (Constructor) 是一个特殊的“初始化”方法。它在你 `new` 对象的那一瞬间自动被调用。', NULL, 1),
                                                                                               (21, 'text', E'1. 方法名必须与**类名完全一致**。\n2. **不需要**写返回值类型。', NULL, 2),
                                                                                               (21, 'code', E'class Person {\n    String name;\n    // 构造方法\n    Person(String n) {\n        this.name = n;\n    }\n}\n// Person p = new Person("Alice");', 'java', 3);

-- 3. 编程实战 (Logic Problem)
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (7, 'DESCRIPTION', 'text', '请在 `Solution` 类外部定义一个名为 `Dog` 的类，包含 `name` 属性和 `bark()` 方法。在 main 中创建对象并调用。', NULL, 1),
                                                                                                         (7, 'STUB', 'code', E'// TODO: Define class Dog\npublic class Solution {\n    public static void main(String[] args) {\n        // TODO: Create Dog object\n    }\n}', 'java', 1);

-- 4. 测验 (Quiz)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (20, '在 Java 中，哪个关键字用于根据类“创建”一个新的对象实例？', 7),
                                                     (21, '构造方法 (Constructor) 的名称必须满足什么条件？', 7),
                                                     (22, '在类的方法内部，关键字 `this` 代表什么？', 7),
                                                     (91, '`Car c1 = new Car(); Car c2 = c1;` 修改 c1 的属性，c2 会受影响吗？', 7),
                                                     (92, '如果一个类没有定义任何构造方法，Java 会默认提供什么？', 7);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('create', false, 20), ('new', true, 20), ('init', false, 20),
                                                            ('必须以 "init" 开头', false, 21), ('必须与类名完全相同', true, 21),
                                                            ('父类对象', false, 22), ('当前对象本身', true, 22),
                                                            ('不会', false, 91), ('会，因为它们指向内存中同一个对象', true, 91),
                                                            ('一个无参构造方法', true, 92), ('报错', false, 92);


-----------------------------------------------------
-- Level 8: OOP - 继承与多态
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (22, '8.1 继承 (extends)', 1, 8),
                                                                  (23, '8.2 方法重写 (Override)', 2, 8),
                                                                  (24, '8.3 多态 (Polymorphism)', 3, 8);

-- 2. 课程内容
-- 8.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (22, 'text', '继承允许我们创建一个新类，直接拥有现有类的属性和方法。使用 `extends` 关键字。', NULL, 1),
                                                                                               (22, 'code', E'class Animal { void eat() {} }\nclass Dog extends Animal { void bark() {} }\n// Dog 对象既可以 eat() 也可以 bark()', 'java', 2);

-- 8.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (23, 'text', '如果子类觉得父类的方法不够好，可以重新定义它，这叫**方法重写** (Override)。', NULL, 1),
                                                                                               (23, 'code', E'class Cat extends Animal {\n    @Override\n    void eat() {\n        System.out.println("猫吃鱼");\n    }\n}', 'java', 2);

-- 8.3
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (24, 'text', '多态：**父类的引用可以指向子类的对象**。', NULL, 1),
                                                                                               (24, 'code', E'Animal myPet = new Dog();\nmyPet.eat(); // 如果 Dog 重写了 eat，这里执行的是 Dog 的逻辑', 'java', 2);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (8, 'DESCRIPTION', 'text', '定义 `Cat` 类继承 `Animal`，并重写 `makeSound` 方法。', NULL, 1),
                                                                                                         (8, 'STUB', 'code', E'class Animal { void makeSound() { System.out.println("..."); } }\n// TODO: class Cat extends Animal\npublic class Solution { ... }', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (23, '继承使用哪个关键字？', 8),
                                                     (24, '子类重新定义父类方法叫什么？', 8),
                                                     (25, '关于多态，哪项正确？', 8),
                                                     (99, 'Java 中所有类的祖先类是？', 8),
                                                     (100, '子类调用父类构造方法使用哪个关键字？', 8);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('implements', false, 23), ('extends', true, 23),
                                                            ('重载 (Overloading)', false, 24), ('重写 (Overriding)', true, 24),
                                                            ('父类引用可指向子类对象', true, 25), ('子类引用可指向父类对象', false, 25),
                                                            ('Object', true, 99), ('Class', false, 99),
                                                            ('this()', false, 100), ('super()', true, 100);


-----------------------------------------------------
-- Level 9: 常用类 (String & Math)
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (25, '9.1 String 的不可变性', 1, 9),
                                                                  (26, '9.2 String 常用方法', 2, 9),
                                                                  (27, '9.3 Math 类与随机数', 3, 9);

-- 2. 课程内容
-- 9.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (25, 'text', 'String 对象一旦创建，其内容就**不能改变**。修改字符串实际上是创建了新对象。', NULL, 1),
                                                                                               (25, 'code', E'String s = "a";\ns = s + "b"; // 原来的 "a" 还在内存里，s 指向了新的 "ab"', 'java', 2);

-- 9.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (26, 'text', '常用方法：`length()`, `equals()`, `substring()`, `contains()`。注意：比较内容一定要用 `equals`！', NULL, 1);

-- 9.3
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (27, 'text', 'Math 类提供了很多静态工具方法，如 `Math.max()`, `Math.abs()`, `Math.random()`。', NULL, 1);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (9, 'DESCRIPTION', 'text', '计算字符串数组中所有字符串长度的总和。', NULL, 1),
                                                                                                         (9, 'STUB', 'code', E'String[] words = {"Java", "is", "fun"};\n// TODO: loop and sum length', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (26, 'String 是不可变的吗？', 9),
                                                     (27, '比较两个字符串内容是否相同应使用？', 9),
                                                     (107, '`s.toUpperCase()` 会修改原字符串吗？', 9);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('是', true, 26), ('否', false, 26),
                                                            ('==', false, 27), ('.equals()', true, 27),
                                                            ('会', false, 107), ('不会，它返回一个新的字符串', true, 107);


-----------------------------------------------------
-- Level 10: 集合入门 (ArrayList)
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (28, '10.1 为什么需要 ArrayList?', 1, 10),
                                                                  (29, '10.2 增删改查操作', 2, 10),
                                                                  (30, '10.3 包装类 (Integer vs int)', 3, 10);

-- 2. 课程内容
-- 10.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (28, 'text', '普通数组大小固定，`ArrayList` 是**动态数组**，可以自动调整大小。', NULL, 1);

-- 10.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (29, 'code', E'ArrayList<String> list = new ArrayList<>();\nlist.add("A");\nlist.get(0);\nlist.remove(0);\nlist.size();', 'java', 1);

-- 10.3
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (30, 'text', '集合只能存对象。要存 `int`，必须用包装类 `Integer`。Java 会自动拆装箱。', NULL, 1);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (10, 'DESCRIPTION', 'text', '创建 Integer 列表，添加 1, 2, 3，遍历并打印平方。', NULL, 1),
                                                                                                         (10, 'STUB', 'code', E'// TODO: ArrayList<Integer> ...', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (28, 'ArrayList 最大的优势是？', 10),
                                                     (29, '`ArrayList<int>` 是合法的吗？', 10),
                                                     (114, '清空 ArrayList 使用哪个方法？', 10);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('速度快', false, 28), ('动态调整大小', true, 28),
                                                            ('合法', false, 29), ('非法，需用 Integer', true, 29),
                                                            ('delete()', false, 114), ('clear()', true, 114);


-----------------------------------------------------
-- Level 11: 接口与抽象类 (内容严重缺失，已在此补全)
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (31, '11.1 抽象类 (Abstract Class)', 1, 11),
                                                                  (32, '11.2 接口 (Interface)', 2, 11),
                                                                  (33, '11.3 实现多个接口', 3, 11);

-- 2. 课程内容 (NEW CONTENT)
-- 11.1 抽象类
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (31, 'text', '有时候，父类无法确定具体的方法实现。例如 `Animal.makeSound()`，具体是“汪”还是“喵”取决于子类。这时我们可以用 `abstract`。', NULL, 1),
                                                                                               (31, 'text', '1. **抽象方法**：只有声明，没有方法体 `{}`。\n2. **抽象类**：包含抽象方法的类必须是抽象类。**抽象类不能被实例化 (不能 new)**。', NULL, 2),
                                                                                               (31, 'code', E'abstract class Shape {\n    abstract double getArea(); // 子类必须实现我！\n}\n\nclass Circle extends Shape {\n    double getArea() { return 3.14 * r * r; }\n}', 'java', 3);

-- 11.2 接口
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (32, 'text', '接口 (Interface) 是一份“**契约**”。它通常只包含抽象方法（Java 8 后可包含 default 方法）。', NULL, 1),
                                                                                               (32, 'text', '类使用 `implements` 关键字来实现接口，并且**必须实现接口中定义的所有抽象方法**。', NULL, 2),
                                                                                               (32, 'code', E'interface USB {\n    void connect();\n}\nclass Mouse implements USB {\n    public void connect() { System.out.println("Connected"); }\n}', 'java', 3);

-- 11.3 多接口
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (33, 'text', 'Java 不支持多重继承 (extends A, B)，但支持**实现多个接口**。这是 Java 灵活性的关键。', NULL, 1),
                                                                                               (33, 'code', E'class SmartPhone implements Phone, Camera, WiFi {\n    // 必须实现这三个接口的所有方法\n}', 'java', 2);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (11, 'DESCRIPTION', 'text', '定义 `Bird` 类，实现 `Flyable` 接口。', NULL, 1),
                                                                                                         (11, 'STUB', 'code', E'interface Flyable { void fly(); }\n// TODO: class Bird implements Flyable', 'java', 1);

-- 4. 测验 (补充了新题)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (30, '实现接口必须做什么？', 11),
                                                     (31, '一个类可以实现多个接口吗？', 11),
                                                     (121, '抽象类可以被实例化 (new) 吗？', 11),
                                                     (122, '接口中未实现的方法默认是什么修饰符？', 11);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('继承接口', false, 30), ('实现所有抽象方法', true, 30),
                                                            ('可以', true, 31), ('不可以', false, 31),
                                                            ('可以', false, 121), ('不可以', true, 121),
                                                            ('private', false, 122), ('public abstract', true, 122);


-----------------------------------------------------
-- Level 12: 异常处理
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (34, '12.1 什么是异常 (Exception)?', 1, 12),
                                                                  (35, '12.2 try-catch 捕获异常', 2, 12),
                                                                  (36, '12.3 finally 块', 3, 12);

-- 2. 课程内容
-- 12.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (34, 'text', '异常是程序运行中发生的错误。如果不处理，程序会崩溃。常见的有 `NullPointerException`, `ArithmeticException` 等。', NULL, 1);

-- 12.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (35, 'text', '我们使用 `try-catch` 块来捕获并处理异常。', NULL, 1),
                                                                                               (35, 'code', E'try {\n    int a = 10 / 0; // 会抛出异常\n} catch (ArithmeticException e) {\n    System.out.println("不能除以零！");\n}', 'java', 2);

-- 12.3
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (36, 'text', '`finally` 块中的代码，无论是否发生异常，**永远都会执行**。通常用于关闭资源（文件、数据库连接）。', NULL, 1);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (12, 'DESCRIPTION', 'text', '使用 try-catch 捕获除以零的异常。', NULL, 1),
                                                                                                         (12, 'STUB', 'code', E'int a = 10; int b = 0;\n// TODO: try-catch around a/b', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (32, 'try-catch 的作用？', 12),
                                                     (33, '一定会被执行的代码块是？', 12),
                                                     (123, '遇到异常不处理会发生什么？', 12);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('加速', false, 32), ('防止程序崩溃', true, 32),
                                                            ('catch', false, 33), ('finally', true, 33),
                                                            ('自动跳过', false, 123), ('程序终止 (Crash)', true, 123);

-- =====================================================
-- Part 2: Level 13 - Level 16 (进阶数据结构与核心特性)
-- =====================================================

-----------------------------------------------------
-- Level 13: HashMap (键值对)
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (37, '13.1 键值对 (Key-Value) 概念', 1, 13),
                                                                  (38, '13.2 HashMap 常用操作', 2, 13);

-- 2. 课程内容
-- 13.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (37, 'text', '`HashMap` 就像一本字典。你通过一个“**键 (Key)**”来查找对应的“**值 (Value)**”。', NULL, 1),
                                                                                               (37, 'text', '例如：通过学号 (Key) 查找学生姓名 (Value)。**键必须唯一**，但值可以重复。', NULL, 2),
                                                                                               (37, 'code', E'HashMap<String, Integer> prices = new HashMap<>();\nprices.put("Apple", 5);\nprices.put("Banana", 3);', 'java', 3);

-- 13.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (38, 'text', '常用操作：`put`, `get`, `containsKey`, `remove`。', NULL, 1),
                                                                                               (38, 'code', E'// 添加/更新 (如果 Key 存在，会覆盖旧值)\nmap.put("Apple", 10);\n\n// 获取\nInteger p = map.get("Apple"); // 10\n\n// 遍历 (遍历 KeySet)\nfor (String key : map.keySet()) {\n    System.out.println(key + " : " + map.get(key));\n}', 'java', 2);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (13, 'DESCRIPTION', 'text', '统计水果出现的次数。使用 HashMap，如果 Key 存在则值+1，不存在则存入1。', NULL, 1),
                                                                                                         (13, 'STUB', 'code', E'String[] fruits = {"apple", "banana", "apple"};\n// TODO: Use HashMap to count frequency', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (34, '在 HashMap 中放入重复的 Key 会发生什么？', 13),
                                                     (131, 'HashMap 是有序的吗？', 13);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('报错', false, 34), ('覆盖旧值', true, 34),
                                                            ('是', false, 131), ('不是 (无序)', true, 131);


-----------------------------------------------------
-- Level 14: 泛型 (Generics) - 重点修复板块
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (39, '14.1 泛型 (Generics) 初探', 1, 14),
                                                                  (40, '14.2 自定义泛型类', 2, 14);

-- 2. 课程内容 (详细补充)
-- 14.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (39, 'text', '在没有泛型之前，集合里装的都是 `Object`，取出时容易报错。泛型 `<String>` 就像给集合贴了标签，**强制检查类型**。', NULL, 1),
                                                                                               (39, 'code', E'// 没泛型 (危险)\nList list = new ArrayList(); \nlist.add("Hello"); list.add(123);\n// String s = (String) list.get(1); // 运行时崩溃！\n\n// 有泛型 (安全)\nList<String> list2 = new ArrayList<>();\n// list2.add(123); // 编译期就会报错，这就叫类型安全', 'java', 2);

-- 14.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (40, 'text', '你可以定义自己的泛型类。通常用 `T` (Type) 作为占位符。', NULL, 1),
                                                                                               (40, 'code', E'// 定义一个“万能盒子”\npublic class Box<T> {\n    private T item;\n    public void set(T item) { this.item = item; }\n    public T get() { return item; }\n}\n\n// 使用\nBox<String> sBox = new Box<>();\nBox<Integer> iBox = new Box<>();', 'java', 2);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (14, 'DESCRIPTION', 'text', '创建一个简单的泛型类 `Box<T>`，包含 set 和 get 方法。', NULL, 1),
                                                                                                         (14, 'STUB', 'code', E'// TODO: class Box<T> ...', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (35, '`List<String>` 中的 `<String>` 作用是？', 14),
                                                     (141, '泛型 T 必须是？', 14);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('注释', false, 35), ('强制类型检查', true, 35),
                                                            ('基本类型 (int)', false, 141), ('引用类型 (Integer, String...)', true, 141);


-----------------------------------------------------
-- Level 15: IO 流 - 重点修复板块
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (41, '15.1 File 对象与路径', 1, 15),
                                                                  (42, '15.2 读写文本文件', 2, 15);

-- 2. 课程内容
-- 15.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (41, 'text', '`java.io.File` 对象代表文件系统中的路径。注意：**new File() 不会在硬盘创建文件**，它只是内存里的一个对象。', NULL, 1),
                                                                                               (41, 'code', E'File f = new File("C:\\\\data.txt");\nif(f.exists()) { ... }', 'java', 2);

-- 15.2 (推荐 try-with-resources)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (42, 'text', 'IO 操作必须**关闭资源**。Java 7 引入了 `try-with-resources` 语法，能自动关闭文件，非常推荐！', NULL, 1),
                                                                                               (42, 'code', E'// 括号里的资源会自动关闭，不用写 finally\ntry (FileWriter writer = new FileWriter("out.txt")) {\n    writer.write("Hello IO");\n} catch (IOException e) {\n    e.printStackTrace();\n}', 'java', 2);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (15, 'DESCRIPTION', 'text', '使用 FileWriter 将 "Hello" 写入文件。', NULL, 1),
                                                                                                         (15, 'STUB', 'code', E'// TODO: Write to file using try-catch', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (36, 'IO 操作后必须做什么？', 15),
                                                     (151, '`new File("a.txt")` 会立即在硬盘创建文件吗？', 15);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('flush()', false, 36), ('close() (关闭资源)', true, 36),
                                                            ('会', false, 151), ('不会，只是创建内存对象', true, 151);


-----------------------------------------------------
-- Level 16: 枚举与 Final
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (43, '16.1 final 关键字的三种用法', 1, 16),
                                                                  (44, '16.2 枚举类型 (Enum)', 2, 16);

-- 2. 课程内容
-- 16.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (43, 'text', 'Final 意味着“**无法改变**”：\n1. **变量**：常量，不可重新赋值。\n2. **方法**：不可被重写。\n3. **类**：不可被继承。', NULL, 1);

-- 16.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (44, 'text', '当变量的取值是**固定的几个值**（如季节、星期、状态）时，应该使用枚举。', NULL, 1),
                                                                                               (44, 'code', E'enum Level { LOW, MEDIUM, HIGH }\n\nLevel s = Level.MEDIUM;\nif (s == Level.HIGH) { ... }', 'java', 2);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (16, 'DESCRIPTION', 'text', '定义枚举 Level，并使用 switch 语句判断。', NULL, 1),
                                                                                                         (16, 'STUB', 'code', E'// TODO: enum Level\npublic class Solution { ... }', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (37, 'final 修饰的变量意味着？', 16),
                                                     (161, '枚举常用于什么场景？', 16);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('必须静态', false, 37), ('不可修改 (常量)', true, 37),
                                                            ('无限可能的数值', false, 161), ('有限的、固定的选项集合', true, 161);

-- =====================================================
-- Part 3: Level 17 - Level 20 (Java 8+, 多线程, 架构)
-- =====================================================

-----------------------------------------------------
-- Level 17: Lambda 与 Stream (Java 8 新特性)
-----------------------------------------------------
-- 1. 课程小节 (原有+新增)
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (45, '17.1 Lambda 表达式简介', 1, 17),
                                                                  (50, '17.2 函数式接口 (Functional Interface)', 2, 17), -- 新增
                                                                  (51, '17.3 Stream API 初探', 3, 17); -- 新增

-- 2. 课程内容
-- 17.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (45, 'text', 'Lambda 表达式 `(参数) -> { 代码 }` 是匿名内部类的简写，让代码极其简洁。', NULL, 1),
                                                                                               (45, 'code', E'// Old\nnew Thread(new Runnable() { run() { ... } });\n// New\nnew Thread(() -> System.out.println("Go!"));', 'java', 2);

-- 17.2 (New)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (50, 'text', 'Lambda 只能用于**函数式接口**（只有一个抽象方法的接口，如 `Runnable`, `Comparator`）。', NULL, 1);

-- 17.3 (New)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (51, 'text', 'Stream API 允许以声明式方式处理集合。常用操作：`filter` (过滤), `map` (转换), `collect` (收集)。', NULL, 1),
                                                                                               (51, 'code', E'list.stream()\n    .filter(s -> s.length() > 3)\n    .map(s -> s.toUpperCase())\n    .collect(Collectors.toList());', 'java', 2);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (17, 'DESCRIPTION', 'text', '使用 Lambda 对字符串数组按**长度**排序。', NULL, 1),
                                                                                                         (17, 'STUB', 'code', E'String[] arr = {"Bob", "Alice", "Li"};\n// Arrays.sort(arr, (s1, s2) -> ... );', 'java', 1);

-- 4. 测验 (使用你指定的 ID 165+)
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (165, 'Lambda 表达式的语法箭头是？', 17),
                                                     (166, 'Lambda 表达式可以替代什么？', 17),
                                                     (167, '`Stream` 的 `map` 操作主要用于？', 17),
                                                     (168, '`Stream` 的 `filter` 操作主要用于？', 17),
                                                     (170, '以下哪个是函数式接口？', 17);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('->', true, 165), ('=>', false, 165),
                                                            ('匿名内部类', true, 166), ('构造方法', false, 166),
                                                            ('转换元素', true, 167), ('过滤元素', false, 167),
                                                            ('筛选条件', true, 168), ('排序', false, 168),
                                                            ('Runnable', true, 170), ('String', false, 170);


-----------------------------------------------------
-- Level 18: 多线程 (Multithreading)
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (46, '18.1 线程 (Thread) 基础', 1, 18),
                                                                  (52, '18.2 线程安全与 synchronized', 2, 18), -- 新增
                                                                  (53, '18.3 线程的状态与休眠', 3, 18); -- 新增

-- 2. 课程内容
-- 18.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (46, 'text', '创建线程推荐实现 `Runnable` 接口。调用 `start()` 启动线程（如果调用 `run()` 则只是普通方法调用）。', NULL, 1);

-- 18.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (52, 'text', '当多线程修改同一变量时会发生冲突。使用 `synchronized` 关键字加锁保证安全。', NULL, 1),
                                                                                               (52, 'code', E'public synchronized void add() { count++; }', 'java', 2);

-- 18.3
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (53, 'text', '`Thread.sleep(1000)` 可以让线程暂停执行。', NULL, 1);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (18, 'DESCRIPTION', 'text', '创建并启动一个线程，打印 "Running"。', NULL, 1),
                                                                                                         (18, 'STUB', 'code', E'// class MyRunnable implements Runnable ...', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (172, '启动一个线程应该调用哪个方法？', 18),
                                                     (173, '`Thread.sleep()` 会释放锁吗？', 18),
                                                     (175, '什么是死锁 (Deadlock)？', 18),
                                                     (176, '`synchronized` 关键字的作用是？', 18);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('start()', true, 172), ('run()', false, 172),
                                                            ('不会', true, 173), ('会', false, 173),
                                                            ('互相等待资源导致卡死', true, 175), ('线程结束', false, 175),
                                                            ('保证线程安全', true, 176), ('加速', false, 176);


-----------------------------------------------------
-- Level 19: 集合框架进阶 (Set & Collections)
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (47, '19.1 Set 集合 (去重)', 1, 19),
                                                                  (54, '19.2 迭代器 (Iterator)', 2, 19), -- 新增
                                                                  (55, '19.3 Collections 工具类', 3, 19); -- 新增

-- 2. 课程内容
-- 19.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (47, 'text', '`Set` (如 `HashSet`) 的特点是**无序**且**不可重复**。它是去重的最佳选择。', NULL, 1);

-- 19.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (54, 'text', '在遍历中删除元素，必须使用 `Iterator.remove()`，否则会抛出并发修改异常。', NULL, 1);

-- 19.3
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
    (55, 'text', '`Collections` (带s) 是工具类，提供 `sort`, `shuffle` (洗牌), `reverse` 等静态方法。', NULL, 1);

-- 3. 编程实战
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (19, 'DESCRIPTION', 'text', '利用 HashSet 去除数组中的重复元素。', NULL, 1),
                                                                                                         (19, 'STUB', 'code', E'int[] nums = {1, 2, 2, 3};\n// TODO: Use HashSet', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (38, 'Set 集合最显著的特性是？', 19),
                                                     (182, '`Collections.sort()` 默认按什么顺序？', 19),
                                                     (183, 'Iterator 的主要用途是？', 19);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('去重 (Unique)', true, 38), ('有序', false, 38),
                                                            ('升序', true, 182), ('降序', false, 182),
                                                            ('安全遍历并删除', true, 183), ('快速访问', false, 183);


-----------------------------------------------------
-- Level 20: 构建与工具 & 完结
-----------------------------------------------------
-- 1. 课程小节
INSERT INTO beginner_lesson (id, title, sort_order, level_id) VALUES
                                                                  (48, '20.1 Maven 与依赖管理', 1, 20),
                                                                  (49, '20.2 恭喜通关！', 2, 20); -- 完结篇

-- 2. 课程内容
-- 20.1
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (48, 'text', 'Maven 是项目构建工具。核心是 `pom.xml`。', NULL, 1),
                                                                                               (48, 'text', '它能自动管理 **Dependency (依赖)**，你只需要在 xml 中声明你需要什么 jar 包，它就会自动下载。', NULL, 2);

-- 20.2
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (49, 'text', '🎉 **恭喜通关！** 你已经完成了 Java 入门的所有关卡！', NULL, 1),
                                                                                               (49, 'text', '休息一下，准备开始学习 Spring Boot 和企业级开发吧！', NULL, 2);

-- 3. 编程实战 (综合题)
INSERT INTO beginner_logic_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                         (20, 'DESCRIPTION', 'text', '综合练习：创建 Student 类，存入 List，筛选分数及格的学生。', NULL, 1),
                                                                                                         (20, 'STUB', 'code', E'// Final Challenge ...', 'java', 1);

-- 4. 测验
INSERT INTO quiz_question (id, text, chapter_id) VALUES
                                                     (39, 'Maven 主要用来做什么？', 20),
                                                     (186, 'Maven 的核心配置文件是？', 20),
                                                     (190, 'JUnit 是用来做什么的？', 20),
                                                     (191, 'Git 是用来做什么的？', 20);

INSERT INTO quiz_option (text, is_correct, question_id) VALUES
                                                            ('依赖管理与构建', true, 39), ('写代码', false, 39),
                                                            ('pom.xml', true, 186), ('config.xml', false, 186),
                                                            ('单元测试', true, 190), ('部署', false, 190),
                                                            ('版本控制', true, 191), ('编译', false, 191);


-- =====================================================
-- Java 深度补充包 V2.0 (Document Level Detail)
-- 策略：sort_order 从 10 开始，接在原有内容后，提供文档级的详细讲解
-- =====================================================

-----------------------------------------------------
-- Level 7: 类与对象 (深度补充)
-----------------------------------------------------

-- Lesson 7.1: 什么是类与对象? (ID 19)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (19, 'sub-header', '深度解析：类成员 (Class Members)', NULL, 10),
                                                                                               (19, 'text', '一个完整的 Java 类通常包含以下三种成员：\n\n1. **字段 (Fields)**：也称为属性或成员变量，用于存储对象的状态数据。\n2. **方法 (Methods)**：用于描述对象的行为逻辑。\n3. **构造器 (Constructors)**：用于初始化新创建的对象。', NULL, 11),
                                                                                               (19, 'text', '此外，类还可以包含**代码块 (Blocks)** 和 **内部类 (Inner Classes)**，这些将在进阶部分涉及。', NULL, 12),
                                                                                               (19, 'sub-header', '内存视角：栈 (Stack) 与 堆 (Heap)', NULL, 13),
                                                                                               (19, 'text', '理解内存是理解 OOP 的关键：\n\n* **堆 (Heap)**：所有的**对象**（包括数组）都存储在堆内存中。`new Car()` 会在堆中开辟一块空间。\n* **栈 (Stack)**：方法的调用和局部变量存储在栈中。变量 `Car myCar` 实际上存储的是堆中那个对象的**内存地址**（引用）。', NULL, 14);

-- Lesson 7.2: 创建对象 (ID 20)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (20, 'sub-header', '成员变量的默认值', NULL, 10),
                                                                                               (20, 'text', '当你 `new` 一个对象时，如果没给属性赋值，Java 会给它们赋予**默认值**，这与局部变量不同（局部变量不赋值不能用）。', NULL, 11),
                                                                                               (20, 'table', '| 类型 | 默认值 |\n| :--- | :--- |\n| int, byte, short, long | 0 |\n| double, float | 0.0 |\n| boolean | false |\n| String / 对象引用 | null (空) |', NULL, 12),
                                                                                               (20, 'code', E'class Student {\n    int id;\n    boolean isRegistered;\n    String name;\n}\n\nStudent s = new Student();\n// s.id 是 0\n// s.isRegistered 是 false\n// s.name 是 null', 'java', 13),
                                                                                               (20, 'sub-header', '匿名对象 (Anonymous Object)', NULL, 14),
                                                                                               (20, 'text', '如果你只需要使用对象一次，可以不给它起名字，直接使用。这在传参时很常见。', NULL, 15),
                                                                                               (20, 'code', E'// 普通方式\nCar c = new Car();\nc.drive();\n\n// 匿名对象方式 (创建后立刻调用，用完即被垃圾回收)\nnew Car().drive();', 'java', 16);

-- Lesson 7.3: 构造方法 (ID 21)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (21, 'sub-header', 'this 关键字详解', NULL, 10),
                                                                                               (21, 'text', '在构造方法中，`this` 关键字起着至关重要的作用。它指代**当前正在被创建的这个对象**。', NULL, 11),
                                                                                               (21, 'text', '最常见的用法是解决**局部变量与成员变量同名**的问题（遮蔽效应）。', NULL, 12),
                                                                                               (21, 'code', E'class Human {\n    String name;\n\n    Human(String name) {\n        // name = name; // ❌ 错误！这是把参数赋给参数自己，属性没变\n        this.name = name; // ✅ 正确！把参数 name 赋给当前对象的属性 name\n    }\n}', 'java', 13),
                                                                                               (21, 'sub-header', '构造方法重载 (Overloading)', NULL, 14),
                                                                                               (21, 'text', '一个类可以有多个构造方法，只要它们的**参数列表不同**。这允许我们以不同的方式初始化对象。', NULL, 15),
                                                                                               (21, 'code', E'class Phone {\n    String brand;\n    double price;\n\n    // 无参构造 (默认值)\n    Phone() {\n        this.brand = "Unknown";\n        this.price = 0.0;\n    }\n\n    // 全参构造\n    Phone(String brand, double price) {\n        this.brand = brand;\n        this.price = price;\n    }\n}', 'java', 16);


-----------------------------------------------------
-- Level 8: 继承与多态 (深度补充)
-----------------------------------------------------

-- Lesson 8.1: 继承 (ID 22)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (22, 'sub-header', 'Object 类：万物之祖', NULL, 10),
                                                                                               (22, 'text', '在 Java 中，所有的类都直接或间接继承自 `java.lang.Object` 类。即使你没写 `extends`，编译器也会默认加上 `extends Object`。', NULL, 11),
                                                                                               (22, 'text', '这意味着所有对象都拥有 Object 类的方法，例如：\n* `toString()`: 返回对象的字符串表示。\n* `equals()`: 比较对象是否相等。\n* `hashCode()`: 返回对象的哈希码。', NULL, 12),
                                                                                               (22, 'sub-header', 'super 关键字', NULL, 13),
                                                                                               (22, 'text', '`super` 代表父类的引用。它有两个主要用法：\n1. **调用父类成员**：`super.method()` 或 `super.field`。\n2. **调用父类构造器**：`super()`。注意：**子类构造器的第一行代码默认都是 `super()`**，以确保父类先完成初始化。', NULL, 14);

-- Lesson 8.3: 多态 (ID 24)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (24, 'sub-header', 'instanceof 关键字', NULL, 10),
                                                                                               (24, 'text', '在使用多态时，我们有时需要知道一个引用变量到底指向什么类型的实例。这时可以使用 `instanceof`。', NULL, 11),
                                                                                               (24, 'code', E'Animal a = new Dog();\n\nif (a instanceof Dog) {\n    System.out.println("它是一只狗");\n    // 向下转型 (Downcasting) 安全转换\n    Dog d = (Dog) a;\n    d.bark();\n} else if (a instanceof Cat) {\n    System.out.println("它是一只猫");\n}', 'java', 12),
                                                                                               (24, 'sub-header', '多态的实际应用场景', NULL, 13),
                                                                                               (24, 'text', '假设你在写一个支付系统。你定义一个父类 `Payment`，子类有 `WeChatPay`, `AliPay`, `CreditCard`。\n\n你可以写一个方法 `process(Payment p)`。无论用户选择哪种支付方式，你只需要把对象传进去，系统自动调用对应的支付逻辑。这就是**开闭原则 (Open-Closed Principle)** 的基础。', NULL, 14);


-----------------------------------------------------
-- Level 9: 常用类 (深度补充)
-----------------------------------------------------

-- Lesson 9.1: String (ID 25)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (25, 'sub-header', '字符串常量池 (String Pool)', NULL, 10),
                                                                                               (25, 'text', '为了优化内存，Java 在堆中维护了一个特殊的区域叫“字符串常量池”。', NULL, 11),
                                                                                               (25, 'code', E'String s1 = "Java";\nString s2 = "Java";\n// s1 和 s2 指向内存中的同一个对象！\nSystem.out.println(s1 == s2); // true\n\nString s3 = new String("Java");\n// s3 强制在堆中创建新对象，不走常量池\nSystem.out.println(s1 == s3); // false', 'java', 12),
                                                                                               (25, 'sub-header', 'StringBuilder 与 StringBuffer', NULL, 13),
                                                                                               (25, 'text', '由于 String 不可变，如果你在循环中频繁拼接字符串（`s = s + "a"`），会产生大量垃圾对象，严重拖慢程序。', NULL, 14),
                                                                                               (25, 'text', '此时应使用 `StringBuilder` (非线程安全，快) 或 `StringBuffer` (线程安全，稍慢)。它们的内容是**可变**的。', NULL, 15),
                                                                                               (25, 'code', E'StringBuilder sb = new StringBuilder();\nfor (int i = 0; i < 100; i++) {\n    sb.append(i).append(",");\n}\nString result = sb.toString();', 'java', 16);


-----------------------------------------------------
-- Level 10: ArrayList (深度补充)
-----------------------------------------------------

-- Lesson 10.2: 操作 (ID 29)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (29, 'sub-header', '底层原理：动态扩容', NULL, 10),
                                                                                               (29, 'text', '`ArrayList` 的底层其实就是一个 `Object[]` 数组。', NULL, 11),
                                                                                               (29, 'text', '1. **初始化**：默认创建一个容量为 10 的空数组。\n2. **扩容**：当你添加到第 11 个元素时，Java 会自动创建一个新的、更大的数组（通常是原大小的 1.5 倍），然后把旧数据**复制**过去。\n3. **代价**：扩容操作是比较耗时的。如果你预先知道大概有多少数据，建议在构造时指定容量：`new ArrayList<>(1000)`。', NULL, 12),
                                                                                               (29, 'sub-header', '常用批量操作', NULL, 13),
                                                                                               (29, 'code', E'ArrayList<String> list1 = new ArrayList<>();\nArrayList<String> list2 = new ArrayList<>();\n\n// addAll: 将 list2 所有元素加入 list1\nlist1.addAll(list2);\n\n// contains: 检查是否存在\nboolean hasApple = list1.contains("Apple");\n\n// toArray: 转换为数组\nObject[] arr = list1.toArray();', 'java', 14);


-----------------------------------------------------
-- Level 11: 接口与抽象类 (深度补充)
-----------------------------------------------------

-- Lesson 11.2: 接口 (ID 32)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (32, 'sub-header', '接口中的成员特点', NULL, 10),
                                                                                               (32, 'text', '接口中的成员有极其严格的隐式规定：', NULL, 11),
                                                                                               (32, 'text', '1. **成员变量**：默认全都是 `public static final` (即常量)。你不能在接口里定义普通变量。\n2. **成员方法**：默认全都是 `public abstract` (抽象方法)。', NULL, 12),
                                                                                               (32, 'code', E'interface Config {\n    int TIMEOUT = 5000; // 等同于 public static final int TIMEOUT = 5000;\n    \n    void save(); // 等同于 public abstract void save();\n}', 'java', 13);

-- Lesson 11.3: 高级特性 (ID 33)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (33, 'sub-header', '抽象类 vs 接口：如何选择？', NULL, 10),
                                                                                               (33, 'table', '| 特性 | 抽象类 (Abstract Class) | 接口 (Interface) |\n| :--- | :--- | :--- |\n| 继承关系 | 单继承 (extends) | 多实现 (implements) |\n| 成员变量 | 可以有各种变量 | 只能是常量 |\n| 构造方法 | 可以有 (用于子类super调用) | **没有** |\n| 设计目的 | "Is-a" (它是什么)，代码复用 | "Has-a" (它能做什么)，功能扩展 |', NULL, 11),
                                                                                               (33, 'sub-header', 'Java 8 static 方法', NULL, 12),
                                                                                               (33, 'text', 'Java 8 以后，接口中除了可以写 `default` 方法，还可以写 `static` 方法。这使得接口可以像工具类一样使用。', NULL, 13);


-----------------------------------------------------
-- Level 12: 异常 (深度补充)
-----------------------------------------------------

-- Lesson 12.1: 异常体系 (ID 34)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (34, 'sub-header', 'Throwable 继承树', NULL, 10),
                                                                                               (34, 'text', 'Java 中所有错误和异常的父类是 `java.lang.Throwable`。它有两个大子类：', NULL, 11),
                                                                                               (34, 'text', '1. **Error**: 严重的系统级错误（如 `OutOfMemoryError` 内存溢出，`StackOverflowError` 栈溢出）。程序通常无法恢复，**不建议捕获**。\n2. **Exception**: 程序可以处理的异常。分为受检（Checked）和非受检（Runtime）。', NULL, 12);

-- Lesson 12.2: 处理机制 (ID 35)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (35, 'sub-header', 'throw vs throws', NULL, 10),
                                                                                               (35, 'text', '这也是容易混淆的概念：\n* **throw**: 动作。用在方法体内，**抛出**一个异常对象。`throw new Exception("出错了");`\n* **throws**: 声明。用在方法签名上，告诉调用者“我可能会抛出这些异常，你要小心”。', NULL, 11),
                                                                                               (35, 'code', E'// 定义方法时声明可能出错\npublic void readFile(String path) throws IOException {\n    if (path == null) {\n        throw new IOException("路径为空"); // 实际抛出\n    }\n}', 'java', 12),
                                                                                               (35, 'sub-header', '自定义异常', NULL, 13),
                                                                                               (35, 'text', '你可以通过继承 `Exception` 或 `RuntimeException` 来创建自己的异常类，以便更清晰地描述业务错误。', NULL, 14);


-----------------------------------------------------
-- Level 13: HashMap (深度补充)
-----------------------------------------------------

-- Lesson 13.1: 原理 (ID 37)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (37, 'sub-header', '哈希表工作原理 (简化版)', NULL, 10),
                                                                                               (37, 'text', 'HashMap 内部维护了一个数组（桶）。\n1. 当你 `put(key, value)` 时，Java 计算 `key` 的 `hashCode()`。\n2. 根据 Hash 值算出数组下标。\n3. 如果那个位置已经有数据了（**哈希冲突**），Java 会使用链表或红黑树将新数据挂在后面。', NULL, 11),
                                                                                               (37, 'text', '因此，作为 Key 的对象，必须正确重写 `hashCode()` 和 `equals()` 方法，否则会导致存进去的数据取不出来。', NULL, 12);


-----------------------------------------------------
-- Level 14: 泛型 (深度补充)
-----------------------------------------------------

-- Lesson 14.1: 泛型深入 (ID 39)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (39, 'sub-header', '类型擦除 (Type Erasure)', NULL, 10),
                                                                                               (39, 'text', 'Java 的泛型是**伪泛型**。在编译后的 `.class` 文件中，所有的 `<String>`、`<Integer>` 都会消失，变回 `Object`。', NULL, 11),
                                                                                               (39, 'text', '泛型只是给编译器看的，用来确保你在写代码时不会把 Integer 放进 String 列表里。这也是为什么你不能 `new T()` 的原因，因为运行时根本不知道 T 是什么。', NULL, 12);

-- Lesson 14.2: 通配符 (ID 40)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (40, 'sub-header', '通配符 (?)', NULL, 10),
                                                                                               (40, 'text', '有时候我们想接收任何类型的泛型列表，可以使用通配符 `?`。', NULL, 11),
                                                                                               (40, 'code', E'// 可以接收 List<String>, List<Integer> 等\npublic void printList(List<?> list) {\n    for (Object obj : list) {\n        System.out.println(obj);\n    }\n}\n\n// 上界通配符: 只接收 Number 及其子类 (Integer, Double)\npublic void sum(List<? extends Number> nums) { ... }', 'java', 12);


-----------------------------------------------------
-- Level 15: IO 流 (深度补充)
-----------------------------------------------------

-- Lesson 15.2: 高级 IO (ID 42)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (42, 'sub-header', '缓冲流 (Buffered IO)', NULL, 10),
                                                                                               (42, 'text', '普通的 `FileReader` 每次读取一个字符都要访问硬盘，效率极低。**缓冲流** (`BufferedReader`) 会一次性读取一大块数据到内存（缓冲区），下次读取直接从内存拿，速度提升几十倍。', NULL, 11),
                                                                                               (42, 'code', E'try (BufferedReader br = new BufferedReader(new FileReader("large.txt"))) {\n    String line;\n    // 一次读一行，非常方便\n    while ((line = br.readLine()) != null) {\n        System.out.println(line);\n    }\n} catch (IOException e) { ... }', 'java', 12),
                                                                                               (42, 'sub-header', 'Java NIO (Files 工具类)', NULL, 13),
                                                                                               (42, 'text', 'Java 7 引入了 `java.nio.file.Files` 工具类，让文件操作变得像 Python 一样简单。', NULL, 14),
                                                                                               (42, 'code', E'Path path = Paths.get("data.txt");\n// 一行代码读取所有内容\nList<String> lines = Files.readAllLines(path);\n// 一行代码写入\nFiles.write(path, "New Content".getBytes());', 'java', 15);


-----------------------------------------------------
-- Level 16: 进阶 (深度补充)
-----------------------------------------------------

-- Lesson 16.2: 枚举进阶 (ID 44)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (44, 'sub-header', '枚举的高级用法', NULL, 10),
                                                                                               (44, 'text', '枚举不仅仅是常量列表，它**本质上是类**。你可以给枚举添加属性、构造方法和普通方法。', NULL, 11),
                                                                                               (44, 'code', E'enum Status {\n    SUCCESS(200, "成功"),\n    ERROR(500, "服务器错误");\n\n    private int code;\n    private String msg;\n\n    // 构造方法默认是 private\n    Status(int code, String msg) {\n        this.code = code;\n        this.msg = msg;\n    }\n\n    public int getCode() { return code; }\n}\n\n// 使用\nint c = Status.SUCCESS.getCode(); // 200', 'java', 12);

-----------------------------------------------------
-- Level 20: 构建工具 (深度补充)
-----------------------------------------------------

-- Lesson 20.1: Maven (ID 48)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (48, 'sub-header', 'Maven 依赖范围 (Scope)', NULL, 10),
                                                                                               (48, 'text', '在 `pom.xml` 中，你经常会看到 `<scope>` 标签。它决定了 jar 包在什么时候有效：', NULL, 11),
                                                                                               (48, 'text', '* **compile** (默认): 编译、测试、运行都有效（如 Spring Core）。\n* **test**: 只在测试时有效，打包发布时不会带上（如 JUnit）。\n* **provided**: 编译时有效，但运行时由服务器提供（如 Servlet API）。', NULL, 12),
                                                                                               (48, 'sub-header', 'Maven 仓库', NULL, 13),
                                                                                               (48, 'text', 'Maven 下载 Jar 包的顺序：\n1. **本地仓库** (`.m2` 文件夹)：看电脑上有没有。\n2. **中央仓库** (Central Repository)：去互联网下载。\n3. **镜像仓库** (Mirror)：国内通常配置阿里云镜像加速下载。', NULL, 14);

-- =====================================================
-- Java 专家级补充包 V2.2 (Expert Level Detail)
-- 针对 Level 7 - 16 进行第三轮内容扩充
-- sort_order 从 20 开始，接在所有现有内容最后
-- =====================================================

-----------------------------------------------------
-- Level 7: 类与对象 (专家补充)
-- 重点：封装性、JavaBean 标准、Static 详解
-----------------------------------------------------

-- Lesson 7.1: 封装与访问控制 (ID 19)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (19, 'sub-header', '封装 (Encapsulation) 与 JavaBean', NULL, 20),
                                                                                               (19, 'text', '在企业开发中，**绝对不建议**直接将属性设为 `public`。你应该将它们设为 `private`，然后通过 `public` 的 getter/setter 方法来访问。', NULL, 21),
                                                                                               (19, 'text', '这样做的好处是：你可以在 set 方法中加入逻辑控制（比如年龄不能小于 0），从而保护数据的安全性。符合这种规范的类被称为 **JavaBean**。', NULL, 22),
                                                                                               (19, 'code', E'public class User {\n    private int age;\n\n    // Getter\n    public int getAge() {\n        return age;\n    }\n\n    // Setter\n    public void setAge(int age) {\n        if (age < 0) {\n            System.out.println("年龄不合法");\n            return;\n        }\n        this.age = age;\n    }\n}', 'java', 23);

-- Lesson 7.2: Static 关键字 (ID 20)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (20, 'sub-header', 'Static: 类变量 vs 实例变量', NULL, 20),
                                                                                               (20, 'text', '`static` 修饰的成员属于**类本身**，而不是属于某个对象。', NULL, 21),
                                                                                               (20, 'text', '1. **内存只有一份**：所有对象共享同一个 static 变量。如果一个对象改了它，所有对象看到的都变了。\n2. **优先加载**：static 成员随着类的加载而加载，比对象创建得更早。所以，**静态方法中不能使用 `this` 关键字**（因为那时候对象还没生出来）。', NULL, 22),
                                                                                               (20, 'code', E'class Earth {\n    static long population; // 全人类共享这一个人口计数\n}\n\nEarth.population = 7000000000L; // 直接用类名访问，不需要 new Earth()', 'java', 23);

-----------------------------------------------------
-- Level 8: 继承与多态 (专家补充)
-- 重点：Object 类深度剖析、Equals 契约
-----------------------------------------------------

-- Lesson 8.1: Object 类方法 (ID 22)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (22, 'sub-header', '深度剖析 toString()', NULL, 20),
                                                                                               (22, 'text', '为什么直接打印对象 `System.out.println(p)` 会输出像 `Person@15db9742` 这样的乱码？', NULL, 21),
                                                                                               (22, 'text', '因为 `Object` 类默认的 `toString()` 实现就是：`类名 + @ + 哈希值的16进制`。如果你想打印出人话（如 `Person{name="Bob"}`），你**必须重写** `toString()` 方法。', NULL, 22),
                                                                                               (22, 'code', E'@Override\npublic String toString() {\n    return "Person{name=" + name + "}";\n}', 'java', 23);

-- Lesson 8.3: == 与 equals (ID 24)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (24, 'sub-header', '面试必考：== 和 equals 的本质区别', NULL, 20),
                                                                                               (24, 'text', '这是 Java 初学者最大的坑：', NULL, 21),
                                                                                               (24, 'table', '| 比较方式 | 基本类型 (int, char) | 引用类型 (String, Object) |\n| :--- | :--- | :--- |\n| **==** | 比较数值 (1==1) | **比较内存地址** (是不是同一个对象) |\n| **equals()** | 不适用 | 默认比地址，但**通常被重写**用来比较内容 |', NULL, 22),
                                                                                               (24, 'text', '结论：比较对象内容（尤其是 String），永远用 `equals()`。', NULL, 23);

-----------------------------------------------------
-- Level 9: 常用类 (专家补充)
-- 重点：格式化输出、类型转换
-----------------------------------------------------

-- Lesson 9.2: 格式化与转换 (ID 26)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (26, 'sub-header', 'String.format 格式化', NULL, 20),
                                                                                               (26, 'text', '不想用 `+` 号拼接一长串字符串？使用 `String.format`（类似 C 语言的 printf）。', NULL, 21),
                                                                                               (26, 'code', E'String name = "Alice";\ndouble price = 12.5678;\n// %s=字符串, %.2f=保留两位小数\nString s = String.format("用户 %s 消费了 %.2f 元", name, price);\n// 输出: 用户 Alice 消费了 12.57 元', 'java', 22),
                                                                                               (26, 'sub-header', '类型转换黑魔法', NULL, 23),
                                                                                               (26, 'text', '1. **String 转 int**: `Integer.parseInt("123")`。注意：如果字符串不是数字，会爆 `NumberFormatException`。\n2. **int 转 String**: `String.valueOf(123)` 或 `123 + ""`（最快写法）。', NULL, 24);

-----------------------------------------------------
-- Level 10: ArrayList (专家补充)
-- 重点：Fail-Fast 机制、Arrays 工具坑
-----------------------------------------------------

-- Lesson 10.2: 进阶操作 (ID 29)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (29, 'sub-header', 'Arrays.asList 的坑', NULL, 20),
                                                                                               (29, 'text', '我们常用 `Arrays.asList("A", "B")` 快速创建列表。但是！这个列表是**固定大小**的。如果你对它调用 `add()` 或 `remove()`，会直接报错 `UnsupportedOperationException`。', NULL, 21),
                                                                                               (29, 'text', '如果你想得到一个可修改的列表，需要多包一层：', NULL, 22),
                                                                                               (29, 'code', E'// 正确的可修改列表创建方式\nList<String> list = new ArrayList<>(Arrays.asList("A", "B"));', 'java', 23);

-----------------------------------------------------
-- Level 12: 异常 (专家补充)
-- 重点：Multi-catch、异常屏蔽
-----------------------------------------------------

-- Lesson 12.2: 异常进阶 (ID 35)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (35, 'sub-header', 'Multi-catch (Java 7+)', NULL, 20),
                                                                                               (35, 'text', '如果你的 try 块可能抛出多种异常，但处理逻辑是一样的，可以用 `|` 合并捕获，让代码更简洁。', NULL, 21),
                                                                                               (35, 'code', E'try {\n    process();\n} catch (IOException | SQLException e) {\n    // 统一记录日志\n    logger.error("数据库或文件错误", e);\n}', 'java', 22),
                                                                                               (35, 'sub-header', '最佳实践', NULL, 23),
                                                                                               (35, 'text', '1. **不要捕获 Exception**：尽量捕获具体的异常（如 `FileNotFoundException`），否则会把潜在的 Bug（如空指针）也吞掉。\n2. **不要吞掉异常**：catch 块里至少要打印 `e.printStackTrace()`，什么都不写是犯罪。', NULL, 24);

-----------------------------------------------------
-- Level 13: HashMap (专家补充)
-- 重点：红黑树、扩容因子
-----------------------------------------------------

-- Lesson 13.1: 底层结构演进 (ID 37)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (37, 'sub-header', '面试核弹：红黑树 (Java 8)', NULL, 20),
                                                                                               (37, 'text', '在 Java 7 以前，HashMap 是“数组 + 链表”。如果哈希冲突严重，链表会很长，查找性能从 O(1) 退化成 O(n)。', NULL, 21),
                                                                                               (37, 'text', '从 Java 8 开始，**当链表长度超过 8** 时，链表会自动进化成 **红黑树 (Red-Black Tree)**。红黑树的查找性能是 O(log n)，极其稳定。这是为了防止哈希碰撞攻击。', NULL, 22),
                                                                                               (37, 'sub-header', '加载因子 (Load Factor)', NULL, 23),
                                                                                               (37, 'text', 'HashMap 默认的加载因子是 **0.75**。意思是：当容量使用了 75% 时，它就会自动扩容（容量翻倍）。这是在“空间”和“时间”之间取得的黄金平衡点。', NULL, 24);

-----------------------------------------------------
-- Level 14: 泛型 (专家补充)
-- 重点：泛型方法、上下界
-----------------------------------------------------

-- Lesson 14.2: 泛型进阶 (ID 40)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (40, 'sub-header', '泛型方法', NULL, 20),
                                                                                               (40, 'text', '不仅仅类可以是泛型的，方法也可以。泛型方法的 `<T>` 要放在返回值前面。', NULL, 21),
                                                                                               (40, 'code', E'public <T> void printArray(T[] arr) {\n    for (T t : arr) System.out.print(t);\n}', 'java', 22),
                                                                                               (40, 'sub-header', 'PECS 原则', NULL, 23),
                                                                                               (40, 'text', '记住通配符的黄金法则：**PECS (Producer Extends, Consumer Super)**。\n* 如果你需要从集合**读取**数据（生产者），用 `? extends T`。\n* 如果你需要往集合**写入**数据（消费者），用 `? super T`。', NULL, 24);

-----------------------------------------------------
-- Level 15: IO 流 (专家补充)
-- 重点：序列化、NIO
-----------------------------------------------------

-- Lesson 15.2: 序列化 (ID 42)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (42, 'sub-header', '对象序列化 (Serialization)', NULL, 20),
                                                                                               (42, 'text', '序列化是将内存中的**对象**变成**二进制流**的过程，这样才能把对象保存到硬盘或通过网络传输。', NULL, 21),
                                                                                               (42, 'text', '1. 类必须实现 `java.io.Serializable` 接口（这只是个标记，里面没方法）。\n2. 使用 `ObjectOutputStream` 写入，`ObjectInputStream` 读取。', NULL, 22),
                                                                                               (42, 'sub-header', 'transient 关键字', NULL, 23),
                                                                                               (42, 'text', '如果不希望某个属性被序列化（比如密码 sensitiveData），可以用 `transient` 关键字修饰。序列化时该属性会被忽略。', NULL, 24);

-----------------------------------------------------
-- Level 16: Final/Enum (专家补充)
-- 重点：单例模式、内部类
-----------------------------------------------------

-- Lesson 16.2: 设计模式 (ID 44)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (44, 'sub-header', 'Enum 实现单例模式 (Singleton)', NULL, 20),
                                                                                               (44, 'text', '《Effective Java》推荐：**枚举是实现单例模式最好的方式**。它天生线程安全，且能防止反序列化破坏单例。', NULL, 21),
                                                                                               (44, 'code', E'public enum DataSource {\n    INSTANCE;\n    \n    public void connect() {\n        System.out.println("数据库连接中...");\n    }\n}\n// 调用: DataSource.INSTANCE.connect();', 'java', 22);

-- (补充 ID 43 Final 的一点内容)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (43, 'sub-header', '匿名内部类 (Anonymous Inner Class)', NULL, 20),
                                                                                               (43, 'text', '在 Lambda 出现之前，我们常用匿名内部类来实现接口。注意：匿名内部类中使用的外部局部变量，必须是 **final** 的（或者隐式 final，即赋值后不再修改）。', NULL, 21);

-- =====================================================
-- Java 深度补充包 V2.1 (Advanced Topics Deep Dive)
-- 针对 Level 17, 18, 19 进行文档级内容扩充
-- sort_order 从 10 开始，无缝衔接原有内容
-- =====================================================

-----------------------------------------------------
-- Level 17: Lambda 与 Stream (深度补充)
-- 重点：函数式编程思想、Stream 惰性求值、Optional
-----------------------------------------------------

-- Lesson 17.1: Lambda 表达式 (ID 45)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (45, 'sub-header', '四大内置函数式接口', NULL, 10),
                                                                                               (45, 'text', 'Java 8 在 `java.util.function` 包下提供了四个核心接口，你是必须要背下来的，因为 Stream 全靠它们支撑：', NULL, 11),
                                                                                               (45, 'text', '1. **Consumer<T> (消费型)**: 有参数，无返回值。`void accept(T t)`。\n   * 用途：打印、写入数据库。\n2. **Supplier<T> (供给型)**: 无参数，有返回值。`T get()`。\n   * 用途：工厂模式、生成随机数。\n3. **Function<T, R> (函数型)**: 有参数，有返回值。`R apply(T t)`。\n   * 用途：类型转换 (如 String 转 Integer)。\n4. **Predicate<T> (断言型)**: 有参数，返回 boolean。`boolean test(T t)`。\n   * 用途：过滤、条件判断。', NULL, 12),
                                                                                               (45, 'code', E'// 示例：Predicate 判断字符串是否为空\nPredicate<String> isNotEmpty = s -> s != null && !s.isEmpty();\nSystem.out.println(isNotEmpty.test("Java")); // true', 'java', 13);

-- Lesson 17.3: Stream API (ID 51)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (51, 'sub-header', 'Stream 的流水线原理', NULL, 10),
                                                                                               (51, 'text', 'Stream 操作分为两类：\n\n1. **中间操作 (Intermediate)**: 如 `filter`, `map`, `sorted`。它们是**惰性 (Lazy)** 的。如果你不调用终止操作，中间操作**一行代码都不会执行**！\n2. **终止操作 (Terminal)**: 如 `collect`, `forEach`, `count`。只有调用了它，流水线才会真正启动。', NULL, 11),
                                                                                               (51, 'sub-header', 'Optional 类：告别 NullPointerException', NULL, 12),
                                                                                               (51, 'text', 'Stream 的某些操作（如 `findFirst`）可能找不到元素。Java 8 引入了 `Optional<T>` 容器来优雅地处理空值。', NULL, 13),
                                                                                               (51, 'code', E'// 以前的写法\n// if (user != null) { System.out.println(user.getName()); }\n\n// Optional 写法\nOptional<String> opt = Optional.ofNullable(null);\n// 如果存在就打印，不存在就用默认值 "Guest"\nString name = opt.orElse("Guest");', 'java', 14);


-----------------------------------------------------
-- Level 18: 多线程 (深度补充)
-- 重点：线程生命周期、线程池、死锁、Volatile
-----------------------------------------------------

-- Lesson 18.1: 线程基础 (ID 46)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (46, 'sub-header', '线程的生命周期 (Lifecycle)', NULL, 10),
                                                                                               (46, 'text', '线程不仅仅是“运行”和“停止”，它有 6 种状态：\n\n1. **NEW**: 新建了线程对象，但还没调 start()。\n2. **RUNNABLE**: 正在运行，或者正在排队等待 CPU 时间片。\n3. **BLOCKED**: 阻塞。正在等待锁 (synchronized)。\n4. **WAITING**: 无限期等待。等待其他线程唤醒 (notify)。\n5. **TIMED_WAITING**: 限时等待 (sleep)。\n6. **TERMINATED**: 结束。任务执行完毕。', NULL, 11),
                                                                                               (46, 'sub-header', '为什么不建议显式创建 Thread？', NULL, 12),
                                                                                               (46, 'text', '在实际开发中，**严禁**直接 `new Thread()`。因为线程的创建和销毁非常消耗资源。如果并发量大，系统会直接卡死。应使用**线程池 (Thread Pool)**。', NULL, 13);

-- Lesson 18.2: 线程安全 (ID 52)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (52, 'sub-header', '死锁 (Deadlock)', NULL, 10),
                                                                                               (52, 'text', '当线程 A 拿着锁 1 等锁 2，而线程 B 拿着锁 2 等锁 1 时，程序就会永远卡住，这就是死锁。', NULL, 11),
                                                                                               (52, 'sub-header', 'volatile 关键字', NULL, 12),
                                                                                               (52, 'text', '`synchronized` 既保证原子性又保证可见性，但比较重。`volatile` 是轻量级的，它**只保证可见性**（一个线程修改了变量，其他线程立刻能看见），但**不保证原子性**。适用于状态标记量。', NULL, 13),
                                                                                               (52, 'code', E'private volatile boolean running = true;\n\npublic void stop() {\n    running = false; // 其他线程能立刻感知到 running 变了\n}', 'java', 14);


-----------------------------------------------------
-- Level 19: 集合进阶 (深度补充)
-- 重点：HashSet 底层、TreeSet、LinkedList、比较器
-----------------------------------------------------

-- Lesson 19.1: Set 集合 (ID 47)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (47, 'sub-header', 'HashSet vs TreeSet', NULL, 10),
                                                                                               (47, 'text', '* **HashSet**: 底层是 HashMap。无序，增删改查最快 (O(1))。**绝大多数情况都用它**。\n* **TreeSet**: 底层是红黑树。有序 (自动排序)，插入慢 (O(log n))。当你需要数据自动排好序时使用。', NULL, 11),
                                                                                               (47, 'sub-header', '原理：如何判断“重复”？', NULL, 12),
                                                                                               (47, 'text', 'HashSet 去重依赖两个方法：\n1. 先算 `hashCode()`：如果 Hash 值不同，肯定是新元素。\n2. 如果 Hash 值相同（冲突），再比 `equals()`：确认内容是否真的相同。\n\n**结论**：存入 Set 的自定义对象，必须重写 hashCode 和 equals！', NULL, 13);

-- Lesson 19.3: Collections 与 排序 (ID 55)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (55, 'sub-header', 'Comparable vs Comparator', NULL, 10),
                                                                                               (55, 'text', '给对象排序有两种方式：\n\n1. **Comparable (内部比较器)**: 让类自己实现 `compareTo` 方法。例如“学生类”天生就是按学号排的。\n2. **Comparator (外部比较器)**: 写一个独立的排序策略。例如“我想临时按分数排”，不需要修改学生类代码，写一个 Comparator 传给 `sort` 方法即可。', NULL, 11),
                                                                                               (55, 'code', E'// Comparator 写法 (Lambda)\nCollections.sort(students, (s1, s2) -> s1.score - s2.score);', 'java', 12),
                                                                                               (55, 'sub-header', 'ArrayList vs LinkedList', NULL, 13),
                                                                                               (55, 'text', '* **ArrayList**: 数组结构。查询快，增删慢（因为要移动数据）。**首选**。\n* **LinkedList**: 链表结构。查询慢（要从头数），首尾增删快。只在需要频繁在头部插入删除时使用。', NULL, 14);

-- =====================================================
-- Java 专家级补充包 V2.2 (Expert Level Detail)
-- Part 2: Level 17 - 20 (高并发与架构进阶)
-- sort_order 从 20 开始，补全最后的专家级内容
-- =====================================================

-----------------------------------------------------
-- Level 17: Lambda & Stream (专家补充)
-- 重点：并行流、方法引用、短路运算
-----------------------------------------------------

-- Lesson 17.1: Lambda 进阶 (ID 45)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (45, 'sub-header', '方法引用 (Method Reference)', NULL, 20),
                                                                                               (45, 'text', '当 Lambda 表达式的方法体仅仅是调用一个已有的方法时，可以使用 `::` 操作符来进一步简化。这是 Lambda 的终极形态。', NULL, 21),
                                                                                               (45, 'code', E'// 原始 Lambda\nlist.forEach(s -> System.out.println(s));\n\n// 方法引用 (意思一样：把参数传给 println)\nlist.forEach(System.out::println);\n\n// 静态方法引用\nlist.stream().map(Math::abs);', 'java', 22);

-- Lesson 17.3: Stream 性能与陷阱 (ID 51)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (51, 'sub-header', '并行流 (Parallel Stream)', NULL, 20),
                                                                                               (51, 'text', 'Stream 有一个超能力：`parallel()`。它可以自动利用多核 CPU 并行处理数据，速度飞快。', NULL, 21),
                                                                                               (51, 'text', '⚠️ **警告**：并行流虽然快，但极其危险！\n1. **线程安全**：如果你的操作涉及修改共享变量，并行流会导致数据错乱。\n2. **顺序**：并行处理后，元素的顺序可能被打乱。\n**结论**：处理纯计算任务且数据量巨大时才用，操作数据库或共享变量时严禁使用。', NULL, 22),
                                                                                               (51, 'code', E'// 开启并行处理\nlist.parallelStream().filter(...).collect(...);', 'java', 23);


-----------------------------------------------------
-- Level 18: 多线程 (专家补充)
-- 重点：线程池、Callable、JUC 原子类
-----------------------------------------------------

-- Lesson 18.1: 线程池 (ID 46)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (46, 'sub-header', '企业级规范：线程池 (Thread Pool)', NULL, 20),
                                                                                               (46, 'text', '阿里巴巴开发手册强制规定：**线程资源必须通过线程池提供，不允许在应用中自行显式创建线程**。', NULL, 21),
                                                                                               (46, 'text', '线程池的好处：\n1. **复用**：避免反复创建和销毁线程的巨大开销。\n2. **管理**：控制最大并发数，防止 CPU 爆满导致服务器宕机。', NULL, 22),
                                                                                               (46, 'code', E'// 创建一个包含 5 个线程的固定线程池\nExecutorService pool = Executors.newFixedThreadPool(5);\n\n// 提交任务\npool.submit(() -> System.out.println("任务1"));\npool.submit(() -> System.out.println("任务2"));\n\n// 关闭池子\npool.shutdown();', 'java', 23);

-- Lesson 18.2: 进阶锁与原子类 (ID 52)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (52, 'sub-header', 'Callable 与 Future', NULL, 20),
                                                                                               (52, 'text', '`Runnable` 有个缺点：没有返回值。如果你想让线程算完数据后返回给你，需要使用 `Callable` 接口配合 `Future`。', NULL, 21),
                                                                                               (52, 'sub-header', 'CAS 与 Atomic 原子类', NULL, 22),
                                                                                               (52, 'text', '`synchronized` 是悲观锁（觉得一定会冲突，先锁住再说）。\nJava 提供了一组 `Atomic` 类（如 `AtomicInteger`），底层使用 **CAS (Compare And Swap)** 乐观锁机制。它不加锁，通过 CPU 指令保证线程安全，性能极高。', NULL, 23),
                                                                                               (52, 'code', E'AtomicInteger count = new AtomicInteger(0);\n// 线程安全地 +1，不需要 synchronized\ncount.incrementAndGet();', 'java', 24);


-----------------------------------------------------
-- Level 19: 集合进阶 (专家补充)
-- 重点：ConcurrentHashMap、Fail-Fast
-----------------------------------------------------

-- Lesson 19.3: 并发集合 (ID 55)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (55, 'sub-header', '面试之王：ConcurrentHashMap', NULL, 20),
                                                                                               (55, 'text', '普通的 `HashMap` 线程不安全，多线程环境下扩容会导致死循环（CPU 100%）。\n`Hashtable` 虽然安全，但是暴力锁全表，效率极低。', NULL, 21),
                                                                                               (55, 'text', '`ConcurrentHashMap` 是终极解决方案。Java 8 以前使用**分段锁 (Segment)**，Java 8 以后使用 **CAS + synchronized (锁节点)**。它能允许多个线程同时读写不同的数据段，并发性能无敌。', NULL, 22),
                                                                                               (55, 'sub-header', 'Fail-Fast 机制', NULL, 23),
                                                                                               (55, 'text', '当你在遍历 `ArrayList` 时，如果另一个线程（或者你在循环里）删除了一个元素，程序会立刻抛出 `ConcurrentModificationException`。这叫 **Fail-Fast (快速失败)**，为了防止处理脏数据。', NULL, 24);


-----------------------------------------------------
-- Level 20: 构建与工具 (专家补充)
-- 重点：Maven 生命周期、依赖冲突、单元测试
-----------------------------------------------------

-- Lesson 20.1: Maven 进阶 (ID 48)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (48, 'sub-header', 'Maven 生命周期 (Lifecycle)', NULL, 20),
                                                                                               (48, 'text', 'Maven 的命令是遵循特定顺序的。当你运行 `mvn install` 时，它实际执行了以下所有步骤：\n`clean` -> `compile` (编译) -> `test` (运行单元测试) -> `package` (打包jar) -> `install` (存入本地仓库)。', NULL, 21),
                                                                                               (48, 'sub-header', '依赖冲突 (Dependency Hell)', NULL, 22),
                                                                                               (48, 'text', '如果 A 依赖 C(v1.0)，B 依赖 C(v2.0)，而你的项目同时引入了 A 和 B，Maven 会选哪个版本的 C？\n\nMaven 遵循“**最短路径优先**”和“**声明优先**”原则。但最好使用 `mvn dependency:tree` 命令查看冲突，并使用 `<exclusion>` 手动排除不需要的版本。', NULL, 23);

-- (由于 Level 20 是最后一关，我们再补一点 JUnit 单元测试的内容，这对职业生涯极重要)
INSERT INTO beginner_lesson_content_block (lesson_id, type, content, language, sort_order) VALUES
                                                                                               (48, 'sub-header', 'JUnit 单元测试', NULL, 24),
                                                                                               (48, 'text', '写完代码必须测试！JUnit 是 Java 标准测试框架。\n常用注解：\n* `@Test`: 标记这是一个测试方法。\n* `@BeforeEach`: 每个测试开始前执行（初始化）。\n* `@AfterEach`: 每个测试结束后执行（清理）。\n* `Assert.assertEquals(expect, actual)`: 断言，判断结果是否符合预期。', NULL, 25);

-- =====================================================
-- 最后的关键步骤：重置序列号 (防止后续插入报错)
-- =====================================================
SELECT setval('beginner_lesson_id_seq', (SELECT MAX(id) FROM beginner_lesson));
SELECT setval('beginner_lesson_content_block_id_seq', (SELECT MAX(id) FROM beginner_lesson_content_block));
SELECT setval('quiz_question_id_seq', (SELECT MAX(id) FROM quiz_question));
SELECT setval('quiz_option_id_seq', (SELECT MAX(id) FROM quiz_option));
SELECT setval('beginner_logic_content_block_id_seq', (SELECT MAX(id) FROM beginner_logic_content_block));