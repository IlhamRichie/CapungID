import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String groqApiKey = 'yourapikey';
  final String groqBaseUrl = 'https://api.groq.com/openai/v1';
  final String groqModel = 'llama-3.3-70b-versatile';

  String extractErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body.containsKey('msg')) {
        return body['msg'];
      } else {
        return 'Terjadi kesalahan pada server.';
      }
    } catch (e) {
      return 'Gagal memproses respons dari server.';
    }
  }

  String handleExceptionMessage(Object e, [http.Response? response]) {
    if (response != null && response.body.isNotEmpty) {
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('msg')) {
          return body['msg'];
        }
      } catch (_) {
        // Abaikan error parsing
      }
    }
    // Pesan fallback untuk error lain
    String errorMessage = e.toString();
    if (errorMessage.contains("Failed to fetch response")) {
      return "Gagal mendapatkan data dari server. Silakan coba lagi.";
    } else if (errorMessage.contains("Token expired")) {
      return "Sesi Anda telah berakhir. Silakan login ulang.";
    } else if (errorMessage.contains("Connection timed out")) {
      return "Koneksi ke server gagal. Periksa koneksi internet Anda.";
    } else {
      return "Terjadi kesalahan. Silakan coba lagi.";
    }
  }

  // Fungsi Chatbot Groq API
  Future<String> sendMessageToGroqAPI(String userMessage) async {
    final url = Uri.parse('$groqBaseUrl/chat/completions');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $groqApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "messages": [
            {
              "role": "system",
              "content":
                  "Chatpung: Asisten berbasis AI untuk aplikasi Capung ID. Jawaban selalu informatif, sopan, dan relevan dengan dunia capung. Jangan pernah membuat respon dengan bahasa inggris.",
            },
            {"role": "user", "content": userMessage}
          ],
          "model": groqModel,
          "temperature": 0.6,
          "max_tokens": 1024,
          "top_p": 0.7
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception(extractErrorMessage(response));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}