# Pertahankan semua kelas dari TensorFlow Lite
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# Jika ada library lain yang bermasalah, tambahkan aturan serupa
-keep class com.example.library.** { *; }
-dontwarn com.example.library.**