// home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'deteksi_capung.dart';  // Import halaman deteksi

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CapungID',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2C6A77), // Biru Laut
        elevation: 0, // Menghilangkan shadow di bawah AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Judul Selamat Datang
              Text(
                'Selamat datang di CapungID!',
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C6A77), // Biru Laut
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // Deskripsi Aplikasi (opsional)
              Text(
                'Identifikasi spesies capung dengan mudah.',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: const Color(0xFF8E735B), // Cokelat Hangat
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Tombol Deteksi Capung
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeteksiCapungPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E735B), // Cokelat Hangat
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Membuat tombol lebih modern dengan border radius
                  ),
                  elevation: 4, // Menambahkan sedikit shadow untuk efek visual
                ),
                child: Text(
                  'Deteksi Capung',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}