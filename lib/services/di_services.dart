// lib/services/di_services.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/services/invalidate_di.dart';

/// Dispose/invalidate keepAlive providers on logout.
void disposeProviders(WidgetRef ref) => InvalidateDI.invalidateWidget(ref);
