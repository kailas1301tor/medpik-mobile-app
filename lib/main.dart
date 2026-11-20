// lib/main.dart
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medpik/res/enums/app_environment.dart';
import 'package:medpik/providers/app_container.dart';
import 'package:medpik/services/crash_reporting_service.dart';
import 'package:medpik/services/onesignal_service.dart';
import 'package:medpik/src/auth/notifier/auth_notifier.dart';
import 'package:medpik/src/orders/notifier/orders_notifier.dart';
import 'package:medpik/utils/helpers/app_environment_helper.dart';
import 'package:medpik/utils/helpers/pre_cache_images.dart';
import 'src/root/medpik_app.dart';
import 'utils/helpers/common_functions.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CrashReportingService.instance.initialize();

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
    bindAppProviderContainer(container);
    final restoredUserId = await container
        .read(authNotifierProvider.notifier)
        .bootstrap();
    await container
        .read(oneSignalServiceProvider)
        .initialize(restoredUserId: restoredUserId);

    // Resume verify if the app was killed mid-Razorpay checkout.
    if (restoredUserId != null && restoredUserId.trim().isNotEmpty) {
      unawaited(
        container
            .read(ordersNotifierProvider.notifier)
            .resumePendingPaymentIfAny(),
      );
    }

    runApp(
      UncontrolledProviderScope(container: container, child: const MedpikApp()),
    );
  }, CrashReportingService.instance.recordZoneError);
}
