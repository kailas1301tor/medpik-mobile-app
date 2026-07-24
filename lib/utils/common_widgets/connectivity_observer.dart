import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/services/connectivity_service.dart';

/// A single, app-root-level widget that observes connectivity changes
/// and shows a global snackbar (online / offline).
///
/// Place this as a direct child of [MaterialApp.builder] so that it has
/// access to [ScaffoldMessenger] and lives for the entire app lifecycle.
///
/// There must be **exactly one** instance of this widget in the tree.
/// Individual screens and [CommonSwitchState] widgets do NOT need to
/// handle snackbar display — this widget does it globally.
class ConnectivityObserver extends ConsumerStatefulWidget {
  const ConnectivityObserver({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ConnectivityObserver> createState() =>
      _ConnectivityObserverState();
}

class _ConnectivityObserverState extends ConsumerState<ConnectivityObserver> {
  bool? _previousStatus;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(connectivityStatusProvider, (previous, next) {
      final isOnline = next.valueOrNull ?? true;

      // Skip the very first emission — don't show snackbar on app launch
      if (_previousStatus == null) {
        _previousStatus = isOnline;
        return;
      }

      // Only react to actual transitions
      if (_previousStatus == isOnline) return;
      _previousStatus = isOnline;

      _showConnectivitySnackbar(isOnline);
    });

    return widget.child;
  }

  void _showConnectivitySnackbar(bool isOnline) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    // Clear existing connectivity snackbars before showing a new one
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          isOnline
              ? 'Back online!'
              : "You're offline. Some features may not work.",
        ),
        backgroundColor: isOnline ? Colors.green : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isOnline ? 2 : 3),
      ),
    );
  }
}
