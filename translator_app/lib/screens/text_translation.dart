import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

const Color primaryBlue = Color(0xFF2076F7);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: const TranslatorScreen(),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _controller = TextEditingController();
  String? translatedText;
  bool _isTranslating = false;

  Future<void> _onTranslatePressed() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isTranslating = true;
    });

    try {
      // Dummy API call for now (replace with real one)
      final response = await http.post(
        Uri.parse("https://api.mymemory.translated.net/get"),
        body: {
          "q": _controller.text.trim(),
          "langpair": "en|es", // English → Spanish
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data["responseData"]["translatedText"];
        setState(() {
          translatedText = result;
        });
      }
    } catch (e) {
      debugPrint("Translation failed: $e");
    }

    setState(() {
      _isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Input box
              TextField(
                controller: _controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Enter text to translate...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),

              const SizedBox(height: 20),

              // Translate button
              SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isTranslating ? null : _onTranslatePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isTranslating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Translate",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              // 2-line spacing
              const SizedBox(height: 24),

              // Blue translated result box
              if (translatedText != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        // Top-left decorative image
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Image.asset(
                            "assets/images/inside_left.png",
                            width: 56,
                            height: 56,
                          ),
                        ),

                        // Translated text
                        Positioned(
                          top: 60,
                          left: 12,
                          right: 12,
                          child: Text(
                            translatedText!,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),

                        // Bottom white icons
                        Positioned(
                          left: 12,
                          bottom: 8,
                          right: MediaQuery.of(context).size.width / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                "assets/images/icon1.png",
                                width: 28,
                                height: 28,
                                color: Colors.white,
                              ),
                              Image.asset(
                                "assets/images/icon2.png",
                                width: 28,
                                height: 28,
                                color: Colors.white,
                              ),
                              Image.asset(
                                "assets/images/icon3.png",
                                width: 28,
                                height: 28,
                                color: Colors.white,
                              ),
                              Image.asset(
                                "assets/images/icon4.png",
                                width: 28,
                                height: 28,
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
      ),
    );
  }
}
