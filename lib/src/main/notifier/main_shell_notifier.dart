// lib/src/main/notifier/main_shell_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:medpik/res/constants/string_constants.dart';
import 'package:medpik/utils/common_widgets/custom_toast.dart';

part 'main_shell_notifier.g.dart';

@Riverpod(keepAlive: false)
class MainShellNotifier extends _$MainShellNotifier {
  DateTime? _lastBackPressTime;

  @override
  int build() => 0;

  void setTab(int index) => state = index;

  bool handleBackPress() {
    if (state != 0) {
      state = 0;
      return false;
    }

    final now = DateTime.now();
    const doubleTapDuration = Duration(seconds: 2);

    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > doubleTapDuration) {
      _lastBackPressTime = now;
      showCustomToast(message: Strings.pressBackAgainToExit);
      return false;
    }
    return true;
  }
}
