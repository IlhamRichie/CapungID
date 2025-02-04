import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JenisCapungPage extends StatelessWidget {
  const JenisCapungPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jenis Capung',
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
        child: ListView(
          children: [
            // Jenis Capung 1
            ListTile(
              title: Text(
                'Orthetrum sabina',
                style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Capung dengan tubuh ramping dan warna yang indah.'),
            ),
            Divider(),
            // Jenis Capung 2
            ListTile(
              title: Text(
                'Pantala flavescens',
                style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Capung dengan sayap besar dan warna kekuningan.'),
            ),
            Divider(),
            // Jenis Capung 3
            ListTile(
              title: Text(
                'Neurothemis ramburii',
                style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Capung dengan warna merah cerah dan sayap yang lebar.'),
            ),
          ],
        ),
      ),
    );
  }
}
