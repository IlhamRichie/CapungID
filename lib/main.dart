import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'page/homescreen.dart';  // Import HomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CapungID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Menggunakan Google Fonts Roboto sebagai default font
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Color(0xFF8E735B), // Cokelat Hangat untuk teks body
          displayColor: Color(0xFF2C6A77), // Biru Laut untuk teks headline
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal, // Menggunakan warna biru laut sebagai primarySwatch
          accentColor: Color(0xFF8E735B), // Cokelat Hangat sebagai secondary
          backgroundColor: Color(0xFFF5F5F5), // Background putih keabu-abuan
          errorColor: Colors.red, // Warna merah untuk error
          brightness: Brightness.light,
        ).copyWith(
          primary: Color(0xFF2C6A77), // Biru Laut
          onPrimary: Colors.white,
          secondary: Color(0xFF8E735B), // Cokelat Hangat
          onSecondary: Colors.white,
          surface: Color(0xFFA8D5BA), // Hijau Lembut
          onSurface: Colors.black,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD8B56D), // Emas Lembut
        ),
        useMaterial3: true, // Mengaktifkan Material Design 3
      ),
      home: const HomeScreen(),  // Ganti dengan HomeScreen
    );
  }
}