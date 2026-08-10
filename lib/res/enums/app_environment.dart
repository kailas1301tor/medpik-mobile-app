// lib/res/enums/app_environment.dart
enum AppEnvironment { dev, stage, prod }

extension AppEnvironmentX on AppEnvironment {
  String get baseUrl => switch (this) {
    AppEnvironment.stage => 'https://stage-backend.medpik.in',
    AppEnvironment.dev => '',
    AppEnvironment.prod => '',
  };

  /// Public marketing site used for legal pages and other web content.
  String get webBaseUrl => switch (this) {
    AppEnvironment.stage => 'https://stage.medpik.in',
    AppEnvironment.prod => 'https://medpik.in',
    AppEnvironment.dev => 'https://stage.medpik.in',
  };
}
