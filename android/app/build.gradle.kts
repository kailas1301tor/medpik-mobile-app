plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

import java.util.Properties
import java.util.Base64
import groovy.json.JsonSlurper
import com.flutter.gradle.tasks.FlutterTask
import kotlin.text.Charsets
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

fun decodeDartDefines(encodedDefines: String): List<Pair<String, String>> {
    if (encodedDefines.isBlank()) return emptyList()

    return encodedDefines
        .split(",")
        .mapNotNull { encodedValue ->
            runCatching {
                val decoded = String(Base64.getDecoder().decode(encodedValue.trim()), Charsets.UTF_8)
                val separatorIndex = decoded.indexOf("=")
                if (separatorIndex <= 0) {
                    null
                } else {
                    decoded.substring(0, separatorIndex).trim() to
                        decoded.substring(separatorIndex + 1).trim()
                }
            }.getOrNull()
        }
}

fun encodeDartDefine(key: String, value: String): String =
    Base64.getEncoder().encodeToString("$key=$value".toByteArray(Charsets.UTF_8))

val dartDefinesFile = rootProject.file("../config/dart_defines.json")
if (!dartDefinesFile.exists()) {
    throw GradleException(
        """
        config/dart_defines.json is missing. The Android build cannot inject
        the Dart Geocoding key, so address lookup would fail in release.

        Run ./tool/bootstrap_secrets.sh before building.
        """.trimIndent(),
    )
}

@Suppress("UNCHECKED_CAST")
val fileDartDefines = JsonSlurper().parse(dartDefinesFile) as Map<String, Any?>
val googleGeocodingKey = fileDartDefines["GOOGLE_MAPS_API_KEY"]?.toString()?.trim().orEmpty()
if (googleGeocodingKey.isEmpty()) {
    throw GradleException(
        """
        GOOGLE_MAPS_API_KEY is missing in config/dart_defines.json.
        Set GOOGLE_GEOCODING_KEY in config/secrets.local.json, then run
        ./tool/bootstrap_secrets.sh before building.
        """.trimIndent(),
    )
}

val mergedDartDefines = linkedMapOf<String, String>()
fileDartDefines.forEach { (key, value) ->
    val defineKey = key.trim()
    val defineValue = value?.toString()?.trim().orEmpty()
    if (defineKey.isNotEmpty() && defineValue.isNotEmpty()) {
        mergedDartDefines[defineKey] = defineValue
    }
}
decodeDartDefines(project.findProperty("dart-defines")?.toString().orEmpty())
    .forEach { (key, value) ->
        if (key.isNotEmpty() && value.isNotEmpty()) {
            mergedDartDefines[key] = value
        }
    }

val encodedDartDefines = mergedDartDefines
    .map { (key, value) -> encodeDartDefine(key, value) }
    .joinToString(",")

extra["dart-defines"] = encodedDartDefines
tasks.withType<FlutterTask>().configureEach {
    dartDefines = encodedDartDefines
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
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
        applicationId = "com.medpik"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey
    }

    signingConfigs {
        create("release") {
            val keyAliasVal = keystoreProperties.getProperty("keyAlias")
            val keyPasswordVal = keystoreProperties.getProperty("keyPassword")
            val storeFileVal = keystoreProperties.getProperty("storeFile")
            val storePasswordVal = keystoreProperties.getProperty("storePassword")

            if (keyAliasVal != null && keyPasswordVal != null && storeFileVal != null && storePasswordVal != null) {
                keyAlias = keyAliasVal
                keyPassword = keyPasswordVal
                storeFile = file(storeFileVal)
                storePassword = storePasswordVal
            }
        }
    }

    buildTypes {
        release {
            val releaseSigning = signingConfigs.getByName("release")
            signingConfig = if (releaseSigning.storeFile?.exists() == true) {
                releaseSigning
            } else {
                signingConfigs.getByName("debug")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
