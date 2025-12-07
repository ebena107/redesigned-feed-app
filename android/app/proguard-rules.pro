# ProGuard rules for Feed Estimator
# Keep Flutter and plugin entry points
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep generated GoRouter data classes
-keep class **_Route { *; }
-keepclassmembers class * extends com.google.gson.TypeAdapter { *; }

# Keep json_serializable generated adapters
-keep class **$$JsonAdapter { *; }
-keep class **_$* { *; }

# Keep Riverpod generated providers
-keep class **_provider { *; }
-keepclassmembers class **_provider { *; }

# Avoid obfuscating model classes used for SQLite serialization
-keepclassmembers class * implements java.io.Serializable { *; }

# Retain annotations used by reflection (if any)
-keepattributes *Annotation*
