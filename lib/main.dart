// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsuite/services/auth_session_service.dart';
import 'package:tsuite/services/onesignal_service.dart';
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
  final session = await container.read(authSessionServiceProvider).restore();
  await container.read(oneSignalServiceProvider).initialize(
        restoredUserId: session?.authModel.id.toString(),
      );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TSuiteApp(),
    ),
  );
}
