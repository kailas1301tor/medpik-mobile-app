// lib/utils/extensions/controller_extensions.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ScrollControllerExtension on ScrollController {
  bool get isAtTop => offset <= 0;
  bool get isAtBottom => offset >= position.maxScrollExtent;

  void scrollToTop({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) =>
      animateTo(0, duration: duration, curve: curve);

  void scrollToBottom({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) =>
      animateTo(position.maxScrollExtent, duration: duration, curve: curve);
}

extension PageControllerExtension on PageController {
  int get currentPageIndex => page?.round() ?? 0;

  bool get isOnFirstPage => currentPageIndex == 0;

  void nextPage({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) =>
      animateToPage(currentPageIndex + 1, duration: duration, curve: curve);

  void previousPage({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) =>
      animateToPage(currentPageIndex - 1, duration: duration, curve: curve);

  void jumpToFirst() => jumpToPage(0);
}

extension TextEditingControllerExtension on TextEditingController {
  void moveCursorToEnd() {
    selection =
        TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  String get trimmedText => text.trim();
  bool get hasText => text.trim().isNotEmpty;
  bool get isEmpty => text.isEmpty;

  void clearText() {
    clear();
  }
}

extension FormStateExtension on GlobalKey<FormState> {
  bool validateAndSave() {
    final form = currentState;
    if (form == null) return false;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void resetForm() => currentState?.reset();
}

extension FocusNodeExtension on FocusNode {
  void requestNextFocus(BuildContext context, FocusNode next) {
    unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  void unfocusAndHideKeyboard(BuildContext context) {
    unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

extension AnimationControllerExtension on AnimationController {
  void toggle() => isCompleted ? reverse() : forward();

  void replay() {
    reset();
    forward();
  }
}
