// lib/screens/text_translation.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

/// Language codes mapping for translation API
const Map<String, String> languageCodes = {
  "English": "en",
  "Spanish": "es",
  "Urdu": "ur",
  "French": "fr",
  "German": "de",
  "Arabic": "ar",
};

class TextTranslationScreen extends StatefulWidget {
  const TextTranslationScreen({super.key});

  @override
  State<TextTranslationScreen> createState() => _TextTranslationScreenState();
}

class _TextTranslationScreenState extends State<TextTranslationScreen> {
  String fromLanguage = "English";
  String toLanguage = "Spanish";

  final TextEditingController _controller = TextEditingController();
  bool _isTranslating = false;

  Future<String> translateText(String text, String from, String to) async {
    // Using LibreTranslate public instance as an example (no API key here).
    // You can replace endpoint / add API key as required for production.
    final uri = Uri.parse('https://libretranslate.de/translate');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'source': languageCodes[from] ?? 'en',
        'target': languageCodes[to] ?? 'es',
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      // LibreTranslate returns: { "translatedText": "..." }
      return body['translatedText'] ?? '';
    } else {
      throw Exception('Translation failed (${response.statusCode})');
    }
  }

  void _onTranslatePressed() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to translate')),
      );
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      final translated = await translateText(text, fromLanguage, toLanguage);
      setState(() {
        _isTranslating = false;
      });

      // Navigate to a simple results screen (you can change this later)
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TranslationResultScreen(
            sourceText: text,
            translatedText: translated,
            fromLanguage: fromLanguage,
            toLanguage: toLanguage,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isTranslating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Translation failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors from your spec
    const Color primaryBlue = Color(0xFF2076F7);
    const Color hintGrey = Color(0xFF979797);
    const Color bottomInactive = Color(0xFF6F6F77);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F4),
      body: Column(
        children: [
          const SizedBox(height: 33),

          // Top white rectangle "appbar"
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
                    // back icon placeholder
                    Image.asset(
                      "assets/images/back.png",
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Translator",
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

          // 3 line spacing (approx)
          const SizedBox(height: 24),

          // Row with two language "buttons" and center white small box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left language button (English)
                GestureDetector(
                  onTap: () => _showLanguagePicker(isFrom: true),
                  child: Container(
                    width: 130,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fromLanguage,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),

                // center white small area (image placeholder)
                Container(
                  width: 46,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/center_icon.png",
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Right language button (Spanish)
                GestureDetector(
                  onTap: () => _showLanguagePicker(isFrom: false),
                  child: Container(
                    width: 130,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          toLanguage,
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3 line spacing
          const SizedBox(height: 24),

          // Big rounded rectangle text area (width 328, height 235)
          Center(
            child: Container(
              width: 328,
              height: 235,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                // stroke black with 40% opacity as you requested
                border: Border.all(color: Colors.black.withOpacity(0.40)),
              ),
              child: Stack(
                children: [
                  // Hint text at top-left (it will be covered by actual text when typing)
                  Positioned(
                    top: 12,
                    left: 12,
                    right: 12,
                    child: _controller.text.isEmpty
                        ? Text(
                            "Text here to translate...",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: const Color(0xFF979797),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Right-side image inside rectangle
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Image.asset(
                      "assets/images/inside_right.png",
                      width: 56,
                      height: 56,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // The actual text input area (transparent background so hint shows before typing)
                  Positioned(
                    top: 36,
                    left: 12,
                    right: 12,
                    bottom: 56, // leave space at bottom for icons row
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true, // reduces default paddings
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) {
                        setState(() {}); // to hide hint when typing
                      },
                    ),
                  ),

                  // Bottom-left 4 images equally spaced
                  Positioned(
                    left: 12,
                    bottom: 8,
                    right: 12,
                    child: SizedBox(
                      height: 36,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/icon1.png",
                            width: 28,
                            height: 28,
                          ),
                          Image.asset(
                            "assets/images/icon2.png",
                            width: 28,
                            height: 28,
                          ),
                          Image.asset(
                            "assets/images/icon3.png",
                            width: 28,
                            height: 28,
                          ),
                          Image.asset(
                            "assets/images/icon4.png",
                            width: 28,
                            height: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Translate button center
          SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: _isTranslating ? null : _onTranslatePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2076F7),
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

          const Spacer(),

          // Bottom bar (360 x 56)
          Container(
            width: double.infinity,
            height: 56,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text Translation (selected)
                _BottomNav(
                  iconPath: "assets/images/bottom_text.png",
                  label: "Text Translation",
                  active: true,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
                _BottomNav(
                  iconPath: "assets/images/bottom_voice.png",
                  label: "Voice Translation",
                  active: false,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
                _BottomNav(
                  iconPath: "assets/images/bottom_dict.png",
                  label: "Dictionary",
                  active: false,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
                _BottomNav(
                  iconPath: "assets/images/bottom_conv.png",
                  label: "Conversation",
                  active: false,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker({required bool isFrom}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final langs = languageCodes.keys.toList();
        return ListView.builder(
          itemCount: langs.length,
          itemBuilder: (context, index) {
            final lang = langs[index];
            return ListTile(
              title: Text(lang),
              onTap: () {
                setState(() {
                  if (isFrom) {
                    fromLanguage = lang;
                    // prevent choosing same as target
                    if (fromLanguage == toLanguage) {
                      // swap
                    }
                  } else {
                    toLanguage = lang;
                  }
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;

  const _BottomNav({
    required this.iconPath,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(iconPath, width: 20, height: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: active ? activeColor : inactiveColor,
          ),
        ),
      ],
    );
  }
}

/// A simple result screen to show translation (you can modify it later)
class TranslationResultScreen extends StatelessWidget {
  final String sourceText;
  final String translatedText;
  final String fromLanguage;
  final String toLanguage;

  const TranslationResultScreen({
    required this.sourceText,
    required this.translatedText,
    required this.fromLanguage,
    required this.toLanguage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result', style: GoogleFonts.roboto()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('From: $fromLanguage', style: GoogleFonts.roboto()),
            const SizedBox(height: 8),
            Text(sourceText, style: GoogleFonts.roboto(fontSize: 16)),
            const Divider(height: 32),
            Text('To: $toLanguage', style: GoogleFonts.roboto()),
            const SizedBox(height: 8),
            Text(translatedText, style: GoogleFonts.roboto(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
