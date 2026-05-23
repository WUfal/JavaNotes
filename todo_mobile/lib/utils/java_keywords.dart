class JavaKeywords {
  // 基础关键字
  static const List<String> all = [
    'System', 'out', 'println', 'String', 'Math', 'Integer', 'Double', 'Boolean',
    'List', 'ArrayList', 'HashMap', 'Map', 'Set', 'HashSet', 'Arrays', 'Collections',
    'public', 'class', 'static', 'void', 'main', 'return', 'import', 'package',
    'int', 'double', 'boolean', 'char', 'float', 'long', 'byte', 'short',
    'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'break', 'continue', 'default',
    'try', 'catch', 'finally', 'throw', 'throws',
    'length', 'size()', 'add', 'get', 'remove', 'toString()', 'equals', 'contains',
    'true', 'false', 'null', 'new', 'this', 'super', 'final', 'extends', 'implements'
  ];
  // --- ⬇️ (新增) 常用方法列表 (用于 "." 触发) ⬇️ ---
  static const List<String> methods = [
    'add()', 'remove()', 'get()', 'set()', 'size()', 'clear()', 'isEmpty()', // 集合
    'length()', 'substring()', 'charAt()', 'equals()', 'contains()', 'indexOf()', 'split()', 'trim()', // 字符串
    'toString()', 'hashCode()',
    'println()', 'print()',
    'max()', 'min()', 'abs()', 'pow()', 'sqrt()' // Math
  ];
  // 符号栏
  static const List<String> symbols = [
    '{', '}', '(', ')', '[', ']', ';', '.', '"', '=', '+', '-', '*', '/', '!', '<', '>'
  ];

  // 智能模版 (输入左边，自动变成右边)
  static const Map<String, String> snippets = {
    'sout': 'System.out.println();',
    'psvm': 'public static void main(String[] args) {\n    \n}',
    'fori': 'for (int i = 0; i < ; i++) {\n    \n}',
  };
}