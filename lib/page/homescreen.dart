import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CapungID',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme( // Menggunakan font Roboto
          Theme.of(context).textTheme.copyWith(
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C6A77), // Biru Laut
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              color: Color(0xFF8E735B), // Cokelat Hangat
            ),
          ),
        ),
        colorScheme: ColorScheme(
          primary: Color(0xFF2C6A77), // Biru Laut
          onPrimary: Colors.white,
          secondary: Color(0xFF8E735B), // Cokelat Hangat
          onSecondary: Colors.white,
          surface: Color(0xFFA8D5BA), // Hijau Lembut
          onSurface: Colors.black,
          background: Color(0xFFF5F5F5),
          onBackground: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD8B56D), // Emas Lembut
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CapungID'),
        backgroundColor: Color(0xFF2C6A77), // Biru Laut
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Text(
              'Selamat datang di CapungID!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            Text(
              'Apa yang ingin kamu lakukan?',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF8E735B), // Cokelat Hangat
              ),
            ),
            SizedBox(height: 10),

            // Grid section with 3 options
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 kolom
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.2, // Menyesuaikan rasio untuk kotak
                ),
                itemCount: 3, // 3 item dalam grid
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Aksi saat memilih item
                      if (index == 0) {
                        // Menampilkan halaman Deteksi
                      } else if (index == 1) {
                        // Menampilkan informasi spesies
                      } else {
                        // Menampilkan peta lokasi
                      }
                    },
                    child: Card(
                      color: Color(0xFFA8D5BA), // Hijau Lembut
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            index == 0
                                ? Icons.camera_alt // Ikon untuk Deteksi
                                : index == 1
                                    ? Icons.info_outline // Ikon untuk Informasi
                                    : Icons.map, // Ikon untuk Peta
                            size: 50,
                            color: Color(0xFF2C6A77), // Biru Laut
                          ),
                          SizedBox(height: 10),
                          Text(
                            index == 0
                                ? 'Deteksi Capung'
                                : index == 1
                                    ? 'Informasi Spesies'
                                    : 'Peta Lokasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C6A77), // Biru Laut
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
