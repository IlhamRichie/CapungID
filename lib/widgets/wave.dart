import 'dart:math';
import 'package:flutter/material.dart';

class AbstractWaveCircle extends StatefulWidget {
  @override
  _AbstractWaveCircleState createState() => _AbstractWaveCircleState();
}

class _AbstractWaveCircleState extends State<AbstractWaveCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  double _dx = 0; // Kecepatan horizontal
  double _dy = 0; // Kecepatan vertikal
  double _circleSize = 60; // Ukuran lingkaran
  Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller animasi dengan durasi yang sangat cepat agar bisa berulang
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    )..repeat(); // Animasi berulang terus-menerus

    // Menginisialisasi kecepatan gerak acak
    _dx = _random.nextDouble() * 2 - 1; // Kecepatan horizontal acak
    _dy = _random.nextDouble() * 2 - 1; // Kecepatan vertikal acak

    // Membuat animasi untuk mengubah posisi
    _xAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _yAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Mendapatkan ukuran layar
        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        // Memperbarui posisi lingkaran berdasarkan kecepatan
        double newX = _dx * _controller.value * screenWidth;
        double newY = _dy * _controller.value * screenHeight;

        // Jika lingkaran menyentuh dinding, pantulkan arah
        if (newX < 0 || newX > screenWidth - _circleSize) {
          _dx = -_dx; // Membalikkan arah horizontal
        }
        if (newY < 0 || newY > screenHeight - _circleSize) {
          _dy = -_dy; // Membalikkan arah vertikal
        }

        // Mengupdate posisi final lingkaran
        double finalX = _dx * _controller.value * screenWidth;
        double finalY = _dy * _controller.value * screenHeight;

        return Positioned(
          left: finalX,
          top: finalY,
          child: Container(
            width: _circleSize,
            height: _circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.7),
            ),
          ),
        );
      },
    );
  }
}

class WaveAppBarHome extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.5);

    // Gelombang pertama (ke bawah)
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.5,
      size.width * 0.3,
      size.height * 0.35,
    );

    // Gelombang kedua (ke atas)
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.25,
      size.width * 0.6,
      size.height * 0.35,
    );

    // Gelombang ketiga (ke bawah)
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.45,
      size.width * 0.8,
      size.height * 0.4,
    );

    // Gelombang keempat (ke atas)
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.3,
      size.width,
      size.height * 0.35,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(7, size.height * 0.3);

    // Gelombang pertama (ke bawah)
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.9,
      size.width * 0.3,
      size.height * 0.7,
    );

    // Gelombang kedua (ke atas)
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.75,
    );

    // Gelombang ketiga (ke bawah)
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.9,
      size.width * 0.75,
      size.height * 0.6,
    );

    // Gelombang keempat (ke atas, lebih menonjol di kanan)
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.4,
      size.width,
      size.height * 0.9,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomWave extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.25,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.2,
      size.width * 0.75,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.8,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveAppBarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wave AppBar with Circle"),
        flexibleSpace: ClipPath(
          clipper: WaveAppBarHome(),
          child: Container(color: Colors.blue),
        ),
      ),
      body: Stack(
        children: [
          AbstractWaveCircle(), // Animasi lingkaran yang bergerak
          CustomPaint(
            painter: BottomWavePainter(),
          ),
        ],
      ),
    );
  }
}

class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
        size.width * 0.1,
        size.height * 0.3,
        size.width * 0.25,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.7,
        size.width * 0.5,
        size.height * 0.4,
      )
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.2,
        size.width * 0.75,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.8,
        size.width,
        size.height * 0.5,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    
    final paint = Paint()..color = Colors.blue.withOpacity(0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
