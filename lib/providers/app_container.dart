// lib/providers/app_container.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root [ProviderContainer] set from `main.dart`.
///
/// Used for logout cleanup that must not run through AuthNotifier's `ref`
/// (avoids Auth ↔ NetworkServices circular dependency on invalidate).
ProviderContainer? appProviderContainer;

void bindAppProviderContainer(ProviderContainer container) {
  appProviderContainer = container;
}

void unbindAppProviderContainer(ProviderContainer container) {
  if (identical(appProviderContainer, container)) {
    appProviderContainer = null;
  }
}
