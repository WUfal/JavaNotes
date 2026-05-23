-- 版本 1.7: (安全地) “增加更多算法题”
-- (添加 "有效的括号")

-----------------------------------------------------
-- 1. 插入新题目 (AlgorithmProblem)
-----------------------------------------------------
-----------------------------------------------------
-- 3. B 路径：算法 (Algorithm)
-----------------------------------------------------
-- (Algorithm 题目)
INSERT INTO algorithm_problem (id, title, difficulty) VALUES
                                                          ('algo_two_sum', '两数之和', 'Easy'),
                                                          ('algo_reverse_list', '反转链表', 'Easy'),
                                                          ('algo_lru_cache', 'LRU 缓存', 'Medium');
-- (Algorithm 内容块)
-- (Two Sum)
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                    ('algo_two_sum', 'DESCRIPTION', 'text', E'给定一个整数数组 `nums` 和一个整数目标值 `target`，请在数组中找出**和为目标值**的那两个整数，并返回它们的下标。\n\n- 每种输入只会对应一个答案，但同一个元素不能使用两遍。\n- 你可以按任意顺序返回答案。\n\n**示例：**', NULL, 1),
                                                                                                    ('algo_two_sum', 'DESCRIPTION', 'code', E'输入：nums = [2,7,11,15], target = 9\n输出：[0,1]\n解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1]。', 'plaintext', 2),
                                                                                                    ('algo_two_sum', 'SOLUTION', 'text', E'**思路：哈希表**\n\n- 遍历数组，对每个元素 `x`，检查 `target - x` 是否已在哈希表中。\n- 如果存在，直接返回下标。\n- 否则将 `x` 和下标存入哈希表。\n\n**复杂度分析：**\n- 时间复杂度：O(n)\n- 空间复杂度：O(n)', NULL, 1),
                                                                                                    ('algo_two_sum', 'SOLUTION', 'code', E'import java.util.HashMap;\nimport java.util.Map;\n\nclass Solution {\n    public int[] twoSum(int[] nums, int target) {\n        Map<Integer, Integer> map = new HashMap<>();\n        for (int i = 0; i < nums.length; i++) {\n            int complement = target - nums[i];\n            if (map.containsKey(complement)) {\n                return new int[] { map.get(complement), i };\n            }\n            map.put(nums[i], i);\n        }\n        throw new IllegalArgumentException("No two sum solution");\n    }\n}', 'java', 2);
-- (Reverse List)
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                    ('algo_reverse_list', 'DESCRIPTION', 'text', E'给定一个单链表的头节点 `head`，请你反转链表，并返回反转后的链表。\n\n- 你需要将链表中的节点顺序全部反转。\n- 请尽量用**原地算法**，不需要新建链表。\n\n**示例：**', NULL, 1),
                                                                                                    ('algo_reverse_list', 'DESCRIPTION', 'code', E'输入：head = [1,2,3,4,5]\n输出：[5,4,3,2,1]', 'plaintext', 2),
                                                                                                    ('algo_reverse_list', 'SOLUTION', 'text', E'**思路：迭代法**\n\n- 定义三个指针：\n  - `prev`：指向前一个节点，初始为 `null`\n  - `curr`：指向当前节点，初始为 `head`\n  - `nextTemp`：临时存储下一个节点\n- 每次循环将 `curr.next` 指向 `prev`，然后三个指针整体向后移动。\n- 最终 `prev` 即为反转后的新头节点。\n\n**复杂度分析：**\n- 时间复杂度：O(n)\n- 空间复杂度：O(1)', NULL, 1),
                                                                                                    ('algo_reverse_list', 'SOLUTION', 'code', E'class Solution {\n    public ListNode reverseList(ListNode head) {\n        ListNode prev = null;\n        ListNode curr = head;\n        while (curr != null) {\n            ListNode nextTemp = curr.next;\n            curr.next = prev;\n            prev = curr;\n            curr = nextTemp;\n        }\n        return prev;\n    }\n}', 'java', 2);
-- (LRU Cache)
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order) VALUES
                                                                                                    ('algo_lru_cache', 'DESCRIPTION', 'text', E'请你设计并实现一个满足 **LRU（最近最少使用）缓存** 约束的数据结构。\n\n- 实现 `get` 和 `put` 操作，要求平均时间复杂度 O(1)。\n- 最近最少使用：当容量满时，移除最久未被访问的数据。\n\n**示例：**', NULL, 1),
                                                                                                    ('algo_lru_cache', 'SOLUTION', 'text', E'**思路：LinkedHashMap**\n\n- Java 中最简单的实现方式是继承 `LinkedHashMap`，利用其有序性和自动淘汰机制。\n- 重写 `removeEldestEntry` 方法，当缓存超出容量时自动移除最久未使用的元素。\n\n**复杂度分析：**\n- 时间复杂度：O(1)\n- 空间复杂度：O(capacity)', NULL, 1),
                                                                                                    ('algo_lru_cache', 'SOLUTION', 'code', E'import java.util.LinkedHashMap;\nimport java.util.Map;\n\nclass LRUCache extends LinkedHashMap<Integer, Integer> {\n    private final int capacity;\n\n    public LRUCache(int capacity) {\n        super(capacity, 0.75f, true);\n        this.capacity = capacity;\n    }\n    public int get(int key) {\n        return super.getOrDefault(key, -1);\n    }\n    public void put(int key, int value) {\n        super.put(key, value);\n    }\n    @Override\n    protected boolean removeEldestEntry(Map.Entry<Integer, Integer> eldest) {\n        return size() > capacity;\n    }\n}', 'java', 2);
INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_valid_parentheses', '有效的括号', 'Easy');

-----------------------------------------------------
-- 2. 插入内容块 (Content Blocks)
-----------------------------------------------------

-- 2a. 题目描述 (category = 'DESCRIPTION')
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_valid_parentheses',
        'DESCRIPTION',
        'text',
        E'给定一个只包括 `(`、`)`、`{`、`}`、`[`、`]` 的字符串 `s`，判断字符串是否**有效**。\n\n- 有效字符串需满足：\n  1. 左括号必须用相同类型的右括号闭合。\n  2. 左括号必须以正确的顺序闭合。\n  3. 每个右括号都有一个对应的相同类型的左括号。\n\n**示例：**',
        NULL,
        1
    ),
    (
        'algo_valid_parentheses',
        'DESCRIPTION',
        'code',
        E'输入：s = "()[]{}"\n输出：true\n\n输入：s = "(]"\n输出：false',
        'plaintext',
        2
    );
-- 2b. 题解 (category = 'SOLUTION')
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_valid_parentheses',
        'SOLUTION',
        'text',
        E'**思路：栈**\n\n- 遍历字符串中的每个字符。\n- 遇到左括号 `(`、`[`、`{` 时，入栈。\n- 遇到右括号时：\n  - 如果栈为空，返回 false。\n  - 弹出栈顶元素，检查是否与当前右括号匹配。\n  - 不匹配则返回 false。\n- 遍历结束后，栈为空则有效，否则无效。\n\n**复杂度分析：**\n- 时间复杂度：O(n)\n- 空间复杂度：O(n)',
        NULL,
        1
    ),
    (
        'algo_valid_parentheses',
        'SOLUTION',
        'code',
        E'import java.util.Stack;\n\nclass Solution {\n    public boolean isValid(String s) {\n        Stack<Character> stack = new Stack<>();\n        for (char c : s.toCharArray()) {\n            if (c == ''('' || c == ''['' || c == ''{''  ) {\n                stack.push(c);\n            } else {\n                if (stack.isEmpty()) return false;\n                char top = stack.pop();\n                if (c == '')'' && top != ''('') return false;\n                if (c == '']'' && top != ''['') return false;\n                if (c == ''}'' && top != ''{''  ) return false;\n            }\n        }\n        return stack.isEmpty();\n    }\n}',
        'java',
        3
    );
-- 版本 1.2: (续写) 填充 12 个热门算法题
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 1. 插入题目 (algorithm_problem)
-- -----------------------------------------------------

INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_merge_two_lists', '合并两个有序链表', 'Easy'),
    ('algo_buy_sell_stock_1', '买卖股票的最佳时机', 'Easy'),
    ('algo_invert_binary_tree', '翻转二叉树', 'Easy'),
    ('algo_binary_search', '二分查找', 'Easy'),
    ('algo_climbing_stairs', '爬楼梯', 'Easy'),
    ('algo_longest_substring_no_repeat', '无重复字符的最长子串', 'Medium'),
    ('algo_3sum', '三数之和', 'Medium'),
    ('algo_merge_intervals', '合并区间', 'Medium'),
    ('algo_kth_smallest_bst', '二叉搜索树中第K小的元素', 'Medium'),
    ('algo_search_range', '在排序数组中查找元素的第一个和最后一个位置', 'Medium'),
    ('algo_trap_rain_water', '接雨水', 'Hard'),
    ('algo_sliding_window_max', '滑动窗口最大值', 'Hard');

-- -----------------------------------------------------
-- 2. 插入内容块 (algorithm_content_block)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 5. 合并两个有序链表 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    ('algo_merge_two_lists', 'DESCRIPTION', 'text', '将两个升序链表合并为一个新的 升序 链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。', NULL, 1),
    ('algo_merge_two_lists', 'DESCRIPTION', 'code', E'输入：list1 = [1,2,4], list2 = [1,3,4]\n输出：[1,1,2,3,4,4]', 'plaintext', 2),
    ('algo_merge_two_lists', 'SOLUTION', 'text', E'**思路：迭代法**\n\n- 创建虚拟头节点 `dummy` 和 `curr` 指针。\n- 比较 `list1` 和 `list2` 当前节点的值。\n- 将较小的节点链接到 `curr.next`。\n- 移动相应的指针直到一个链表为空。\n- 将剩余链表全部链接到 `curr.next`。\n\n**复杂度分析：**\n- 时间复杂度：O(m + n)，其中 m、n 分别为两个链表长度\n- 空间复杂度：O(1)', NULL, 1),
    ('algo_merge_two_lists', 'SOLUTION', 'code', E'/**\n * Definition for singly-linked list.\n * public class ListNode {\n * int val;\n * ListNode next;\n * ListNode() {}\n * ListNode(int val) { this.val = val; }\n * ListNode(int val, ListNode next) { this.val = val; this.next = next; }\n * }\n */\nclass Solution {\n    public ListNode mergeTwoLists(ListNode list1, ListNode list2) {\n        ListNode dummy = new ListNode(-1);\n        ListNode curr = dummy;\n\n        while (list1 != null && list2 != null) {\n            if (list1.val <= list2.val) {\n                curr.next = list1;\n                list1 = list1.next;\n            } else {\n                curr.next = list2;\n                list2 = list2.next;\n            }\n            curr = curr.next;\n        }\n\n        // (连接剩余的链表)\n        curr.next = (list1 != null) ? list1 : list2;\n\n        return dummy.next;\n    }\n}', 'java', 2);

-- -----------------------------------------------------
-- 6. 买卖股票的最佳时机 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    ('algo_buy_sell_stock_1', 'DESCRIPTION', 'text', '给定一个数组 `prices` ，它的第 `i` 个元素 `prices[i]` 表示一支给定股票第 `i` 天的价格。你只能在 某一天 买入这只股票，并选择在 未来的某一个不同的日子 卖出。返回你能获取的最大利润。如果你不能获取任何利润，返回 0 。', NULL, 1),
    ('algo_buy_sell_stock_1', 'DESCRIPTION', 'code', E'输入：[7,1,5,3,6,4]\n输出：5\n解释：在第 2 天（价格 = 1）买入，在第 5 天（价格 = 6）卖出，最大利润 = 6-1 = 5 。\n     注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。', 'plaintext', 2),
    ('algo_buy_sell_stock_1', 'SOLUTION', 'text', E'**思路：一次遍历（贪心）**\n\n- 维护两个变量：\n  - `minPrice`：迄今为止的最低价格\n  - `maxProfit`：迄今为止的最大利润\n- 遍历数组 `prices`：\n  1. 如果 `price < minPrice`，更新 `minPrice = price`。\n  2. 否则计算利润 `price - minPrice`，更新 `maxProfit`。\n\n**复杂度分析：**\n- 时间复杂度：O(n)\n- 空间复杂度：O(1)', NULL, 1),
    ('algo_buy_sell_stock_1', 'SOLUTION', 'code', E'class Solution {\n    public int maxProfit(int[] prices) {\n        int minPrice = Integer.MAX_VALUE;\n        int maxProfit = 0;\n\n        for (int price : prices) {\n            if (price < minPrice) {\n                minPrice = price; // (找到更低的价格)\n            } else {\n                // (尝试卖出)\n                int profit = price - minPrice;\n                if (profit > maxProfit) {\n                    maxProfit = profit;\n                }\n            }\n        }\n        return maxProfit;\n    }\n}', 'java', 2);

-- -----------------------------------------------------
-- 7. 翻转二叉树 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    ('algo_invert_binary_tree', 'DESCRIPTION', 'text', '给你一棵二叉树的根节点 `root` ，翻转这棵二叉树，并返回其根节点。', NULL, 1),
    ('algo_invert_binary_tree', 'DESCRIPTION', 'code', E'输入：root = [4,2,7,1,3,6,9]\n输出：[4,7,2,9,6,3,1]', 'plaintext', 2),
    ('algo_invert_binary_tree', 'SOLUTION', 'text', E'**思路：递归法（DFS）**\n\n- 对任何节点 `root` 执行以下操作：\n  1. 基线条件：如果 `root == null`，返回 `null`。\n  2. 递归翻转左子树：`left = invertTree(root.left)`\n  3. 递归翻转右子树：`right = invertTree(root.right)`\n  4. 交换当前节点的左右指针：`root.left = right`，`root.right = left`。\n  5. 返回 `root`。\n\n**复杂度分析：**\n- 时间复杂度：O(n)，n 为节点数\n- 空间复杂度：O(h)，h 为树高（递归栈深度）', NULL, 1),
    ('algo_invert_binary_tree', 'SOLUTION', 'code', E'/**\n * Definition for a binary tree node.\n * public class TreeNode {\n * int val;\n * TreeNode left;\n * TreeNode right;\n * TreeNode(int val) { this.val = val; }\n * }\n */\nclass Solution {\n    public TreeNode invertTree(TreeNode root) {\n        if (root == null) {\n            return null;\n        }\n\n        // (递归翻转左右子树)\n        TreeNode left = invertTree(root.left);\n        TreeNode right = invertTree(root.right);\n\n        // (交换当前节点的左右指针)\n        root.left = right;\n        root.right = left;\n\n        return root;\n    }\n}', 'java', 2);

-- -----------------------------------------------------
-- 8. 二分查找 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    ('algo_binary_search', 'DESCRIPTION', 'text', '给定一个 `n` 个元素有序的（升序）整型数组 `nums` 和一个目标值 `target` ，写一个函数搜索 `nums` 中的 `target`，如果目标值存在返回下标，否则返回 -1。', NULL, 1),
    ('algo_binary_search', 'DESCRIPTION', 'code', E'输入: nums = [-1,0,3,5,9,12], target = 9\n输出: 4\n解释: 9 出现在 nums 中并且下标为 4', 'plaintext', 2),
    ('algo_binary_search', 'SOLUTION', 'text', E'**思路：二分查找法**\n\n- 在排序数组中查找目标值：\n  1. 初始化两个指针：`left = 0`，`right = nums.length - 1`\n  2. 当 `left <= right` 时，循环执行以下步骤：\n     - 计算中点：`mid = left + (right - left) / 2`（防止溢出）\n     - 如果 `nums[mid] == target`，返回 `mid`。\n     - 如果 `nums[mid] < target`，搜索范围缩小到右半部分：`left = mid + 1`\n     - 如果 `nums[mid] > target`，搜索范围缩小到左半部分：`right = mid - 1`\n  3. 循环结束后未找到，返回 `-1`。\n\n**复杂度分析：**\n- 时间复杂度：O(log n)\n- 空间复杂度：O(1)', NULL, 1),
    ('algo_binary_search', 'SOLUTION', 'code', E'class Solution {\n    public int search(int[] nums, int target) {\n        int left = 0;\n        int right = nums.length - 1;\n\n        while (left <= right) {\n            int mid = left + (right - left) / 2;\n\n            if (nums[mid] == target) {\n                return mid;\n            } else if (nums[mid] < target) {\n                left = mid + 1;\n            } else {\n                right = mid - 1;\n            }\n        }\n        return -1;\n    }\n}', 'java', 2);

-- -----------------------------------------------------
-- 9. 爬楼梯 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    ('algo_climbing_stairs', 'DESCRIPTION', 'text', '假设你正在爬楼梯。需要 `n` 阶你才能到达楼顶。每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶？', NULL, 1),
    ('algo_climbing_stairs', 'DESCRIPTION', 'code', E'输入：n = 3\n输出：3\n解释：有三种方法可以爬到楼顶。\n1. 1 阶 + 1 阶 + 1 阶\n2. 1 阶 + 2 阶\n3. 2 阶 + 1 阶', 'plaintext', 2),
    ('algo_climbing_stairs', 'SOLUTION', 'text', '动态规划（斐波那契数列）。\n`dp[i]` 表示爬到第 `i` 阶的方法数。\n要想到达第 `i` 阶，你只能从第 `i-1` 阶 (爬1阶) 或第 `i-2` 阶 (爬2阶) 上来。\n因此，`dp[i] = dp[i-1] + dp[i-2]`。\n基线条件：`dp[1] = 1`, `dp[2] = 2`。\n为了将空间复杂度优化到 O(1)，我们可以使用“滚动数组”思想，只保留 `a = dp[i-2]`, `b = dp[i-1]`。', NULL, 1),
    ('algo_climbing_stairs', 'SOLUTION', 'code', E'class Solution {\n    public int climbStairs(int n) {\n        if (n <= 2) {\n            return n;\n        }\n\n        int a = 1; // dp[1]\n        int b = 2; // dp[2]\n\n        for (int i = 3; i <= n; i++) {\n            int temp = a + b;\n            a = b;\n            b = temp;\n        }\n        return b;\n    }\n}', 'java', 2);

-- -----------------------------------------------------
-- 10. 无重复字符的最长子串 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    ('algo_longest_substring_no_repeat', 'DESCRIPTION', 'text', '给定一个字符串 `s` ，请你找出其中不含有重复字符的 最长子串 的长度。', NULL, 1),
    ('algo_longest_substring_no_repeat', 'DESCRIPTION', 'code', E'输入: s = "abcabcbb"\n输出: 3 \n解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。\n\n输入: s = "pwwkew"\n输出: 3\n解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。', 'plaintext', 2),
    ('algo_longest_substring_no_repeat', 'SOLUTION', 'text', '滑动窗口 + 哈希集合 (Set)。\n我们使用一个哈希集合 `Set` 来存储当前“窗口”内的字符，并使用 `left` (左指针) 和 `right` (右指针) 来定义窗口的边界。\n1. `right` 指针向右移动 ( `for` 循环 )，将 `s.charAt(right)` 加入 `set`。\n2. 如果 `set.add()` 返回 `false`（表示 `s.charAt(right)` 已存在于 `set` 中），说明窗口内有重复字符。\n3. 我们必须收缩窗口：`while` 循环，`set.remove(s.charAt(left))` 并且 `left++`，直到 `s.charAt(right)` 可以被成功加入 `set`。\n4. 每次 `right` 指针移动后，更新 `maxLength = Math.max(maxLength, right - left + 1)` (即当前窗口大小)。', NULL, 1),
    ('algo_longest_substring_no_repeat', 'SOLUTION', 'code', E'import java.util.HashSet;\nimport java.util.Set;\n\nclass Solution {\n    public int lengthOfLongestSubstring(String s) {\n        Set<Character> set = new HashSet<>();\n        int left = 0;\n        int maxLength = 0;\n\n        for (int right = 0; right < s.length(); right++) {\n            char c = s.charAt(right);\n            // (如果窗口中已存在该字符，收缩左边界)\n            while (!set.add(c)) {\n                set.remove(s.charAt(left));\n                left++;\n            }\n            // (此时窗口内 [left, right] 均无重复)\n            maxLength = Math.max(maxLength, right - left + 1);\n        }\n        return maxLength;\n    }\n}', 'java', 2);

-- -----------------------------------------------------
-- 11. 三数之和 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    ('algo_3sum', 'DESCRIPTION', 'text', '给你一个整数数组 `nums` ，判断是否存在三元组 `[nums[i], nums[j], nums[k]]` 满足 `i != j`、`i != k` 且 `j != k` ，同时还满足 `nums[i] + nums[j] + nums[k] == 0` 。\n请你返回所有和为 0 且不重复的三元组。', NULL, 1),
    ('algo_3sum', 'DESCRIPTION', 'code', E'输入：nums = [-1,0,1,2,-1,-4]\n输出：[[-1,-1,2],[-1,0,1]]', 'plaintext', 2),
    ('algo_3sum', 'SOLUTION', 'text', E'**思路：排序 + 双指针**\n\n- 对数组进行排序。\n- 外层循环遍历数组（i 从 0 到 n-2）：\n  1. 固定 `nums[i]` 为第一个数。\n  2. 剪枝：如果 `nums[i] > 0`，直接 break（后续都是正数，不可能和为 0）。\n  3. 去重：跳过重复的 `nums[i]`。\n- 内层双指针在剩余部分寻找两数之和等于 `-nums[i]`：\n  1. `left = i + 1`，`right = n - 1`\n  2. 根据 `nums[left] + nums[right]` 的值移动指针。\n  3. 找到目标时，记录结果并对 `left` 和 `right` 进行去重。\n\n**复杂度分析：**\n- 时间复杂度：O(n²)
- 空间复杂度：O(1)（不计排序空间）', NULL, 1),
    ('algo_3sum', 'SOLUTION', 'code', E'import java.util.Arrays;\nimport java.util.List;\nimport java.util.ArrayList;\n\nclass Solution {\n    public List<List<Integer>> threeSum(int[] nums) {\n        Arrays.sort(nums);\n        List<List<Integer>> result = new ArrayList<>();\n        int n = nums.length;\n\n        for (int i = 0; i < n - 2; i++) {\n            // (剪枝)\n            if (nums[i] > 0) break;\n            // (去重 i)\n            if (i > 0 && nums[i] == nums[i-1]) continue;\n\n            int left = i + 1;\n            int right = n - 1;\n            int target = -nums[i];\n\n            while (left < right) {\n                int sum = nums[left] + nums[right];\n                if (sum == target) {\n                    result.add(Arrays.asList(nums[i], nums[left], nums[right]));\n                    // (去重 left 和 right)\n                    while (left < right && nums[left] == nums[left + 1]) left++;\n                    while (left < right && nums[right] == nums[right - 1]) right--;\n                    left++;\n                    right--;\n                } else if (sum < target) {\n                    left++;\n                } else {\n                    right--;\n                }\n            }\n        }\n        return result;\n    }\n}', 'java', 2);

-- -----------------------------------------------------
-- 12. 合并区间 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_merge_intervals',
        'DESCRIPTION',
        'text',
        E'以一个 **`intervals`** 数组表示若干个区间的集合，其中 `intervals[i] = [start_i, end_i]`。\n\n请你合并所有重叠的区间，并返回一个**不重叠**的区间数组，该数组需恰好覆盖输入中的所有区间。\n\n**约束：**\n- `intervals[i].length == 2`\n- `0 <= start_i <= end_i`',
        NULL,
        1
    ),
    (
        'algo_merge_intervals',
        'SOLUTION',
        'text',
        E'**思路：排序 + 贪心**\n\n此题的核心是“**按左端点排序**”。当区间按起始点排序后，我们就可以用贪心法处理重叠问题。\n\n1.  **排序**：将 `intervals` 数组按照每个区间的**起始点** `[0]` 进行升序排序。\n2.  **初始化**：创建一个 `LinkedList<int[]>` (或 `ArrayList`) `merged` 来存储最终结果。\n3.  **遍历**：遍历排序后的 `intervals` 数组。\n    * **情况 1：不重叠**\n        如果 `merged` 为空，或者当前区间 `interval` 的起始点 `interval[0]` **大于** `merged` 中最后一个区间的结束点 `merged.getLast()[1]`，说明它们不重叠。此时将 `interval` 直接添加到 `merged` 列表末尾。\n    * **情况 2：重叠**\n        如果 `interval[0] <= merged.getLast()[1]`，说明当前区间与 `merged` 中的最后一个区间有重叠。我们需要合并它们。\n        合并操作：更新 `merged` 最后一个区间的**结束点** `[1]`，使其等于 `Math.max(merged.getLast()[1], interval[1])`。\n4.  **返回**：将 `merged` 转换为 `int[][]` 数组返回。\n\n**复杂度分析：**\n-   时间复杂度：O(n log n)，瓶颈在于排序。\n-   空间复杂度：O(log n) 或 O(n)，取决于排序算法所用的栈空间（或 O(n) 如果计入 `merged` 列表）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 13. 二叉搜索树中第K小的元素 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_kth_smallest_bst',
        'DESCRIPTION',
        'text',
        E'给定一个二叉搜索树 (BST) 的根节点 `root` 和一个整数 `k` ，请你设计一个算法查找其中第 `k` 个最小元素（从 1 开始计数）。',
        NULL,
        1
    ),
    (
        'algo_kth_smallest_bst',
        'SOLUTION',
        'text',
        E'**思路：中序遍历 (迭代法)**\n\n二叉搜索树 (BST) 的一个关键特性是：**中序遍历（In-order Traversal）** (左-根-右) 会得到一个严格递增的有序序列。\n\n因此，第 `k` 小的元素就是中序遍历访问到的第 `k` 个元素。\n\n我们可以使用一个**栈 (Stack)** 来迭代地实现中序遍历，并用一个计数器 `count`：\n\n1.  初始化 `Stack<TreeNode> stack` 和 `count = 0`。\n2.  使用 `while (root != null || !stack.isEmpty())` 循环：\n    * **步骤 1 (向左)**：`while (root != null)`，将所有左子节点压入栈中，`stack.push(root)`，`root = root.left`。这会找到最左边的叶子节点。\n    * **步骤 2 (访问根)**：`root = stack.pop()`。此时 `root` 是当前应访问的节点（中序）。\n    * **步骤 3 (计数)**：`count++`。\n    * **步骤 4 (检查)**：`if (count == k)`，我们找到了第 k 小的元素，`return root.val`。\n    * **步骤 5 (向右)**：`root = root.right`。转向右子树，开始下一轮的“步骤 1 (向左)”。\n\n**复杂度分析：**\n-   时间复杂度：O(h + k)，其中 h 是树的高度（最差 O(n)），k 是 k 的值。因为我们最多遍历 k 个节点。\n-   空间复杂度：O(h)，迭代所用的栈空间（最差 O(n)）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 14. 在排序数组中查找元素的第一个和最后一个位置 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_search_range',
        'DESCRIPTION',
        'text',
        E'给你一个按照**非递减顺序**排列的整数数组 `nums`，和一个目标值 `target`。\n\n请你找出给定目标值在数组中的**开始位置和结束位置**。\n\n如果数组中不存在目标值 `target`，返回 `[-1, -1]`。\n\n**要求：** 你必须设计并实现时间复杂度为 **O(log n)** 的算法解决此问题。',
        NULL,
        1
    ),
    (
        'algo_search_range',
        'SOLUTION',
        'text',
        E'**思路：二分查找变体 (寻找边界)**\n\nO(log n) 的要求提示我们必须使用二分查找。标准的二分查找只能找到 `target` 的*任意*一个位置，而我们需要的是“左边界”和“右边界”。\n\n我们可以执行**两次**二分查找：\n\n1.  **查找左边界 (Left Boundary)**：\n    * 我们寻找第一个 **`>= target`** 的位置。\n    * 这可以通过一个二分查找实现：当 `nums[mid] >= target` 时，我们尝试收缩右边界 `right = mid`；否则 `left = mid + 1`。\n    * 循环结束后，`left` 指针 (记为 `leftIdx`) 就是左边界。\n    * (检查) 必须检查 `leftIdx` 是否越界 ( `leftIdx == nums.length` ) 以及 `nums[leftIdx]` 是否真的等于 `target`。如果任一条件不满足，说明 `target` 不存在，返回 `[-1, -1]`。\n\n2.  **查找右边界 (Right Boundary)**：\n    * (方法一) 寻找第一个 **`> target`** 的位置。循环结束后，`rightIdx - 1` 就是右边界。\n    * (方法二，更简单) 寻找第一个 **`>= target + 1`** 的位置。循环结束后，`rightIdx - 1` 就是右边界。\n\n**统一的 `findBoundary` 函数 (如示例代码)：**\n我们可以用一个函数 `findBoundary(nums, target, seekingLeft)` 来统一处理：\n-   `seekingLeft = true` (找左边界)：当 `nums[mid] == target` 时，我们收缩 `right = mid`。\n-   `seekingLeft = false` (找右边界)：当 `nums[mid] == target` 时，我们收缩 `left = mid + 1`。\n\n**复杂度分析：**\n-   时间复杂度：O(log n)。执行了两次二分查找。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 15. 接雨水 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_trap_rain_water',
        'DESCRIPTION',
        'text',
        E'给定 `n` 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。\n\n(图片示例：高度图 `[0,1,0,2,1,0,1,3,2,1,2,1]`，可以接 6 单位的雨水)',
        NULL,
        1
    ),
    (
        'algo_trap_rain_water',
        'SOLUTION',
        'text',
        E'**思路：双指针法 (最优解)**\n\n这是 O(N) 时间复杂度和 O(1) 空间复杂度的最优解法。\n\n“木桶原理”告诉我们，一个位置 `i` 能接多少水，取决于它**左边的最高柱子** ( `leftMax` ) 和**右边的最高柱子** ( `rightMax` ) 中的**较小者**。\n水量 `water[i] = Math.min(leftMax[i], rightMax[i]) - height[i]`。\n\n朴素解法 (O(N^2)) 或动态规划 (O(N) 空间) 都是为了计算 `leftMax` 和 `rightMax`。\n\n**双指针 O(1) 空间优化：**\n1.  维护两个指针：`left = 0`, `right = n - 1`。\n2.  维护两个变量：`leftMax = 0` (代表 `height[0...left]` 的最高柱子) 和 `rightMax = 0` (代表 `height[right...n-1]` 的最高柱子)。\n3.  维护 `totalWater = 0`。\n4.  `while (left < right)` 循环：\n    * **核心判断**：`if (height[left] < height[right])`：\n        * (如果 `height[left]` 较小) 此时，`rightMax` ( `height[right]` ) 肯定大于 `leftMax` ( `height[left]` )。但我们*不*知道 `height[left]` 右侧的*真正* `rightMax` 是多少。
        * 但是，我们*确定* `height[left]` 的 `leftMax` 是 `leftMax` (已知的)。
        * 由于 `leftMax` ( `height[left]` ) **小于** `rightMax` ( `height[right]` )，此时 `left` 位置的水量**仅由 `leftMax` 决定**。\n        * `if (height[left] >= leftMax)`，更新 `leftMax = height[left]`。\n        * `else` ( `height[left] < leftMax` )，`totalWater += (leftMax - height[left])`。\n        * `left++`。\n    * `else` ( `height[right] <= height[left]` )：\n        * (同理) 此时 `right` 位置的水量**仅由 `rightMax` 决定**。\n        * `if (height[right] >= rightMax)`，更新 `rightMax = height[right]`。\n        * `else`，`totalWater += (rightMax - height[right])`。\n        * `right--`。\n5.  返回 `totalWater`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。`left` 和 `right` 指针各遍历一次。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 16. 滑动窗口最大值 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_sliding_window_max',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums`，有一个大小为 `k` 的滑动窗口从数组的最左侧移动到数组的最右侧。\n\n你只可以看到在滑动窗口内的 `k` 个数字。请你找出每次滑动窗口中的最大值。\n\n返回一个数组，包含每次窗口移动时的最大值。',
        NULL,
        1
    ),
    (
        'algo_sliding_window_max',
        'SOLUTION',
        'text',
        E'**思路：单调队列 (Deque - 双端队列)**\n\n我们需要一个数据结构，它能 O(1) 时间获取当前窗口的最大值，并且能高效地维护窗口的滑动。\n\n使用一个 `Deque<Integer>` (双端队列)，**存储元素的索引 (Index)**。\n这个队列必须**严格保持“单调递减”**（按值 `nums[index]`）。\n-   队首 (`peekFirst`)：永远是当前窗口最大值的*索引*。\n-   队尾 (`peekLast`)：是当前窗口最小值的*索引*。\n\n**算法流程：**\n遍历 `nums` 数组 ( `i` 从 0 到 n-1 )：\n\n1.  **维护队尾 (保持单调递减)**：\n    `while (!deque.isEmpty() && nums[deque.peekLast()] <= nums[i])`：\n    如果队尾元素 `nums[deque.peekLast()]` *小于等于* 当前元素 `nums[i]`，说明队尾元素已经“过时”且“无用”( `i` 更大且更新)，将其从队尾 `pollLast()` 移除。\n    (这确保了队列中 `nums[index]` 的值是单调递减的)。\n\n2.  **加入当前元素**：\n    `deque.addLast(i)`。将当前索引 `i` 加入队尾。\n\n3.  **维护队首 (移除窗口外的)**：\n    `if (deque.peekFirst() <= i - k)`：\n    检查队首的最大值索引是否已经滑出窗口 (即索引 `i - k`)。如果是，`pollFirst()` 移除。\n\n4.  **记录结果**：\n    `if (i >= k - 1)` (窗口已形成)：\n    `result[i - k + 1] = nums[deque.peekFirst()]` (队首即为当前窗口最大值)。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。每个元素最多入队一次、出队一次。\n-   空间复杂度：O(k)。双端队列中最多存储 `k` 个索引。',
        NULL,
        1
    );
