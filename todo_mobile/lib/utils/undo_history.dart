import 'dart:async';

class SimpleUndoHistory {
  final List<String> _stack = [];
  int _pointer = -1;
  final int _limit = 50; // 最多记住 50 步
  Timer? _debounce;

  // 获取当前内容
  String? get current => _pointer >= 0 && _pointer < _stack.length ? _stack[_pointer] : null;

  // 能否撤回
  bool get canUndo => _pointer > 0;

  // 能否重做
  bool get canRedo => _pointer < _stack.length - 1;

  // 添加新记录 (带防抖，防止每打一个字都存一次)
  void record(String text, {bool force = false}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // 如果是强制保存（比如回车、粘贴），或者等待了 800ms
    if (force) {
      _push(text);
    } else {
      _debounce = Timer(const Duration(milliseconds: 800), () {
        _push(text);
      });
    }
  }

  void _push(String text) {
    // 如果内容没变，不存
    if (_pointer >= 0 && _stack[_pointer] == text) return;

    // 如果我们在历史中间，切断后面的（新的未来）
    if (_pointer < _stack.length - 1) {
      _stack.removeRange(_pointer + 1, _stack.length);
    }

    // 存入
    _stack.add(text);
    _pointer++;

    // 限制大小
    if (_stack.length > _limit) {
      _stack.removeAt(0);
      _pointer--;
    }
  }

  String? undo() {
    if (!canUndo) return null;
    _pointer--;
    return _stack[_pointer];
  }

  String? redo() {
    if (!canRedo) return null;
    _pointer++;
    return _stack[_pointer];
  }

  void clear() {
    _stack.clear();
    _pointer = -1;
  }
}