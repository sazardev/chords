import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "app.chords.chords"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "app.chords.chords"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Flavors (variantes) de Chords: dev, staging y prod.
    // Cada flavor tiene su propio applicationId, nombre visible y punto de
    // entrada Dart (lib/main_dev.dart, lib/main_staging.dart, lib/main_prod.dart).
    flavorDimensions += "app"
    productFlavors {
        create("dev") {
            dimension = "app"
            applicationId = "app.chords.chords.dev"
        }
        create("staging") {
            dimension = "app"
            applicationId = "app.chords.chords.staging"
        }
        create("prod") {
            dimension = "app"
            applicationId = "app.chords.chords"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