-----------------------------------------------------
-- 3. (重要) 更新所有被修改表的序列号
-----------------------------------------------------
-- -----------------------------------------------------
-- 版本 1.3: (续写) 填充 12 个新的热门算法题
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 1. 插入题目 (algorithm_problem)
-- -----------------------------------------------------

INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_add_two_numbers', '两数相加', 'Medium'),
    ('algo_max_subarray', '最大子数组和', 'Easy'),
    ('algo_group_anagrams', '字母异位词分组', 'Medium'),
    ('algo_linked_list_cycle', '环形链表', 'Easy'),
    ('algo_max_depth_tree', '二叉树的最大深度', 'Easy'),
    ('algo_min_stack', '最小栈', 'Easy'),
    ('algo_coin_change', '零钱兑换', 'Medium'),
    ('algo_longest_palindrome_sub', '最长回文子串', 'Medium'),
    ('algo_kth_largest_array', '数组中的第K个最大元素', 'Medium'),
    ('algo_word_search', '单词搜索', 'Medium'),
    ('algo_diameter_tree', '二叉树的直径', 'Easy'),
    ('algo_median_data_stream', '数据流的中位数', 'Hard');

-- -----------------------------------------------------
-- 2. 插入内容块 (algorithm_content_block)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 17. 两数相加 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_add_two_numbers',
        'DESCRIPTION',
        'text',
        E'给你两个 **非空** 的链表，表示两个非负的整数。\n\n它们每位数字都是按照 **逆序** 的方式存储的，并且每个节点只能存储 **一位** 数字。\n\n(例如：`[2,4,3]` 表示 `342`)',
        NULL,
        1
    ),
    (
        'algo_add_two_numbers',
        'DESCRIPTION',
        'text',
        E'请你将两个数相加，并以相同形式返回一个表示和的链表。\n\n你可以假设除了数字 0 之外，这两个数都不会以 0 开头。',
        NULL,
        2
    ),
    (
        'algo_add_two_numbers',
        'SOLUTION',
        'text',
        E'**思路：模拟小学加法**\n\n由于链表是 **逆序** 存储的 (个位在 `head`)，这使得加法非常方便。我们可以从 `l1` 和 `l2` 的头部 (个位) 开始，逐位相加，并维护一个 `carry` (进位) 变量。\n\n1.  **初始化**：\n    * 创建“虚拟头节点” `dummy = new ListNode(0)` (用于简化返回 `dummy.next`)。\n    * 创建 `curr = dummy` 指针，用于构建新链表。\n    * `carry = 0` (初始进位为 0)。\n\n2.  **遍历**：\n    使用 `while (l1 != null || l2 != null || carry != 0)` 循环。\n    (循环条件必须包含 `carry != 0`，以处理 `[5] + [5] = [0, 1]` 这样的情况)。\n\n3.  **计算**：\n    * `val1 = (l1 != null) ? l1.val : 0`。\n    * `val2 = (l2 != null) ? l2.val : 0`。\n    * `sum = val1 + val2 + carry`。\n\n4.  **更新进位和当前位**：\n    * `carry = sum / 10`。\n    * `curr.next = new ListNode(sum % 10)` (创建新节点，值为 `sum` 的个位数)。\n\n5.  **移动指针**：\n    * `curr = curr.next`。\n    * `if (l1 != null) l1 = l1.next`。\n    * `if (l2 != null) l2 = l2.next`。\n\n6.  **返回**：`return dummy.next`。\n\n**复杂度分析：**\n-   时间复杂度：O(max(m, n))，m 和 n 分别为 `l1` 和 `l2` 的长度。\n-   空间复杂度：O(max(m, n))，新链表的长度。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 18. 最大子数组和 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_max_subarray',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums` ，请你找出一个具有最大和的**连续子数组**（子数组最少包含一个元素），返回其最大和。',
        NULL,
        1
    ),
    (
        'algo_max_subarray',
        'SOLUTION',
        'text',
        E'**思路：动态规划 (Kadane''s 算法)**\n\n这是 O(N) 时间复杂度的最优解。我们使用“滚动”的方式来优化 DP。\n\n我们维护两个变量：\n\n1.  `currentSum`: (或 `dp[i]`) 表示**以 `nums[i]` 结尾**的“最大连续子数组和”。\n2.  `maxSum`: (或 `max(dp[0...n-1])`) 表示遍历过程中见过的 `currentSum` 的最大值，即全局最大和。\n\n**遍历数组 `nums`：**\n对于 `nums` 中的每个元素 `num` (从 `i=0` 开始，但 `i=0` 时 `currentSum = num` )：\n\n1.  **状态转移**：\n    `currentSum` (以 `num` 结尾的最大和) 有两种选择：\n    * **(A) 接上**：将 `num` 接到上一段 ( `currentSum + num` )。\n    * **(B) 重新开始**：从 `num` 重新开始一段 ( `num` )。\n    * 我们取其大者：`currentSum = Math.max(num, currentSum + num);`\n    * (含义：如果 `currentSum` 在此之前是负数，那么 `num` 更好；如果是正数，`currentSum + num` 更好)。\n\n2.  **更新全局最大值**：\n    用 `currentSum` 更新 `maxSum`。\n    `maxSum = Math.max(maxSum, currentSum);`\n\n**初始化：**\n-   `maxSum = nums[0]`\n-   `currentSum = nums[0]`\n-   (循环从 `i = 1` 开始)\n\n**复杂度分析：**\n-   时间复杂度：O(n)，一次遍历。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 19. 字母异位词分组 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_group_anagrams',
        'DESCRIPTION',
        'text',
        E'给你一个字符串数组 `strs`，请你将 **字母异位词** 组合在一起。\n\n可以按任意顺序返回结果列表。\n\n**字母异位词** (Anagram) 是由相同字母按任意顺序排列而成的字符串。\n(例如: "eat", "tea", "ate" 是字母异位词)',
        NULL,
        1
    ),
    (
        'algo_group_anagrams',
        'SOLUTION',
        'text',
        E'**思路：哈希表 (HashMap)**\n\n解决“分组”问题，首先要想到使用哈希表 (HashMap)。\n\n关键在于：如何为“字母异位词”（如 "eat", "tea", "ate"）生成一个**唯一的 Key**，使得它们都能映射到哈希表的同一个条目中。\n\n**Key 生成方法：排序**\n对字符串中的字符进行排序。`"eat"`, `"tea"`, `"ate"` 排序后都等于 `"aet"`。\n\n**算法流程：**\n1.  创建一个 `Map<String, List<String>> map`。\n    * `Key`: 排序后的字符串 (如 "aet")\n    * `Value`: 原始字符串列表 (如 ["eat", "tea", "ate"])\n\n2.  遍历 `strs` 数组中的每个 `str`。\n3.  将 `str` 转换为 `char[]` 数组。\n4.  对 `char[]` 进行 `Arrays.sort()` 排序。\n5.  将排序后的 `char[]` 转换回 `String key`。\n6.  使用 `map.computeIfAbsent(key, k -> new ArrayList<>()).add(str);` 将**原始字符串 `str`** 添加到对应的分组中。\n    ( `computeIfAbsent` 是一种高效写法，等价于：)\n    ( `if (!map.containsKey(key)) { map.put(key, new ArrayList<>()); }` )\n    ( `map.get(key).add(str);` )\n\n7.  遍历结束后，`map` 中 `values()` (所有的 `List<String>` ) 就是答案。\n8.  返回 `new ArrayList<>(map.values())`。\n\n**(替代方法：计数)**\n如果字符串只包含小写字母，可以用 `int[26]` 数组作为 Key (如 "1a1e1t0...0")，但排序更通用。\n\n**复杂度分析 (排序法)：**\n-   时间复杂度：O(n * k log k)，n 是 `strs` 长度，k 是字符串最大长度 (排序时间)。\n-   空间复杂度：O(n * k)，哈希表存储所有字符串。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 20. 环形链表 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_linked_list_cycle',
        'DESCRIPTION',
        'text',
        E'给你一个链表的头节点 `head` ，判断链表中是否有环。\n\n如果链表中有某个节点，可以通过连续跟踪 `next` 指针再次到达，则链表中存在环。',
        NULL,
        1
    ),
    (
        'algo_linked_list_cycle',
        'SOLUTION',
        'text',
        E'**思路：快慢指针 (Floyd 判圈法)**\n\n这是最优解，空间复杂度 O(1)。\n\n想象一下在操场跑道上，一个“快”跑者和一个“慢”跑者。如果跑道是环形的，快跑者（速度是慢跑者的 2 倍）最终一定会从*后面*追上慢跑者。\n\n**算法流程：**\n1.  创建两个指针 `slow` 和 `fast`，都指向 `head`。\n2.  在 `while` 循环中，`slow` 每次走一步 (`slow = slow.next`)，`fast` 每次走两步 (`fast = fast.next.next`)。\n3.  **循环条件** (保证 `fast` 不会出错)：\n    `while (fast != null && fast.next != null)`\n4.  **判断相遇**：\n    如果在循环中 `slow == fast` (两个指针指向了同一个节点)，说明快指针追上了慢指针，链表**有环**，返回 `true`。\n5.  **循环结束**：\n    如果循环正常结束 (即 `fast` 到达 `null` 或 `fast.next` 到达 `null`)，说明快跑者到达了终点，链表**无环**，返回 `false`。\n\n**(注意)**：\n-   (处理空链表) `if (head == null)`，返回 `false`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 21. 二叉树的最大深度 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_max_depth_tree',
        'DESCRIPTION',
        'text',
        E'给定一个二叉树，找出其**最大深度**。\n\n二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。\n\n**叶子节点**是指没有子节点的节点。',
        NULL,
        1
    ),
    (
        'algo_max_depth_tree',
        'SOLUTION',
        'text',
        E'**思路：递归 (DFS, 深度优先搜索)**\n\n这是一个最直观的树递归问题。一个树的“最大深度”可以通过其子树的“最大深度”推导出来。\n\n**递归函数 `maxDepth(root)` 的定义：**\n返回以 `root` 为根的子树的最大深度。\n\n1.  **(递归基线 / Base Case)**：\n    如果 `root == null` (空节点)，说明到达了叶子节点的下一层，其深度为 0。返回 `0`。\n\n2.  **(递归拆解 / Divide)**：\n    递归计算左子树的深度：`leftDepth = maxDepth(root.left)`。\n    递归计算右子树的深度：`rightDepth = maxDepth(root.right)`。\n\n3.  **(合并结果 / Conquer)**：\n    当前 `root` 节点的深度，等于其左右子树深度的 **最大值**，再加上 `root` 节点本身的 `1`。\n    返回 `1 + Math.max(leftDepth, rightDepth)`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，n 为节点数，因为每个节点都访问一次。\n-   空间复杂度：O(h)，h 为树的高度。这是递归栈所需的空间（最坏情况 O(n)，平衡情况 O(log n)）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 22. 最小栈 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_min_stack',
        'DESCRIPTION',
        'text',
        E'设计一个支持 `push`，`pop`，`top` 操作，并能在**常数时间 O(1)** 内检索到最小元素的栈。\n\n实现 `MinStack` 类：\n- `MinStack()` 初始化栈对象。\n- `void push(int val)`\n- `void pop()`\n- `int top()`\n- `int getMin()`',
        NULL,
        1
    ),
    (
        'algo_min_stack',
        'SOLUTION',
        'text',
        E'**思路：辅助栈 (双栈法)**\n\n我们需要一个“主栈” `stack` 来执行 `push`, `pop`, `top`。但 `getMin` 无法在 O(1) 完成。\n\n我们可以使用**第二个栈 `minStack` (辅助栈)**，专门用于跟踪“最小值”。\n\n`minStack` 的栈顶 `minStack.peek()` 永远是 `stack` *当前所有元素*中的最小值。\n\n**算法流程：**\n1.  **`push(x)`**:\n    * `stack.push(x)` (主栈正常 push)。\n    * (关键) **如果** `x` **小于等于** `minStack.peek()` (或者 `minStack` 为空)，`minStack.push(x)`。\n    * (注意：必须是“小于等于”，以处理 `[5, 5, 4]` 这样的情况)。\n\n2.  **`pop()`**:\n    * `int popped = stack.pop()` (主栈正常 pop)。\n    * (关键) **如果** `popped` 的值 **等于** `minStack.peek()` (注意：Java 中比较 `Integer` 对象必须用 `equals` 或 `==` (注意缓存范围))。\n    * 如果是，`minStack.pop()` (辅助栈也必须 pop，以暴露*下一个*最小值)。\n    * (注：`popped.equals(minStack.peek())` 是最安全的写法)。\n\n3.  **`getMin()`**:\n    * 返回 `minStack.peek()`。\n\n**复杂度分析：**\n-   时间复杂度：O(1)，所有操作都是常数时间。\n-   空间复杂度：O(n)，最坏情况 (如 `[5, 4, 3, 2, 1]` )，`minStack` 需要存储 n 个元素。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 23. 零钱兑换 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_coin_change',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `coins` ，表示不同面额的硬币；以及一个总金额 `amount` 。\n\n计算并返回可以凑成总金额所需的 **最少的硬币个数** 。\n\n如果没有任何一种硬币组合能组成总金额，返回 -1 。\n\n(你可以假设每种硬币的数量是无限的)',
        NULL,
        1
    ),
    (
        'algo_coin_change',
        'SOLUTION',
        'text',
        E'**思路：动态规划 (完全背包问题)**\n\n这是一个典型的“完全背包”问题，因为硬币可以无限次使用。\n\n1.  **定义 `dp` 数组**：\n    `int[] dp = new int[amount + 1]`\n    `dp[i]` 表示：凑成金额 `i` 所需的**最少硬币数**。\n\n2.  **初始化**：\n    * `Arrays.fill(dp, amount + 1)`。我们将 `dp` 数组初始化为一个“无穷大”的值 ( `amount + 1` 是一个不可能达到的值)。\n    * `dp[0] = 0` (凑成金额 0 需要 0 个硬币)。\n\n3.  **状态转移 (迭代)**：\n    遍历所有金额 `i` (从 1 到 `amount`)：\n    * 对于每种硬币 `coin` (遍历 `coins` 数组)：\n        * `if (i >= coin)` (只有当 `i` 大于等于 `coin` 时，才可能使用 `coin`)：\n            * `dp[i] = Math.min(dp[i], dp[i - coin] + 1)`\n            * (含义：凑成 `i` 的最少硬币数，等于 `dp[i]` (当前值) 和 `dp[i - coin] + 1` (我用 1 个 `coin`，然后看凑成 `i - coin` 需要多少个) 中的较小者)。\n\n4.  **结果**：\n    * 遍历结束后，`dp[amount]` 就是答案。\n    * (检查) 如果 `dp[amount]` 仍然等于 `amount + 1` (即“无穷大”)，说明无解，返回 -1。\n    * 否则返回 `dp[amount]`。\n\n**复杂度分析：**\n-   时间复杂度：O(S * n)，S 是 `amount`，n 是 `coins` 数组长度。\n-   空间复杂度：O(S)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 24. 最长回文子串 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_longest_palindrome_sub',
        'DESCRIPTION',
        'text',
        E'给你一个字符串 `s`，找到 `s` 中最长的**回文子串**。\n\n**回文串**：正读和反读都一样的字符串 (如 "aba", "bb")。',
        NULL,
        1
    ),
    (
        'algo_longest_palindrome_sub',
        'SOLUTION',
        'text',
        E'**思路：中心扩展法 (O(1) 空间)**\n\n动态规划 (DP) 解法需要 O(N^2) 空间。中心扩展法是 O(N^2) 时间和 O(1) 空间的最优解。\n\n回文串的“中心”有两种情况：\n1.  **奇数长度**：如 "a B a", 中心是 `B`。\n2.  **偶数长度**：如 "a B B a", 中心是 `BB`。\n\n**算法流程：**\n1.  维护 `start` 和 `end` (或 `maxLen`) 变量，记录迄今为止找到的最长回文串的边界。\n2.  遍历字符串 `s` 的每个索引 `i` (从 0 到 n-1)：\n    * (情况 1) 以 `i` 为中心 (奇数情况)，向两边扩展。\n        `len1 = expandAroundCenter(s, i, i)`\n    * (情况 2) 以 `i` 和 `i+1` 为中心 (偶数情况)，向两边扩展。\n        `len2 = expandAroundCenter(s, i, i + 1)`\n    * `len = Math.max(len1, len2)`。\n    * 比较 `len` 和当前已知的 `maxLen` (即 `end - start + 1`)，如果 `len` 更大，则更新 `start` 和 `end`。\n3.  返回 `s.substring(start, end + 1)`。\n\n**`expandAroundCenter(s, left, right)` 辅助函数：**\n-   `while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right))`：\n    * (向两边扩展) `left--`, `right++`。\n-   循环结束时, `[left+1, right-1]` 是以 `(left, right)` 初始值为中心的回文串。\n-   返回长度 `(right - 1) - (left + 1) + 1` (即 `right - left - 1`)。\n\n**复杂度分析：**\n-   时间复杂度：O(n²)。有 2n-1 个中心点，每个中心点扩展最多 O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 25. 数组中的第K个最大元素 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_kth_largest_array',
        'DESCRIPTION',
        'text',
        E'给定整数数组 `nums` 和整数 `k`，请返回数组中第 `k` 个最大的元素。\n\n请注意，你需要找的是数组排序后的第 `k` 个最大的元素，而不是第 `k` 个不同的元素。',
        NULL,
        1
    ),
    (
        'algo_kth_largest_array',
        'SOLUTION',
        'text',
        E'**思路：最小堆 (PriorityQueue)**\n\n这是 Java 中最简单且高效的解法，时间复杂度 O(N log k)。(注：最优解是 O(N) 的 QuickSelect 算法，但实现复杂)。\n\n我们需要一个数据结构来维护“迄今为止最大的 `k` 个元素”。\n\n**算法流程：**\n1.  创建一个“**最小堆**” `minHeap` (Java 默认的 `PriorityQueue` 就是最小堆)。\n    `PriorityQueue<Integer> minHeap = new PriorityQueue<>((a, b) -> a - b);`\n    (或 `new PriorityQueue<>(k)`，但比较器仍是默认的最小堆)\n\n2.  **堆的大小 (Size) 维护在 `k`**。\n    遍历 `nums` 数组中的每个 `num`：\n    * `minHeap.add(num)` (将 `num` 加入堆)。\n    * (关键) **如果 `minHeap.size() > k`**：\n        * `minHeap.poll()` (移除堆顶的**最小**元素)。\n\n3.  **遍历结束**：\n    堆 `minHeap` 中存储的就是 `nums` 数组中**最大的 `k` 个元素**。\n    (因为所有比这 `k` 个数小的元素都在 `poll()` 过程中被移除了)。\n\n4.  **结果**：\n    堆顶 `minHeap.peek()` (或 `minHeap.poll()`) 就是这 `k` 个数中**最小的**，即“**第 K 大**”的元素。\n\n**复杂度分析：**\n-   时间复杂度：O(N log k)。遍历 N 个元素，每次 `add` 或 `poll` 都是 O(log k)。\n-   空间复杂度：O(k)，堆的大小。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 26. 单词搜索 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_word_search',
        'DESCRIPTION',
        'text',
        E'给定一个 `m x n` 二维字符网格 `board` 和一个字符串单词 `word` 。如果 `word` 存在于网格中，返回 `true` ；否则，返回 `false` 。\n\n单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。\n\n**同一个单元格内的字母不允许被重复使用。**',
        NULL,
        1
    ),
    (
        'algo_word_search',
        'SOLUTION',
        'text',
        E'**思路：回溯 (DFS + 标记)**\n\n这是一个典型的图/矩阵 DFS 遍历问题，结合了回溯法。\n\n1.  **主函数**：\n    * 遍历 `board` 中的每一个单元格 `(i, j)`，尝试将其作为 `word` 的起点。\n    * `if (dfs(board, word, i, j, 0)) return true;` ( `0` 是 `word` 的索引 `k` )。\n    * 如果遍历完所有起点都失败，返回 `false`。\n\n2.  **`dfs(board, word, i, j, k)` 辅助函数**：\n    ( `k` 是 `word` 中正在匹配的字符索引 `word.charAt(k)` )\n\n    * **(基线 - 失败 1: 越界)**\n        `if (i < 0 || i >= m || j < 0 || j >= n)`，返回 `false`。\n\n    * **(基线 - 失败 2: 不匹配)**\n        `if (board[i][j] != word.charAt(k))`，返回 `false`。\n\n    * **(基线 - 成功)**\n        `if (k == word.length() - 1)` (已匹配到 `word` 的最后一个字符)，返回 `true`。\n\n    * **(标记访问)** (防止重复使用)\n        `char temp = board[i][j];`\n        `board[i][j] = ''#''`; (任意一个 `board` 中不存在的字符)。\n\n    * **(递归搜索)**\n        搜索四个方向：\n        `boolean found = dfs(..., i+1, j, k+1) ||`\n                        `dfs(..., i-1, j, k+1) ||`\n                        `dfs(..., i, j+1, k+1) ||`\n                        `dfs(..., i, j-1, k+1);`\n\n    * **(回溯 / 撤销选择)**\n        `board[i][j] = temp;` (将单元格还原，以便其他路径使用)。\n\n    * 返回 `found`。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n * 3^L)，m*n 是起点数，L 是 `word` 长度，3 是因为除了来时方向，最多 3 个方向可选。\n-   空间复杂度：O(L)，递归栈深度。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 27. 二叉树的直径 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_diameter_tree',
        'DESCRIPTION',
        'text',
        E'给定一棵二叉树，你需要计算它的**直径**长度。\n\n一棵二叉树的直径长度是任意两个结点路径长度中的最大值。**这条路径可能穿过也可能不穿过根结点。**\n\n(注意：长度通常指“边”的数量，但这题的解法通常计算“节点”数再减 1，或者直接计算“边”数。示例中 `[4,2,1,3]` 长度为 3 (3 条边))',
        NULL,
        1
    ),
    (
        'algo_diameter_tree',
        'SOLUTION',
        'text',
        E'**思路：DFS + 全局变量**\n\n一个节点的“直径” = `left_height + right_height` (左子树高度 + 右子树高度)。\n\n但是，**“最大直径”不一定穿过根节点** (它可能完全在左子树中，或完全在右子树中)。\n\n我们需要一个 DFS 函数，它有两个作用：\n1.  **(返回值)**：返回以 `node` 为根的**“最大高度”** (或“最大深度”)。\n2.  **(副作用)**：在计算高度的过程中，*顺便*更新一个**全局变量 `maxDiameter`**。\n\n**`dfs(node)` (或 `height(node)`) 函数：**\n1.  **(基线)** `if (node == null) return 0;` (空节点高度为 0)。\n\n2.  **(递归)**\n    `int leftHeight = dfs(node.left);`\n    `int rightHeight = dfs(node.right);`\n\n3.  **(更新最大直径 - 副作用)**\n    `maxDiameter = Math.max(maxDiameter, leftHeight + rightHeight);`\n    ( `leftHeight + rightHeight` 是 *穿过* `node` 节点的最大直径)。\n\n4.  **(返回高度)**\n    `return 1 + Math.max(leftHeight, rightHeight);`\n    ( `node` 的高度等于其子树最大高度 + 1)。\n\n**主函数 `diameterOfBinaryTree(root)`:**\n-   初始化 `maxDiameter = 0`。\n-   调用 `dfs(root)`。\n-   返回 `maxDiameter`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，每个节点访问一次。\n-   空间复杂度：O(h)，h 为树高（递归栈深度）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 28. 数据流的中位数 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_median_data_stream',
        'DESCRIPTION',
        'text',
        E'**中位数**是有序整数列表中的中间值。如果列表大小是偶数，则中位数是两个中间值的平均值。\n\n设计一个支持以下两种操作的数据结构：\n-   `void addNum(int num)` - 从数据流中添加一个整数。\n-   `double findMedian()` - 返回当前所有元素的中位数。',
        NULL,
        1
    ),
    (
        'algo_median_data_stream',
        'SOLUTION',
        'text',
        E'**思路：双堆 (Two Heaps)**\n\n这是解决此问题的经典方法。我们使用两个堆来维护数据流的“两半”。\n\n1.  **`lo` (大顶堆 / Max-Heap)**：\n    存储数据流中“**较小的一半**”数字。\n    ( `PriorityQueue<>((a, b) -> b - a)` )\n2.  **`hi` (小顶堆 / Min-Heap)**：\n    存储数据流中“**较大的一半**”数字。\n    ( `PriorityQueue<>((a, b) -> a - b)` )\n\n**平衡 (Invariants)：**\n我们必须始终保持 `lo` 和 `hi` 的大小平衡：\n1.  `lo.size() == hi.size()` (偶数个元素时)\n2.  `lo.size() == hi.size() + 1` (奇数个元素时)\n( `lo` 始终等于或多 1 个元素)\n\n**`addNum(num)` 流程：**\n1.  `lo.add(num)` (总是先加入大顶堆)。\n2.  **(平衡 A)** `hi.add(lo.poll())` (将 `lo` 中最大的元素 ( `lo.poll()` ) 移到 `hi` 中)。\n3.  **(平衡 B)** `if (hi.size() > lo.size())` (如果 `hi` 元素过多)，`lo.add(hi.poll())` (将 `hi` 中最小的移回 `lo` 中)。\n\n(经过这三步，`lo` 和 `hi` 始终保持平衡，且 `lo` 中所有数 <= `hi` 中所有数)\n\n**`findMedian()` 流程：**\n1.  **奇数个** ( `lo.size() > hi.size()` )：\n    中位数是 `lo.peek()` (较小一半的最大值)。\n2.  **偶数个** ( `lo.size() == hi.size()` )：\n    中位数是 `(lo.peek() + hi.peek()) / 2.0` (两半的边界值的平均数)。\n\n**复杂度分析：**\n-   `addNum`：O(log n)，堆操作。\n-   `findMedian`：O(1)，`peek` 操作。\n-   空间复杂度：O(n)，存储所有元素。',
        NULL,
        1
    );
