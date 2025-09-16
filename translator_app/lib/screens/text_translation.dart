import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

class TextTranslationScreen extends StatefulWidget {
  const TextTranslationScreen({super.key});

  @override
  State<TextTranslationScreen> createState() => _TextTranslationScreenState();
}

class _TextTranslationScreenState extends State<TextTranslationScreen> {
  String fromLanguage = "English";
  String toLanguage = "Spanish";

  final TextEditingController _controller = TextEditingController();
  String? translatedText;
  bool _isTranslating = false;

  /// Multiple LibreTranslate servers for fallback
  final List<String> _servers = [
    "https://translate.astian.org/translate",
    "https://libretranslate.de/translate",
    "https://translate.fedilab.app/translate",
  ];

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
        const SnackBar(content: Text('Please enter text to translate')),
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

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2076F7);
    const Color bottomInactive = Color(0xFF6F6F77);

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

          const SizedBox(height: 24),

          // Language selectors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLanguageButton(fromLanguage, isFrom: true),
                Container(
                  width: 46,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
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
                _buildLanguageButton(toLanguage, isFrom: false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Input box only (output removed from here)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Hint
                  if (_controller.text.isEmpty)
                    Positioned(
                      top: 36,
                      left: 12,
                      child: Text(
                        "Text here to translate...",
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: const Color(0xFF979797),
                        ),
                      ),
                    ),

                  // Inside icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Image.asset(
                      "assets/images/inside_right.png",
                      width: 56,
                      height: 56,
                    ),
                  ),

                  // Input text
                  Positioned.fill(
                    top: 8,
                    bottom: 130,
                    left: 12,
                    right: 12,
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

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

          const SizedBox(height: 24),

          // 🔹 New blue result box
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
                    // Top-left image
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
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Bottom icons (white, left side)
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

          const Spacer(),

          // Bottom nav
          Container(
            width: double.infinity,
            height: 56,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(height: 2, width: 40, color: primaryBlue),
                    const SizedBox(height: 4),
                    Image.asset(
                      "assets/images/bottom_text.png",
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Text Translation",
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const _BottomNav(
                  iconPath: "assets/images/bottom_voice.png",
                  label: "Voice Translation",
                  active: false,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
                const _BottomNav(
                  iconPath: "assets/images/bottom_dict.png",
                  label: "Dictionary",
                  active: false,
                  activeColor: primaryBlue,
                  inactiveColor: bottomInactive,
                ),
                const _BottomNav(
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

  Widget _buildLanguageButton(String lang, {required bool isFrom}) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          if (isFrom) {
            fromLanguage = value;
          } else {
            toLanguage = value;
          }
        });
      },
      itemBuilder: (context) {
        return languageCodes.keys.map((String choice) {
          return PopupMenuItem<String>(value: choice, child: Text(choice));
        }).toList();
      },
      child: Container(
        width: 130,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lang,
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
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
