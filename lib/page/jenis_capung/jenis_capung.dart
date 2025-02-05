import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/capung/capung_data.dart';
import '../../widgets/wave.dart';
import 'jenis_capung_detail.dart'; // Pastikan file wave.dart ada

class JenisCapungPage extends StatelessWidget {
  const JenisCapungPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFECA5C),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Tinggi AppBar disesuaikan
        child: AppBar(
          title: Text(
            'Jenis Capung',
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          backgroundColor: Colors.transparent, // Transparent background
          elevation: 0,
          flexibleSpace: Stack(
            children: [
              // Background transparan
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent, // Warna transparan
                ),
              ),
              // Wave dengan gradient
              Transform.translate(
                offset: Offset(0, 0), // Geser wave ke bawah
                child: ClipPath(
                  clipper: WaveAppBar(),
                  child: Container(
                    height: 220, // Tinggi container disesuaikan
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFda8937), Color(0xFFbb7224)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Wave di bagian bawah layar
          Positioned(
            bottom: -50, // Menggeser wave ke atas agar terlihat
            left: 0,
            right: 0,
            child: ClipPath(
              clipper:
                  BottomWave(), // Pastikan BottomWave ada di file wave.dart
              child: Container(
                height: 150, // Tinggi wave
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFda8937), Color(0xFFbb7224)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // Gambar di atas card pertama
          Positioned(
            top: 500, // Ubah posisi top untuk mengangkat gambar ke atas
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/5.2.png', // Gambar yang akan ditampilkan
              width: MediaQuery.of(context)
                  .size
                  .width, // Sesuaikan lebar gambar dengan layar
              height: 150, // Tinggi gambar
              fit: BoxFit.cover, // Menjaga proporsi gambar
            ),
          ),
          // Konten utama
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: ListView.builder(
              itemCount: CapungData.capungList.length,
              itemBuilder: (context, index) {
                final capung = CapungData.capungList[index];
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16.0), // Jarak antar card
                  child: _buildCapungCard(
                    context,
                    capung.imagePath,
                    capung.latinName,
                    capung.indonesianName,
                    capung.description,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapungCard(
    BuildContext context,
    String imagePath,
    String latinName,
    String indonesianName,
    String description,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CapungDetailPage(
              latinName: latinName, // Mengirimkan latinName ke halaman detail
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFBB7224),
            width: 3.0,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          Color(0xFF116baf), // Biru Muda
                          Color(0xFFaee0ef), // Biru Tua
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      latinName,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    indonesianName,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF116baf),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: const Color(0xFF116baf),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