-- -----------------------------------------------------
-- 版本 1.4: (续写) 填充 12 个新的热门算法题
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 1. 插入题目 (algorithm_problem)
-- -----------------------------------------------------

INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_product_except_self', '除自身以外数组的乘积', 'Medium'),
    ('algo_is_symmetric_tree', '对称二叉树', 'Easy'),
    ('algo_max_area_island', '岛屿的最大面积', 'Medium'),
    ('algo_merge_sorted_array', '合并两个有序数组', 'Easy'),
    ('algo_lca_bst', '二叉搜索树的最近公共祖先', 'Easy'),
    ('algo_lca_bt', '二叉树的最近公共祖先', 'Medium'),
    ('algo_daily_temperatures', '每日温度', 'Medium'),
    ('algo_find_all_anagrams', '找到字符串中所有字母异位词', 'Medium'),
    ('algo_permutations', '全排列', 'Medium'),
    ('algo_word_break', '单词拆分', 'Medium'),
    ('algo_longest_consecutive', '最长连续序列', 'Medium'),
    ('algo_rotate_image', '旋转图像', 'Medium');

-- -----------------------------------------------------
-- 2. 插入内容块 (algorithm_content_block)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 29. 除自身以外数组的乘积 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_product_except_self',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums`，返回 数组 `answer` ，其中 `answer[i]` 等于 `nums` 中除 `nums[i]` 之外其余各元素的乘积。',
        NULL,
        1
    ),
    (
        'algo_product_except_self',
        'DESCRIPTION',
        'text',
        E'**要求：**\n1.  请**不要使用除法**。\n2.  在 **O(n)** 时间复杂度内完成此题。\n3.  (进阶) 在 **O(1)** 额外空间复杂度内完成 ( `answer` 数组不算额外空间)。',
        NULL,
        2
    ),
    (
        'algo_product_except_self',
        'SOLUTION',
        'text',
        E'**思路：前缀积 + 后缀积 (O(1) 空间)**\n\n`answer[i]` = ( `i` 左侧所有元素的乘积) * ( `i` 右侧所有元素的乘积)。\n\nO(N) 空间的解法是创建 `leftProducts[]` 和 `rightProducts[]` 数组，然后 `answer[i] = leftProducts[i] * rightProducts[i]`。\n\n**O(1) 空间优化：**\n我们可以利用 `answer` 数组来复用空间。\n\n1.  **(计算前缀积)** (第一次遍历, 0 to n-1)\n    * 创建 `answer` 数组。`answer[0] = 1`。\n    * `for (int i = 1; i < n; i++)`：\n        `answer[i] = answer[i-1] * nums[i-1]`。\n    * (此时 `answer[i]` 存储的是 `i` **左侧**所有元素的乘积)。\n    * (例如 `[1,2,3,4]` -> `answer` 变为 `[1, 1, 2, 6]` )\n\n2.  **(计算后缀积并合并)** (第二次遍历, n-1 to 0)\n    * 创建一个变量 `rightProduct = 1` (用于存储从右到当前的后缀积)。\n    * `for (int i = n - 1; i >= 0; i--)` (反向遍历)：\n        * `answer[i] = answer[i] * rightProduct`\n            ( `answer[i]` (左前缀积) * `rightProduct` (右后缀积) )\n        * `rightProduct = rightProduct * nums[i]` (更新后缀积，为下一轮 `i-1` 做准备)。\n\n    * (例如 `answer = [1, 1, 2, 6]` 和 `rightProduct = 1`)\n    * `i=3`: `answer[3] = 6 * 1 = 6`。`right = 1 * 4 = 4`。\n    * `i=2`: `answer[2] = 2 * 4 = 8`。`right = 4 * 3 = 12`。\n    * `i=1`: `answer[1] = 1 * 12 = 12`。`right = 12 * 2 = 24`。\n    * `i=0`: `answer[0] = 1 * 24 = 24`。`right = 24 * 1 = 24`。\n    * (结果 `[24, 12, 8, 6]` )\n\n**复杂度分析：**\n-   时间复杂度：O(n)，两次遍历。\n-   空间复杂度：O(1) ( `answer` 数组不计入)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 30. 对称二叉树 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_is_symmetric_tree',
        'DESCRIPTION',
        'text',
        E'给你一个二叉树的根节点 `root` ， 检查它是否**轴对称**。\n\n(即，它是否是它自己的镜像？)',
        NULL,
        1
    ),
    (
        'algo_is_symmetric_tree',
        'SOLUTION',
        'text',
        E'**思路：递归 (DFS)**\n\n要判断一棵树 `root` 是否对称，等价于判断它的“左子树” `root.left` 和“右子树” `root.right` 是否“**镜像对称**”。\n\n我们需要定义一个辅助函数 `isMirror(node1, node2)`，用于判断 `node1` 和 `node2` 是否镜像对称。\n\n**`isMirror(node1, node2)` 逻辑：**\n1.  **(基线 - 成功)**\n    `if (node1 == null && node2 == null)`，返回 `true` (两个空节点是镜像对称的)。\n\n2.  **(基线 - 失败)**\n    * `if (node1 == null || node2 == null)` (一个空，一个不空)，返回 `false`。\n    * `if (node1.val != node2.val)` (值不同)，返回 `false`。\n\n3.  **(递归)**\n    必须同时满足**两个**条件 (交叉比较)：\n    * (A) `node1` 的**左**子树与 `node2` 的**右**子树镜像对称：\n        `isMirror(node1.left, node2.right)`\n    * (B) `node1` 的**右**子树与 `node2` 的**左**子树镜像对称：\n        `isMirror(node1.right, node2.left)`\n\n**主函数 `isSymmetric(root)`:**\n-   `if (root == null)` 返回 `true`。\n-   调用 `isMirror(root.left, root.right)`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，n 为节点数。\n-   空间复杂度：O(h)，h 为树高（递归栈深度）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 31. 岛屿的最大面积 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_max_area_island',
        'DESCRIPTION',
        'text',
        E'给你一个大小为 `m x n` 的二进制矩阵 `grid` 。\n\n**岛屿** 是由一些相邻的 `1` (代表土地) 构成的组合，这里的“相邻”要求两个 `1` 必须在 **水平或者竖直** T上相邻。\n\n你可以假设 `grid` 的四个边缘都被 `0` (代表水) 包围着。',
        NULL,
        1
    ),
    (
        'algo_max_area_island',
        'DESCRIPTION',
        'text',
        E'岛屿的**面积**是岛上值为 `1` 的单元格的数目。\n\n计算并返回 `grid` 中最大的岛屿面积。如果不存在岛屿，返回 `0` 。',
        NULL,
        2
    ),
    (
        'algo_max_area_island',
        'SOLUTION',
        'text',
        E'**思路：DFS (深度优先搜索) 或 BFS**\n\n这是图/矩阵遍历的经典题目 (类似 200. 岛屿数量)。我们需要遍历整个 `grid`，找到所有岛屿，并计算每个岛屿的面积，返回最大值。\n\n**算法流程 (DFS)：**\n1.  初始化 `maxArea = 0`。\n2.  遍历 `grid` 中的每个单元格 `(i, j)`。\n3.  如果 `grid[i][j] == 1` (发现一块新土地，即一个新岛屿的起点)：\n    * 调用 `dfs(grid, i, j)` 计算这个新岛屿的面积 `currentArea`。\n    * `maxArea = Math.max(maxArea, currentArea)`。\n\n4.  返回 `maxArea`。\n\n**`dfs(grid, i, j)` 辅助函数 (计算面积)：**\n1.  **(基线 - 失败)**\n    * 检查 `(i, j)` 是否越界 ( `i < 0` ... )。\n    * 检查 `grid[i][j]` 是否是 `0` (水) 或已被访问 (见下)。\n    * 如果是，返回 `0` (不增加面积)。\n\n2.  **(标记访问)** (重要！)\n    * `grid[i][j] = 0` (将这块土地“沉没”，防止重复计算)。\n\n3.  **(计算面积)**\n    * `area = 1` (当前这块土地)。\n\n4.  **(递归)**\n    * `area += dfs(grid, i+1, j)` (下)\n    * `area += dfs(grid, i-1, j)` (上)\n    * `area += dfs(grid, i, j+1)` (右)\n    * `area += dfs(grid, i, j-1)` (左)\n\n5.  返回 `area`。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n)，每个单元格最多访问一次。\n-   空间复杂度：O(m * n)，递归栈深度（最坏情况，一个岛屿占满整个 `grid`）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 32. 合并两个有序数组 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_merge_sorted_array',
        'DESCRIPTION',
        'text',
        E'给你两个按 **非递减顺序** 排列的整数数组 `nums1` 和 `nums2`，另有两个整数 `m` 和 `n` ，分别表示 `nums1` 和 `nums2` 中的元素数目。',
        NULL,
        1
    ),
    (
        'algo_merge_sorted_array',
        'DESCRIPTION',
        'text',
        E'请你 **合并** `nums2` 到 `nums1` 中，使合并后的数组同样按 **非递减顺序** 排列。\n\n**注意:** \n-   最终合并后的数组**不应**由函数返回，而是存储在数组 `nums1` 中。\n-   `nums1` 的末尾有 `n` 个 0，是为 `nums2` 预留的空间 ( `nums1.length == m + n` )。',
        NULL,
        2
    ),
    (
        'algo_merge_sorted_array',
        'SOLUTION',
        'text',
        E'**思路：双指针 (从后往前)**\n\n由于 `nums1` 的末尾有足够的空间，为了避免在“从前往后”合并时覆盖 `nums1` 中尚未比较的元素，我们必须**从后往前**填充 `nums1`。\n\n1.  **初始化指针**：\n    * `p1` (指向 `nums1` 的有效末尾): `p1 = m - 1`。\n    * `p2` (指向 `nums2` 的有效末尾): `p2 = n - 1`。\n    * `p` (指向 `nums1` 的物理末尾，即填充位置): `p = m + n - 1`。\n\n2.  **主循环** (比较 `p1` 和 `p2` )：\n    * `while (p1 >= 0 && p2 >= 0)`：\n        * 比较 `nums1[p1]` 和 `nums2[p2]`。\n        * 将 **较大** 的那个元素放入 `nums1[p]`。\n        * 移动对应的指针 (`p1` 或 `p2`) 和 `p`。\n        * (例如 `if (nums1[p1] > nums2[p2]) { nums1[p--] = nums1[p1--]; } else { ... }` )\n\n3.  **(处理剩余元素)**：\n    * 循环结束后，`p1` 和 `p2` 中可能有一个尚未耗尽。\n    * **如果 `p1` 耗尽** ( `p2 >= 0` )：说明 `nums2` 中还有剩余（且它们都比 `nums1` 剩余的要小）。\n        `while (p2 >= 0) { nums1[p--] = nums2[p2--]; }`\n    * **如果 `p2` 耗尽** ( `p1 >= 0` )：无需处理。`nums1` 中剩余的元素本就在它们应该在的正确位置。\n\n**复杂度分析：**\n-   时间复杂度：O(m + n)，每个元素只移动一次。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 33. 二叉搜索树的最近公共祖先 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_lca_bst',
        'DESCRIPTION',
        'text',
        E'给定一个**二叉搜索树 (BST)**, 找到该树中两个给定节点 `p` 和 `q` 的最近公共祖先 (LCA)。\n\n**最近公共祖先**：对于节点 `p` 和 `q`，LCA 是 `p` 和 `q` 的所有共同祖先中“离根节点最远”的那个。',
        NULL,
        1
    ),
    (
        'algo_lca_bst',
        'SOLUTION',
        'text',
        E'**思路：利用 BST 特性**\n\n对于普通二叉树 ( (34) LCA BT )，我们需要 O(N) 递归。但对于 BST，我们可以利用其特性：`left.val < root.val < right.val`。\n\nLCA (最近公共祖先) 是 `p` 和 `q` 开始“分叉”的那个节点。\n\n**算法流程 (迭代法 O(1) 空间)：**\n1.  从 `root` 开始遍历。\n2.  `while (root != null)`:\n    * **(情况 1：都在右子树)**\n        如果 `p.val` 和 `q.val` 都 **大于** `root.val`，说明 `p` 和 `q` 都在 `root` 的右子树中，LCA 必定也在右子树。`root = root.right`。\n    * **(情况 2：都在左子树)**\n        如果 `p.val` 和 `q.val` 都 **小于** `root.val`，说明 LCA 必定在左子树。`root = root.left`。\n    * **(情况 3：分叉点)**\n        如果 `p` 和 `q` 分布在 `root` 的两侧 (一个 `p.val <= root.val`，一个 `q.val >= root.val`)，或者 `root` 等于 `p` 或 `q`。\n        此时，`root` 就是“分叉点”，即 LCA。\n        返回 `root`。\n\n**复杂度分析：**\n-   时间复杂度：O(h)，h 为树高（平均 O(log n)，最差 O(n)）。\n-   空间复杂度：O(1) (迭代法)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 34. 二叉树的最近公共祖先 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_lca_bt',
        'DESCRIPTION',
        'text',
        E'给定一个**普通二叉树**, 找到该树中两个给定节点 `p` 和 `q` 的最近公共祖先 (LCA)。\n\n(注意：这是一个普通二叉树，不是 BST)。',
        NULL,
        1
    ),
    (
        'algo_lca_bt',
        'SOLUTION',
        'text',
        E'**思路：递归 (DFS)**\n\n对于普通二叉树 (非 BST)，我们无法利用值的大小关系，只能递归搜索。\n\n**递归函数 `lowestCommonAncestor(root, p, q)` 的含义：**\n在以 `root` 为根的树中搜索 `p` 和 `q`，并返回：\n-   如果 `root` 是 `p` 或 `q`，返回 `root`。\n-   如果 `p` 和 `q` 分布在 `root` 两侧，返回 `root` (LCA)。\n-   如果 `p` 和 `q` 都在左侧，返回在左侧找到的 LCA。\n-   如果 `p` 和 `q` 都在右侧，返回在右侧找到的 LCA。\n-   如果都没找到，返回 `null`。\n\n**算法流程：**\n1.  **(基线条件)**\n    * `if (root == null)`，返回 `null` (没找到)。\n    * `if (root == p || root == q)`，返回 `root` (找到了 `p` 或 `q`，`root` 可能是 LCA)。\n\n2.  **(递归)**\n    * `left = lowestCommonAncestor(root.left, p, q)` (去左子树找)。\n    * `right = lowestCommonAncestor(root.right, p, q)` (去右子树找)。\n\n3.  **(合并结果)**\n    * **情况 1：`p`, `q` 在两侧**\n        `if (left != null && right != null)`，说明 `p` 和 `q` 分别在 `root` 的左右子树，`root` 即为 LCA。\n        返回 `root`。\n    * **情况 2：只在左侧找到**\n        `if (left != null)` ( `right` 为 `null` )，说明 `p` 和 `q` 都在左子树。\n        返回 `left` ( `left` 是在左子树中找到的 `p`, `q` 或 LCA)。\n    * **情况 3：只在右侧找到**\n        `if (right != null)` ( `left` 为 `null` )。\n        返回 `right`。\n    * **情况 4：都没找到**\n        `if (left == null && right == null)`。\n        返回 `null`。\n\n    (情况 2, 3, 4 可以合并为 `return (left != null) ? left : right;` )\n\n**复杂度分析：**\n-   时间复杂度：O(n)，n 为节点数。\n-   空间复杂度：O(h)，h 为树高（递归栈深度）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 35. 每日温度 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_daily_temperatures',
        'DESCRIPTION',
        'text',
        E'给定一个整数数组 `temperatures` ，表示每天的温度。\n\n返回一个数组 `answer` ，其中 `answer[i]` 是指对于第 `i` 天，下一个**更高**温度出现在几天后 ( `j - i` )。\n\n如果气温在这之后都不会升高，请在该位置用 `0` 来代替。',
        NULL,
        1
    ),
    (
        'algo_daily_temperatures',
        'SOLUTION',
        'text',
        E'**思路：单调栈 (Monotonic Stack)**\n\n这道题要求我们寻找“下一个更大的元素 (Next Greater Element)”。这是单调栈的经典应用场景。\n\n我们需要一个“**单调递减**”的栈。栈中存储的是元素的 **索引 (Index)**。\n\n(为什么是“递减”？因为我们希望栈顶是 `[75]`，`[71, 69]` 这样的序列，当 `[72]` 进来时，可以处理 `69` 和 `71` )。\n\n**算法流程：**\n1.  创建 `answer` 数组 (默认全 0) 和一个 `Stack<Integer>` (存储索引)。\n2.  遍历 `temperatures` ( `i` 从 0 到 n-1 )：\n    * `currentTemp = temperatures[i]`。\n\n    * **`while (!stack.isEmpty() && currentTemp > temperatures[stack.peek()])`**：\n        (核心：如果当前温度 `currentTemp` 大于栈顶索引 `prevIdx` 对应的温度)\n        * `int prevIdx = stack.pop()` (弹出 `prevIdx`，我们找到了它的答案)。\n        * `answer[prevIdx] = i - prevIdx` (计算天数差)。\n\n    * **`stack.push(i)`** (将当前索引 `i` 压栈，等待未来找到比它高的温度)。\n\n3.  遍历结束后，栈中剩余的索引（如 `[76, 73]` ）对应的 `answer` 保持为 0。\n4.  返回 `answer`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。每个索引最多入栈一次、出栈一次。\n-   空间复杂度：O(n)。最坏情况 ( `[76, 75, 74]` )，栈中存储 n 个索引。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 36. 找到字符串中所有字母异位词 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_find_all_anagrams',
        'DESCRIPTION',
        'text',
        E'给定两个字符串 `s` 和 `p`，找到 `s` 中所有 `p` 的 **异位词** 的子串。\n\n返回这些子串的**起始索引**。不考虑答案输出的顺序。\n\n**异位词**：(同 (19) 字母异位词分组) "abc" 和 "cba" 是异位词。',
        NULL,
        1
    ),
    (
        'algo_find_all_anagrams',
        'SOLUTION',
        'text',
        E'**思路：滑动窗口 + 数组哈希**\n\n这是“滑动窗口”的经典应用。我们需要在 `s` 中维护一个长度等于 `p.length()` 的窗口，并检查窗口内的“字符频率”是否与 `p` 完全相等。\n\n由于字符都是小写字母，我们可以使用 `int[26]` 数组来代替 `HashMap`，效率更高。\n\n**算法流程：**\n1.  (边界) `if (s.length() < p.length())` 返回空列表。\n2.  **( `p` 的哈希)** 创建 `pMap[26]` 数组，统计 `p` 中每个字符的频率。\n3.  **( `s` 的哈希)** 创建 `sMap[26]` 数组，用于统计 `s` 中“窗口”内字符的频率。\n4.  **初始化窗口**：先处理 `s` 的前 `p.length()` 个字符，填充 `sMap`。\n5.  (检查) `if (Arrays.equals(sMap, pMap))`，`result.add(0)` (索引 0 是一个答案)。\n\n6.  **滑动窗口** ( `i` 从 `p.length()` 到 `s.length() - 1` )：\n    * `rightChar = s.charAt(i)`\n    * `leftChar = s.charAt(i - p.length())`\n\n    * (扩大窗口) `sMap[rightChar - ''a'']++`。\n    * (收缩窗口) `sMap[leftChar - ''a'']--`。\n\n    * (检查匹配) `if (Arrays.equals(sMap, pMap))`：\n        * `result.add(i - p.length() + 1)` ( `left` 指针的索引)。\n\n7.  返回 `result`。\n\n**(优化)**：(如示例代码) 可以在一个 `for` 循环 ( `right` 指针) 中同时处理扩大和收缩，`left` 指针随之移动。\n\n**复杂度分析：**\n-   时间复杂度：O(N + M)，N 是 `s` 长度，M 是 `p` 长度。`Arrays.equals` 比较是 O(26) = O(1)。\n-   空间复杂度：O(1) ( O(26) )。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 37. 全排列 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_permutations',
        'DESCRIPTION',
        'text',
        E'给定一个**不含重复数字**的数组 `nums` ，返回其 所有可能的**全排列** 。\n\n你可以 按任意顺序 返回答案。',
        NULL,
        1
    ),
    (
        'algo_permutations',
        'SOLUTION',
        'text',
        E'**思路：回溯 (DFS)**\n\n全排列是回溯算法的经典模板题。\n\n`backtrack(nums, path, visited, result)`:\n-   `nums`: 原始数组 (选择列表)。\n-   `path`: 当前路径 (已选择的)。\n-   `visited`: 布尔数组, 标记 `nums` 中哪些索引已被 `path` 使用。\n-   `result`: 存储所有符合条件的 `path`。\n\n**算法流程：**\n1.  **(基线 - 成功)**\n    `if (path.size() == nums.length)`：\n    * 说明 `path` 已满 ( `[1,2,3]` )，找到了一个全排列。\n    * `result.add(new ArrayList<>(path))` (必须添加 `path` 的*副本*)。\n    * `return`。\n\n2.  **(遍历选择列表)**\n    `for (int i = 0; i < nums.length; i++)`：\n\n    * **(剪枝)** `if (visited[i]) continue;` (如果 `nums[i]` 已在 `path` 中，跳过)。\n\n    * **(1. 做选择)**\n        `path.add(nums[i])`\n        `visited[i] = true`\n\n    * **(2. 递归)**\n        `backtrack(nums, path, visited, result)` (进入下一层决策)。\n\n    * **(3. 撤销选择 / 回溯)**\n        `path.remove(path.size() - 1)` (将 `nums[i]` 移出 `path` )\n        `visited[i] = false` (将 `nums[i]` 标记为“未使用”，以便其他分支使用)。\n\n**复杂度分析：**\n-   时间复杂度：O(n * n!)。有 n! 种排列，每种排列需要 O(n) 时间构建。\n-   空间复杂度：O(n)，`visited` 数组和递归栈深度。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 38. 单词拆分 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_word_break',
        'DESCRIPTION',
        'text',
        E'给你一个字符串 `s` 和一个字符串列表 `wordDict` (字典)。\n\n请你判断是否可以利用字典中出现的单词拼接出 `s` 。',
        NULL,
        1
    ),
    (
        'algo_word_break',
        'DESCRIPTION',
        'text',
        E'**注意：**\n-   不要求字典中单词全部都使用。\n-   并且字典中的单词可以**重复使用**。',
        NULL,
        2
    ),
    (
        'algo_word_break',
        'SOLUTION',
        'text',
        E'**思路：动态规划 (完全背包变体)**\n\n`wordDict` 中的单词可以重复使用，这是一个“完全背包”问题。\n\n1.  **定义 `dp` 数组**：\n    `boolean[] dp = new boolean[s.length() + 1]`\n    `dp[i]` 表示：字符串 `s` 的前 `i` 个字符 (即 `s.substring(0, i)`) **是否**可以被 `wordDict` 拆分。\n\n2.  **初始化**：\n    * `dp[0] = true` (空字符串 `""` 总可以被拆分)。\n\n3.  **(优化)**：将 `wordDict` 放入 `HashSet` 中，以便 O(1) 查找 `wordSet.contains()`。\n\n4.  **状态转移 (迭代)**：\n    ( `i` 代表 `dp` 数组索引，即 `s` 的长度)\n    `for (int i = 1; i <= s.length(); i++)`：\n        ( `j` 代表 `dp` 数组索引，即“断点”)\n        `for (int j = 0; j < i; j++)`：\n            * (检查 `j` 是否可达) `if (dp[j] == true)`：\n                * (检查 `s[j...i-1]` 是否在字典中)\n                * `String sub = s.substring(j, i)`\n                * `if (wordSet.contains(sub))`：\n                    * `dp[i] = true` ( `s[0...j]` 可达，且 `s[j...i]` 在字典中，则 `s[0...i]` 可达)。\n                    * `break;` (只要找到一种拆分, `dp[i]` 就为 `true`, 跳出 `j` 循环)。\n\n5.  **返回** `dp[s.length()]`。\n\n**复杂度分析：**\n-   时间复杂度：O(n²)。两层 `for` 循环。\n    (注：`substring` 在 Java 中是 O(k)，所以总时间是 O(n³)。但如果 `j` 循环优化 (遍历 `wordDict` )，可以是 O(n * m * k)，或使用更高级算法)。\n    (常规 DP 分析 O(n²) 即可)。\n-   空间复杂度：O(n) ( `dp` 数组) + O(m * k) ( `wordSet` )。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 39. 最长连续序列 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_longest_consecutive',
        'DESCRIPTION',
        'text',
        E'给定一个未排序的整数数组 `nums` ，找出数字**连续**的最长序列（不要求序列元素在原数组中连续）的长度。\n\n(例如：`[100, 4, 200, 1, 3, 2]` 中，最长连续序列是 `[1, 2, 3, 4]`，长度 4)。',
        NULL,
        1
    ),
    (
        'algo_longest_consecutive',
        'DESCRIPTION',
        'text',
        E'请你设计并实现时间复杂度为 **O(n)** 的算法解决此问题。',
        NULL,
        2
    ),
    (
        'algo_longest_consecutive',
        'SOLUTION',
        'text',
        E'**思路：哈希集合 (HashSet)**\n\nO(N) 的要求排除了“排序” (O(N log N))。\n\n朴素的 O(N²) 解法是：遍历 `num`，然后 `while(set.contains(num+1))` 检查。但 `[1,2,3,4,5]` 会导致 `1` 查 4 次, `2` 查 3 次...\n\nO(N) 的关键在于**避免重复计算**。\n\n**算法流程：**\n1.  **(去重)**：将 `nums` 中所有元素放入 `HashSet` ( `set` )。O(N)。\n2.  初始化 `maxLen = 0`。\n3.  **(遍历)**：再次遍历 `nums` 数组 (或 `set` ) 中的每个 `num`。\n4.  **(关键：寻找起点)**\n    **`if (!set.contains(num - 1))`**：\n    * (这个 `if` 是 O(N) 的关键。它确保我们只从一个“连续序列”的**起点** (如 `[1, 2, 3, 4]` 中的 `1`) 开始计算。对于 `2`, `3`, `4`，`set.contains(num - 1)` 都是 true，它们会被跳过)。\n\n    * **(开始计算)**\n        * `currentNum = num`\n        * `currentLen = 1`\n        * `while (set.contains(currentNum + 1))` (向后查找)：\n            * `currentNum++`\n            * `currentLen++`\n        * `maxLen = Math.max(maxLen, currentLen)`。\n\n5.  返回 `maxLen`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。`HashSet` 添加是 O(n)。第二次遍历，`if` 检查 O(1)，`while` 循环在整个运行过程中总共只会执行 O(n) 次 (因为起点只会被触发 N 次中的一部分)。\n-   空间复杂度：O(n)，`HashSet` 存储。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 40. 旋转图像 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_rotate_image',
        'DESCRIPTION',
        'text',
        E'给定一个 `n x n` 的二维矩阵 `matrix` 表示一个图像。\n\n请你将图像 **顺时针旋转 90 度**。',
        NULL,
        1
    ),
    (
        'algo_rotate_image',
        'DESCRIPTION',
        'text',
        E'你必须在 **原地** 旋转图像，这意味着你需要直接修改输入的二维矩阵。**请不要** 使用另一个矩阵来旋转图像。',
        NULL,
        2
    ),
    (
        'algo_rotate_image',
        'SOLUTION',
        'text',
        E'**思路：两次翻转 (O(1) 空间)**\n\n原地旋转 90 度 (顺时针)，可以通过两次“翻转”操作组合而成：\n\n1.  **沿“主对角线”翻转 (Transpose)** (左上到右下)\n    ( `(i, j)` -> `(j, i)` )\n2.  **沿“垂直中轴线”翻转 (Reverse Rows)** (左右翻转)\n\n(例如 `[[1,2],[3,4]]` )\n1. (Transpose) -> `[[1,3],[2,4]]`\n2. (Reverse) -> `[[3,1],[4,2]]` (旋转成功)\n\n**算法流程：**\n1.  **沿主对角线翻转 (Transpose)**：\n    * `for (int i = 0; i < n; i++)`：\n    * `for (int j = i + 1; j < n; j++)`：( `j` 必须从 `i + 1` 开始，否则会换回来)\n        * `swap(matrix[i][j], matrix[j][i])`。\n\n2.  **沿垂直中轴线翻转 (Reverse Rows)**：\n    * `for (int i = 0; i < n; i++)`：(遍历每一行)\n    * `reverse(matrix[i])` ( `reverse` 是一个辅助函数，使用双指针 `left`, `right` 翻转该行)。\n\n**复杂度分析：**\n-   时间复杂度：O(n²)。矩阵中的每个元素被访问两次。\n-   空间复杂度：O(1)。原地操作。',
        NULL,
        1
    );
