plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    }

android {
    namespace = "com.example.game_master_plus"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.game_master_plus"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
