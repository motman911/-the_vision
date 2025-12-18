plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // 🔧 غير هذا السطر - يجب أن يكون نفس applicationId
    namespace = "com.sks.vision"  // غير من "com.example.the_vision"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.sks.vision"  // ✅ هذا صحيح
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 1  // 🔧 أضف قيمة ثابتة
        versionName = "1.0.0"  // 🔧 أضف قيمة ثابتة
    }

    signingConfigs {
        create("release") {
            // ملف keystore يكون داخل android/app
            storeFile = file("app-release.keystore")
            storePassword = "Skimo590"
            keyAlias = "upload"
            keyPassword = "Skimo590"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}