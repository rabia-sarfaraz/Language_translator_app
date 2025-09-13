import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TextTranslationScreen extends StatefulWidget {
  const TextTranslationScreen({super.key});

  @override
  State<TextTranslationScreen> createState() => _TextTranslationScreenState();
}

class _TextTranslationScreenState extends State<TextTranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  String? translatedText;
  String sourceLang = "en";
  String targetLang = "es";
  bool isLoading = false;

  /// Multiple LibreTranslate servers for fallback
  final List<String> _servers = [
    "https://translate.astian.org/translate",
    "https://libretranslate.de/translate",
    "https://translate.fedilab.app/translate",
  ];

  Future<void> _translateText() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      translatedText = null;
    });

    final body = {
      "q": _controller.text.trim(),
      "source": sourceLang,
      "target": targetLang,
      "format": "text",
    };

    bool success = false;

    for (final server in _servers) {
      try {
        final uri = Uri.parse(server);
        final response = await http.post(
          uri,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            translatedText = data["translatedText"];
          });
          success = true;
          break;
        }
      } catch (e) {
        // try next server
      }
    }

    if (!success) {
      setState(() {
        translatedText = "❌ Translation failed. Try again.";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  final List<Map<String, String>> languages = [
    {"code": "en", "name": "English"},
    {"code": "es", "name": "Spanish"},
    {"code": "fr", "name": "French"},
    {"code": "de", "name": "German"},
    {"code": "it", "name": "Italian"},
    {"code": "ur", "name": "Urdu"},
    {"code": "ar", "name": "Arabic"},
    {"code": "hi", "name": "Hindi"},
    {"code": "zh", "name": "Chinese"},
    {"code": "ru", "name": "Russian"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 20,
            child: Image.asset("assets/images/back.png", width: 30, height: 30),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Image.asset(
              "assets/images/setting.png",
              width: 30,
              height: 30,
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                width: 340,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Source dropdown
                    DropdownButton<String>(
                      value: sourceLang,
                      underline: const SizedBox(),
                      items: languages.map((lang) {
                        return DropdownMenuItem<String>(
                          value: lang["code"],
                          child: Text(lang["name"]!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sourceLang = value!;
                        });
                      },
                    ),

                    const Icon(Icons.swap_horiz, size: 28, color: Colors.black),

                    /// Target dropdown
                    DropdownButton<String>(
                      value: targetLang,
                      underline: const SizedBox(),
                      items: languages.map((lang) {
                        return DropdownMenuItem<String>(
                          value: lang["code"],
                          child: Text(lang["name"]!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          targetLang = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 220,
            left: 20,
            right: 20,
            child: TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter text to translate...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _translateText,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "Translate",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (translatedText != null)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  translatedText!,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
