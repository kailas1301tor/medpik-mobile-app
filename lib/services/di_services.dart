import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dispose/invalidate commonly cached providers on logout.
///
/// Add your notifier providers here as you create new features.
disposeProviders(WidgetRef ref) {
  // ref.invalidate(authNotifierProvider);
  // ref.invalidate(homeNotifierProvider);
}
