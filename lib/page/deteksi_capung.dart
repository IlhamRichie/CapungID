// deteksi_capung.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as img;
import 'dart:typed_data'; // Untuk menggunakan Uint8List
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class DeteksiCapungPage extends StatefulWidget {
  const DeteksiCapungPage({super.key});

  @override
  _DeteksiCapungPageState createState() => _DeteksiCapungPageState();
}

class _DeteksiCapungPageState extends State<DeteksiCapungPage> {
  File? _image;
  String _result = 'Belum ada deteksi';
  bool _isLoading = false;

  // Memuat model TFLite
  Future loadModel() async {
    try {
      await Tflite.loadModel(
        model: 'assets/capung_model.tflite',
        labels: 'assets/labels.txt',
      );
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Fungsi untuk memilih gambar dari galeri
  Future pickImageFromGallery() async {
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
  Future pickImageFromCamera() async {
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

      // Mengonversi gambar hasil resize menjadi bytes dalam format yang diinginkan
      var inputImage = Uint8List.fromList(img.encodeJpg(resizedImage));

      // Prediksi dengan model TensorFlow Lite
      var recognitions = await Tflite.runModelOnBinary(binary: inputImage);

      setState(() {
        _isLoading = false;
        _result = recognitions?.isNotEmpty ?? false
            ? 'Prediksi: ${recognitions![0]['label']} (Confidence: ${(recognitions[0]['confidence'] * 100).toStringAsFixed(2)}%)'
            : 'Gambar tidak dikenali';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _result = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    Tflite.close();
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
                      valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF2C6A77)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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