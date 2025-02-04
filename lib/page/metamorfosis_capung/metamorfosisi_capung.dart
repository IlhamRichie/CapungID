import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetamorfosisCapungPage extends StatelessWidget {
  const MetamorfosisCapungPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Metamorfosis Capung',
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
              'Proses Metamorfosis Capung:',
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '1. Telur: Capung memulai siklus hidupnya dengan bertelur di permukaan air.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '2. Larva: Setelah menetas, larva capung berkembang di dalam air selama beberapa bulan hingga mencapai tahap nymph.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '3. Nymph: Nymph capung merupakan tahap berikutnya yang menghabiskan waktu untuk berkembang di bawah air.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '4. Imago (Dewasa): Setelah melalui tahapan nymph, capung menjadi dewasa dan terbang di udara.',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
