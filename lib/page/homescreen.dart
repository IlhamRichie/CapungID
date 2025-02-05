import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/wave.dart';
import 'bantuan/bantuan.dart';
import 'chatbot/chatbot_capung.dart';
import 'deteksi_capung.dart';
import 'jenis_capung/jenis_capung.dart';
import 'metamorfosis_capung/metamorfosisi_capung.dart';
import 'morfologi_capung/morfologi_capung.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFECA5C),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Wave AppBar sebagai background
            ClipPath(
              clipper: WaveAppBarHome(),
              child: Container(
                height: 330, // Tinggi AppBar disesuaikan
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFda8937), Color(0xFFbb7224)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            // Teks "CapungID" dan Salam
            Positioned(
              top: 60, // Sesuaikan posisi vertikal teks
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'CapungID™',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    getGreeting(),
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Konten utama (tombol-tombol)
            Padding(
              padding: const EdgeInsets.only(top: 160), // Jarak dari atas
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Pusatkan secara vertikal
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Pusatkan secara horizontal
                  children: [
                    _buildActionButton(
                      context,
                      'Deteksi Capung',
                      'assets/images/5.png',
                      'Temukan jenis capung',
                      const DeteksiCapungPage(),
                      Alignment.centerLeft,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      context,
                      'Jenis Capung',
                      'assets/images/3.png',
                      'Kenali berbagai jenis',
                      const JenisCapungPage(),
                      Alignment.centerRight,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      context,
                      'Morfologi Capung',
                      'assets/images/4.png',
                      'Pelajari bentuk tubuh',
                      const MorfologiCapungPage(),
                      Alignment.centerLeft,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      context,
                      'Metamorfosis Capung',
                      'assets/images/6.png',
                      'Proses perubahan capung',
                      const MetamorfosisCapungPage(),
                      Alignment.centerRight,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      context,
                      'Bantuan',
                      'assets/images/1.png',
                      'Butuh bantuan?',
                      const BantuanCapungPage(),
                      Alignment.centerLeft,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      context,
                      'Chatbot',
                      'assets/images/2.png',
                      'Tanya jawab capung',
                      const ChatScreen(), // Ganti dengan halaman chatbot
                      Alignment.centerRight,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '"Selamat Pagi"';
    } else if (hour < 15) {
      return '"Selamat Siang"';
    } else if (hour < 18) {
      return '"Selamat Sore"';
    } else {
      return '"Selamat Malam"';
    }
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    String imagePath,
    String subtitle,
    Widget destinationPage,
    Alignment alignment,
  ) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationPage),
          );
        },
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.92, // Lebar tombol dikurangi
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(
              color: const Color(0xFFbb7224), // Warna border
              width: 3.0, // Ketebalan border
            ),
          ),
          child: Row(
            mainAxisAlignment: alignment == Alignment.centerLeft
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (alignment == Alignment.centerLeft)
                Image.asset(
                  imagePath,
                  height: 100,
                  width: 100,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Teks Label dengan Gradasi Warna
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [
                              Color(0xFFaee0ef),
                              Color(0xFF116baf)
                            ], // Gradasi biru
                            begin: Alignment.topRight,
                            end: Alignment.bottomCenter,
                          ).createShader(bounds);
                        },
                        child: Text(
                          label,
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Warna dasar teks harus putih untuk gradasi
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Subtitle tetap seperti semula
                      Text(
                        subtitle,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: const Color(0xFF116baf),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (alignment == Alignment.centerRight)
                Image.asset(
                  imagePath,
                  height: 100,
                  width: 100,
                ),
            ],
          ),
        ),
      ),
    );
  }
}


// Konstanta untuk warna dan ukuran
class AppColors {
  static const Color primaryColor = Color(0xFF577BC1);
  static const Color waveColor = Color(0xFF344CB7);
}

class AppSizes {
  static const double cardRadius = 20;
}
