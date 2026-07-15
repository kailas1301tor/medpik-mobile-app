// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/services/auth_session_service.dart';
import 'src/root/tsuite_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final container = ProviderContainer();
  await container.read(authSessionServiceProvider).initialize();
  await container.read(authSessionServiceProvider).restore();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TSuiteApp(),
    ),
  );
}
