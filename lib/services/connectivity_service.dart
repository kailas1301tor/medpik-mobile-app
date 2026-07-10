import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  Timer? _debounce;
  bool _isConnected = true;

  Stream<bool> get connectionStream => _controller.stream;
  bool get isConnected => _isConnected;

  ConnectivityService() {
    initialize();
  }

  void initialize() {
    checkConnection();

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      // Debounce to allow network to stabilize
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), () async {
        final status = await _verifyConnection();
        _updateStatus(status);
      });
    });
  }

  Future<void> checkConnection() async {
    final initialStatus = await _verifyConnection();
    _updateStatus(initialStatus);
  }

  Future<bool> _verifyConnection({int retry = 2}) async {
    while (retry > 0) {
      try {
        final response = await http
            .get(Uri.parse("https://clients3.google.com/generate_204"))
            .timeout(const Duration(seconds: 2));

        if (response.statusCode == 204) return true;
      } catch (_) {
        // ignore and retry
      }

      retry--;
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return false;
  }

  void _updateStatus(bool connected) {
    if (!_controller.isClosed && _isConnected != connected) {
      _isConnected = connected;
      _controller.add(connected);
    }
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