-- -----------------------------------------------------
-- 版本 1.5: (续写) 填充 12 个新的热门算法题
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 1. 插入题目 (algorithm_problem)
-- -----------------------------------------------------

INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_container_most_water', '盛最多水的容器', 'Medium'),
    ('algo_is_valid_bst', '验证二叉搜索树', 'Medium'),
    ('algo_build_tree_pre_in', '从前序与中序遍历序列构造二叉树', 'Medium'),
    ('algo_subarray_sum_equals_k', '和为 K 的子数组', 'Medium'),
    ('algo_sort_colors', '颜色分类', 'Medium'),
    ('algo_find_duplicate_number', '寻找重复数', 'Medium'),
    ('algo_lis', '最长递增子序列', 'Medium'),
    ('algo_copy_list_random', '复制带随机指针的链表', 'Medium'),
    ('algo_min_window_substring', '最小覆盖子串', 'Hard'),
    ('algo_subtree_of_another_tree', '另一棵树的子树', 'Easy'),
    ('algo_rotting_oranges', '腐烂的橘子', 'Medium'),
    ('algo_search_rotated_array', '搜索旋转排序数组', 'Medium');

-- -----------------------------------------------------
-- 2. 插入内容块 (algorithm_content_block)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 41. 盛最多水的容器 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_container_most_water',
        'DESCRIPTION',
        'text',
        E'给定一个长度为 `n` 的整数数组 `height` 。有 `n` 条垂线，第 `i` 条线的两个端点是 `(i, 0)` 和 `(i, height[i])` 。',
        NULL,
        1
    ),
    (
        'algo_container_most_water',
        'DESCRIPTION',
        'text',
        E'找出其中的两条线，使得它们与 `x` 轴共同构成的容器可以容纳最多的水。\n\n返回容器可以储存的最大水量。\n\n(注意：你不能倾斜容器)。',
        NULL,
        2
    ),
    (
        'algo_container_most_water',
        'SOLUTION',
        'text',
        E'**思路：双指针法 (O(N))**\n\n这是 O(N) 的最优解。\n\n面积 `Area = min(height[left], height[right]) * (right - left)`。\n\n**算法流程：**\n1.  维护 `left = 0`, `right = n - 1` 两个指针，分别指向数组的开头和结尾 (最宽的可能)。\n2.  `maxArea = 0`。\n3.  `while (left < right)`:\n    * `currentHeight = Math.min(height[left], height[right])`\n    * `currentWidth = right - left`\n    * `currentArea = currentHeight * currentWidth`\n    * `maxArea = Math.max(maxArea, currentArea)`。\n\n    * **(关键：移动指针)**\n        面积受限于“**较短的板**”。\n        如果我们移动“较长的板”，`currentHeight` 不会变 (或变小)，`currentWidth` 变小，`Area` 必定变小。\n        为了找到 *可能* 更大的面积，我们必须移动“**较短的板**”，以期找到更高的 `height` 来弥补 `width` 的损失。\n\n    * `if (height[left] < height[right])`：\n        * `left++` (移动左短板)。\n    * `else`：\n        * `right--` (移动右短板)。\n\n4.  返回 `maxArea`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。`left` 和 `right` 指针最多移动 N 次。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 42. 验证二叉搜索树 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_is_valid_bst',
        'DESCRIPTION',
        'text',
        E'给你一个二叉树的根节点 `root` ，判断其是否是一个 **有效的** 二叉搜索树 (BST)。',
        NULL,
        1
    ),
    (
        'algo_is_valid_bst',
        'DESCRIPTION',
        'text',
        E'**有效 BST 定义如下：**\n-   节点的**左**子树只包含**小于**当前节点的数。\n-   节点的**右**子树只包含**大于**当前节点的数。\n-   所有左子树和右子树自身必须也是二叉搜索树。',
        NULL,
        2
    ),
    (
        'algo_is_valid_bst',
        'SOLUTION',
        'text',
        E'**思路：中序遍历 (In-order Traversal)**\n\nBST 的一个关键特性是“中序遍历” (左-根-右) 得到的是一个**严格递增**的序列。\n\n(注意：仅检查 `root.left.val < root.val` 是不够的，因为左子树的*所有*节点都必须小于 `root.val` )。\n\n**算法流程 (迭代或递归)：**\n我们可以使用一个变量 `prevVal` (使用 `Long` 类型来处理 `Integer.MIN_VALUE` 边界) 来记录前一个遍历到的节点的值。\n\n在递归中序遍历时：\n1.  **(遍历左子树)** 递归 `isValid(root.left)`。\n    * `if (!isValidBST(root.left)) return false;`\n2.  **(访问根节点)**\n    * 检查 `root.val` 是否 **小于等于** `prevVal`。\n    * `if (root.val <= prevVal)`，说明顺序错误 (不满足“严格递增”)，返回 `false`。\n3.  **(更新 prevVal)**\n    * `prevVal = root.val`。\n4.  **(遍历右子树)**\n    * `return isValidBST(root.right);`\n\n**(替代思路：递归 + 范围)**\n`isValid(node, min, max)` 检查 `node.val` 是否在 `(min, max)` 范围内。\n-   `isValid(root, null, null)`\n-   `isValid(root.left, min, root.val)`\n-   `isValid(root.right, root.val, max)`\n\n**复杂度分析 (中序遍历)：**\n-   时间复杂度：O(n)，n 为节点数。\n-   空间复杂度：O(h)，h 为树高（递归栈深度）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 43. 从前序与中序遍历序列构造二叉树 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_build_tree_pre_in',
        'DESCRIPTION',
        'text',
        E'给定两个整数数组 `preorder` (前序遍历) 和 `inorder` (中序遍历)，请你构造并返回这棵 二叉树。\n\n(假设树中没有重复的元素)',
        NULL,
        1
    ),
    (
        'algo_build_tree_pre_in',
        'SOLUTION',
        'text',
        E'**思路：递归 + 哈希表**\n\n1.  **(核心特性)**\n    * **`preorder`** (根-左-右): `preorder[0]` 永远是当前子树的 `root`。\n    * **`inorder`** (左-根-右): 在 `inorder` 中找到这个 `root` ( `inorder[inRootIdx]` )。`inorder` 中 `inRootIdx` **左边**的所有元素都属于 `root` 的左子树，**右边**的都属于右子树。\n\n2.  **(优化)**\n    为了能 O(1) 时间在 `inorder` 中找到 `root` 的索引 `inRootIdx`，我们先把 `inorder` 存入 `Map<Integer, Integer> (val -> index)`。\n\n3.  **递归函数 `dfs(preStart, inStart, inEnd)`**\n    ( `preStart` 是 `preorder` 中的索引；`inStart`, `inEnd` 是 `inorder` 中的范围)\n\n    * **(基线)** `if (inStart > inEnd)` (空子树)，返回 `null`。\n\n    * **(找根)**\n        * `rootVal = preorder[preStart]` ( `preStart` 需要一个全局变量 `preIndex` 来递增，如示例代码所示)。\n        * `root = new TreeNode(rootVal)`。\n\n    * **(分割)**\n        * `inRootIdx = map.get(rootVal)`。\n        * `leftSubtreeSize = inRootIdx - inStart` (左子树的节点数)。\n\n    * **(递归)**\n        * `root.left = dfs(preStart + 1, inStart, inRootIdx - 1)`\n        * `root.right = dfs(preStart + leftSubtreeSize + 1, inRootIdx + 1, inEnd)`\n        ( `preIndex` 的递增顺序自动处理了 `preStart` 的偏移)\n\n    * 返回 `root`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。`HashMap` O(1) 查找，每个节点处理一次。\n-   空间复杂度：O(n)，`HashMap` 和递归栈深度。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 44. 和为 K 的子数组 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_subarray_sum_equals_k',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums` 和一个整数 `k` ，请你统计并返回 该数组中和为 `k` 的**连续子数组**的个数 。\n\n(数组中可能包含负数)',
        NULL,
        1
    ),
    (
        'algo_subarray_sum_equals_k',
        'SOLUTION',
        'text',
        E'**思路：前缀和 + 哈希表**\n\nO(N) 的最优解。(O(N²) 朴素解法是 `for i, for j` 计算 `sum(i..j)` )。\n\n1.  **前缀和 (Prefix Sum)**：\n    * `prefixSum[i]` 是 `nums[0...i]` 的和。\n    * `nums[i...j]` (子数组 `i` 到 `j` 的和) = `prefixSum[j] - prefixSum[i-1]`。\n\n2.  **转换问题**：\n    * 我们要求 `sum(i..j) == k`。\n    * 即 `prefixSum[j] - prefixSum[i-1] == k`。\n    * 变形：`prefixSum[i-1] == prefixSum[j] - k`。\n\n3.  **算法思路**：\n    * 我们遍历 `nums`，计算 `currentSum` (即 `prefixSum[j]`)。\n    * 我们去哈希表中查找，有多少个 `i-1` 满足 `prefixSum[i-1] == currentSum - k`。\n\n4.  **算法流程**：\n    * `count = 0` (结果), `currentSum = 0`。\n    * `Map<Integer, Integer> map` ( 存储 `prefixSum` -> 出现次数 )。\n\n    * **(初始化)** `map.put(0, 1)`。\n        (这至关重要，它代表 `prefixSum[-1]`。如果 `currentSum == k`，我们需要 `complement = 0`，`map.get(0)` 必须是 1)。\n\n    * 遍历 `num` in `nums`:\n        * `currentSum += num` (即 `prefixSum[j]`)。\n        * `complement = currentSum - k`。\n        * (查找 `prefixSum[i-1]`) `count += map.getOrDefault(complement, 0)`。\n        * (将 `prefixSum[j]` 存入 map)\n            `map.put(currentSum, map.getOrDefault(currentSum, 0) + 1)`。\n\n5.  返回 `count`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。一次遍历，`HashMap` O(1)。\n-   空间复杂度：O(n)，`HashMap` 最多存储 n 个前缀和。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 45. 颜色分类 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_sort_colors',
        'DESCRIPTION',
        'text',
        E'给定一个包含红色、白色和蓝色、共 `n` 个元素的数组 `nums` ，**原地**对它们进行排序。\n\n使得相同颜色的元素相邻，并按照 **红色、白色、蓝色** 顺序排列。',
        NULL,
        1
    ),
    (
        'algo_sort_colors',
        'DESCRIPTION',
        'text',
        E'我们使用整数 `0`、 `1` 和 `2` 分别表示红色、白色和蓝色。\n\n你必须在不使用库的 `sort` 函数的情况下解决这个问题。(要求：**仅遍历一次**)',
        NULL,
        2
    ),
    (
        'algo_sort_colors',
        'SOLUTION',
        'text',
        E'**思路：三指针 (荷兰国旗问题)**\n\n这是 O(N) 时间, O(1) 空间, 仅遍历一次的解法。\n\n我们需要维护三个指针，将数组分为三个区域：\n-   `p0` ( `[0...p0]` 区域全是 0 )。`p0 = 0`。\n-   `p2` ( `[p2...n-1]` 区域全是 2 )。`p2 = n - 1`。\n-   `curr` ( `[p0...curr]` 是 0 和 1, `(curr...p2)` 是未知 )。`curr = 0`。\n\n(注：`p0` 也可以定义为 "0 区的*末尾*的下一个"，`p2` 为 "2 区的*开头*的前一个"。示例代码使用 `p0` 指向 0 区末尾，`p2` 指向 2 区开头)。\n\n**算法流程 (以 `p0`, `p2` 指向末尾/开头为例)：**\n1.  `p0 = 0`, `curr = 0`, `p2 = n - 1`。\n2.  `while (curr <= p2)` ( `p2` 右侧已排好序, 故 `curr` 不应超过 `p2` )：\n\n    * **`if (nums[curr] == 0)`**：\n        * `swap(nums[curr], nums[p0])` (将 0 换到 `p0` 位置)。\n        * `curr++`。\n        * `p0++`。\n        ( `curr` 必须 `++`，因为从 `p0` 换回来的一定是 `1` (或 `0`，如果 `curr==p0`)，`curr` 已检查过)。\n\n    * **`if (nums[curr] == 2)`**：\n        * `swap(nums[curr], nums[p2])` (将 2 换到 `p2` 位置)。\n        * `p2--`。\n        * ( **注意：`curr` *不*增加**，因为从 `p2` 换回来的 `nums[curr]` 尚未被 `curr` 检查过，可能是 0, 1, 2)。\n\n    * **`if (nums[curr] == 1)`**：\n        * ( `1` 就在它该在的中间区域)\n        * `curr++`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。`curr` 指针最多遍历 n 次。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 46. 寻找重复数 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_find_duplicate_number',
        'DESCRIPTION',
        'text',
        E'给定一个包含 `n + 1` 个整数的数组 `nums` ，其数字都在 `[1, n]` 范围内（含 1 和 n），可知**至少存在一个重复的整数**。',
        NULL,
        1
    ),
    (
        'algo_find_duplicate_number',
        'DESCRIPTION',
        'text',
        E'假设 `nums` 中**只存在一个重复的整数**，返回 这个重复的数 。\n\n**要求：**\n1.  **不修改** 数组 `nums`。\n2.  只使用 **O(1)** 的额外空间。',
        NULL,
        2
    ),
    (
        'algo_find_duplicate_number',
        'SOLUTION',
        'text',
        E'**思路：快慢指针 (Floyd 判圈法)**\n\nO(1) 空间和 O(N) 时间的要求，排除了哈希表和排序。\n\n我们可以将 `nums` 数组视为一个“**链表**”。\n`nums` 中的 *索引* `i` 指向 `nums[i]`。\n\n例如 `nums = [1, 3, 4, 2, 2]` (n=4, 索引 0-4, 值 1-4)\n-   `0 -> nums[0] = 1`\n-   `1 -> nums[1] = 3`\n-   `3 -> nums[3] = 2`\n-   `2 -> nums[2] = 4`\n-   `4 -> nums[4] = 2`\n\n链表为： `0 -> 1 -> 3 -> 2 -> 4 -> 2 -> 4 -> ...`\n\n由于 `nums[2] = 4` 和 `nums[4] = 2`，在 `2` 和 `4` 之间形成环。`2` 是环的入口。\n“重复数” `2` 是导致这个环的入口点。\n\n这个问题被转换为了 (142. 环形链表 II)：找到链表的环的入口。\n\n**算法流程：**\n1.  **(阶段 1：找到相遇点)** (同 141. 环形链表)\n    * `slow = nums[0]` (走一步)\n    * `fast = nums[nums[0]]` (走两步)\n    * `while (slow != fast)` 循环：\n        * `slow = nums[slow]`\n        * `fast = nums[nums[fast]]`\n\n2.  **(阶段 2：找到环的入口)** (同 142. 环形链表 II)\n    * 将 `slow` 重置回 `nums[0]` (起点)。\n    * ( `fast` 保持在相遇点)。\n    * `while (slow != fast)` 循环：\n        * `slow = nums[slow]` (走一步)\n        * `fast = nums[fast]` (走一步)\n\n3.  当它们再次相遇时，相遇点 `slow` (或 `fast`) 就是重复的数 (环的入口)。\n4.  返回 `slow`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 47. 最长递增子序列 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_lis',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums` ，找到其中**最长严格递增子序列**的长度。\n\n**子序列**：通过删除(或不删除)数组中的元素而不改变其余元素顺序得到的序列。\n(例如 `[3,6,2,7]` 是 `[0,3,1,6,2,2,7]` 的子序列)',
        NULL,
        1
    ),
    (
        'algo_lis',
        'SOLUTION',
        'text',
        E'**思路：动态规划 (O(N^2))**\n\n这是最基础的 DP 解法。(注：最优解是 O(N log N) 的“耐心排序法”，但 O(N^2) 已足够)。\n\n1.  **定义 `dp` 数组**：\n    * `dp[i]` 表示：以 `nums[i]` **结尾** 的最长递增子序列的长度。\n\n2.  **初始化**：\n    * `Arrays.fill(dp, 1)`。\n    * (因为 `nums[i]` 自身至少构成长度为 1 的子序列)。\n\n3.  **状态转移**：\n    * `for (i = 1 to n-1)`：( `dp[0]` 永远是 1)\n        * `for (j = 0 to i-1)`：(检查 `i` 之前的所有 `j`)\n            * `if (nums[i] > nums[j])` ( `nums[i]` 可以接在 `nums[j]` 后面)：\n                * `dp[i] = Math.max(dp[i], dp[j] + 1)`\n                * ( `dp[i]` 取“不接” ( `dp[i]` 原始值 1) 和“接” ( `dp[j] + 1` ) 中的较大值)。\n\n4.  **结果**：\n    * 遍历 `dp` 数组，找到其中的最大值 ( `max(dp[0...n-1])` ) 作为答案。\n    * (注意：答案 *不是* `dp[n-1]`，因为 LIS 不一定以 `nums[n-1]` 结尾)。\n\n**复杂度分析：**\n-   时间复杂度：O(n²)，两层 `for` 循环。\n-   空间复杂度：O(n)，`dp` 数组。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 48. 复制带随机指针的链表 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_copy_list_random',
        'DESCRIPTION',
        'text',
        E'给你一个长度为 `n` 的链表，每个节点包含一个额外增加的随机指针 `random` ，该指针可以指向链表中的任何节点或 `null`。\n\n构造这个链表的 **深拷贝 (Deep Copy)**。',
        NULL,
        1
    ),
    (
        'algo_copy_list_random',
        'SOLUTION',
        'text',
        E'**思路：哈希表 (O(N) 空间)**\n\n(O(1) 空间的解法是通过原地修改链表，但哈希表法更直观)。\n\n我们需要一个 `Map` 来建立“**原始节点**”到“**新创建的拷贝节点**”之间的映射。\n\n`Map<Node, Node> map`：\n-   `Key`: 原始节点 (e.g., `OldNode_A`)\n-   `Value`: 新创建的拷贝节点 (e.g., `NewNode_A`)\n\n**算法流程：**\n1.  **(第一次遍历：复制所有节点)**\n    * 遍历原始链表，`curr = head`。\n    * 对于每个 `curr`，创建 `new Node(curr.val)`。\n    * 存入 `map.put(curr, newNode)`。\n\n2.  **(第二次遍历：连接 `next` 和 `random` 指针)**\n    * 再次遍历原始链表，`curr = head`。\n    * 获取 `newNode = map.get(curr)`。\n\n    * **连接 `next`**：\n        `newNode.next = map.get(curr.next)`\n        ( `map.get(curr.next)` 会从 Map 中找到 `curr.next` 对应的“新节点”。如果 `curr.next == null`，`map.get(null)` 会返回 `null`，符合要求)。\n\n    * **连接 `random`**：\n        `newNode.random = map.get(curr.random)`\n        ( `map.get(curr.random)` 同理)。\n\n3.  **返回**：\n    * 返回 `map.get(head)` (即新链表的头节点)。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，两次遍历。\n-   空间复杂度：O(n)，`HashMap` 存储。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 49. 最小覆盖子串 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_min_window_substring',
        'DESCRIPTION',
        'text',
        E'给你一个字符串 `s` 、一个字符串 `t` 。\n\n返回 `s` 中涵盖 `t` **所有字符**的**最小子串**。\n\n如果 `s` 中不存在涵盖 `t` 所有字符的子串，则返回空字符串 `""` 。\n\n(注意：`t` 中可能有重复字符，例如 `t="AAB"`，子串必须包含 2 个 A 和 1 个 B)',
        NULL,
        1
    ),
    (
        'algo_min_window_substring',
        'SOLUTION',
        'text',
        E'**思路：滑动窗口 + 双哈希表 (计数器)**\n\n这是滑动窗口的经典难题。\n\n1.  **( `t` 哈希)** `tMap`：( `Map<Character, Integer>` 或 `int[128]` ) 统计 `t` 中所需字符的频率。\n2.  **( `s` 哈希)** `sMap` (或 `windowMap`)：统计 `s` 中“窗口”内字符的频率。\n3.  **(窗口)** `left = 0`, `right = 0`。\n4.  **(匹配)**\n    * `required = tMap.size()` ( `t` 中*不同*字符的种类)。\n    * `match = 0` (表示 `windowMap` 中有多少*种*字符已满足 `tMap` 的需求)。\n5.  (记录答案) `minLen = Infinity`, `start = 0`。\n\n**算法流程：**\n1.  **扩大 `right`** ( `right` 从 0 遍历到 n-1 )：\n    * `cRight = s.charAt(right)`。\n    * `windowMap[cRight]++`。\n    * (检查匹配) `if (tMap.containsKey(cRight) && windowMap.get(cRight).equals(tMap.get(cRight)))`：\n        * `match++`。\n\n2.  **收缩 `left`** ( `while (match == required)` )：\n    * ( `while` 循环：因为只要 `match == required`，我们就 *必须* 收缩 `left` 以寻找“最小”子串)。\n\n    * **(a) 更新答案**：\n        * `if (right - left + 1 < minLen)`：\n        * `minLen = right - left + 1`\n        * `start = left`\n\n    * **(b) 移出 `left`**：\n        * `cLeft = s.charAt(left)`。\n        * `windowMap[cLeft]--`。\n        * (检查是否破坏匹配) `if (tMap.containsKey(cLeft) && windowMap.get(cLeft) < tMap.get(cLeft))`：\n            * `match--`。\n\n    * **(c) 移动 `left`**：`left++`。\n\n3.  返回 `(minLen == Infinity) ? "" : s.substring(start, start + minLen)`。\n\n**复杂度分析：**\n-   时间复杂度：O(N + M)，N 是 `s` 长度，M 是 `t` 长度。`left` 和 `right` 都只遍历一次 O(N)。\n-   空间复杂度：O(K)，K 是字符集大小 ( `HashMap` 或 `int[128]` )。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 50. 另一棵树的子树 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_subtree_of_another_tree',
        'DESCRIPTION',
        'text',
        E'给你两棵二叉树 `root` 和 `subRoot` 。\n\n检验 `root` 中是否包含一个与 `subRoot` 具有**相同结构和节点值**的子树。',
        NULL,
        1
    ),
    (
        'algo_subtree_of_another_tree',
        'SOLUTION',
        'text',
        E'**思路：双重 DFS (递归)**\n\n我们需要解决两个问题：\n1.  ( `isSameTree` ) 如何判断两棵树*完全*相同？\n2.  ( `isSubtree` ) 如何遍历 `root` 中的*每一个*节点，并用 (1) 来检查？\n\n**1. `isSameTree(p, q)` 辅助函数**\n(同 LeetCode 100. 相同的树)\n-   `if (p == null && q == null)` 返回 `true`。\n-   `if (p == null || q == null || p.val != q.val)` 返回 `false`。\n-   `return isSameTree(p.left, q.left) && isSameTree(p.right, q.right)`。\n\n**2. `isSubtree(root, subRoot)` 主函数**\n遍历 `root` 树中的 *每一个* 节点 `node`，检查以 `node` 为根的子树是否 `isSameTree` `subRoot`。\n\n-   **(基线 - 失败)** `if (root == null)` ( `root` 遍历完了)，返回 `false`。\n\n-   **(基线 - subRoot 为空)** `if (subRoot == null)` 返回 `true` (空子树总是子树)。(注：此基线通常被 `isSameTree` 包含了)。\n\n-   **(检查)** `if (isSameTree(root, subRoot))` (检查 `root` *自己*是否匹配)，返回 `true`。\n\n-   **(递归)**\n    `return isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot)`\n    (如果 `root` 自己不匹配，就去 `root` 的左子树 或 右子树 中寻找匹配 `subRoot` 的起点)。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n)，m 是 `root` 节点数, n 是 `subRoot` 节点数。最坏情况 `root` 的每个节点都要调用 `isSameTree` (O(n))。\n-   空间复杂度：O(h_m + h_n)，递归栈深度。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 51. 腐烂的橘子 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_rotting_oranges',
        'DESCRIPTION',
        'text',
        E'在给定的 `m x n` 网格 `grid` 中，每个单元格可以有三个值：\n-   `0` 代表空单元格；\n-   `1` 代表新鲜橘子；\n-   `2` 代表腐烂橘子。',
        NULL,
        1
    ),
    (
        'algo_rotting_oranges',
        'DESCRIPTION',
        'text',
        E'每分钟，腐烂的橘子 周围 4 个方向上相邻 的新鲜橘子都会腐烂。\n\n返回 直到单元格中没有新鲜橘子为止所必须经过的**最小分钟数**。\n\n如果不可能（某些新鲜橘子永远不会腐烂），返回 `-1` 。',
        NULL,
        2
    ),
    (
        'algo_rotting_oranges',
        'SOLUTION',
        'text',
        E'**思路：多源 BFS (广度优先搜索)**\n\n求“最短时间”或“最少步数”，是 BFS 的经典应用。\n\n由于腐烂是同时开始的 ( `[2, 1, 1]` -> `[2, 2, 2]` )，我们需要**多源 BFS** (Multi-Source BFS)。\n\n**算法流程：**\n1.  **(初始化)**\n    * `Queue<int[]> queue` (存储 `(i, j)` 坐标)。\n    * `freshOranges = 0`。\n    * 遍历 `grid`：\n        * 将所有 `2` (腐烂橘子) 的坐标 `(i, j)` 加入 `queue`。\n        * 统计 `freshOranges` ( `1` 的数量)。\n\n2.  **(边界)** `if (freshOranges == 0)` 返回 `0`。\n\n3.  **(BFS 按层遍历)**\n    * `minutes = 0`。\n    * `dirs = {{0,1}, ...}` (4 个方向)。\n    * `while (!queue.isEmpty() && freshOranges > 0)`：\n        * (按层遍历) `size = queue.size()`。\n        * `for (i = 0 to size-1)`：\n            * `cell = queue.poll()`。\n            * 遍历 `cell` 的 4 个方向 `(ni, nj)`。\n            * `if ((ni, nj)` 越界，或 `grid[ni][nj]` 不是 `1` (新鲜)，`continue`)。\n            * (腐烂它)\n                * `grid[ni][nj] = 2` (标记访问)。\n                * `freshOranges--`。\n                * `queue.add((ni, nj))` (加入下一轮)。\n        * (这一层遍历完，时间+1)\n            `if (!queue.isEmpty()) minutes++;` (或者 `minutes++` 在 `while` 开始时，`return minutes-1`)。\n            (如示例代码：`minutes++` 在 `while` 循环末尾，`while` 结束后 `freshOranges == 0` 才返回 `minutes`)。\n\n4.  **(结果)**\n    * `return (freshOranges == 0) ? minutes : -1` (如果 `freshOranges` 仍 > 0，说明有无法到达的橘子)。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n)，每个单元格最多入队出队一次。\n-   空间复杂度：O(m * n)，`queue` 最多存储所有单元格。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 52. 搜索旋转排序数组 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_search_rotated_array',
        'DESCRIPTION',
        'text',
        E'整数数组 `nums` 按升序排列，数组中的值 **互不相同** 。\n\n在传递给函数之前，`nums` 在预先未知的某个下标 `k` 上进行了 **旋转**。\n(例如 `[0,1,2,4,5,6,7]` 旋转后可能变为 `[4,5,6,7,0,1,2]` )。',
        NULL,
        1
    ),
    (
        'algo_search_rotated_array',
        'DESCRIPTION',
        'text',
        E'给你 **旋转后** 的数组 `nums` 和一个整数 `target` ，如果 `nums` 中存在这个目标值 `target` ，则返回它的下标，否则返回 `-1` 。\n\n你必须设计一个时间复杂度为 **O(log n)** 的算法。',
        NULL,
        2
    ),
    (
        'algo_search_rotated_array',
        'SOLUTION',
        'text',
        E'**思路：二分查找变体**\n\nO(log n) 提示我们必须使用二分查找。旋转数组的特性是：它总是由**两个**有序的部分组成 (或一个，如果未旋转)。\n\n关键在于：当 `nums[mid]` 不是 `target` 时，我们如何判断 `target` 在 `mid` 的左边还是右边？\n\n**算法流程：**\n1.  `left = 0`, `right = n - 1`。\n2.  `while (left <= right)`：\n    * `mid = ...`\n    * `if (nums[mid] == target) return mid`。\n\n    * **(核心：判断 `mid` 在哪个有序区)**\n        ( `nums[left]` ... `mid` ... `nums[right]` )\n\n    * **情况 1：`if (nums[mid] >= nums[left])`**\n        ( `mid` 落在“左半边有序区” ( `[4,5,6,7]` 部分))\n        * **(A)** `if (target >= nums[left] && target < nums[mid])`\n            ( `target` 在 `mid` 左侧 ( `[4...7]` 之间))，`right = mid - 1`。\n        * **(B)** 否则 ( `target` 在 `mid` 右侧 ( `[0...2]` 部分))，`left = mid + 1`。\n\n    * **情况 2：`else` ( `nums[mid] < nums[left]` )**\n        ( `mid` 落在“右半边有序区” ( `[0,1,2]` 部分))\n        * **(A)** `if (target > nums[mid] && target <= nums[right])`\n            ( `target` 在 `mid` 右侧 ( `[0...2]` 之间))，`left = mid + 1`。\n        * **(B)** 否则 ( `target` 在 `mid` 左侧 ( `[4...7]` 部分))，`right = mid - 1`。\n\n3.  循环结束，返回 -1。\n\n**复杂度分析：**\n-   时间复杂度：O(log n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );
-- 版本 1.6: (续写) 填充 12 个新的热门算法题
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 1. 插入题目 (algorithm_problem)
-- -----------------------------------------------------

INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_level_order_traversal', '二叉树的层序遍历', 'Medium'),
    ('algo_move_zeroes', '移动零', 'Easy'),
    ('algo_unique_paths', '不同路径', 'Medium'),
    ('algo_lru_cache2', 'LRU 缓存', 'Medium'),
    ('algo_set_matrix_zeroes', '矩阵置零', 'Medium'),
    ('algo_min_path_sum', '最小路径和', 'Medium'),
    ('algo_palindrome_linked_list', '回文链表', 'Easy'),
    ('algo_decode_ways', '解码方法', 'Medium'),
    ('algo_merge_k_sorted_lists', '合并K个升序链表', 'Hard'),
    ('algo_path_sum_3', '路径总和 III', 'Medium'),
    ('algo_reverse_nodes_k_group', 'K 个一组翻转链表', 'Hard'),
    ('algo_find_k_closest', '找到 K 个最接近的元素', 'Medium');

-- -----------------------------------------------------
-- 2. 插入内容块 (algorithm_content_block)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 53. 二叉树的层序遍历 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_level_order_traversal',
        'DESCRIPTION',
        'text',
        E'给你二叉树的根节点 `root` ，返回其节点值的 **层序遍历** 。 \n\n（即逐层地，从左到右访问所有节点）。',
        NULL,
        1
    ),
    (
        'algo_level_order_traversal',
        'SOLUTION',
        'text',
        E'**思路：广度优先搜索 (BFS)**\n\n层序遍历是 BFS 的标准应用。\n\n**算法流程：**\n1.  使用 `Queue<TreeNode>` (例如 `LinkedList`)。\n2.  `result` ( `List<List<Integer>>` )。\n3.  (基线) `if (root == null)` 返回 `result`。\n4.  `queue.add(root)`。\n5.  `while (!queue.isEmpty())`：\n    * **(关键) `levelSize = queue.size()`**。\n        在内循环开始前，必须记录当前层的节点数 ( `levelSize` )。\n\n    * 创建 `currentLevel = new ArrayList<>()`。\n\n    * **`for (i = 0 to levelSize - 1)`**：(只遍历当前层的 `levelSize` 个节点)\n        * `node = queue.poll()`。\n        * `currentLevel.add(node.val)`。\n\n        * (将*下一层*的节点入队)\n        * `if (node.left != null) queue.add(node.left)`。\n        * `if (node.right != null) queue.add(node.right)`。\n\n    * `result.add(currentLevel)`。\n\n6.  返回 `result`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，n 为节点数。\n-   空间复杂度：O(w)，w 是树的最大宽度（ `queue` 的最大大小）。最坏 O(n) (满二叉树)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 54. 移动零 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_move_zeroes',
        'DESCRIPTION',
        'text',
        E'给定一个数组 `nums`，编写一个函数将所有 `0` 移动到数组的末尾，同时保持**非零元素的相对顺序**。',
        NULL,
        1
    ),
    (
        'algo_move_zeroes',
        'DESCRIPTION',
        'text',
        E'**要求：** 必须在不复制数组的情况下**原地**对数组进行操作。',
        NULL,
        2
    ),
    (
        'algo_move_zeroes',
        'SOLUTION',
        'text',
        E'**思路：双指针 (快慢指针/单指针)**\n\nO(N) 时间, O(1) 空间。关键在于保持“非零元素的相对顺序”。\n\n我们可以使用一个指针 `insertPos` (或 `slow`)，它指向“**下一个非零元素应该被放置的位置**”。\n\n**算法流程 (单指针 + 填充)：**\n1.  `insertPos = 0`。\n    ( `[0...insertPos]` 区域将存储所有已遍历的非零元素)。\n\n2.  **(第一次遍历：把所有非零元素前移)**\n    * `for (int i = 0; i < n; i++)` ( `i` 是快指针)：\n        * `if (nums[i] != 0)`：\n            * `nums[insertPos] = nums[i]` (将非零元素 `nums[i]` 放到 `insertPos` 位置)。\n            * (可选 `if (i != insertPos) nums[i] = 0;` 但没必要)\n            * `insertPos++`。\n    * (例如 `[0,1,0,3,12]` 遍历后变为 `[1,3,12,3,12]`，`insertPos = 3` )\n\n3.  **(第二次遍历：填充末尾的 0)**\n    * ( `[insertPos...n-1]` 区域必须是 0)\n    * `while (insertPos < n)`：\n        * `nums[insertPos] = 0`。\n        * `insertPos++`。\n\n**(优化：Swap 法)**\n1. `slow = 0`。\n2. `for (fast = 0 to n-1)`:\n   `if (nums[fast] != 0)`:\n      `swap(nums[slow], nums[fast])`\n      `slow++`\n(这种方法虽然 O(N)，但“非零元素”的 `swap` 次数可能较多，而“填充法”的写操作次数最少)。\n\n**复杂度分析 (填充法)：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 55. 不同路径 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_unique_paths',
        'DESCRIPTION',
        'text',
        E'一个机器人位于一个 `m x n` 网格的左上角 （ `(0, 0)` ）。\n\n机器人每次只能**向下**或者**向右**移动一步。\n\n机器人试图达到网格的右下角（ `(m-1, n-1)` ）。',
        NULL,
        1
    ),
    (
        'algo_unique_paths',
        'DESCRIPTION',
        'text',
        E'问总共有多少条不同的路径？',
        NULL,
        2
    ),
    (
        'algo_unique_paths',
        'SOLUTION',
        'text',
        E'**思路：动态规划**\n\n1.  **定义 `dp[i][j]`**：\n    * `dp[i][j]` 表示：从 (0, 0) 到达 (i, j) 的路径数。\n\n2.  **(状态转移)**：\n    * 由于只能“向下”或“向右”，要到达 (i, j)，只能从 (i-1, j) (上面) 或 (i, j-1) (左面) 来。\n    * `dp[i][j] = dp[i-1][j] + dp[i][j-1]`。\n\n3.  **(初始化)**：\n    * `dp` 数组第一行 (`dp[0][j]`) 和第一列 (`dp[i][0]`) 都初始化为 1。\n    * (因为到达 `(0, j)` 只有一条路 (一直向右)，到达 `(i, 0)` 也只有一条路 (一直向下))。\n\n4.  **返回** `dp[m-1][n-1]`。\n\n**空间优化 (滚动数组 O(N))：**\n我们发现 `dp[i][j]` 只依赖于 `i` 和 `i-1` (上一行)。\n我们可以使用一个 O(N) 的一维数组 `dp[j]` (代表 *当前行* )。\n\n1.  `int[] dp = new int[n]`。\n2.  (初始化第一行) `Arrays.fill(dp, 1)`。\n3.  `for (i = 1 to m-1)` (遍历行)：\n    * `for (j = 1 to n-1)` (遍历列)：\n        * `dp[j] (新) = dp[j] (旧) + dp[j-1] (新)`\n        * ( `dp[j] (新)` 是 `dp[i][j]` )\n        * ( `dp[j] (旧)` 是 `dp[i-1][j]` )\n        * ( `dp[j-1] (新)` 是 `dp[i][j-1]` )\n        * ( `dp[0]` 始终为 1，无需修改)\n4.  返回 `dp[n-1]`。\n\n**复杂度分析 (空间优化)：**\n-   时间复杂度：O(m * n)。\n-   空间复杂度：O(n)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 56. LRU 缓存 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_lru_cache2',
        'DESCRIPTION',
        'text',
        E'请你设计并实现一个满足 **LRU (最近最少使用)** 缓存约束的数据结构。\n\n(LRU: 当缓存容量满时，必须移除**最久未被访问**的数据)。',
        NULL,
        1
    ),
    (
        'algo_lru_cache2',
        'DESCRIPTION',
        'text',
        E'实现 `LRUCache` 类：\n- `LRUCache(int capacity)`\n- `int get(int key)`：如果 `key` 存在，返回 `value` (并更新为“最近使用”)，否则返回 -1。\n- `void put(int key, int value)`：如果 `key` 存在，更新 `value` (并更新为“最近使用”)。如果 `key` 不存在，插入。如果容量满，先移除“最久未使用”的，再插入。\n\n**要求：** `get` 和 `put` 操作的平均时间复杂度为 **O(1)**。',
        NULL,
        2
    ),
    (
        'algo_lru_cache2',
        'SOLUTION',
        'text',
        E'**思路：哈希表 + 双向链表**\n\nO(1) 的 `get` (查找) 提示我们用 **哈希表 (HashMap)**。\nO(1) 的 `put` (插入/删除) 提示我们用 **链表**。\n\n为了 O(1) 删除“最久未使用” ( `tail` ) 和 O(1) 移动“最近使用” ( `head` )，我们必须使用**双向链表 (Doubly Linked List)**。\n\n**数据结构：**\n1.  **(哈希表)** `Map<Integer, DLinkedNode> map`：\n    * `Key`: `key`。\n    * `Value`: “双向链表节点”的**引用** ( `DLinkedNode` )。\n    ( `DLinkedNode` 内部存 `key, value, prev, next` )\n2.  **(双向链表)** `head` (最近使用) -> ... -> `tail` (最久未使用)。\n    (使用 `dummyHead` 和 `dummyTail` 哨兵节点简化边界处理)。\n\n**`get(key)` 流程：**\n1.  `node = map.get(key)`。\n2.  `if (node == null)` 返回 -1。\n3.  (关键) `moveToHead(node)` (将 `node` 从链表中摘下，移到 `head` )。\n4.  返回 `node.value`。\n\n**`put(key, value)` 流程：**\n1.  `node = map.get(key)`。\n2.  `if (node != null)` (存在)：\n    * 更新 `node.value = value`。\n    * `moveToHead(node)`。\n3.  `else` (不存在)：\n    * 创建 `newNode`。\n    * `map.put(key, newNode)`。\n    * `addToHead(newNode)`。\n    * (检查容量) `if (map.size() > capacity)`：\n        * `removedNode = removeTail()`。\n        * `map.remove(removedNode.key)` (从哈希表中删除)。\n\n**(Java 简便解法：使用 `LinkedHashMap`)**\nJava 的 `LinkedHashMap` 内部已经实现了哈希表+双向链表。我们只需要：\n1.  构造函数 `super(capacity, 0.75f, true)` ( `true` 表示 access-order, 即 `get()` 操作也会更新顺序)。\n2.  重写 `removeEldestEntry` 方法：`return size() > capacity;`。\n\n**复杂度分析：**\n-   时间复杂度：O(1) ( `get` 和 `put` )。\n-   空间复杂度：O(capacity)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 57. 矩阵置零 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_set_matrix_zeroes',
        'DESCRIPTION',
        'text',
        E'给定一个 `m x n` 的矩阵 `matrix` ，如果一个元素为 `0` ，则将其所在**行**和**列**的所有元素都设为 `0` 。',
        NULL,
        1
    ),
    (
        'algo_set_matrix_zeroes',
        'DESCRIPTION',
        'text',
        E'请使用 **原地** 算法。\n\n(O(m+n) 空间解法：使用两个 `Set` ( `rowsToZero`, `colsToZero` ) 记录。)\n\n(O(1) 空间解法？)',
        NULL,
        2
    ),
    (
        'algo_set_matrix_zeroes',
        'SOLUTION',
        'text',
        E'**思路：O(1) 空间优化 (利用第一行/列)**\n\n我们可以利用矩阵的**“第一行”**和**“第一列”**作为标记位，来代替 O(M+N) 的 `Set`。\n\n**算法流程：**\n1.  **(特殊标记)**\n    * `isFirstRowZero = false`, `isFirstColZero = false`。\n    * (检查第一行) `for (j)`: `if (matrix[0][j] == 0) isFirstRowZero = true;`\n    * (检查第一列) `for (i)`: `if (matrix[i][0] == 0) isFirstColZero = true;`\n    (注：示例代码用了更巧妙的方式，`isFirstColZero` 单独，`matrix[0][0]` 标记第一行)。\n\n2.  **(标记)**\n    * 遍历 ( `i=1` to `m-1`, `j=1` to `n-1` ) ( **跳过第一行/列** )。\n    * 如果 `matrix[i][j] == 0`：\n        * `matrix[i][0] = 0` (标记第 i 行)\n        * `matrix[0][j] = 0` (标记第 j 列)\n\n3.  **(置零)**\n    * 再次遍历 ( `i=1` to `m-1`, `j=1` to `n-1` )。\n    * 如果 `matrix[i][0] == 0` 或 `matrix[0][j] == 0` (检查标记)：\n        * `matrix[i][j] = 0`。\n\n4.  **(处理第一行/列)**\n    * `if (isFirstRowZero)`，置零第一行。\n    * `if (isFirstColZero)`，置零第一列。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 58. 最小路径和 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_min_path_sum',
        'DESCRIPTION',
        'text',
        E'给定一个包含非负整数的 `m x n` 网格 `grid` ，请找出一条从左上角到右下角的路径，使得路径上的数字总和为**最小**。',
        NULL,
        1
    ),
    (
        'algo_min_path_sum',
        'DESCRIPTION',
        'text',
        E'**说明：** 每次只能**向下**或者**向右**移动一步。',
        NULL,
        2
    ),
    (
        'algo_min_path_sum',
        'SOLUTION',
        'text',
        E'**思路：动态规划 (O(1) 空间)**\n\n(同 (55) 不同路径，但状态转移方程不同)。\n\n1.  **定义 `dp[i][j]`**：\n    * `dp[i][j]` 表示：从 (0, 0) 到达 (i, j) 的**最小路径和**。\n\n2.  **(状态转移)**：\n    * 要到达 (i, j)，只能从 (i-1, j) (上面) 或 (i, j-1) (左面) 来。\n    * `dp[i][j] = grid[i][j] + Math.min(dp[i-1][j], dp[i][j-1])`。\n\n3.  **(O(1) 空间优化：原地 DP)**\n    我们可以直接修改 `grid` 数组来充当 `dp` 数组。\n\n**算法流程 (原地 DP)：**\n1.  (初始化) `grid[0][0]` 不变。\n\n2.  **(初始化第一行)** (只能从左边来)\n    * `for (j = 1 to n-1)`：\n    * `grid[0][j] = grid[0][j] + grid[0][j-1]`。\n\n3.  **(初始化第一列)** (只能从上边来)\n    * `for (i = 1 to m-1)`：\n    * `grid[i][0] = grid[i][0] + grid[i-1][0]`。\n\n4.  **(遍历)**\n    * `i=1` to `m-1`, `j=1` to `n-1`：\n    * `grid[i][j] = grid[i][j] + Math.min(grid[i-1][j], grid[i][j-1])`。\n\n5.  返回 `grid[m-1][n-1]`。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n)。\n-   空间复杂度：O(1) (原地修改)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 59. 回文链表 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_palindrome_linked_list',
        'DESCRIPTION',
        'text',
        E'给你一个单链表的头节点 `head` ，请你判断该链表是否为**回文链表**。\n\n(例如 `[1, 2, 2, 1]` 是, `[1, 2]` 不是)。\n\n**要求：** O(N) 时间, O(1) 空间。',
        NULL,
        1
    ),
    (
        'algo_palindrome_linked_list',
        'SOLUTION',
        'text',
        E'**思路：快慢指针 + 反转后半部分 (O(1) 空间)**\n\nO(N) 空间的解法是存入 `ArrayList` 再用双指针判断。\nO(1) 空间解法如下：\n\n1.  **(找中点)**\n    * 使用快慢指针 `slow`, `fast` ( `fast` 走两步, `slow` 走一步)。\n    * `while (fast.next != null && fast.next.next != null)` ... (偶数情况停在 `[1,2], 2`；奇数停在 `[1], 2, [3]` )\n    * (如示例代码：`slow` 最终停在前半部分的末尾，或中点)。\n\n2.  **(反转后半)**\n    * `secondHalf = reverse(slow.next)` ( `reverse` 是一个反转链表的辅助函数 (206. 反转链表))。\n\n3.  **(断开)** (可选，但推荐)\n    * `slow.next = null` (将前半部分与后半部分断开)。\n\n4.  **(比较)**\n    * 遍历 `firstHalf = head` 和 `secondHalf`。\n    * `while (secondHalf != null)`：\n        * `if (firstHalf.val != secondHalf.val)` 返回 `false`。\n        * `firstHalf = firstHalf.next`, `secondHalf = secondHalf.next`。\n\n5.  **(恢复链表)** (可选，但推荐)\n    * `slow.next = reverse(secondHalf)` (将后半部分反转回来)。\n\n6.  返回 `true` (比较通过)。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。找中点 O(N), 反转 O(N/2), 比较 O(N/2)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 60. 解码方法 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_decode_ways',
        'DESCRIPTION',
        'text',
        E'一条包含 A-Z 的消息通过以下映射进行了 编码：\n''A'' -> "1", ''B'' -> "2", ..., ''Z'' -> "26"。',
        NULL,
        1
    ),
    (
        'algo_decode_ways',
        'DESCRIPTION',
        'text',
        E'给你一个只包含数字的 **非空** 字符串 `s` ，请计算并返回 **解码方法** 的总数。\n\n**注意：** "06" ( `F` ) 和 "0" 是无效的，必须是 "1" ( `A` ) 到 "26" ( `Z` )。',
        NULL,
        2
    ),
    (
        'algo_decode_ways',
        'SOLUTION',
        'text',
        E'**思路：动态规划**\n\n`dp[i]` 表示字符串 `s` 的前 `i` 个字符 (`s.substring(0, i)`) 的解码方法总数。\n\n1.  **(基线)**\n    * `dp[0] = 1` (空字符串 `""` 有 1 种解码方式)。\n    * `dp[1] = (s.charAt(0) == ''0'') ? 0 : 1`。\n\n2.  **(状态转移)** `for (i = 2 to n)`：\n    ( `i` 对应 `s` 中的 `s[i-1]` )\n\n    * **(a. 检查 1 位数)** (即 `s[i-1]` )\n        * `oneDigit = s.substring(i-1, i)` (即 `s[i-1]` )\n        * 如果 `oneDigit` 在 "1"-"9" 之间 ( `s.charAt(i-1) != ''0''` )：\n            * `dp[i] += dp[i-1]`\n            * (例如 "22" + "6" -> `dp[3] += dp[2]` )。\n\n    * **(b. 检查 2 位数)** (即 `s[i-2...i-1]` )\n        * `twoDigits = s.substring(i-2, i)`\n        * 如果 `twoDigits` 在 "10"-"26" 之间：\n            * `dp[i] += dp[i-2]`\n            * (例如 "2" + "26" -> `dp[3] += dp[1]` )。\n\n3.  返回 `dp[n]`。\n\n**空间优化 (O(1))**\n`dp[i]` 只依赖 `dp[i-1]` 和 `dp[i-2]`。\n-   `a = dp[i-2]`\n-   `b = dp[i-1]`\n-   `c = dp[i]`\n-   `c = (check 1-digit) * b + (check 2-digits) * a`\n-   `a = b`, `b = c`\n\n**复杂度分析 (O(N) DP)：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(n)。(O(1) if 优化)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 61. 合并K个升序链表 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_merge_k_sorted_lists',
        'DESCRIPTION',
        'text',
        E'给你一个链表数组 `lists` ，每个链表都已经按**升序**排列。\n\n请你将所有链表合并到一个升序链表中，返回合并后的链表。',
        NULL,
        1
    ),
    (
        'algo_merge_k_sorted_lists',
        'SOLUTION',
        'text',
        E'**思路：最小堆 (PriorityQueue)**\n\nO(N log k) 时间, O(k) 空间 (N 是总节点数, k 是链表数)。\n(注：O(N k) 解法是 K 次“合并两个链表”)。\n\n**算法流程：**\n1.  创建一个“**最小堆**” `minHeap`。\n    * `PriorityQueue<ListNode>`。\n    * 比较器 (Comparator) 比较 `a.val` 和 `b.val`。\n\n2.  **(初始化)**\n    * 遍历 `lists` 数组 (k 个链表)。\n    * 将 *每个* 链表的 *头节点* (如果不为 `null`) 加入 `minHeap`。\n    * (此时 `minHeap` 中有 k 个元素，堆顶是 k 个头中最小的)。\n\n3.  **(构建)**\n    * 创建 `dummy` 头节点和 `curr` 指针。\n    * `while (!minHeap.isEmpty())`：\n        * `node = minHeap.poll()` (从堆中取出全局最小的节点)。\n        * `curr.next = node` (连接到结果链表)。\n        * `curr = curr.next`。\n\n        * **(关键)** `if (node.next != null)`：\n            * 将 `node.next` (该链表的下一个节点) 加入 `minHeap`。\n            * (堆会自动排序，O(log k))。\n\n4.  返回 `dummy.next`。\n\n**(替代思路：分治合并)**\n-   `merge(lists, 0, n-1)`\n-   `mid = ...`\n-   `left = merge(lists, 0, mid)`\n-   `right = merge(lists, mid+1, n-1)`\n-   `return mergeTwoLists(left, right)`\n-   时间 O(N log k)，空间 O(log k) (递归栈)。\n\n**复杂度分析 (最小堆)：**\n-   时间复杂度：O(N log k)。N 是总节点数，每次 `poll` 和 `add` 都是 O(log k)。\n-   空间复杂度：O(k)，堆的大小。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 62. 路径总和 III (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_path_sum_3',
        'DESCRIPTION',
        'text',
        E'给定一个二叉树的根节点 `root` ，和一个整数 `targetSum` ，求在该二叉树中，节点值之和等于 `targetSum` 的 **路径** 的数目。',
        NULL,
        1
    ),
    (
        'algo_path_sum_3',
        'DESCRIPTION',
        'text',
        E'**注意：**\n-   路径 **不需要**从根节点开始，也**不需要**在叶子节点结束。\n-   但是路径方向必须是**向下**的（只能从父节点到子节点）。',
        NULL,
        2
    ),
    (
        'algo_path_sum_3',
        'SOLUTION',
        'text',
        E'**思路：前缀和 (DFS + 哈希表)**\n\n(O(N²) 解法：`dfs(root)` + `dfs_sum(node, target)` (以 `node` 为起点的)。)\n\n(O(N) 最优解：前缀和)。\n\n(类似 (44. 和为 K 的子数组))。\n\n`PathSum(j) - PathSum(i) = targetSum`\n`PathSum(i) = PathSum(j) - targetSum`\n\n**算法流程：**\n1.  `Map<Long, Integer> map` (前缀和 `sum` -> 出现次数)。(用 `Long` 防溢出)。\n2.  `map.put(0L, 1)` (初始化，`sum=0` 出现 1 次)。\n3.  调用 `dfs(root, 0L, targetSum, map)`。\n\n**`dfs(node, currentSum, targetSum, map)` 函数：**\n( `currentSum` 是从 `root` 到 `node` *父节点* 的路径和，或者 `root` 到 `node` 的路径和，取决于实现)\n\n(以 `currentSum` 是 `root` 到 `node` 的路径和为例，如示例代码)：\n1.  **(基线)** `if (node == null) return 0;`\n\n2.  **(计算当前)**\n    * `currentSum += node.val` ( `root` 到 `node` 的和)。\n    * `complement = currentSum - targetSum`。\n\n3.  **(查找)**\n    * `count = map.getOrDefault(complement, 0)`。\n    * ( `count` 是：在 *进入* 当前节点 `node` 前，有多少条路径 (`root` -> `i`) 的和等于 `complement`。`Path(i -> node) == targetSum` )。\n\n4.  **(做选择)**\n    * `map.put(currentSum, map.getOrDefault(currentSum, 0) + 1)` (将 `node` 的前缀和加入 `map`，供子节点使用)。\n\n5.  **(递归)**\n    * `count += dfs(node.left, currentSum, ...)`\n    * `count += dfs(node.right, currentSum, ...)`\n\n6.  **(撤销选择/回溯)** (重要！)\n    * `map.put(currentSum, map.get(currentSum) - 1)` (离开 `node` 节点，`map` 必须复原)。\n\n7.  返回 `count`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。每个节点访问一次。\n-   空间复杂度：O(h) 或 O(n)。`HashMap` 和递归栈（最差 O(n)）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 63. K 个一组翻转链表 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_reverse_nodes_k_group',
        'DESCRIPTION',
        'text',
        E'给你链表的头节点 `head` ，每 `k` 个节点一组进行翻转，请你返回修改后的链表。\n\n`k` 是一个正整数，它的值小于或等于链表的长度。',
        NULL,
        1
    ),
    (
        'algo_reverse_nodes_k_group',
        'DESCRIPTION',
        'text',
        E'如果节点总数不是 `k` 的整数倍，那么请将最后剩余的节点**保持原有顺序**。',
        NULL,
        2
    ),
    (
        'algo_reverse_nodes_k_group',
        'SOLUTION',
        'text',
        E'**思路：递归**\n\n`reverseKGroup(head, k)`:\n( `head` 是这一组 (k 个) 的头)\n\n1.  **(寻找 k 个节点)**\n    * 从 `head` 开始，向后走 `k` 步，找到 `kEnd` (第 k 个节点)。\n    * (或者 `kEnd` 指向第 `k+1` 个节点，作为 `nextHead` )。\n\n2.  **(基线 - 失败)**\n    * 如果 `kEnd == null` (剩余节点不足 k 个)，`return head` (不翻转)。\n\n3.  **(暂存 & 断开)**\n    * `nextHead = kEnd.next` (下一组的头节点)。\n    * `kEnd.next = null` (将这一组 ( `head` ... `kEnd` ) 与后面断开)。\n\n4.  **(翻转)**\n    * `newHead = reverse(head)` ( `reverse` 是 (206) 反转普通链表的辅助函数)。\n    * (此时 `head` 变成了新尾部，`kEnd` 变成了 `newHead` )。\n    * (注：`newHead` 应该是 `kEnd` )。\n\n5.  **(递归连接)**\n    * `head.next = reverseKGroup(nextHead, k)`\n    * (原 `head` 翻转后变成了新尾部，连接到 *下一组的翻转结果* ( `reverseKGroup(nextHead, k)` ) )。\n\n6.  返回 `newHead`。\n\n**(迭代法 O(1) 空间)**\n-   使用 `dummy` 节点。\n-   维护 `prevGroupTail` (上一组的尾部) 和 `currentGroupHead`。\n-   循环：找到 `kEnd` -> ( `prevGroupTail` 连接到 `kEnd`) -> 反转 (`currentGroupHead` ... `kEnd`) -> ( `currentGroupHead` (新尾) 连接到 `nextHead`)。\n\n**复杂度分析 (递归)：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(n/k)，递归栈深度。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 64. 找到 K 个最接近的元素 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_find_k_closest',
        'DESCRIPTION',
        'text',
        E'给定一个 **排序好** 的数组 `arr` ，两个整数 `k` 和 `x` ，从数组中找到最靠近 `x`（两数之差 `|a - x|` 最小）的 `k` 个数。',
        NULL,
        1
    ),
    (
        'algo_find_k_closest',
        'DESCRIPTION',
        'text',
        E'返回的结果必须要是按**升序**排好的。\n\n( `|a - x| == |b - x|` 时，`a` 优先 ( `a < b` ) )。',
        NULL,
        2
    ),
    (
        'algo_find_k_closest',
        'SOLUTION',
        'text',
        E'**思路：二分查找 + 滑动窗口**\n\n(O(N) 解法：双指针 `left`, `right` 从 `x` 开始向两边扩展，O(N) 找到 `x`，O(k) 扩展)。\n\n(O(log N + k) 最优解：二分查找 + 滑动窗口)。\n\n**算法流程 (O(log N))**：\n我们不是去搜 `x`，而是去搜“**长度为 k 的窗口的*左边界* `left`**”。\n\n1.  搜索范围 `left = 0`, `right = arr.length - k`。\n    ( `left` 最多能取到 `arr.length - k`，窗口是 `[arr.length - k, ..., arr.length - 1]` )。\n\n2.  `while (left < right)` (标准二分查找，寻找 `left` )\n    * `mid = left + (right - left) / 2`。\n    * `mid` 是一个潜在的“左边界”。\n    * `mid + k` 是 `mid` 窗口的“右边界”。\n\n    * **(比较)**：我们比较 `x` 与 `mid` (左端点) 和 `mid + k` (右端点) 的 *距离*。\n        * 我们是在比较 `arr[mid]` 窗口好，还是 `arr[mid+1]` 窗口好。\n        * `if (x - arr[mid] > arr[mid + k] - x)`：\n            * ( `x` 到左端点 `mid` 的距离 > `x` 到右端点 `mid + k` 的距离)。\n            * (例如 `x=3`, `[1,2,3,4,5]`, `k=2`, `mid=0` ( `[1,2]` ) vs `mid=1` ( `[2,3]` ) )\n            * ( `x=3`, `mid=0` ( `[1,2]` ), `x-arr[0](1) = 2`, `arr[2](3)-x = 0`。`2 > 0` )\n            * 说明 `mid` ( `[1,2]` ) 离 `x` 太远了 (左侧距离 > 右侧距离)，窗口应该右移。\n            * `left = mid + 1`。\n\n        * `else`：\n            * ( `x` 到 `mid` 距离 <= `x` 到 `mid + k` 距离)\n            * 说明 `mid` 窗口 (或更左) 是最优的。\n            * `right = mid`。\n\n3.  **(结果)**：\n    * 循环结束时 `left` (或 `right`) 就是最优窗口的左边界。\n    * 从 `arr[left]` 开始取 `k` 个元素。\n\n**复杂度分析：**\n-   时间复杂度：O(log(N - k) + k)。二分 O(log(N-k))，收集结果 O(k)。\n-   空间复杂度：O(k) (结果列表)。',
        NULL,
        1
    );
