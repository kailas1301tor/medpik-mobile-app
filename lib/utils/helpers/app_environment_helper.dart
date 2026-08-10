// lib/utils/helpers/app_environment_helper.dart
import 'package:medpik/res/constants/app_constants.dart';
import 'package:medpik/res/enums/app_environment.dart';

/// Resolves the API base URL for the given [environment].
String resolveAppEnvironmentBaseUrl(AppEnvironment environment) =>
    environment.baseUrl;

/// Applies [environment] to [AppConstants.baseURL] and returns the resolved URL.
String configureAppEnvironment(AppEnvironment environment) {
  AppConstants.configureEnvironment(environment);
  return AppConstants.baseURL;
}
