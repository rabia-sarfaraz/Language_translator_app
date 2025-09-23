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
          localeId: "en_US",
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
      body: Column(
        children: [
          const SizedBox(height: 33),

          /// 🔹 Top Rectangle Bar
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
                      child: const Icon(Icons.arrow_back, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Translate",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/images/right_icon.png", // 👈 replace with your asset
                  height: 24,
                  width: 24,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// 🔹 Language Selector Row
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
                    ),
                  ),
                ),
                _buildLanguageButton(toLanguage, isFrom: false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// 🔹 Input Text Area Rectangle (with mic)
          Container(
            width: 328,
            height: 235,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black.withOpacity(0.4)),
            ),
            child: Stack(
              children: [
                /// Placeholder text
                if (!_isListening && _controller.text.isEmpty)
                  const Positioned(
                    top: 12,
                    left: 12,
                    child: Text(
                      "Tap Mic & hold to Speak ......",
                      style: TextStyle(fontSize: 14, color: Color(0xFF979797)),
                    ),
                  ),

                /// Textfield for recognized text
                Positioned.fill(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 36,
                      ),
                    ),
                  ),
                ),

                /// ✅ Mic icon inside text area
                Positioned(
                  right: 12,
                  bottom: 8,
                  child: GestureDetector(
                    onTap: _listen,
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      size: 40,
                      color: _isListening ? Colors.red : Colors.black54,
                    ),
                  ),
                ),

                /// Bottom 4 icons
                Positioned(
                  left: 12,
                  bottom: 8,
                  child: Row(
                    children: [
                      Image.asset("assets/images/icon1.png", width: 28),
                      const SizedBox(width: 16),
                      Image.asset("assets/images/icon2.png", width: 28),
                      const SizedBox(width: 16),
                      Image.asset("assets/images/icon3.png", width: 28),
                      const SizedBox(width: 16),
                      Image.asset("assets/images/icon4.png", width: 28),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 Translate Button
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

          const Spacer(),

          /// 🔹 Bottom Nav
          Container(
            width: 360,
            height: 56,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _BottomNav(
                  iconPath: "assets/images/bottom_text.png",
                  label: "Text Translation",
                  active: true,
                ),
                _BottomNav(
                  iconPath: "assets/images/bottom_voice.png",
                  label: "Voice Translation",
                  active: false,
                ),
                _BottomNav(
                  iconPath: "assets/images/bottom_dict.png",
                  label: "Dictionary",
                  active: false,
                ),
                _BottomNav(
                  iconPath: "assets/images/bottom_conv.png",
                  label: "Conversation",
                  active: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String lang, {required bool isFrom}) {
    return Container(
      width: 130,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: PopupMenuButton<String>(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 8),
            Text(
              lang,
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
            const SizedBox(width: 8),
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

  const _BottomNav({
    required this.iconPath,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2076F7);
    const Color bottomInactive = Color(0xFF6F6F77);

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
            color: active ? primaryBlue : bottomInactive,
          ),
        ),
      ],
    );
  }
}