-- -----------------------------------------------------
-- 版本 1.7: (续写) 填充 12 个新的热门算法题
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 1. 插入题目 (algorithm_problem)
-- -----------------------------------------------------

INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_merge_trees', '合并二叉树', 'Easy'),
    ('algo_detect_cycle_2', '环形链表 II', 'Medium'),
    ('algo_longest_increasing_path_matrix', '矩阵中的最长递增路径', 'Hard'),
    ('algo_find_all_duplicates', '数组中重复的数据', 'Medium'),
    ('algo_path_sum_2', '路径总和 II', 'Medium'),
    ('algo_course_schedule', '课程表', 'Medium'),
    ('algo_house_robber', '打家劫舍', 'Medium'),
    ('algo_house_robber_2', '打家劫舍 II', 'Medium'),
    ('algo_palindrome_partitioning', '分割回文串', 'Medium'),
    ('algo_word_ladder', '单词接龙', 'Hard'),
    ('algo_serialize_deserialize_tree', '二叉树的序列化与反序列化', 'Hard'),
    ('algo_top_k_frequent_elements', '前 K 个高频元素', 'Medium');

-- -----------------------------------------------------
-- 2. 插入内容块 (algorithm_content_block)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 65. 合并二叉树 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_merge_trees',
        'DESCRIPTION',
        'text',
        E'想象一下，当你将其中一棵覆盖到另一棵之上时，两棵树上的一些节点将会重叠（而另一些则不会）。\n\n你需要将这两棵树合并成一棵新二叉树。',
        NULL,
        1
    ),
    (
        'algo_merge_trees',
        'DESCRIPTION',
        'text',
        E'**合并的规则是：**\n1.  如果两个节点重叠，那么将这两个节点的值相加作为合并后节点的新值。\n2.  否则，不为 `null` 的节点将直接作为新二叉树的节点。\n\n(返回合并后的新树的根节点)',
        NULL,
        2
    ),
    (
        'algo_merge_trees',
        'SOLUTION',
        'text',
        E'**思路：递归 (DFS)**\n\n我们可以原地修改 `root1` (或 `root2`)，或者创建新树。原地修改更节省空间。\n\n**`merge(t1, t2)` 函数 (原地修改 `t1`)：**\n\n1.  **(基线 - 成功)**\n    * `if (t1 == null)`，返回 `t2` ( `t1` 空，用 `t2` 补上)。\n    * `if (t2 == null)`，返回 `t1` ( `t2` 空，`t1` 不动)。\n\n2.  **(合并)** ( `t1` 和 `t2` 都不为 `null` )\n    * `t1.val += t2.val` (将 `t2` 的值加到 `t1` 上)。\n\n3.  **(递归)**\n    * `t1.left = mergeTrees(t1.left, t2.left)` (递归合并左子树)。\n    * `t1.right = mergeTrees(t1.right, t2.right)` (递归合并右子树)。\n\n4.  返回 `t1`。\n\n**复杂度分析：**\n-   时间复杂度：O(min(m, n))，m, n 是两棵树的节点数。我们只遍历重叠的部分。\n-   空间复杂度：O(h)，h 是树高（递归栈深度）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 66. 环形链表 II (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_detect_cycle_2',
        'DESCRIPTION',
        'text',
        E'给定一个链表的头节点 `head` ，返回链表**开始入环的第一个节点**。 \n\n如果链表无环，则返回 `null`。',
        NULL,
        1
    ),
    (
        'algo_detect_cycle_2',
        'SOLUTION',
        'text',
        E'**思路：快慢指针 (Floyd 判圈法)**\n\n(同 (46) 寻找重复数，是 141. 环形链表 的进阶)。\n\n**算法流程：**\n1.  **(阶段 1：找到相遇点)** (同 141. 环形链表)\n    * `slow = head`, `fast = head`。\n    * `while (fast != null && fast.next != null)`：\n        * `slow = slow.next`\n        * `fast = fast.next.next`\n        * `if (slow == fast)`，break (找到相遇点)。\n\n2.  **(处理无环)**\n    * `if (fast == null || fast.next == null)`，说明无环，返回 `null`。\n\n3.  **(阶段 2：找到环的入口)** (数学证明)\n    * ( `fast` 保持在相遇点)。\n    * 将 `slow` 重置回 `head` (起点)。\n    * `while (slow != fast)`：\n        * `slow = slow.next` (走一步)\n        * `fast = fast.next` (走一步)\n\n4.  当它们再次相遇时，相遇点 `slow` (或 `fast`) 就是环的入口节点。\n5.  返回 `slow`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 67. 矩阵中的最长递增路径 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_longest_increasing_path_matrix',
        'DESCRIPTION',
        'text',
        E'给定一个 `m x n` 整数矩阵 `matrix` ，找出其中 **最长递增路径** 的长度。',
        NULL,
        1
    ),
    (
        'algo_longest_increasing_path_matrix',
        'DESCRIPTION',
        'text',
        E'对于每个单元格，你可以往上、下、左、右四个方向移动。\n\n你 **不能** 在 对角线 方向上移动或移动到 单元格外（即不允许环绕）。',
        NULL,
        2
    ),
    (
        'algo_longest_increasing_path_matrix',
        'SOLUTION',
        'text',
        E'**思路：记忆化搜索 (DFS + Memoization)**\n\n朴素 DFS 会 TLE (Time Limit Exceeded)，因为 `(i, j)` 的最长路径会被重复计算。\n\n1.  **定义 `memo` (记忆化) 数组**：\n    * `int[][] memo = new int[m][n]`\n    * `memo[i][j]` 存储：从 `(i, j)` 出发的**最长递增路径**的长度。\n    * `memo` 数组初始化为 0 (或 -1)。\n\n2.  **(主函数)**\n    * `maxLen = 0`。\n    * 遍历所有 `(i, j)`，`maxLen = Math.max(maxLen, dfs(matrix, i, j, memo))`。\n\n3.  **`dfs(matrix, i, j, memo)` 函数：**\n\n    * **(记忆化)** `if (memo[i][j] > 0)` (如果已计算过)，返回 `memo[i][j]`。\n\n    * `currentMax = 1` (至少为 1, 即 `(i, j)` 自己)。\n\n    * **(递归)** 遍历 4 个方向 `(ni, nj)`：\n        * `if ((ni, nj)` 越界，`continue`)。\n        * `if (matrix[ni][nj] > matrix[i][j])` (必须递增)：\n            * `currentMax = Math.max(currentMax, 1 + dfs(matrix, ni, nj, memo))`。\n            * ( `1` ( `(i,j)` 自己) + `(ni,nj)` 出发的最长路径)。\n\n    * **(存入)** `memo[i][j] = currentMax`。\n    * 返回 `currentMax`。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n)。由于记忆化，每个单元格 `(i, j)` 的 `dfs` 只会实际计算一次。\n-   空间复杂度：O(m * n)，`memo` 数组和递归栈深度。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 68. 数组中重复的数据 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_find_all_duplicates',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums`，其中 `1 ≤ nums[i] ≤ n`（`n` 为数组长度）。\n\n请找出数组中所有出现 **两次** 的元素。',
        NULL,
        1
    ),
    (
        'algo_find_all_duplicates',
        'DESCRIPTION',
        'text',
        E'你必须设计并实现一个时间复杂度为 **O(n)** 且只使用 **O(1)** 额外空间的算法解决此问题。',
        NULL,
        2
    ),
    (
        'algo_find_all_duplicates',
        'SOLUTION',
        'text',
        E'**思路：原地哈希 (In-place Hash / 负号标记)**\n\nO(N) 时间和 O(1) 空间的要求，排除了哈希表和排序。\n\n利用 `1 ≤ nums[i] ≤ n` 这个特性，我们可以将 **索引 (index)** 作为哈希表。\n\n**算法流程：**\n思路：遍历 `nums`，将 `num = |nums[i]|` 对应的 *索引* `index = num - 1` 处的元素 `nums[index]` 标记为 *负数*。\n\n1.  `List<Integer> result`。\n2.  遍历 `nums` ( `i` = 0 to n-1 )。\n3.  `num = Math.abs(nums[i])` (取绝对值，因为 `nums[i]` 可能已被标记)。\n4.  `index = num - 1` ( `num=4` 对应 `index=3` )。\n\n5.  **(检查)** `if (nums[index] < 0)`：\n    * 说明 `nums[index]` 之前已经被标记过了，`index` (即 `num`) 是一个重复数。\n    * `result.add(num)`。\n\n6.  **(标记)** `else`：\n    * `nums[index] = -nums[index]`。\n\n(注：此方法会修改原数组。如果不能修改，(46) 寻找重复数 (快慢指针) 只能找 1 个；(96) 缺失的第一个正数 (原地交换) 也可以 O(1) 空间 O(N) 时间)。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1) ( `result` 列表不计入)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 69. 路径总和 II (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_path_sum_2',
        'DESCRIPTION',
        'text',
        E'给你二叉树的根节点 `root` 和一个整数 `targetSum` ，找出所有 **从根节点到叶子节点** 路径总和等于 `targetSum` 的路径。\n\n**叶子节点** 是指没有子节点的节点。',
        NULL,
        1
    ),
    (
        'algo_path_sum_2',
        'SOLUTION',
        'text',
        E'**思路：回溯 (DFS)**\n\n我们需要遍历所有“根到叶”的路径，并检查 `sum`。\n\n`dfs(node, remainingSum, path, result)`:\n-   `remainingSum`: 目标 `targetSum` 减去 `path` 中已有的和。\n-   `path`: ( `List<Integer>` ) 当前路径。\n-   `result`: ( `List<List<Integer>>` ) 存储所有符合条件的 `path`。\n\n**算法流程：**\n1.  **(基线)** `if (node == null)` 返回。\n\n2.  **(做选择)**\n    * `path.add(node.val)`。\n    * `remaining = remainingSum - node.val` (或 `currentSum += node.val` )。\n\n3.  **(基线 - 成功)** (检查是否为叶子节点)\n    * `if (node.left == null && node.right == null && remaining == 0)`：\n        * `result.add(new ArrayList<>(path))` (必须添加 `path` 的*副本*)。\n        * ( **注意：** 找到后*不能* `return`，必须回溯 ( `path.remove` )，因为 `path` 是共享的)。\n\n4.  **(递归)**\n    * `dfs(node.left, remaining, path, result)`。\n    * `dfs(node.right, remaining, path, result)`。\n\n5.  **(撤销选择 / 回溯)** (重要！)\n    * `path.remove(path.size() - 1)` (移除 `node.val`，返回上一层)。\n\n**复杂度分析：**\n-   时间复杂度：O(N²)，最坏情况 ( `[1,1,1...]` ) O(N) 个叶子节点，`path` 副本 O(N)。平衡树 O(N log N)。\n-   空间复杂度：O(h)，h 为树高（递归栈深度）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 70. 课程表 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_course_schedule',
        'DESCRIPTION',
        'text',
        E'你这个学期必须选 `numCourses` 门课程，记为 `0` 到 `numCourses - 1` 。\n\n在选修某些课程之前需要一些先修课程。 先修课程按数组 `prerequisites` 给出，其中 `prerequisites[i] = [ai, bi]` ，表示如果要学习课程 `ai` ，则必须先学习课程 `bi` 。\n\n(例如 `[1, 0]` 表示： `0 -> 1` )',
        NULL,
        1
    ),
    (
        'algo_course_schedule',
        'DESCRIPTION',
        'text',
        E'请你判断是否可能完成所有课程的学习？\n\n(即：判断这个“有向图”中是否存在**环** (Cycle)？)',
        NULL,
        2
    ),
    (
        'algo_course_schedule',
        'SOLUTION',
        'text',
        E'**思路：拓扑排序 (Kahn 算法, BFS)**\n\n(DFS 判环也可以，但 BFS/Kahn 算法更直观)。\n\nKahn 算法模拟了“上课”的过程：我们从“入度 (in-degree) 为 0”的课程 (不需要先修) 开始，修完它们，然后“解锁”它们的后续课程。\n\n**算法流程：**\n1.  **(建图)**\n    * 创建 `adjList` (邻接表, `List<List<Integer>>`)。\n    * 创建 `inDegree` (入度数组, `int[]`)。\n\n2.  **(填充图)**\n    * 遍历 `prerequisites` ( `[crs, pre]` 或 `[a, b]` (b->a) )。\n    * `pre = req[1]`, `crs = req[0]`。\n    * `adjList.get(pre).add(crs)` ( `pre -> crs` )\n    * `inDegree[crs]++`。\n\n3.  **(初始化)**\n    * 创建 `Queue<Integer>`。\n    * 将所有 `inDegree[i] == 0` 的课程 (起点) 加入 `queue`。\n\n4.  **(BFS)**\n    * `count = 0` (已修课程数)。\n    * `while (!queue.isEmpty())`：\n        * `pre = queue.poll()`。\n        * `count++`。\n        * (模拟“修完 `pre`”)\n        * 遍历 `pre` 的所有“邻居” `crs` ( `adjList.get(pre)` )。\n        * `inDegree[crs]--` ( `pre -> crs` 这条边断了，`crs` 的入度 -1)。\n        * `if (inDegree[crs] == 0)` (如果 `crs` 已无先修课)，`queue.add(crs)`。\n\n5.  **(结果)**\n    * `return count == numCourses`。\n    * (如果 `count < numCourses`，说明 `queue` 提前空了，有环路 ( `inDegree` 无法清零))。\n\n**复杂度分析：**\n-   时间复杂度：O(N + E)，N 是节点数 (课程)，E 是边数 (要求)。\n-   空间复杂度：O(N + E)，`adjList` 和 `inDegree`。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 71. 打家劫舍 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_house_robber',
        'DESCRIPTION',
        'text',
        E'你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金。\n\n影响你偷窃的唯一制约因素就是**相邻的房屋**装有防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。',
        NULL,
        1
    ),
    (
        'algo_house_robber',
        'DESCRIPTION',
        'text',
        E'给定一个代表每个房屋存放金额的非负整数数组 `nums` ，计算你 **在不触动警报装置的情况下** ，今晚能够偷窃到的最高金额。',
        NULL,
        2
    ),
    (
        'algo_house_robber',
        'SOLUTION',
        'text',
        E'**思路：动态规划**\n\n`dp[i]` 表示：偷窃到第 `i` 间房屋时 ( `nums[0...i]` ) 能获得的最大金额。\n\n(状态转移) 对于第 `i` 间房 (`nums[i]`)，小偷有两个选择：\n\n1.  **(偷 `i`)**：\n    * `dp[i] = nums[i] + dp[i-2]`\n    * (偷了 `i`，就不能偷 `i-1`，只能加上 `i-2` 的最大金额)。\n2.  **(不偷 `i`)**：\n    * `dp[i] = dp[i-1]`\n    * (不偷 `i`，最大金额等于 `i-1` 的最大金额)。\n\n`dp[i] = Math.max(dp[i-1] (不偷), nums[i] + dp[i-2] (偷))`。\n\n**空间优化 (O(1))**\n`dp[i]` 只依赖 `dp[i-1]` 和 `dp[i-2]`。\n-   `a = dp[i-2]`\n-   `b = dp[i-1]`\n-   `c = dp[i]`\n\n**算法流程 (O(1) 空间)：**\n1.  (基线) `if (n == 0) return 0;`\n2.  `a = 0` (代表 `dp[i-2]`, `dp[-1]`)。\n3.  `b = 0` (代表 `dp[i-1]`, `dp[0]` 哨兵)。\n4.  `for (int num : nums)` ( `num` 即 `nums[i-1]`，但 `num` 代表 `nums[i]` (第 `i` 间房))：\n    * ( `temp` 即 `dp[i]` )\n    * `temp = Math.max(b (不偷), num + a (偷))`\n    * `a = b` ( `dp[i-1]` 变为 `dp[i-2]` )\n    * `b = temp` ( `dp[i]` 变为 `dp[i-1]` )\n5.  返回 `b` (即 `dp[n]` )。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 72. 打家劫舍 II (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_house_robber_2',
        'DESCRIPTION',
        'text',
        E'你是一个专业的小偷... (同 (71) 打家劫舍)。\n\n这一次，所有房屋都 **围成一圈** ，这意味着**第一个房屋和最后一个房屋是紧挨着的**。',
        NULL,
        1
    ),
    (
        'algo_house_robber_2',
        'DESCRIPTION',
        'text',
        E'给定一个代表每个房屋存放金额的非负整数数组 `nums` ，计算你 在不触动警报装置的情况下 ，今晚能够偷窃到的最高金额。',
        NULL,
        2
    ),
    (
        'algo_house_robber_2',
        'SOLUTION',
        'text',
        E'**思路：动态规划 (拆分)**\n\n环形排列意味着“第 0 间”和“第 n-1 间”不能同时被偷。\n\n我们将这个“环形”问题拆分为**两个**“线性”问题 (即 (71) 打家劫舍 I)：\n\n1.  **(情况 A)** 假设我们 *不* 偷最后一间 `nums[n-1]`。\n    * 此时，`nums[0]` 和 `nums[n-2]` 不相邻，我们可以在 `[0, n-2]` 范围内随意偷。\n    * `robA = robRange(nums, 0, n - 2)`。\n\n2.  **(情况 B)** 假设我们 *不* 偷第一间 `nums[0]`。\n    * 此时，`nums[1]` 和 `nums[n-1]` 不相邻，我们可以在 `[1, n-1]` 范围内随意偷。\n    * `robB = robRange(nums, 1, n - 1)`。\n\n最终答案是 `Math.max(rob_A, rob_B)`。\n\n**(边界)**：\n-   `if (n == 0) return 0;`\n-   `if (n == 1) return nums[0];` ( `n=1` 时无法拆分, `[0,-1]` )。\n\n我们需要重用“打家劫舍 I”的 `robRange(nums, start, end)` 辅助函数。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 73. 分割回文串 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_palindrome_partitioning',
        'DESCRIPTION',
        'text',
        E'给你一个字符串 `s`，请你将 `s` 分割成一些子串，使每个子串都是 **回文串** 。\n\n返回 `s` 所有可能的分割方案。',
        NULL,
        1
    ),
    (
        'algo_palindrome_partitioning',
        'SOLUTION',
        'text',
        E'**思路：回文串 (DFS)**\n\n这是一个回溯问题，我们需要“穷举”所有可能的“分割点”。\n\n`backtrack(s, start, path, result)`:\n-   `start`: 当前分割的起始索引。\n-   `path`: ( `List<String>` ) 当前已分割出的回文串路径 (如 `["aa", "b"]` )。\n-   `result`: ( `List<List<String>>` ) 存储所有结果。\n\n**算法流程：**\n1.  **(基线 - 成功)**\n    * `if (start == s.length())`：\n    * ( `start` 已经到达 `s` 的末尾，说明 `path` 是一种有效的分割方案)。\n    * `result.add(new ArrayList<>(path))`。\n\n2.  **(遍历“分割点”)**\n    * `for (i = start to s.length() - 1)`：\n    * ( `i` 是“分割点”，`[start...i]` 是我们要检查的子串)。\n\n    * **(a. 检查)** `substring = s.substring(start, i + 1)`。\n    * (剪枝) `if (!isPalindrome(substring))`，`continue` (这不是一个有效分割)。\n\n    * **(b. 做选择)** `path.add(substring)`。\n\n    * **(c. 递归)** `backtrack(s, i + 1, ...)`\n    * ( `i + 1` 是下一次分割的 `start` )。\n\n    * **(d. 撤销选择)** `path.remove(path.size() - 1)`。\n\n3.  ( `isPalindrome(sub)` 是一个 O(N) 的辅助函数)。\n\n**(优化)**：\n-   `isPalindrome` 可以用 O(N²) DP 预处理，`dp[i][j]` 存储 `s[i...j]` 是否为回文，`backtrack` 中 O(1) 查找。\n\n**复杂度分析 (无优化)：**\n-   时间复杂度：O(N * 2^N)，O(2^N) 种分割，每次 O(N) 检查 `isPalindrome`。\n-   空间复杂度：O(N)，`path` 和递归栈。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 74. 单词接龙 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_word_ladder',
        'DESCRIPTION',
        'text',
        E'字典 `wordList` 中从单词 `beginWord` 和 `endWord` 的 **转换序列** 是一个按顺序排列的单词序列，其中**相邻单词只差一个字母**。',
        NULL,
        1
    ),
    (
        'algo_word_ladder',
        'DESCRIPTION',
        'text',
        E'给你 `beginWord`、`endWord` 和 `wordList` ，返回从 `beginWord` 到 `endWord` 的 **最短转换序列** 中的 **单词数目** 。\n\n如果不存在，返回 0。',
        NULL,
        2
    ),
    (
        'algo_word_ladder',
        'SOLUTION',
        'text',
        E'**思路：BFS (广度优先搜索)**\n\n求“最短”路径（无权图），首先想到 BFS。\n\n**算法流程：**\n1.  **(预处理)**\n    * `wordList` 放入 `Set` ( `wordSet` )，O(1) 查找。\n    * (检查) `if (!wordSet.contains(endWord))` 返回 0。\n\n2.  **(初始化)**\n    * `Queue<String> queue`，`Set<String> visited`。\n    * `queue.add(beginWord)`, `visited.add(beginWord)`。\n    * `level = 1` ( `beginWord` 算 1)。\n\n3.  **(BFS 按层遍历)**\n    * `while (!queue.isEmpty())`：\n    * `size = queue.size()`, `for (i = 0 to size-1)` (按层遍历)：\n        * `word = queue.poll()`。\n\n        * **(寻找邻居)** ( `word` 只改一个字母能得到的所有 `wordList` 中的词)\n            * ( `O(L*26)` 效率高于 `O(N*L)` )\n            * `for (j = 0 to L-1)` (遍历 `word` 的 L 个位置)：\n                * `for (c = ''a'' to ''z'')` (尝试 26 个字母)：\n                    * `neighbor = ...` (替换 `word[j]` 为 `c` )。\n\n                    * **(检查)**\n                    * `if (neighbor.equals(endWord))` 返回 `level + 1`。\n                    * `if (wordSet.contains(neighbor) && !visited.contains(neighbor))`：\n                        * `queue.add(neighbor)`。\n                        * `visited.add(neighbor)`。\n\n    * `level++`。\n\n4.  返回 0 (未找到)。\n\n**(优化：双向 BFS)**\n-   `beginSet` ( `beginWord` ) 和 `endSet` ( `endWord` ) 同时开始 BFS，`level` 交替增加。当 `beginSet` 和 `endSet` 相遇时，返回 `level`。\n\n**复杂度分析 (BFS)：**\n-   时间复杂度：O(N * L² * 26)，N 是 `wordList` 长度, L 是单词长度。\n-   空间复杂度：O(N * L)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 75. 二叉树的序列化与反序列化 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_serialize_deserialize_tree',
        'DESCRIPTION',
        'text',
        E'**序列化**是将一个数据结构或者对象转换成一个序列的比特位的操作，以便在内存中保存或在网络上传输。\n\n**反序列化**是相反。\n\n请设计一个算法来实现**二叉树**的序列化与反序列化。',
        NULL,
        1
    ),
    (
        'algo_serialize_deserialize_tree',
        'SOLUTION',
        'text',
        E'**思路：DFS (前序遍历)**\n\n(BFS/层序遍历 也可以，但 DFS 递归更简洁)。\n\n我们需要一种方式来标记 `null` 节点。\n\n**`serialize(root)` (序列化)：**\n-   使用 `StringBuilder sb`。\n-   `dfs_serialize(root, sb)`:\n    1.  **(基线)** `if (root == null)`：\n        * `sb.append("null,")` (用 "null" 标记空节点)。\n        * `return`。\n    2.  `sb.append(root.val).append(",")` (根 - 前序)。\n    3.  `dfs_serialize(root.left, sb)` (左)。\n    4.  `dfs_serialize(root.right, sb)` (右)。\n-   (结果 "3,9,null,null,20,15,null,null,7,null,null," )\n\n**`deserialize(data)` (反序列化)：**\n-   `data.split(",")` 放入 `Queue<String>` ( `nodes` )。\n-   `return dfs_deserialize(nodes)`。\n\n-   `dfs_deserialize(nodes)`:\n    1.  `valStr = nodes.poll()` (消耗队列)。\n    2.  **(基线)** `if (valStr.equals("null"))`：\n        * 返回 `null`。\n    3.  `root = new TreeNode(Integer.parseInt(valStr))`。\n    4.  `root.left = dfs_deserialize(nodes)` (递归构建左子树)。\n    5.  `root.right = dfs_deserialize(nodes)` (递归构建右子树)。\n    6.  返回 `root`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，n 为节点数。\n-   空间复杂度：O(n)，`sb` 和 `queue`。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 76. 前 K 个高频元素 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_top_k_frequent_elements',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums` 和一个整数 `k` ，请你返回其中出现频率前 `k` 高的元素。\n\n你可以按 **任意顺序** 返回答案。\n\n**要求：** 时间复杂度优于 O(N log N)。',
        NULL,
        1
    ),
    (
        'algo_top_k_frequent_elements',
        'SOLUTION',
        'text',
        E'**思路：哈希表 + 最小堆 (PriorityQueue)**\n\nO(N log k) 时间, 优于 O(N log N) (排序)。\n(注：O(N) 解法是“桶排序”或 QuickSelect)。\n\n(同 (25) 数组中的第K个最大元素，但对象是“频率”)。\n\n**算法流程：**\n1.  **(哈希表)** `Map<Integer, Integer> map`：\n    * 遍历 `nums`，统计每个 `num` 的频率。O(N)。\n\n2.  **(最小堆)** `PriorityQueue<Map.Entry<Integer, Integer>> minHeap`。\n    * 比较器 `(a, b) -> a.getValue() - b.getValue()` (按频率*升序*排)。\n\n3.  **(维护大小为 k 的堆)**\n    * 遍历 `map.entrySet()` (N 个 entry)：\n        * `minHeap.add(entry)`。\n        * (关键) `if (minHeap.size() > k)`：\n            * `minHeap.poll()` (移除频率*最低*的)。\n    * (O(N log k))。\n\n4.  遍历结束后，`minHeap` 中剩下的是频率最高的 `k` 个 `entry`。\n5.  转换 `minHeap` 为 `int[]` 结果 (O(k log k))。\n\n**复杂度分析 (最小堆)：**\n-   时间复杂度：O(N log k)。O(N) 统计 + O(N log k) 堆。\n-   空间复杂度：O(N) ( `map` ) + O(k) ( `minHeap` ) = O(N + k)。',
        NULL,
        1
    );
