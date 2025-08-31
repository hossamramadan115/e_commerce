# Flutter Stripe keep rules
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

# Kotlin coroutines
-dontwarn kotlinx.coroutines.**

# Prevent warnings for Java 8 APIs used by Stripe
-dontwarn java.time.**

# Exclude PushProvisioning (Google Wallet / Apple Wallet) since it's not used
-dontwarn com.stripe.android.pushprovisioning.**
-keep class com.stripe.android.pushprovisioning.** { *; }
