import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/utils/helpers/connectivity_result_helper.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  Timer? _debounce;
  bool _isConnected = true;
  bool _hasEmittedInitial = false;

  Stream<bool> get connectionStream => _controller.stream;
  bool get isConnected => _isConnected;

  ConnectivityService() {
    initialize();
  }

  void initialize() {
    checkConnection();

    _subscription = _connectivity.onConnectivityChanged.listen((_) {
      // Debounce, then re-query so we use the settled interface list.
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), () {
        unawaited(checkConnection());
      });
    });
  }

  Future<void> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatus(isOnlineFromConnectivityResults(results));
    } catch (error) {
      debugPrint('🔴 CONNECTIVITY CHECK ERROR: $error');
      // Fail open — let real API/Dio errors surface network issues.
      _updateStatus(true);
    }
  }

  void _updateStatus(bool connected) {
    if (_controller.isClosed) return;

    final shouldEmit = !_hasEmittedInitial || _isConnected != connected;
    _isConnected = connected;
    if (!shouldEmit) return;

    _hasEmittedInitial = true;
    _controller.add(connected);
    debugPrint(
      connected
          ? '🟢 CONNECTIVITY: online (interface)'
          : '🟡 CONNECTIVITY: offline (no interface)',
    );
  }

  void dispose() {
    _subscription.cancel();
    _debounce?.cancel();
    _controller.close();
  }
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
});

final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectionStream;
});