-- -----------------------------------------------------
-- 版本 1.8: (续写) 填充 12 个新的热门算法题
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 1. 插入题目 (algorithm_problem)
-- -----------------------------------------------------

INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_next_permutation', '下一个排列', 'Medium'),
    ('algo_combination_sum', '组合总和', 'Medium'),
    ('algo_jump_game', '跳跃游戏', 'Medium'),
    ('algo_subsets', '子集', 'Medium'),
    ('algo_sort_list', '排序链表', 'Medium'),
    ('algo_max_product_subarray', '乘积最大子数组', 'Medium'),
    ('algo_intersection_two_lists', '相交链表', 'Easy'),
    ('algo_house_robber_3', '打家劫舍 III', 'Medium'),
    ('algo_flatten_tree_to_list', '二叉树展开为链表', 'Medium'),
    ('algo_decode_string', '字符串解码', 'Medium'),
    ('algo_is_palindrome', '回文数', 'Easy'),
    ('algo_roman_to_int', '罗马数字转整数', 'Easy');

-- -----------------------------------------------------
-- 2. 插入内容块 (algorithm_content_block)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 77. 下一个排列 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_next_permutation',
        'DESCRIPTION',
        'text',
        E'整数数组 `nums` 的“下一个排列”是指其整数所排列的“字典序”中“下一个更大”的排列。',
        NULL,
        1
    ),
    (
        'algo_next_permutation',
        'DESCRIPTION',
        'text',
        E'例如，`[1,2,3]` 的下一个排列是 `[1,3,2]`。\n`[3,2,1]` (最大) 的下一个排列是 `[1,2,3]` (最小)。',
        NULL,
        2
    ),
    (
        'algo_next_permutation',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums` ，找出 `nums` 的下一个排列。\n\n必须 **原地** 修改，只使用 O(1) 额外空间。',
        NULL,
        3
    ),
    (
        'algo_next_permutation',
        'SOLUTION',
        'text',
        E'**思路：两遍扫描 (O(N))**\n\n(示例 `[1, 2, 7, 4, 3, 1]` -> `[1, 3, 1, 2, 4, 7]` )\n\n1.  **(从后往前) 找到 `i` (较小的数)**\n    * 找到第一个 `i` 满足 `nums[i] < nums[i+1]`。\n    * ( `[7, 4, 3, 1]` 是降序。`i` 停在索引 1, `nums[1]=2`。因为 `2 < 7` )。\n\n2.  **(从后往前) 找到 `j` (较大的数)**\n    * (在 `[i+1 ... n-1]` (即 `[7,4,3,1]` ) 中) 找到第一个 `j` 满足 `nums[j] > nums[i]`。\n    * ( `j` 停在索引 4, `nums[4]=3`。因为 `3 > 2` )。\n\n3.  **(交换)** `swap(nums[i], nums[j])`。\n    * ( `[1, 2, 7, 4, 3, 1]` -> `[1, 3, 7, 4, 2, 1]` )\n\n4.  **(翻转)** 翻转 `i+1` 之后的所有元素 (使 `[7, 4, 2, 1]` (降序) 变为 `[1, 2, 4, 7]` (升序))。\n    * ( `[1, 3, 7, 4, 2, 1]` -> `[1, 3, 1, 2, 4, 7]` )\n\n5.  **(特殊情况)**\n    * 如果 `i < 0` ( `i` 没找到，整个数组是降序，如 `[3,2,1]` )。\n    * (步骤 2, 3 跳过)。\n    * (步骤 4) 翻转整个数组 ( `[1,2,3]` )。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。最多 3 次遍历。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 78. 组合总和 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_combination_sum',
        'DESCRIPTION',
        'text',
        E'给你一个 **无重复元素** 的整数数组 `candidates` 和一个目标整数 `target` ，找出 `candidates` 中可以使数字和为 `target` 的所有 **不同组合**。',
        NULL,
        1
    ),
    (
        'algo_combination_sum',
        'DESCRIPTION',
        'text',
        E'`candidates` 中的 **同一个** 数字可以 **无限制重复** 被选取。答案中 *组合* 不能重复。\n\n(例如 `[2,2,3]` 和 `[2,3,2]` 是同一个组合)。',
        NULL,
        2
    ),
    (
        'algo_combination_sum',
        'SOLUTION',
        'text',
        E'**思路：回溯 (DFS)**\n\n(同 (37) 全排列, (80) 子集, 但 `start` 索引处理不同)。\n\n`backtrack(candidates, target, start, path, result)`:\n-   `target`: 剩余目标和。\n-   `start`: (关键) 防止重复组合。`for` 循环从 `start` 开始。\n-   `path`: ( `List<Integer>` ) 当前路径。\n\n**算法流程：**\n1.  **(基线 - 成功)**\n    * `if (target == 0)`：`result.add(new ArrayList<>(path))`。\n2.  **(基线 - 失败)**\n    * `if (target < 0)`：`return`。\n\n3.  **(遍历)** `for (i = start to n-1)`：\n    * ( `start` 变量用于防止重复组合。例如 `[2,3]` vs `[3,2]`，我们只允许 `[2,3]` )。\n\n    * **(a. 做选择)** `path.add(candidates[i])`。\n\n    * **(b. 递归)**\n        * `backtrack(..., target - candidates[i], i, ...)`。\n        * ( **注意：`start` 传入 `i`**，*不是* `i + 1` )。\n        * (因为 `candidates[i]` 可以重复使用，例如 `[2, 2, ...]` )。\n
    * **(c. 撤销选择)** `path.remove(path.size() - 1)`。\n\n**(优化)**：\n-   `Arrays.sort(candidates)`。在 `backtrack` 中 `if (target - candidates[i] < 0)` 时 `break` (剪枝)。\n\n**复杂度分析：**\n-   时间复杂度：O(N^(T/M + 1)) (N 是 `candidates` 数量, T 是 `target`, M 是最小 `candidate`)。O(2^N) ? (复杂，指数级)。\n-   空间复杂度：O(T/M) (递归栈深度)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 79. 跳跃游戏 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_jump_game',
        'DESCRIPTION',
        'text',
        E'给定一个非负整数数组 `nums` ，你最初位于数组的 **第一个下标** 。\n\n数组中的每个元素代表你在该位置可以跳跃的**最大长度**。',
        NULL,
        1
    ),
    (
        'algo_jump_game',
        'DESCRIPTION',
        'text',
        E'判断你是否能够到达**最后一个下标** ( `n-1` )。',
        NULL,
        2
    ),
    (
        'algo_jump_game',
        'SOLUTION',
        'text',
        E'**思路：贪心算法 (Greedy)**\n\nO(N) 时间, O(1) 空间。\n\n我们不需要知道*怎么*跳，只需要知道*最远*能跳到哪里。\n\n**算法流程：**\n1.  维护一个变量 `maxReach` (或 `rightmost`)，表示“**当前所能达到的最远索引**”。\n2.  `maxReach = 0`。\n3.  遍历 `nums` ( `i` 从 0 到 n-1 )。\n\n4.  **(关键)** `if (i > maxReach)`：\n    * 如果 `i` 已经超过了 `maxReach`，说明 `i` (以及 `i` 之后的所有) 永远无法到达。\n    * 返回 `false`。\n\n5.  **(更新)** `maxReach = Math.max(maxReach, i + nums[i])`。\n    * ( `i + nums[i]` 是 `i` 能跳到的最远距离，我们更新全局 `maxReach` )。\n\n6.  **(剪枝)** `if (maxReach >= nums.length - 1)`：\n    * 如果 `maxReach` 已经覆盖或超过了终点，提前返回 `true`。\n\n7.  遍历结束 (说明 `maxReach` 至少达到了 `n-1` )，返回 `true`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 80. 子集 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_subsets',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums` ，数组中的元素 **互不相同** 。\n\n返回该数组所有可能的**子集**（幂集）。',
        NULL,
        1
    ),
    (
        'algo_subsets',
        'DESCRIPTION',
        'text',
        E'解集 **不能** 包含重复的子集。你可以按 **任意顺序** 返回解集。',
        NULL,
        2
    ),
    (
        'algo_subsets',
        'SOLUTION',
        'text',
        E'**思路：回溯 (DFS)**\n\n(同 (78) 组合总和, 但 `start` 索引处理不同)。\n\n`backtrack(nums, start, path, result)`:\n-   `start`: (关键) 防止重复组合。\n-   `path`: ( `List<Integer>` ) 当前子集 (如 `[1, 2]` )。\n-   `result`: ( `List<List<Integer>>` ) 存储所有结果。\n\n**算法流程：**\n1.  **(关键)** *一进入* `backtrack`，就将 `path` 的快照加入 `result`。\n    * (因为 `[]`, `[1]`, `[1,2]` 都是有效子集)。\n    * `result.add(new ArrayList<>(path))`。\n\n2.  **(基线 - 失败)** `if (start == nums.length)`，`return` (可选，`for` 循环会自动处理)。\n\n3.  **(遍历)** `for (i = start to n-1)`：\n    * ( `start` 变量用于防止 `[1,2]` 和 `[2,1]` 同时出现，确保 `[2]` 只在 `[1]` 之后出现)。\n\n    * **(a. 做选择)** `path.add(nums[i])` (选择 `nums[i]` )。\n\n    * **(b. 递归)**\n        * `backtrack(..., i + 1, ...)`。\n        * ( **注意：`start` 传入 `i + 1`** )。\n        * (因为 `nums[i]` *不*能重复使用，下次只能选 `i+1` 之后的)。\n
    * **(c. 撤销选择)** `path.remove(path.size() - 1)` (不选择 `nums[i]` )。\n\n**复杂度分析：**\n-   时间复杂度：O(N * 2^N)。O(2^N) 个子集，`path` 副本 O(N)。\n-   空间复杂度：O(N)，`path` 和递归栈。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 81. 排序链表 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_sort_list',
        'DESCRIPTION',
        'text',
        E'给你链表的头结点 `head` ，请将其按 **升序** 排列并返回 排序后的链表。',
        NULL,
        1
    ),
    (
        'algo_sort_list',
        'DESCRIPTION',
        'text',
        E'**要求：** 你必须在 **O(n log n)** 时间复杂度和 **O(1)** 空间复杂度内完成此题。',
        NULL,
        2
    ),
    (
        'algo_sort_list',
        'SOLUTION',
        'text',
        E'**思路：归并排序 (Merge Sort)**\n\nO(N log N) 时间, O(1) 空间 (迭代) 或 O(log N) 空间 (递归) 是链表排序的最佳选择 (快排 O(1) 空间困难)。\n\n**算法流程 (递归 O(log N) 空间)：**\n1.  **( `sortList(head)` 主函数):**\n    * **(a. 基线)** `if (head == null || head.next == null)`，`return head` ( 0 或 1 个节点已有序)。\n\n    * **(b. 找中点)** `mid = findMiddle(head)` ( (59) 快慢指针法)。\n
    * **(c. 断开)**\n        * `rightHead = mid.next`\n        * `mid.next = null` (将 `left` 和 `right` 断开)。\n\n    * **(d. 递归)**\n        * `left = sortList(head)`\n        * `right = sortList(rightHead)`\n
    * **(e. 合并)** `return merge(left, right)` ( (5) 合并两个有序链表 )。\n\n2.  **( `findMiddle` 辅助函数)**：快慢指针 `slow`, `fast = head.next`。\n\n3.  **( `merge` 辅助函数)**：虚拟头节点 `dummy` + 迭代合并。\n\n**复杂度分析 (递归)：**\n-   时间复杂度：O(n log n)。\n-   空间复杂度：O(log n)，递归栈深度。\n\n**(O(1) 空间解法：** 迭代 (自底向上) 归并排序，实现复杂)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 82. 乘积最大子数组 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_max_product_subarray',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `nums` ，请你找出数组中乘积最大的**非空连续子数组**（该子数组中至少包含一个数字），并返回该子数组所对应的乘积。\n\n(数组中可能包含负数)',
        NULL,
        1
    ),
    (
        'algo_max_product_subarray',
        'SOLUTION',
        'text',
        E'**思路：动态规划**\n\n( (18) 最大子数组和 的变体)。\n\n由于“**负负得正**”的存在，(18) 的 DP 思想 ( `currentSum = max(num, currentSum + num)` ) 不适用。\n(例如 `[-2, -10]`，`dp[0]=-2`，`dp[1] = max(-10, -10 + (-2)) = -10` 错误)。\n\n我们需要同时维护两个 DP 变量：\n1.  `currentMax`: ( `dp_max[i]` ) 到达 `nums[i]` 为止，能构成的“**最大乘积**”。\n2.  `currentMin`: ( `dp_min[i]` ) 到达 `nums[i]` 为止，能构成的“**最小乘积**”\n    (因为 `currentMin` (最小的负数) * `num` (负数) = `currentMax` (最大的正数))。\n\n**算法流程：**\n1.  `maxSoFar = nums[0]`, `currentMax = nums[0]`, `currentMin = nums[0]`。\n2.  遍历 `nums` ( `i` 从 1 开始)：\n    * `num = nums[i]`。\n    * ( `tempMax` 必须存, 因为 `currentMax` 会被修改)\n        `tempMax = currentMax`。\n\n    * ( `num` (重新开始), `tempMax * num` (正*正/负), `currentMin * num` (负*负) )\n    * `currentMax = max(num, max(tempMax * num, currentMin * num))`。\n    * `currentMin = min(num, min(tempMax * num, currentMin * num))`。\n\n    * `maxSoFar = max(maxSoFar, currentMax)`。\n\n3.  返回 `maxSoFar`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 83. 相交链表 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_intersection_two_lists',
        'DESCRIPTION',
        'text',
        E'给你两个单链表的头节点 `headA` 和 `headB` ，请你找出并返回两个单链表**相交的起始节点**。\n\n如果两个链表不存在相交节点，返回 `null` 。',
        NULL,
        1
    ),
    (
        'algo_intersection_two_lists',
        'SOLUTION',
        'text',
        E'**思路：双指针 (浪漫相遇法)**\n\nO(N+M) 时间, O(1) 空间。\n\n**算法流程：**\n1.  `pA = headA`, `pB = headB`。\n2.  `while (pA != pB)`：\n    * ( `pA` 走 A 链)\n        `pA = (pA == null) ? headB : pA.next`。\n        (如果 `pA` 走到了 `A` 的末尾 (`null`)，让它跳到 `B` 的开头 `headB` )。\n\n    * ( `pB` 走 B 链)\n        `pB = (pB == null) ? headA : pB.next`。\n        (如果 `pB` 走到了 `B` 的末尾 (`null`)，让它跳到 `A` 的开头 `headA` )。\n\n3.  返回 `pA` (或 `pB`)。\n\n**(解释)**：\n-   假设 A 链 (非相交部分) 长 `a`，B 链长 `b`，相交部分长 `c`。\n-   `pA` 走的路径 (到达相遇点): `a + c + b`。\n-   `pB` 走的路径 (到达相遇点): `b + c + a`。\n-   `a + c + b == b + c + a`，所以它们一定会在相交点 `c` 的开头相遇 (如果 `c > 0`)。\n-   如果 `c = 0` (不相交)，`a + b == b + a`，它们会同时在 `null` (末尾) 相遇，`pA = pB = null`，返回 `null`。\n\n**复杂度分析：**\n-   时间复杂度：O(N + M)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 84. 打家劫舍 III (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_house_robber_3',
        'DESCRIPTION',
        'text',
        E'小偷又发现了一个新的可行窃的地区。这个地区只有一个入口，我们称之为 `root` 。\n\n这个地方的所有房屋的排列类似于一棵**二叉树**。',
        NULL,
        1
    ),
    (
        'algo_house_robber_3',
        'DESCRIPTION',
        'text',
        E'如果两个**直接相连**的房子(父子)在同一天晚上被盗，房屋将自动报警。\n\n计算小偷 在不触动警报装置的情况下 ，今晚能够偷窃到的最高金额。',
        NULL,
        2
    ),
    (
        'algo_house_robber_3',
        'SOLUTION',
        'text',
        E'**思路：树形 DP (DFS)**\n\n( (71) (72) 的树形版本)。\n\n朴素 `rob(node)` = `max( rob(node.left) + rob(node.right) (不偷 node), node.val + rob(node.left.left) + ... (偷 node) )` 会 TLE (重复计算)。\n\n**优化 (记忆化 / O(N) DFS)：**\n`dfs(node)` 函数必须返回一个 `int[2]` 数组 `res` (或 `Pair`)：\n-   `res[0]`：**不**偷 `node` 时，能获得的最大金额。\n-   `res[1]`：**偷** `node` 时，能获得的最大金额。\n\n**`dfs(node)` 流程：**\n1.  **(基线)** `if (node == null)`，返回 `[0, 0]`。\n\n2.  **(递归)**\n    * `left = dfs(node.left)`\n    * `right = dfs(node.right)`\n    * ( `left[0]` (不偷L), `left[1]` (偷L), `right[0]` (不偷R), `right[1]` (偷R) )\n\n3.  **(合并)** `res = [0, 0]`\n    * **(a. 不偷 `node`) `res[0]`**\n        * `res[0] = Math.max(left[0], left[1]) + Math.max(right[0], right[1])`\n        * ( `node` 不偷，则 `node.left` 可偷可不偷 (取最大)，`node.right` 也可偷可不偷 (取最大))。\n
    * **(b. 偷 `node`) `res[1]`**\n        * `res[1] = node.val + left[0] + right[0]`\n        * ( `node` 偷了，则 `node.left` 必须 *不*偷，`node.right` 必须 *不*偷)。\n
4.  返回 `res`。\n\n5.  **(主函数)** `result = dfs(root)`，返回 `Math.max(result[0], result[1])`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，每个节点访问一次。\n-   空间复杂度：O(h)，h 为树高（递归栈深度）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 85. 二叉树展开为链表 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_flatten_tree_to_list',
        'DESCRIPTION',
        'text',
        E'给你二叉树的根结点 `root` ，请你将其**原地**展开为一个单链表。',
        NULL,
        1
    ),
    (
        'algo_flatten_tree_to_list',
        'DESCRIPTION',
        'text',
        E'1.  展开后的单链表应该同样使用 `TreeNode` ，其中 `right` 子指针指向链表中的下一个结点，而 `left` 子指针始终为 `null` 。\n2.  展开后的单链表应该与二叉树 **先序遍历** 顺序相同。',
        NULL,
        2
    ),
    (
        'algo_flatten_tree_to_list',
        'SOLUTION',
        'text',
        E'**思路：寻找前驱节点 (O(1) 空间)**\n\n(O(N) 空间解法是 DFS 存入 List 再重构)。\n\nO(1) 空间解法 (Morris 遍历思想)：\n目标：将 `root.left` (左子树) 移到 `root.right` (右子树) 的位置，并将 `root.right` (原右子树) 接到 `root.left` (左子树) 的“**最右**”节点 ( `predecessor` ) 上。\n\n**算法流程：**\n1.  `curr = root`。\n2.  `while (curr != null)`：\n\n    * **`if (curr.left != null)`** (有左子树)：\n        * (a. 找到 `curr` 的*左子树*中的“最右”节点 `predecessor`)。\n            * `predecessor = curr.left`\n            * `while (predecessor.right != null) { predecessor = predecessor.right; }`\n\n        * (b. 连接) `predecessor.right = curr.right`。\n            (将原 `curr` 的右子树 `[5,6]` 接到 `predecessor` ( `[4]` ) 后面)。\n\n        * (c. 移动) `curr.right = curr.left`。\n            (将 `curr` 的左子树 `[2,3,4]` 移到 `curr.right` )。\n\n        * (d. 断开) `curr.left = null`。\n\n    * **`curr = curr.right`** (移动到下一个“根”节点)。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。`predecessor` 指针的 `while` 循环在整个过程中总共 O(n) (摊销)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 86. 字符串解码 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_decode_string',
        'DESCRIPTION',
        'text',
        E'给定一个经过编码的字符串，返回它解码后的字符串。\n\n编码规则为: `k[encoded_string]`，表示 `encoded_string` 重复 `k` 次。\n\n( `k` 保证为正整数。`s` 中无数字 ( `3` )，数字只用于 `k` )。',
        NULL,
        1
    ),
    (
        'algo_decode_string',
        'SOLUTION',
        'text',
        E'**思路：双栈法 (Two Stacks)**\n\n(递归法也可以，但栈法 O(N) 空间)。\n\n`"3[a2[c]]"` -> `accaccacc`。\n\n我们需要两个栈来处理 `[` 和 `]` 的嵌套：\n1.  `countStack` ( `Stack<Integer>` ): 存储 `[` 之前的数字 `k`。 (e.g., 3, 2)\n2.  `stringStack` ( `Stack<StringBuilder>` ): 存储 `[` 之前的 `StringBuilder` ( `currentString` )。 (e.g., "", "a")\n\n**算法流程：**\n1.  `currentString = new StringBuilder()`, `currentNum = 0`。\n2.  遍历 `s` 中的 `char c`：\n\n    * **`if (isDigit(c))`**: `currentNum = currentNum * 10 + (c - ''0'')`。\n
    * **`if (c == ''['')`**: (遇到 `[`，入栈)\n        * `countStack.push(currentNum)`。\n        * `stringStack.push(currentString)`。\n        * (重置)\n        * `currentNum = 0`。\n        * `currentString = new StringBuilder()`。\n
    * **`if (c == '']'')`**: (遇到 `]`，出栈，解码)\n        * `k = countStack.pop()`。\n        * `temp = currentString` ( `temp` 是 `[]` *内部*的，如 "c")。\n        * `currentString = stringStack.pop()` ( `currentString` 恢复到 `[` *外部*的，如 "a")。\n        * `for (i=0 to k-1)`: `currentString.append(temp)` ( `currentString` = "a" + "cc")。\n
    * **`else`** (是字母): `currentString.append(c)`。\n\n3.  返回 `currentString.toString()`。\n\n**复杂度分析：**\n-   时间复杂度：O(N * maxK) or O(S)，S 是输出字符串长度。\n-   空间复杂度：O(N)，栈的深度。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 87. 回文数 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_is_palindrome',
        'DESCRIPTION',
        'text',
        E'给你一个整数 `x` ，如果 `x` 是一个**回文整数**，返回 `true` ；否则，返回 `false` 。',
        NULL,
        1
    ),
    (
        'algo_is_palindrome',
        'DESCRIPTION',
        'text',
        E'回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。\n\n(例如，121 是回文，而 123 不是, -121 不是)。\n\n**要求：** 不将整数转为字符串。',
        NULL,
        2
    ),
    (
        'algo_is_palindrome',
        'SOLUTION',
        'text',
        E'**思路：反转一半数字**\n\nO(1) 空间，不使用字符串。\n\n**算法流程：**\n1.  **(特殊情况)**\n    * `if (x < 0)` 返回 `false` (负数不是)。\n    * `if (x % 10 == 0 && x != 0)` 返回 `false` (末尾为 0 的非 0 数，如 10, 120，反转 (01, 021) 不相等)。\n\n2.  `revertedNumber = 0`。\n3.  **(反转后半)**\n    * `while (x > revertedNumber)`：\n        * (反转 `x` 的后半)\n        * `revertedNumber = revertedNumber * 10 + x % 10`。\n        * ( `x` 丢弃后半)\n        * `x /= 10`。\n\n4.  **(检查)** `while` 循环在 `x` (前半) <= `revertedNumber` (后半) 时停止。\n\n    * **(情况 1：偶数位)** `1221`\n        * `while` 结束时: `x = 12`, `rev = 12`。\n        * `return x == revertedNumber`。\n
    * **(情况 2：奇数位)** `12321`\n        * `while` 结束时: `x = 12`, `rev = 123` ( `rev` 多一位)。\n        * `return x == revertedNumber / 10` (去掉 `rev` 的中位数 3)。\n\n5.  `return x == revertedNumber || x == revertedNumber / 10;`\n\n**复杂度分析：**\n-   时间复杂度：O(log10 n)，n 是 `x` 的值 ( `x` 有 log10 n 位)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 88. 罗马数字转整数 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_roman_to_int',
        'DESCRIPTION',
        'text',
        E'罗马数字包含七种不同的字符： `I`(1), `V`(5), `X`(10), `L`(50), `C`(100), `D`(500) 和 `M`(1000)。',
        NULL,
        1
    ),
    (
        'algo_roman_to_int',
        'DESCRIPTION',
        'text',
        E'通常，罗马数字中小的数字在大的数字的右边 ( `XII` = 12)。\n\n但也存在特例 ( `I, X, C` )：\n-   `IV` (4), `IX` (9)\n-   `XL` (40), `XC` (90)\n-   `CD` (400), `CM` (900)\n\n给定一个罗马数字，将其转换成整数。',
        NULL,
        2
    ),
    (
        'algo_roman_to_int',
        'SOLUTION',
        'text',
        E'**思路：遍历 (从左往右)**\n\n思路：如果当前数字 `s[i]` *小于* 它右边的数字 `s[i+1]` (例如 ''I'' < ''V'')，说明发生了特例，我们应该 *减去* `s[i]` 的值。否则，*加上* `s[i]` 的值。\n\n**算法流程：**\n1.  **(哈希表)** `Map<Character, Integer> map` 存储 (''I'' -> 1, ''V'' -> 5 ...)。\n2.  `total = 0`。\n3.  `for (i = 0 to n-1)`：\n    * `currentVal = map.get(s.charAt(i))`。\n\n    * **(检查特例)**\n    * `if (i < n - 1 && currentVal < map.get(s.charAt(i + 1)))`：\n        * `total -= currentVal` (例如 `MCM`: `M`(1000) + `C`(100), 检查 `C < M` -> `total -= 100` ( `total = 900` ) )\n        * (注：`MCMXCIV`, M(1000), C(900), X(90), I(4) )\n        * ( `M`(1000) -> total=1000 )\n        * ( `C`(100), `C < M` -> total -= 100 = 900 ... 啊, 算法错了)\n\n**(修正：** `MCM`: `M`(1000) + `CM`(900) )\n( `M`(1000) -> total=1000 )\n( `C`(100), `C < M` -> total -= 100 = 900 )\n( `M`(1000) -> total += 1000 = 1900 ) ( `MCM` = 1900 )\n\n**(修正 2：从右往左)** (更简单)\n`total = 0`, `prevVal = 0`\n`for (i = n-1 to 0)`:\n  `currVal = map.get(s[i])`\n  `if (currVal < prevVal)` (特例 `IV`, `i` 在 `I`, `prev` 是 `V`)\n     `total -= currVal`\n  `else`\n     `total += currVal`\n  `prevVal = currVal`\n\n**(如示例代码：从左往右)**\n`total = 0`\n`for (i = 0 to n-1)`:\n  `currentVal = map.get(s.charAt(i))`\n  `if (i < n - 1 && currentVal < map.get(s.charAt(i + 1)))` ( `IV`, `i` 在 `I`)\n     `total -= currentVal`\n  `else`\n     `total += currentVal`\n( `MCMXCIV` )\n(i=0, M, total=1000)\n(i=1, C, C < M, total -= 100 = 900)\n(i=2, M, total += 1000 = 1900)\n(i=3, X, X < C, total -= 10 = 1890)\n(i=4, C, total += 100 = 1990)\n(i=5, I, I < V, total -= 1 = 1989)\n(i=6, V, total += 5 = 1994) (正确)\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1) ( `Map` 是 O(7) )。',
        NULL,
        1
    );
