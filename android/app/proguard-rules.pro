# ML Kit text recognition - optional language-specific options referenced by google_mlkit_text_recognition
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# slf4j binding referenced by ML Kit internals
-dontwarn org.slf4j.impl.**
