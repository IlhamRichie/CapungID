import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite_flutter/tflite_flutter.dart'; // Import tflite_flutter

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
      // Memuat model dari file .tflite
      _interpreter = await Interpreter.fromAsset('assets/capung_model_v2.tflite');
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
  Future<void> detectImage(File image) async {
    setState(() {
      _isLoading = true;
      _result = 'Mendeteksi...';
    });

    try {
      // Membaca file gambar dan mengubahnya menjadi bytes
      var imgBytes = image.readAsBytesSync();
      // Decode gambar menggunakan package 'image'
      var decodedImage = img.decodeImage(Uint8List.fromList(imgBytes));

      // Cek jika gambar berhasil didecode
      if (decodedImage == null) {
        setState(() {
          _isLoading = false;
          _result = 'Gagal membaca gambar';
        });
        return;
      }

      // Resize gambar agar sesuai dengan ukuran input model
      var resizedImage = img.copyResize(decodedImage, width: 224, height: 224);

      // Mengonversi gambar hasil resize menjadi tensor input
      var input = preprocessImage(resizedImage);

      // Menyiapkan output sesuai dengan jumlah kelas (3 kelas dalam kasus ini)
      var output = List.filled(1, List.filled(3, 0.0))
          .reshape([1, 3]); // Sesuaikan dengan output model Anda

      // Menjalankan model
      if (_interpreter != null) {
        _interpreter!.run(input, output);

        // Mengambil hasil prediksi
        var recognitions = output[0];

        // Menggunakan max dan indexOf untuk mencari label dengan confidence tertinggi
        var maxConfidence = recognitions[0];
        var labelIndex = 0;

        for (int i = 1; i < recognitions.length; i++) {
          if (recognitions[i] > maxConfidence) {
            maxConfidence = recognitions[i];
            labelIndex = i;
          }
        }

        setState(() {
          _isLoading = false;
          _result =
              'Prediksi: ${labels[labelIndex]} (Confidence: ${(maxConfidence * 100).toStringAsFixed(2)}%)';
        });
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
        input[0][y][x][0] = pixel.r / 255.0; // Normalisasi channel Red
        input[0][y][x][1] = pixel.g / 255.0; // Normalisasi channel Green
        input[0][y][x][2] = pixel.b / 255.0; // Normalisasi channel Blue
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
    _interpreter?.close(); // Menutup interpreter saat widget di-dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deteksi Capung',
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
            children: [
              // Gambar yang dipilih atau placeholder
              _image == null
                  ? Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
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
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        _image!,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(height: 20),

              // Status deteksi
              _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF2C6A77)),
                    )
                  : Text(
                      _result,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8E735B), // Cokelat Hangat
                      ),
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 40),

              // Tombol Pilih Gambar dari Galeri
              ElevatedButton(
                onPressed: pickImageFromGallery,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E735B), // Cokelat Hangat
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                  backgroundColor: const Color(0xFF8E735B), // Cokelat Hangat
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
    );
  }
}