-- -----------------------------------------------------
-- 版本 1.9: (续写) 填充 12 个新的热门算法题 (达成 100 题)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 1. 插入题目 (algorithm_problem)
-- -----------------------------------------------------

INSERT INTO algorithm_problem (id, title, difficulty)
VALUES
    ('algo_longest_common_subsequence', '最长公共子序列', 'Medium'),
    ('algo_edit_distance', '编辑距离', 'Hard'),
    ('algo_min_cost_climbing_stairs', '使用最小花费爬楼梯', 'Easy'),
    ('algo_is_same_tree', '相同的树', 'Easy'),
    ('algo_remove_nth_node', '删除链表的倒数第 N 个结点', 'Medium'),
    ('algo_letter_combinations_phone', '电话号码的字母组合', 'Medium'),
    ('algo_generate_parentheses', '括号生成', 'Medium'),
    ('algo_first_missing_positive', '缺失的第一个正数', 'Hard'),
    ('algo_bst_right_side_view', '二叉树的右视图', 'Medium'),
    ('algo_valid_palindrome', '验证回文串', 'Easy'),
    ('algo_reverse_integer', '整数反转', 'Easy'),
    ('algo_string_to_integer_atoi', '字符串转换整数 (atoi)', 'Medium');

-- -----------------------------------------------------
-- 2. 插入内容块 (algorithm_content_block)
-- -----------------------------------------------------

