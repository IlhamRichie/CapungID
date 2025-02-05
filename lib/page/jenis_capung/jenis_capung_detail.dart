import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/capung/capung_data.dart';

class CapungDetailPage extends StatelessWidget {
  final String latinName;

  const CapungDetailPage({
    super.key,
    required this.latinName,
  });

  @override
  Widget build(BuildContext context) {
    // Temukan capung berdasarkan latinName
    final capung = CapungData.capungList
        .firstWhere((capung) => capung.latinName == latinName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          capung.latinName,
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:
            Color(0xFFda8937), // Warna yang konsisten dengan header
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background gradient untuk halaman detail
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFda8937), Color(0xFFbb7224)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Capung
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      capung.imagePath,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Nama Latin Capung
                  Text(
                    capung.latinName,
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Nama Indonesia Capung
                  Text(
                    capung.indonesianName,
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Deskripsi panjang (descriptionParagraph)
                  Text(
                    capung.descriptionParagraph,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
