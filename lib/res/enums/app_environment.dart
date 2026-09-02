// lib/res/enums/app_environment.dart
enum AppEnvironment { dev, stage, prod }

extension AppEnvironmentX on AppEnvironment {
  String get baseUrl => switch (this) {
    AppEnvironment.stage => 'https://stage-backend.medpik.in',
    AppEnvironment.dev => 'https://stage-backend.medpik.in',
    AppEnvironment.prod => 'https://production-backend.medpik.in',
  };

  /// Public dashboard site used for legal pages and other web content.
  String get webBaseUrl => switch (this) {
    AppEnvironment.stage => 'https://stage-dashboard.medpik.in',
    AppEnvironment.prod => 'https://dashboard.medpik.in',
    AppEnvironment.dev => 'https://stage-dashboard.medpik.in',
  };
}
