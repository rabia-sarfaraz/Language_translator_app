import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TextTranslationScreen extends StatefulWidget {
  const TextTranslationScreen({super.key});

  @override
  State<TextTranslationScreen> createState() => _TextTranslationScreenState();
}

class _TextTranslationScreenState extends State<TextTranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _translatedText = "";
  String _sourceLang = "en"; // default English
  String _targetLang = "es"; // default Spanish

  // Example languages (you can add more)
  final Map<String, String> _languages = {
    "en": "English",
    "es": "Spanish",
    "fr": "French",
    "de": "German",
    "ur": "Urdu",
    "hi": "Hindi",
    "ar": "Arabic",
    "zh": "Chinese",
  };

  bool _isLoading = false;

  Future<void> _translateText() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _translatedText = "";
    });

    try {
      final response = await http.post(
        Uri.parse("https://libretranslate.de/translate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "q": _controller.text,
          "source": _sourceLang,
          "target": _targetLang,
          "format": "text",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _translatedText = data["translatedText"];
        });
      } else {
        setState(() {
          _translatedText = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _translatedText = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Text Translation",
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Rectangle for language selection
            Container(
              width: double.infinity,
              height: 70, // Increased height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black.withOpacity(0.4), // Stroke color
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Center aligned dropdowns (languages)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          value: _sourceLang,
                          items: _languages.entries
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _sourceLang = val!;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.swap_horiz, size: 28),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: _targetLang,
                          items: _languages.entries
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _targetLang = val!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  /// Right side icons
                  Row(
                    children: [
                      Icon(Icons.mic, size: 26, color: Colors.grey[700]),
                      const SizedBox(width: 12),
                      Icon(Icons.camera_alt, size: 26, color: Colors.grey[700]),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Input box
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter text to translate...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            /// Translate button
            ElevatedButton(
              onPressed: _translateText,
              child: const Text("Translate"),
            ),

            const SizedBox(height: 20),

            /// Result box
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(
                _translatedText ?? "",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
