// text_translation.dart (First Screen)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'text_translation1.dart';

// fake translate function (replace with your API call)
Future<String> translateText(String text, String from, String to) async {
  await Future.delayed(const Duration(seconds: 2)); // simulate delay
  return "[$to translation of] $text"; // replace with actual translation
}

class TextTranslationScreen extends StatefulWidget {
  const TextTranslationScreen({super.key});

  @override
  State<TextTranslationScreen> createState() => _TextTranslationScreenState();
}

class _TextTranslationScreenState extends State<TextTranslationScreen> {
  final TextEditingController _controller = TextEditingController();
  String fromLanguage = "English";
  String toLanguage = "Urdu";
  bool _isTranslating = false;

  void _onTranslatePressed() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to translate')),
      );
      return;
    }

    setState(() => _isTranslating = true);

    try {
      final translated = await translateText(text, fromLanguage, toLanguage);
      if (!mounted) return;

      setState(() => _isTranslating = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextTranslation1Screen(
            originalText: text,
            translatedText: translated,
            fromLanguage: fromLanguage,
            toLanguage: toLanguage,
          ),
        ),
      );
    } catch (e) {
      setState(() => _isTranslating = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Translation failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2076F7);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F4),
      body: Column(
        children: [
          const SizedBox(height: 33),
          // Top bar
          Container(
            width: double.infinity,
            height: 56,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        "assets/images/back.png",
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Text Translation",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Image.asset("assets/images/setting.png", height: 24, width: 24),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Text box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 260,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter text here...",
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Translate button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _isTranslating ? null : _onTranslatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isTranslating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Translate",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
