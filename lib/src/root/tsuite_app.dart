import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:tsuite/res/constants/string_constants.dart';
import 'package:tsuite/res/styles/app_theme.dart';
import 'package:tsuite/res/styles/theme_provider.dart';
import 'package:tsuite/utils/common_widgets/connectivity_observer.dart';
import 'package:tsuite/utils/routes/route_constants.dart';
import 'package:tsuite/utils/routes/route_generator.dart';

final navigatorKeyProvider =
    Provider((_) => GlobalKey<NavigatorState>());

class TSuiteApp extends ConsumerWidget {
  const TSuiteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeNotifierProvider);
    final themeMode = themeAsync.valueOrNull ?? ThemeMode.system;
    final navigatorKey = ref.watch(navigatorKeyProvider);

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => ToastificationWrapper(
        child: ConnectivityObserver(          
          child: MaterialApp(
            title: Strings.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,       
            builder: (_, child) => MediaQuery.withClampedTextScaling(
              minScaleFactor: 1,
              maxScaleFactor: 1,
              child: child ?? const SizedBox(),
            ),
            localizationsDelegates:  [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: RouteConstants.routeInitial,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
          ),
        ),
      ),
    );
  }
}