// lib/utils/extensions/async_extensions.dart
import 'dart:async';

extension StreamExtension<T> on Stream<T> {
  Stream<T> debounce(Duration duration) {
    Timer? timer;
    late StreamController<T> controller;
    controller = StreamController<T>(
      onListen: () {
        listen(
          (event) {
            timer?.cancel();
            timer = Timer(duration, () => controller.add(event));
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
        );
      },
    );
    return controller.stream;
  }

  Stream<T> throttle(Duration duration) {
    var lastEmit = DateTime.fromMillisecondsSinceEpoch(0);
    return where((_) {
      final now = DateTime.now();
      if (now.difference(lastEmit) >= duration) {
        lastEmit = now;
        return true;
      }
      return false;
    });
  }

  Stream<T> distinctUntilChanged() {
    T? previous;
    var hasPrevious = false;
    return where((event) {
      if (!hasPrevious || previous != event) {
        previous = event;
        hasPrevious = true;
        return true;
      }
      return false;
    });
  }
}

extension FutureExtension<T> on Future<T> {
  Future<T> withMinDelay(Duration min) async {
    final results = await Future.wait([this, Future.delayed(min)]);
    return results[0] as T;
  }

  Future<T?> get orNull =>
      then<T?>((v) => v).catchError((_) => null);
}

extension DurationExtension on Duration {
  String get timerFormat {
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get fullTimerFormat {
    final h = inHours.toString().padLeft(2, '0');
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return inHours > 0 ? '$h:$m:$s' : '$m:$s';
  }

  String get readable {
    if (inSeconds < 60) return '$inSeconds sec';
    if (inMinutes < 60) return '$inMinutes min';
    if (inHours < 24) return '$inHours hr';
    return '${inDays}d';
  }

  Future<void> get delay => Future.delayed(this);
}
