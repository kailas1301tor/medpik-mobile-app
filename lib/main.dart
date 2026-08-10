// lib/main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/enums/app_environment.dart';
import 'package:medpik/services/onesignal_service.dart';
import 'package:medpik/src/auth/notifier/auth_notifier.dart';
import 'package:medpik/utils/helpers/app_environment_helper.dart';
import 'package:medpik/utils/helpers/pre_cache_images.dart';
import 'src/root/medpik_app.dart';
import 'utils/helpers/common_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureAppEnvironment(
    kDebugMode ? AppEnvironment.stage : AppEnvironment.prod,
  );
  PreCacheImages.initializeAllImages();
  configureImageCache();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final container = ProviderContainer();
  final restoredUserId = await container
      .read(authNotifierProvider.notifier)
      .bootstrap();
  await container
      .read(oneSignalServiceProvider)
      .initialize(restoredUserId: restoredUserId);

  runApp(
    UncontrolledProviderScope(container: container, child: const MedpikApp()),
  );
}
