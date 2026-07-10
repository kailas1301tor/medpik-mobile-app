import 'package:flutter/material.dart';

/// Singleton class to manage connectivity snackbars globally
/// Prevents multiple snackbars from showing when multiple screens
/// are listening to connectivity changes
class ConnectivitySnackbarManager {
  ConnectivitySnackbarManager._();
  static final ConnectivitySnackbarManager _instance =
      ConnectivitySnackbarManager._();
  static ConnectivitySnackbarManager get instance => _instance;

  bool _isShowingSnackbar = false;
  DateTime? _lastSnackbarTime;

  /// Show connectivity snackbar only if one isn't already showing
  /// and enough time has passed since the last one
  void showConnectivitySnackbar({
    required BuildContext context,
    required bool isOnline,
    VoidCallback? onOnlineCallback,
  }) {
    final now = DateTime.now();

    // Prevent showing snackbar if:
    // 1. One is already showing
    // 2. Less than 3 seconds have passed since last snackbar
    if (_isShowingSnackbar) return;
    if (_lastSnackbarTime != null &&
        now.difference(_lastSnackbarTime!).inSeconds < 3) {
      return;
    }

    _isShowingSnackbar = true;
    _lastSnackbarTime = now;

    final messenger = ScaffoldMessenger.of(context);

    // Clear any existing snackbars first
    messenger.clearSnackBars();

    if (isOnline) {
      messenger
          .showSnackBar(
            const SnackBar(
              content: Text('Back online!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          )
          .closed
          .then((_) {
            _isShowingSnackbar = false;
          });

      // Call the online callback if provided
      onOnlineCallback?.call();
    } else {
      messenger
          .showSnackBar(
            const SnackBar(
              content: Text('You\'re offline. Some features may not work.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          )
          .closed
          .then((_) {
            _isShowingSnackbar = false;
          });
    }
  }

  /// Reset the manager (useful for testing or special cases)
  void reset() {
    _isShowingSnackbar = false;
    _lastSnackbarTime = null;
  }
}
