import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceTranslationScreen extends StatefulWidget {
  const VoiceTranslationScreen({super.key});

  @override
  State<VoiceTranslationScreen> createState() => _VoiceTranslationScreenState();
}

class _VoiceTranslationScreenState extends State<VoiceTranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  String? translatedText;
  bool isListening = false;

  /// Function: Start or stop listening
  void _listen() async {
    if (!isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }

  /// Function: Call API for translation
  Future<void> _translateText() async {
    if (_controller.text.isEmpty) return;

    final response = await http.post(
      Uri.parse("https://libretranslate.com/translate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "q": _controller.text,
        "source": "en",
        "target": "es", // Change target language if needed
        "format": "text",
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        translatedText = jsonDecode(response.body)["translatedText"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Top bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back icon (navigator removed)
                  const Icon(Icons.arrow_back, size: 28, color: Colors.black),

                  Text(
                    "Voice Translation",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(width: 28), // spacing balance
                ],
              ),
            ),

            // 🔹 Input Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // Left side mic icon
                    Positioned(
                      top: 8,
                      left: 8,
                      child: GestureDetector(
                        onTap: _listen,
                        child: Icon(
                          isListening ? Icons.mic : Icons.mic_none,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                    ),

                    // Input text (center)
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          expands: true,
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter text here to translate...",
                            hintStyle: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    // Right side icons
                    Positioned(
                      right: 12,
                      bottom: 8,
                      left: MediaQuery.of(context).size.width / 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.copy, size: 28, color: Colors.black54),
                          Icon(
                            Icons.volume_up,
                            size: 28,
                            color: Colors.black54,
                          ),
                          Icon(Icons.share, size: 28, color: Colors.black54),
                          Icon(
                            Icons.more_vert,
                            size: 28,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Translate Button
            Center(
              child: ElevatedButton(
                onPressed: _translateText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2076F7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Translate",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // 🔹 Blue Box (Translated text)
            if (translatedText != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Container(
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2076F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Left image
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Image.asset(
                          "assets/images/inside_left.png",
                          width: 56,
                          height: 56,
                        ),
                      ),

                      // Translated text (a little lower, bold, big)
                      Positioned(
                        top: 70,
                        left: 12,
                        right: 12,
                        child: Text(
                          translatedText!,
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Right side icons
                      Positioned(
                        right: 12,
                        bottom: 8,
                        left: MediaQuery.of(context).size.width / 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.copy, size: 28, color: Colors.white),
                            Icon(
                              Icons.volume_up,
                              size: 28,
                              color: Colors.white,
                            ),
                            Icon(Icons.share, size: 28, color: Colors.white),
                            Icon(
                              Icons.more_vert,
                              size: 28,
                              color: Colors.white,
                            ),
                          ],
                        ),
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
}
