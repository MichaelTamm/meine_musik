fun readEnvVar(envVarName: String): String {
    return System.getenv(envVarName) ?: "Environment variable " + envVarName + " not set."
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "de.michaeltamm.meine_musik"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures.apply {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "de.michaeltamm.meine_musik"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = file(readEnvVar("MEINE_MUSIK_KEYSTORE_PATH"))
            storePassword = readEnvVar("MEINE_MUSIK_KEYSTORE_PASSWORD")
            keyAlias = readEnvVar("MEINE_MUSIK_UPLOAD_KEY_ALIAS")
            keyPassword = readEnvVar("MEINE_MUSIK_UPLOAD_KEY_PASSWORD")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
