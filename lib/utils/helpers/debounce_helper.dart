import 'dart:async';

/// A utility to debounce function calls.
class Debouncer {
  static Timer? _timer;

  static void run(Duration duration, void Function() action) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(duration, action);
  }
}

/// Global shortcut for debouncing.
void debounce(Duration duration, void Function() action) => 
    Debouncer.run(duration, action);