-- -----------------------------------------------------
-- 89. 最长公共子序列 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_longest_common_subsequence',
        'DESCRIPTION',
        'text',
        E'给定两个字符串 `text1` 和 `text2`，返回这两个字符串的**最长公共子序列 (LCS)** 的长度。\n\n如果不存在 公共子序列 ，返回 0 。',
        NULL,
        1
    ),
    (
        'algo_longest_common_subsequence',
        'DESCRIPTION',
        'text',
        E'**子序列** (Subsequence)：通过删除 `text1` 中的某些字符（或不删除）且不改变剩余字符相对位置所组成的新字符串。\n(例如，"ace" 是 "abcde" 的子序列，但 "aec" 不是)。\n\n**公共子序列** (Common Subsequence)：`text1` 和 `text2` 共有的子序列。',
        NULL,
        2
    ),
    (
        'algo_longest_common_subsequence',
        'SOLUTION',
        'text',
        E'**思路：动态规划**\n\n这是 DP 的经典问题。\n\n1.  **定义 `dp[i][j]`**：\n    * `dp[i][j]` 表示 `text1[0...i-1]` ( `text1` 的前 `i` 个) 和 `text2[0...j-1]` ( `text2` 的前 `j` 个) 的最长公共子序列 (LCS) 长度。\n    * ( `dp` 数组大小 `(m+1) x (n+1)` )\n\n2.  **(状态转移)** `for (i = 1 to m), for (j = 1 to n)`：\n\n    * **(a. 相等)** `if (text1.charAt(i-1) == text2.charAt(j-1))`：\n        * ( `text1` 的第 `i` 个字符 `==` `text2` 的第 `j` 个字符)\n        * 这个字符*必须*在 LCS 中。\n        * `dp[i][j] = 1 + dp[i-1][j-1]` ( `1` (当前) + `text1[0...i-2]` 和 `text2[0...j-2]` 的 LCS)。\n
    * **(b. 不等)** `else`：\n        * ( `text1[i-1] != text2[j-1]` )\n        * ( `dp[i][j]` 继承自“去掉 `text1` 最后一个”或“去掉 `text2` 最后一个”中的较大值)。\n        * `dp[i][j] = Math.max(dp[i-1][j], dp[i][j-1])`。\n
3.  **(基线)** `dp[0][j]` ( `text1` 为空) 和 `dp[i][0]` ( `text2` 为空) 默认为 0。\n\n4.  返回 `dp[m][n]`。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n)。\n-   空间复杂度：O(m * n)。(可优化到 O(min(m, n)) )。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 90. 编辑距离 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_edit_distance',
        'DESCRIPTION',
        'text',
        E'给你两个单词 `word1` 和 `word2`， 请返回将 `word1` 转换成 `word2` 所使用的**最少操作数**。',
        NULL,
        1
    ),
    (
        'algo_edit_distance',
        'DESCRIPTION',
        'text',
        E'你可以对一个单词进行如下三种操作：\n1.  **插入** (Insert) 一个字符\n2.  **删除** (Delete) 一个字符\n3.  **替换** (Replace) 一个字符',
        NULL,
        2
    ),
    (
        'algo_edit_distance',
        'SOLUTION',
        'text',
        E'**思路：动态规划**\n\n( (89) LCS 变体)。\n\n1.  **定义 `dp[i][j]`**：\n    * `dp[i][j]` 表示 `word1[0...i-1]` ( `word1` 前 `i` 个) 转换到 `word2[0...j-1]` ( `word2` 前 `j` 个) 的**最少操作数**。\n    * ( `dp` 数组大小 `(m+1) x (n+1)` )\n\n2.  **(初始化)** (基线)\n    * `dp[i][0] = i` ( `word1` ( "abc" ) 转换到 `""` (空) 需要 `i` 次“删除”)。\n    * `dp[0][j] = j` ( `""` (空) 转换到 `word2` ( "xyz" ) 需要 `j` 次“插入”)。\n\n3.  **(状态转移)** `for (i = 1 to m), for (j = 1 to n)`：\n
    * **(a. 相等)** `if (word1.charAt(i-1) == word2.charAt(j-1))`：\n        * `dp[i][j] = dp[i-1][j-1]` (无需操作，继承 `dp[i-1][j-1]` 的操作数)。\n
    * **(b. 不等)** `else`：\n        * `dp[i][j]` 必须在 `dp[i-1][j-1]`, `dp[i-1][j]`, `dp[i][j-1]` 的基础上 + 1 次操作。\n        * (1) **替换 (Replace)**：`dp[i-1][j-1]` ( `word1[0...i-2]` -> `word2[0...j-2]` ) + 1 (替换 `word1[i-1]` 为 `word2[j-1]` )。\n        * (2) **删除 (Delete)**：`dp[i-1][j]` ( `word1[0...i-2]` -> `word2[0...j-1]` ) + 1 (删除 `word1[i-1]` )。\n        * (3) **插入 (Insert)**：`dp[i][j-1]` ( `word1[0...i-1]` -> `word2[0...j-2]` ) + 1 (插入 `word2[j-1]` )。\n        * `dp[i][j] = 1 + Math.min(dp[i-1][j-1] (替换), Math.min(dp[i-1][j] (删除), dp[i][j-1] (插入)))`。\n
4.  返回 `dp[m][n]`。\n\n**复杂度分析：**\n-   时间复杂度：O(m * n)。\n-   空间复杂度：O(m * n)。(可优化到 O(min(m, n)) )。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 91. 使用最小花费爬楼梯 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_min_cost_climbing_stairs',
        'DESCRIPTION',
        'text',
        E'给你一个整数数组 `cost` ，其中 `cost[i]` 是你爬上第 `i` 级台阶的费用。\n\n你可以选择从 `cost[0]` (索引 0) 或 `cost[1]` (索引 1) 开始爬。',
        NULL,
        1
    ),
    (
        'algo_min_cost_climbing_stairs',
        'DESCRIPTION',
        'text',
        E'一旦你支付了该费用，你就可以选择向上爬**一阶**或**两阶**。\n\n请计算并返回你爬到**楼顶**（即 `cost` 数组之外，索引 `n`）的最小费用。',
        NULL,
        2
    ),
    (
        'algo_min_cost_climbing_stairs',
        'SOLUTION',
        'text',
        E'**思路：动态规划 (O(1) 空间)**\n\n( (9) 爬楼梯 变体)。\n\n1.  **定义 `dp[i]`**：\n    * `dp[i]` 表示：到达第 `i` 级台阶所需的**最小花费**。\n
2.  **(状态转移)**：\n    * 要到达 `i`，只能从 `i-1` (爬 1 阶) 或 `i-2` (爬 2 阶) 来。\n    * `dp[i] = cost[i] + Math.min(dp[i-1], dp[i-2])`。\n
3.  **(初始化)**：\n    * `dp[0] = cost[0]`\n    * `dp[1] = cost[1]`\n
4.  **(终点)**：\n    * 楼顶是 `n`。`dp[n]` (楼顶) = `Math.min(dp[n-1], dp[n-2])` (因为楼顶没有 `cost[n]`)。\n
5.  **(O(1) 空间优化)**：\n    * `a = dp[i-2]`\n    * `b = dp[i-1]`\n
    * (初始化) `a = cost[0]`, `b = cost[1]`。\n    * `for (i = 2 to n-1)`:\n        * `temp = cost[i] + Math.min(a, b)`\n        * `a = b`, `b = temp`\n    * ( `a = dp[n-2]`, `b = dp[n-1]` )\n    * 返回 `Math.min(a, b)`。\n\n(如示例代码：`prev=dp[i-2]`, `curr=dp[i-1]` (从 `i=0` 开始)，`prev=0`, `curr=0` (假设 `dp[-2]=0`, `dp[-1]=0` )，`for (i=0 to n-1)`，最后 `min(prev(dp[n-2]), curr(dp[n-1]))` )\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 92. 相同的树 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_is_same_tree',
        'DESCRIPTION',
        'text',
        E'给你两棵二叉树的根节点 `p` 和 `q` ，编写一个函数来检验这两棵树是否相同。',
        NULL,
        1
    ),
    (
        'algo_is_same_tree',
        'DESCRIPTION',
        'text',
        E'如果两个树在**结构上相同**，并且**节点具有相同的值**，则认为它们是相同的。',
        NULL,
        2
    ),
    (
        'algo_is_same_tree',
        'SOLUTION',
        'text',
        E'**思路：递归 (DFS)**\n\n( (30) 对称二叉树 ( `isMirror` ) 和 (50) 另一棵树的子树 ( `isSameTree` ) 的辅助函数)。\n\n`isSameTree(p, q)`:\n\n1.  **(基线 - 成功)**\n    * `if (p == null && q == null)`，返回 `true` (都为空，相同)。\n\n2.  **(基线 - 失败)**\n    * `if (p == null || q == null)`，返回 `false` (一个空，一个不空，不同)。\n    * `if (p.val != q.val)`，返回 `false` (值不同)。\n
3.  **(递归)**\n    * `return isSameTree(p.left, q.left) && isSameTree(p.right, q.right)`\n    * (必须*同时*满足：左子树相同 且 右子树相同)。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，n 为节点数 ( `min(p.nodes, q.nodes)` )。\n-   空间复杂度：O(h)，h 为树高（递归栈深度）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 93. 删除链表的倒数第 N 个结点 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_remove_nth_node',
        'DESCRIPTION',
        'text',
        E'给你一个链表，删除链表的**倒数第 `n` 个结点**，并且返回链表的头结点。\n\n**要求：** O(1) 空间。',
        NULL,
        1
    ),
    (
        'algo_remove_nth_node',
        'SOLUTION',
        'text',
        E'**思路：快慢指针 (O(1) 空间)**\n\n(O(N) 空间解法：遍历 1 遍 ( `L` )，遍历 2 遍 ( `L - n + 1` ) )\n\nO(1) 空间 (遍历 1 遍)：\n\n1.  **(虚拟头节点)** `dummy = new ListNode(-1, head)`。\n    ( `dummy` 用于处理“删除头节点 `head`” (即倒数第 `L` 个) 的情况)。\n
2.  **(快指针)** `fast = dummy`。\n3.  **(慢指针)** `slow = dummy`。\n\n4.  **(快指针先行)** `fast` 先走 `n + 1` 步。\n    * `for (i = 0 to n)` ( `n+1` 次)，`fast = fast.next`。\n    * ( `fast` 和 `slow` 之间相差 `n + 1` 步)。\n
5.  **(同时走)**\n    * `while (fast != null)`：\n    * `slow = slow.next`\n    * `fast = fast.next`\n
6.  **(此时)**\n    * `fast` 走到了末尾 `null`。\n    * `slow` (比 `fast` 慢 `n+1` 步) 正好停在“要删除的节点”的“**前一个节点**”。\n
7.  **(删除)** `slow.next = slow.next.next`。\n8.  返回 `dummy.next`。\n\n**复杂度分析：**\n-   时间复杂度：O(L)，L 是链表长度。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 94. 电话号码的字母组合 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_letter_combinations_phone',
        'DESCRIPTION',
        'text',
        E'给定一个仅包含数字 `2-9` 的字符串 `digits` ，返回所有它能表示的字母组合。\n\n答案可以按 **任意顺序** 返回。',
        NULL,
        1
    ),
    (
        'algo_letter_combinations_phone',
        'SOLUTION',
        'text',
        E'**思路：回溯 (DFS)**\n\n( (37) 全排列, (80) 子集, (78) 组合总和 的变体)。\n\n`backtrack(digits, index, path, map, result)`:\n-   `index`: `digits` 中正在处理的数字索引 ( `digits[index]` )。\n-   `path`: ( `StringBuilder` ) 当前路径 (如 "ad")。\n-   `map`: ( `Map<Character, String>` ) 存储 (''2'' -> "abc", ''3'' -> "def", ...)。\n-   `result`: ( `List<String>` ) 存储所有结果。\n\n**算法流程：**\n1.  **(基线 - 成功)**\n    * `if (index == digits.length())`：\n    * `result.add(path.toString())`。\n    * `return`。\n
2.  `(获取选择列表)`\n    * `digit = digits.charAt(index)`。\n    * `letters = map.get(digit)` (e.g., "abc")。\n
3.  **(遍历)** `for (char c : letters.toCharArray())` (e.g., ''a'', ''b'', ''c'' )：\n\n    * **(a. 做选择)** `path.append(c)`。\n
    * **(b. 递归)** `backtrack(digits, index + 1, ...)` (处理 `digits` 的下一个索引)。\n
    * **(c. 撤销选择)** `path.deleteCharAt(path.length() - 1)`。\n\n**复杂度分析：**\n-   时间复杂度：O(4^N * N)，N 是 `digits` 长度，4 是 "7" or "9"，N 是 `path.toString()`。\n-   空间复杂度：O(N)，`path` 和递归栈。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 95. 括号生成 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_generate_parentheses',
        'DESCRIPTION',
        'text',
        E'数字 `n` 代表生成括号的对数 ( `n` 个 `(` 和 `n` 个 `)` )。\n\n请你设计一个函数，用于能够生成所有可能的并且 **有效的** 括号组合。',
        NULL,
        1
    ),
    (
        'algo_generate_parentheses',
        'SOLUTION',
        'text',
        E'**思路：回溯 (DFS)**\n\n我们需要“穷举”所有 `2n` 个位置的 `(` 或 `)`，并“剪枝”掉无效的组合。\n\n`backtrack(n, leftCount, rightCount, path, result)`:\n-   `n`: 目标对数。\n-   `leftCount`: `path` 中 `(` 的数量。\n-   `rightCount`: `path` 中 `)` 的数量。\n-   `path`: ( `StringBuilder` )。\n\n**算法流程：**\n1.  **(基线 - 成功)**\n    * `if (path.length() == 2 * n)` ( `leftCount == n && rightCount == n` )：\n    * `result.add(path.toString())`。\n
2.  **(剪枝)** (在递归*前*检查，效率更高)：\n
3.  **(选择 ''('')**\n    * `if (leftCount < n)`：( `(` 还没用完)\n        * `path.append(''('')`\n        * `backtrack(..., leftCount + 1, ...)`\n        * `path.deleteCharAt(path.length() - 1)` (回溯)\n
4.  **(选择 '')'')**\n    * `if (rightCount < leftCount)`：( `)` 必须少于 `(` 才能添加)\n        * `path.append('')'')`\n        * `backtrack(..., rightCount + 1, ...)`\n        * `path.deleteCharAt(path.length() - 1)` (回溯)\n
**复杂度分析：**\n-   时间复杂度：O(4^n / sqrt(n)) (Catalan 数)。\n-   空间复杂度：O(n) ( `path` 和递归栈)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 96. 缺失的第一个正数 (Hard)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_first_missing_positive',
        'DESCRIPTION',
        'text',
        E'给你一个未排序的整数数组 `nums` ，请你找出其中没有出现的**最小的正整数**。',
        NULL,
        1
    ),
    (
        'algo_first_missing_positive',
        'DESCRIPTION',
        'text',
        E'请你实现时间复杂度为 **O(n)** 并且只使用 **O(1)** 额外空间的算法。',
        NULL,
        2
    ),
    (
        'algo_first_missing_positive',
        'SOLUTION',
        'text',
        E'**思路：原地哈希 (In-place Hash / 交换)**\n\n( (68) 负号标记 O(1) 空间，但修改了值)。\n\nO(1) 空间 O(N) 时间，要求我们*原地*操作 `nums` 数组。\n\n目标：让 `nums[i] = i + 1`。\n( `nums[0] = 1`, `nums[1] = 2`, `nums[2] = 3` ... )\n\n**算法流程：**\n1.  **(放置)** `for (i = 0 to n-1)`。\n    * ( `nums[i]` (例如 3) 应该在 `j = nums[i] - 1` (索引 2) 的位置)\n
    * **( `while` 循环)** ( `while` 确保 `swap` 换回来的 `nums[i]` 也被放到正确位置)\n    * `while (nums[i] > 0 && nums[i] <= n && nums[nums[i] - 1] != nums[i])`：\n        * `nums[i] > 0 && nums[i] <= n`: (只关心 `[1, n]` 范围内的数，`-1, 0, n+1` 忽略)。\n        * `nums[nums[i] - 1] != nums[i]`: ( `nums[j]` 不等于 `nums[i]`，防止 `[3, 3]` 死循环)。\n
        * `swap(nums, i, nums[i] - 1)`。\n    * ( `[3,4,-1,1]` -> `[-1,4,3,1]` -> `[-1,1,3,4]` -> `[1,-1,3,4]` )\n
2.  **(检查)** `for (i = 0 to n-1)`。\n    * ( `[1, -1, 3, 4]` )\n    * `if (nums[i] != i + 1)`：\n        * ( `i=1`, `nums[1] = -1`, `!= 2` )。\n        * 返回 `i + 1` (返回 2)。\n
3.  (如果 `[1, 2, ... n]` 都在)，返回 `n + 1`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。`while` 循环 `swap` 最多 O(N) 次。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 97. 二叉树的右视图 (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_bst_right_side_view',
        'DESCRIPTION',
        'text',
        E'给定一个二叉树的 根节点 `root`，想象自己站在树的 **右侧** ，按照从顶部到底部的顺序，返回你所能看到的节点值。',
        NULL,
        1
    ),
    (
        'algo_bst_right_side_view',
        'SOLUTION',
        'text',
        E'**思路：BFS (层序遍历)**\n\n( (53) 二叉树的层序遍历 变体)。\n\n在“层序遍历”中，我们按层遍历。对于每一层 `currentLevel`，该层的 **最后一个** 元素，就是“右视图”能看到的元素。\n\n**算法流程：**\n1.  `Queue<TreeNode>`。\n2.  `while (!queue.isEmpty())`：\n    * `levelSize = queue.size()` (记录当前层的节点数)。\n    * `for (i = 0 to levelSize - 1)`：(遍历当前层)\n        * `node = queue.poll()`。\n
        * **(关键)** `if (i == levelSize - 1)`：\n            * ( `i` 是该层的最后一个索引)\n            * `result.add(node.val)`。\n
        * `if (node.left != null) ...`\n        * `if (node.right != null) ...` (先左后右，不影响)\n\n**(DFS 思路)**\n-   `dfs(node, level, result)`\n-   `if (level == result.size())` (第一次到达 `level` 层)，`result.add(node.val)`。\n-   (关键) **优先 `dfs(root.right, ...)`** (先走右边)，确保 `result.add` 时加的是右视图。\n\n**复杂度分析 (BFS)：**\n-   时间复杂度：O(n)，n 为节点数。\n-   空间复杂度：O(w)，w 是树的最大宽度（ `queue` 的最大大小）。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 98. 验证回文串 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_valid_palindrome',
        'DESCRIPTION',
        'text',
        E'给定一个字符串 `s` ，请你确定它是否是“**回文串**”。',
        NULL,
        1
    ),
    (
        'algo_valid_palindrome',
        'DESCRIPTION',
        'text',
        E'**只考虑字母和数字** ( `Alphanumeric` )，**忽略大小写**。',
        NULL,
        2
    ),
    (
        'algo_valid_palindrome',
        'SOLUTION',
        'text',
        E'**思路：双指针法**\n\n1.  `left = 0`, `right = s.length() - 1`。\n2.  `while (left < right)`：\n
    * **(a. 跳过左侧)** (跳过 `left` 指向的非字母/数字)\n        * `while (left < right && !Character.isLetterOrDigit(s.charAt(left)))`，`left++`。\n
    * **(b. 跳过右侧)** (跳过 `right` 指向的非字母/数字)\n        * `while (left < right && !Character.isLetterOrDigit(s.charAt(right)))`，`right--`。\n
    * **(c. 比较)**\n        * `if (Character.toLowerCase(s.charAt(left)) != Character.toLowerCase(s.charAt(right)))`：\n        * 返回 `false`。\n
    * **(d. 移动)**\n        * `left++`\n        * `right--`\n
3.  返回 `true`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 99. 整数反转 (Easy)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_reverse_integer',
        'DESCRIPTION',
        'text',
        E'给你一个 32 位的有符号整数 `x` ，返回将 `x` 中的数字部分反转后的结果。',
        NULL,
        1
    ),
    (
        'algo_reverse_integer',
        'DESCRIPTION',
        'text',
        E'如果反转后整数超过 32 位的有符号整数的范围 `[−2^31,  2^31 − 1]` ( `Integer.MIN_VALUE` to `Integer.MAX_VALUE` )，就返回 0。',
        NULL,
        2
    ),
    (
        'algo_reverse_integer',
        'SOLUTION',
        'text',
        E'**思路：数学 (溢出检查)**\n\n`x = 123` -> `pop=3, x=12, rev=3` -> `pop=2, x=1, rev=32` -> `pop=1, x=0, rev=321`\n\n**算法流程：**\n1.  `reversed = 0` (用 `int` 或 `long`，但用 `int` 更好)。\n2.  `while (x != 0)`：\n    * `pop = x % 10`。\n    * `x /= 10`。\n
    * **(溢出检查)** (在 `reversed = reversed * 10 + pop` *之前* 检查)\n        * `MAX = Integer.MAX_VALUE` ( `2147483647` )\n        * `MIN = Integer.MIN_VALUE` ( `-2147483648` )\n
        * **(a. 正溢出)**\n            * `if (reversed > MAX / 10)` ( `rev=214748365` )\n            * `|| (reversed == MAX / 10 && pop > 7)` ( `rev=214748364` ( `MAX/10` ), `pop=8` )\n            * `return 0`。\n
        * **(b. 负溢出)**\n            * `if (reversed < MIN / 10)` ( `rev=-214748365` )\n            * `|| (reversed == MIN / 10 && pop < -8)` ( `rev=-214748364` ( `MIN/10` ), `pop=-9` )\n            * `return 0`。\n
    * `reversed = reversed * 10 + pop`。\n
3.  返回 `reversed`。\n\n**复杂度分析：**\n-   时间复杂度：O(log10 n)，n 是 `x` 的值 ( `x` 有 log10 n 位)。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- -----------------------------------------------------
-- 100. 字符串转换整数 (atoi) (Medium)
-- -----------------------------------------------------
INSERT INTO algorithm_content_block (problem_id, category, type, content, language, sort_order)
VALUES
    (
        'algo_string_to_integer_atoi',
        'DESCRIPTION',
        'text',
        E'请你来实现一个 `myAtoi(string s)` 函数，使其能将字符串转换成一个 32 位有符号整数。',
        NULL,
        1
    ),
    (
        'algo_string_to_integer_atoi',
        'DESCRIPTION',
        'text',
        E'**算法如下：**\n1.  读入字符串并丢弃无用的前导**空格**。\n2.  检查第一个非空字符是 **''+''** 或 **''-''** (符号)，或**数字**。\n3.  读入连续的**数字**，直到遇到非数字或到末尾。\n4.  将数字转换为整数。如果数字超出 `[−2^31, 2^31 − 1]` 范围，则截断 (Clamping) 到该范围。\n5.  返回整数。',
        NULL,
        2
    ),
    (
        'algo_string_to_integer_atoi',
        'SOLUTION',
        'text',
        E'**思路：状态机/模拟**\n\n( (99) 整数反转 的溢出检查变体)。\n\n1.  `i = 0`, `n = s.length()`。\n2.  `result = 0` (用 `int` 或 `long`，但 `int` 更好，见 (99) )。\n\n3.  **(1. 去空格)** `while (i < n && s.charAt(i) == '' '') i++`。\n
4.  **(2. 处理符号)**\n    * `sign = 1`。\n    * `if (s[i] == ''+'') i++`。\n    * `else if (s[i] == ''-'')` `sign = -1`, `i++`。\n
5.  **(3. 读数字)** `while (i < n && Character.isDigit(s.charAt(i)))`：\n    * `digit = s.charAt(i) - ''0''`。\n
    * **(4. 溢出检查)** (同 (99) )\n        * `MAX = Integer.MAX_VALUE`\n        * `if (result > (MAX - digit) / 10)` ( `(result * 10 + digit) > MAX` )\n            * `return (sign == 1) ? Integer.MAX_VALUE : Integer.MIN_VALUE`。\n
    * `result = result * 10 + digit`。\n    * `i++`。\n
6.  **(5. 返回)** 返回 `result * sign`。\n\n**复杂度分析：**\n-   时间复杂度：O(n)，遍历 `s`。\n-   空间复杂度：O(1)。',
        NULL,
        1
    );

-- (ID 是 String 的表不需要 setval, 因为它们不使用序列)
SELECT setval('algorithm_content_block_id_seq', (SELECT MAX(id) FROM algorithm_content_block));