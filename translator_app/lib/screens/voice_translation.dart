import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Full language codes
const Map<String, String> languageCodes = {
  "English": "en",
  "Spanish": "es",
  "French": "fr",
  "German": "de",
  "Italian": "it",
  "Urdu": "ur",
  "Arabic": "ar",
  "Hindi": "hi",
  "Chinese": "zh",
  "Russian": "ru",
};

class VoiceTranslationScreen extends StatefulWidget {
  const VoiceTranslationScreen({super.key});

  @override
  State<VoiceTranslationScreen> createState() => _VoiceTranslationScreenState();
}

class _VoiceTranslationScreenState extends State<VoiceTranslationScreen> {
  String fromLanguage = "English";
  String toLanguage = "Spanish";

  final TextEditingController _controller = TextEditingController();
  String? translatedText;
  bool _isTranslating = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;

  /// Multiple LibreTranslate servers for fallback
  final List<String> _servers = [
    "https://translate.astian.org/translate",
    "https://libretranslate.de/translate",
    "https://translate.fedilab.app/translate",
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  /// Translation with fallback
  Future<String> translateText(String text, String from, String to) async {
    final body = {
      'q': text,
      'source': languageCodes[from] ?? 'auto',
      'target': languageCodes[to] ?? 'en',
      'format': 'text',
    };

    for (final server in _servers) {
      try {
        final uri = Uri.parse(server);
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['translatedText'] ?? '';
        }
      } catch (_) {
        // try next server
      }
    }

    throw Exception("All servers failed. Please try again later.");
  }

  void _onTranslatePressed() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please say something first')),
      );
      return;
    }

    setState(() {
      _isTranslating = true;
      translatedText = null;
    });

    try {
      final translated = await translateText(text, fromLanguage, toLanguage);
      if (!mounted) return;

      setState(() {
        _isTranslating = false;
        translatedText = translated;
      });
    } catch (e) {
      setState(() => _isTranslating = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Translation failed: $e')));
    }
  }

  /// ✅ Mic listening logic
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("onStatus: $status"),
        onError: (error) => print("onError: $error"),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
          listenFor: const Duration(seconds: 20),
          pauseFor: const Duration(seconds: 5),
          partialResults: true,
          localeId: "en_US", // 👈 Change this based on `fromLanguage`
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission not granted")),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2076F7);
    const Color bottomInactive = Color(0xFF6F6F77);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F4),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Voice Translator",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// Language selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: fromLanguage,
                  items: languageCodes.keys
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => fromLanguage = val!),
                ),
                const Icon(Icons.swap_horiz, size: 28, color: primaryBlue),
                DropdownButton<String>(
                  value: toLanguage,
                  items: languageCodes.keys
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => toLanguage = val!),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Input box
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Speak or type something...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Mic button
            Center(
              child: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  size: 40,
                  color: _isListening ? Colors.red : primaryBlue,
                ),
                onPressed: _listen,
              ),
            ),

            const SizedBox(height: 20),

            /// Translate button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _onTranslatePressed,
              child: _isTranslating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Translate",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),

            const SizedBox(height: 20),

            /// Translated output
            if (translatedText != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  translatedText!,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
