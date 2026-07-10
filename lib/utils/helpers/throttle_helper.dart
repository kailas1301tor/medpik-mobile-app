/// A utility to throttle function calls.
class Throttler {
  static DateTime _lastCall = DateTime.fromMillisecondsSinceEpoch(0);

  static void run(Duration duration, void Function() action) {
    final now = DateTime.now();
    if (now.difference(_lastCall) >= duration) {
      _lastCall = now;
      action();
    }
  }
}

/// Global shortcut for throttling.
void throttle(Duration duration, void Function() action) => 
    Throttler.run(duration, action);
