import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  final List<Map<String, String>> _messages = [];
  bool _isThinking = false;
  OverlayEntry? _infoOverlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoPopup(context);
    });
  }

  void _sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": userMessage});
      _isThinking = true;
    });

    _controller.clear();

    String response = await _apiService.sendMessageToGroqAPI(userMessage);

    setState(() {
      _messages.add({"role": "assistant", "content": response});
      _isThinking = false;
    });
  }

  void _showInfoPopup(BuildContext context) {
    if (_infoOverlayEntry != null) return;

    _infoOverlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _removeInfoPopup();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA55500), // Warna biru CapungID
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'ChatPung ini masih dalam proses pengembangan.\nFitur-fitur akan terus ditingkatkan.',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_infoOverlayEntry!);
    Future.delayed(const Duration(seconds: 2), _removeInfoPopup);
  }

  void _removeInfoPopup() {
    _infoOverlayEntry?.remove();
    _infoOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff), // Background lembut biru muda
      appBar: AppBar(
        title: Text(
          'ChatPung',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [Color(0xFFFECA5C), Color(0xFFA55500)], // Gradasi warna
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ).createShader(
                  Rect.fromLTWH(0, 0, 200, 70)), // Tentukan area teks
          ),
        ),
        centerTitle: true,
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Gradasi biru CapungID
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFA55500)),
        actions: [
          GestureDetector(
            onTap: () {
              _showInfoPopup(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.info_outline, color: Color(0xFFA55500)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.36, // Memindahkan gambar sedikit ke bawah
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/7.png',
              fit: BoxFit.cover, // Gambar menutupi area dengan proporsional
              height: MediaQuery.of(context).size.height *
                  0.5, // Atur ketinggian gambar sesuai dengan kebutuhan
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _messages.length + (_isThinking ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isThinking && index == _messages.length) {
                      return const ThinkingBubble();
                    }
                    final message = _messages[index];
                    final isUser = message['role'] == 'user';
                    return MessageBubble(
                      content: message['content'] ?? '',
                      isUser: isUser,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          style: GoogleFonts.roboto(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Ayo tanya tentang capung...',
                            hintStyle: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFA55500), Color(0xFFda8937)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA55500).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ThinkingBubble extends StatelessWidget {
  const ThinkingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xFFA55500),
            child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const DotLoader(),
            ),
          ),
        ],
      ),
    );
  }
}

class DotLoader extends StatefulWidget {
  const DotLoader({super.key});

  @override
  _DotLoaderState createState() => _DotLoaderState();
}

class _DotLoaderState extends State<DotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: (_controller.value * 3 - index).clamp(0.0, 1.0),
                child: const CircleAvatar(
                  radius: 4,
                  backgroundColor: Color(0xFFA55500),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
