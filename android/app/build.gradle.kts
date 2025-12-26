plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.sks.vision"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.sks.vision" // 👈 تأكد أن هذا هو نفس الاسم المسجل في فايربيس
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    signingConfigs {
        create("release") {
            // هذا الإعداد سنحتاجه لاحقاً عند رفع التطبيق للمتجر
            // حالياً قد يسبب خطأ إذا لم يكن الملف موجوداً، لكن سأتركه كما هو
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
            // 🔥 التعديل هنا: حذفنا سطر التوقيع لكي يستخدم مفتاح الـ Debug الافتراضي
            // signingConfig = signingConfigs.getByName("release") ❌
        }
    }
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
}