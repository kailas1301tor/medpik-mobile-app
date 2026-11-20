// lib/res/enums/app_environment.dart
enum AppEnvironment { dev, stage, prod }

extension AppEnvironmentX on AppEnvironment {
  String get baseUrl => switch (this) {
    AppEnvironment.stage => 'https://stage-backend.medpik.in',
    AppEnvironment.dev => 'https://stage-backend.medpik.in',
    AppEnvironment.prod => 'https://stage-backend.medpik.in',
  };

  /// Public dashboard site used for legal pages and other web content.
  ///
  /// Stage/dev intentionally use the production dashboard host because
  /// `stage-dashboard.medpik.in` has no DNS record and legal routes only
  /// exist on `dashboard.medpik.in` today.
  String get webBaseUrl => switch (this) {
    AppEnvironment.stage => 'https://dashboard.medpik.in',
    AppEnvironment.prod => 'https://dashboard.medpik.in',
    AppEnvironment.dev => 'https://dashboard.medpik.in',
  };
}
