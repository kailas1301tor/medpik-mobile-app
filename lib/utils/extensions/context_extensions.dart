// lib/utils/extensions/context_extensions.dart
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  double get bottomInset => mediaQuery.viewInsets.bottom;
  bool get isKeyboardOpen => mediaQuery.viewInsets.bottom > 0;
  double get statusBarHeight => mediaQuery.padding.top;
  double get bottomBarHeight => mediaQuery.padding.bottom;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;

  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  Future<T?> push<T>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => page));
  Future<T?> pushReplacement<T>(Widget page) =>
      Navigator.of(this).pushReplacement<T, dynamic>(
          MaterialPageRoute(builder: (_) => page));
  void popUntilFirst() =>
      Navigator.of(this).popUntil((route) => route.isFirst);

  void hideKeyboard() => FocusScope.of(this).unfocus();
  void requestFocus(FocusNode node) =>
      FocusScope.of(this).requestFocus(node);

  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

extension ContextDialogExtension on BuildContext {
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: this,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(this, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(this, true),
            style: TextButton.styleFrom(
              foregroundColor:
                  confirmColor ?? Theme.of(this).colorScheme.error,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool isScrollControlled = true,
    Color? backgroundColor,
    double? maxHeight,
  }) =>
      showModalBottomSheet<T>(
        context: this,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        backgroundColor:
            backgroundColor ?? Theme.of(this).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints:
            maxHeight != null ? BoxConstraints(maxHeight: maxHeight) : null,
        builder: (_) => child,
      );

  void showLoadingDialog({String? message}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(message),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dismissDialog() =>
      Navigator.of(this, rootNavigator: true).pop();
}
