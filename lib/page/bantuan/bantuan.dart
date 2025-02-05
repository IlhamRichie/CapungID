import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BantuanCapungPage extends StatelessWidget {
  const BantuanCapungPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bantuan',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2C6A77), // Biru Laut
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bantuan Penggunaan Aplikasi:',
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '1. Pilih gambar capung dari galeri atau kamera untuk melakukan identifikasi.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '2. Aplikasi akan memberikan prediksi jenis capung beserta tingkat kepercayaan.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '3. Untuk bantuan lebih lanjut, kunjungi halaman bantuan atau hubungi tim pengembang.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '22090098.ilham@student.poltek.ac.id',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
