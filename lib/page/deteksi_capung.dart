import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../widgets/wave.dart'; // Import tflite_flutter

class DeteksiCapungPage extends StatefulWidget {
  const DeteksiCapungPage({super.key});

  @override
  _DeteksiCapungPageState createState() => _DeteksiCapungPageState();
}

class _DeteksiCapungPageState extends State<DeteksiCapungPage> {
  File? _image;
  String _result = 'Belum ada deteksi';
  bool _isLoading = false;
  Interpreter? _interpreter; // Interpreter untuk menjalankan model TFLite
  List<String> labels = []; // List untuk menyimpan label

  // Memuat model TFLite
  Future<void> loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/capung_model_v2.tflite');
      print("Model berhasil dimuat");
    } catch (e) {
      print("Error loading model: $e");
      setState(() {
        _result = 'Gagal memuat model: $e';
      });
    }
  }

  // Memuat label dari file labels.txt
  Future<void> loadLabels() async {
    try {
      var labelData = await rootBundle.loadString('assets/labels.txt');
      labels = labelData.split('\n');
      print("Labels berhasil dimuat");
    } catch (e) {
      print("Error loading labels: $e");
    }
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await detectImage(_image!);
    }
  }

  // Fungsi untuk mengambil gambar dari kamera
  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await detectImage(_image!);
    }
  }

  // Fungsi untuk melakukan prediksi
  Future detectImage(File image) async {
    setState(() {
      _isLoading = true;
      _result = 'Mendeteksi...';
    });

    try {
      var imgBytes = image.readAsBytesSync();
      var decodedImage = img.decodeImage(Uint8List.fromList(imgBytes));
      if (decodedImage == null) {
        setState(() {
          _isLoading = false;
          _result = 'Gagal membaca gambar';
        });
        return;
      }

      // Resize gambar ke ukuran input model
      var resizedImage = img.copyResize(decodedImage, width: 224, height: 224);
      var input = preprocessImage(resizedImage);

      // Inisialisasi output
      var output = List.filled(1, List.filled(3, 0.0)).reshape([1, 3]);

      if (_interpreter != null) {
        _interpreter!.run(input, output);
        var recognitions = output[0];

        // Cari label dengan confidence tertinggi
        var maxConfidence = recognitions[0];
        var labelIndex = 0;
        for (int i = 1; i < recognitions.length; i++) {
          if (recognitions[i] > maxConfidence) {
            maxConfidence = recognitions[i];
            labelIndex = i;
          }
        }

        // Validasi apakah gambar mengandung capung
        if (maxConfidence < 0.5) {
          // Jika confidence rendah, anggap tidak ada capung
          setState(() {
            _isLoading = false;
            _result = 'Tidak ada gambar capung';
          });
        } else {
          // Jika confidence cukup tinggi, tampilkan hasil deteksi
          setState(() {
            _isLoading = false;
            _result =
                'Prediksi: ${labels[labelIndex]} (Confidence: ${(maxConfidence * 100).toStringAsFixed(2)}%)';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _result = 'Model tidak dimuat';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = 'Terjadi kesalahan: $e';
      });
    }
  }

  // Fungsi untuk memproses gambar menjadi tensor input
  List<List<List<List<double>>>> preprocessImage(img.Image image) {
    var input = List.generate(
        1,
        (_) => List.generate(
            224, (_) => List.generate(224, (_) => List.filled(3, 0.0))));
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        var pixel = image.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }
    return input;
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    loadLabels();
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Tinggi AppBar disesuaikan
        child: AppBar(
          title: Text(
            'Deteksi Capung',
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
          // Gambar background di bagian bawah layar
          Positioned(
            bottom: 305, // Menggeser gambar ke atas
            left: -20,
            right: 0,
            child: Image.asset(
              'assets/images/5.png', // Gambar background
              width: MediaQuery.of(context).size.width *
                  0.9, // Ukuran gambar diatur
              height: 400, // Tinggi gambar diatur
              fit: BoxFit.cover, // Memastikan gambar tetap proporsional
            ),
          ),
          // Konten utama
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gambar yang dipilih atau placeholder
                  _image == null
                      ? Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF116baf), // Warna border
                              width: 3.0, // Ketebalan border
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Tidak ada gambar yang dipilih.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF116baf), // Warna border
                                width: 3.0, // Ketebalan border
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.file(
                              _image!,
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  // Status deteksi
                  _isLoading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF116baf)),
                        )
                      : Text(
                          _result,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(
                                255, 132, 202, 255), // Biru muda
                          ),
                          textAlign: TextAlign.center,
                        ),
                  const SizedBox(height: 40),
                  // Tombol Pilih Gambar dari Galeri
                  ElevatedButton(
                    onPressed: pickImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF116baf), // Biru muda
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Pilih Gambar dari Galeri',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tombol Ambil Foto dari Kamera
                  ElevatedButton(
                    onPressed: pickImageFromCamera,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF116baf), // Biru muda
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Ambil Foto dari Kamera',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Wave di bagian bawah layar
          Positioned(
            bottom: -50, // Menggeser wave ke atas agar terlihat
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: BottomWave(),
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
        ],
      ),
    );
  }
}
