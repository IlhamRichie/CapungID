import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MorfologiCapungPage extends StatelessWidget {
  const MorfologiCapungPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Morfologi Capung',
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
              'Bagian-bagian morfologi capung:',
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Deskripsi Morfologi
            Text(
              '1. Kepala: Bagian tubuh capung yang berfungsi untuk penginderaan dan penglihatan.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '2. Thorax: Bagian tubuh yang memiliki sayap dan kaki. Ini adalah bagian tubuh yang berfungsi untuk bergerak.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '3. Abdomen: Bagian tubuh yang panjang dan ramping, berfungsi untuk penyerapan oksigen dan pencernaan.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
