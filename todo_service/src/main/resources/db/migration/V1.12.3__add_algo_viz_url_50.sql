-- ----------------------------------------------------------------------
-- 更新 algorithm_problem 表的 visualization_url 字段
-- ----------------------------------------------------------------------

-- 1. 基础题目 (Base)
UPDATE algorithm_problem SET visualization_url = '/viz/algo_two_sum.html' WHERE id = 'algo_two_sum';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_reverse_list.html' WHERE id = 'algo_reverse_list';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_lru_cache.html' WHERE id = 'algo_lru_cache';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_valid_parentheses.html' WHERE id = 'algo_valid_parentheses';

-- 2. 版本 1.2 题目 (Version 1.2)
UPDATE algorithm_problem SET visualization_url = '/viz/algo_merge_two_lists.html' WHERE id = 'algo_merge_two_lists';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_buy_sell_stock_1.html' WHERE id = 'algo_buy_sell_stock_1';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_invert_binary_tree.html' WHERE id = 'algo_invert_binary_tree';
-- 注意：此 ID 在插入时带有 .html 后缀，故 WHERE 条件需匹配该 ID
UPDATE algorithm_problem SET visualization_url = '/viz/algo_climbing_stairs.html' WHERE id = 'algo_climbing_stairs.html';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_longest_substring_no_repeat.html' WHERE id = 'algo_longest_substring_no_repeat';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_3sum.html' WHERE id = 'algo_3sum';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_merge_intervals.html' WHERE id = 'algo_merge_intervals';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_kth_smallest_bst.html' WHERE id = 'algo_kth_smallest_bst';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_search_range.html' WHERE id = 'algo_search_range';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_trap_rain_water.html' WHERE id = 'algo_trap_rain_water';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_sliding_window_max.html' WHERE id = 'algo_sliding_window_max';

-- 3. 版本 1.3 题目 (Version 1.3)
UPDATE algorithm_problem SET visualization_url = '/viz/algo_add_two_numbers.html' WHERE id = 'algo_add_two_numbers';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_max_subarray.html' WHERE id = 'algo_max_subarray';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_group_anagrams.html' WHERE id = 'algo_group_anagrams';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_linked_list_cycle.html' WHERE id = 'algo_linked_list_cycle';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_max_depth_tree.html' WHERE id = 'algo_max_depth_tree';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_min_stack.html' WHERE id = 'algo_min_stack';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_coin_change.html' WHERE id = 'algo_coin_change';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_longest_palindrome_sub.html' WHERE id = 'algo_longest_palindrome_sub';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_kth_largest_array.html' WHERE id = 'algo_kth_largest_array';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_word_search.html' WHERE id = 'algo_word_search';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_diameter_tree.html' WHERE id = 'algo_diameter_tree';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_median_data_stream.html' WHERE id = 'algo_median_data_stream';

-- 4. 版本 1.4 题目 (Version 1.4)
UPDATE algorithm_problem SET visualization_url = '/viz/algo_product_except_self.html' WHERE id = 'algo_product_except_self';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_is_symmetric_tree.html' WHERE id = 'algo_is_symmetric_tree';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_max_area_island.html' WHERE id = 'algo_max_area_island';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_merge_sorted_array.html' WHERE id = 'algo_merge_sorted_array';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_lca_bst.html' WHERE id = 'algo_lca_bst';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_lca_bt.html' WHERE id = 'algo_lca_bt';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_daily_temperatures.html' WHERE id = 'algo_daily_temperatures';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_find_all_anagrams.html' WHERE id = 'algo_find_all_anagrams';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_permutations.html' WHERE id = 'algo_permutations';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_word_break.html' WHERE id = 'algo_word_break';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_longest_consecutive.html' WHERE id = 'algo_longest_consecutive';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_rotate_image.html' WHERE id = 'algo_rotate_image';

-- 5. 版本 1.5 题目 (Version 1.5)
UPDATE algorithm_problem SET visualization_url = '/viz/algo_container_most_water.html' WHERE id = 'algo_container_most_water';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_is_valid_bst.html' WHERE id = 'algo_is_valid_bst';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_build_tree_pre_in.html' WHERE id = 'algo_build_tree_pre_in';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_subarray_sum_equals_k.html' WHERE id = 'algo_subarray_sum_equals_k';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_sort_colors.html' WHERE id = 'algo_sort_colors';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_find_duplicate_number.html' WHERE id = 'algo_find_duplicate_number';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_lis.html' WHERE id = 'algo_lis';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_copy_list_random.html' WHERE id = 'algo_copy_list_random';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_min_window_substring.html' WHERE id = 'algo_min_window_substring';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_subtree_of_another_tree.html' WHERE id = 'algo_subtree_of_another_tree';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_rotting_oranges.html' WHERE id = 'algo_rotting_oranges';
UPDATE algorithm_problem SET visualization_url = '/viz/algo_search_rotated_array.html' WHERE id = 'algo_search_rotated_array';