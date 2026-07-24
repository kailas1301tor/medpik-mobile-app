plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

import java.util.Properties
import org.gradle.api.GradleException

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val googleMapsApiKey: String =
    (localProperties.getProperty("GOOGLE_MAPS_API_KEY")
        ?: System.getenv("GOOGLE_MAPS_API_KEY")
        ?: "")
        .trim()

if (googleMapsApiKey.isEmpty()) {
    throw GradleException(
        """
        GOOGLE_MAPS_API_KEY is missing. The Android build cannot inject an empty
        Maps SDK key into AndroidManifest.xml (maps would fail silently at runtime).

        Set it in android/local.properties:
          GOOGLE_MAPS_API_KEY=your_key_here
        Or export the GOOGLE_MAPS_API_KEY environment variable for CI.

        See docs/location_maps_quota.md.
        """.trimIndent(),
    )
}

android {
    namespace = "com.medpik"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.medpik"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
