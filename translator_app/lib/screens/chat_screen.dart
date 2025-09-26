import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;

/// Language codes (no flags in dropdown)
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

/// Flags for chat bubbles only
const Map<String, String> languageFlags = {
  "English": "assets/flags/english.png",
  "Spanish": "assets/flags/spanish.png",
  "French": "assets/flags/french.png",
  "German": "assets/flags/german.png",
  "Italian": "assets/flags/italian.png",
  "Urdu": "assets/flags/urdu.png",
  "Arabic": "assets/flags/arabic.png",
  "Hindi": "assets/flags/hindi.png",
  "Chinese": "assets/flags/chinese.png",
  "Russian": "assets/flags/russian.png",
};

/// 🌍 Translation servers (fallback list)
const List<String> translationServers = [
  "https://libretranslate.de/translate",
  "https://translate.astian.org/translate",
  "https://libretranslate.com/translate",
];

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String fromLanguage = "English";
  String toLanguage = "Spanish";

  List<Map<String, dynamic>> messages = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listenAndTranslate(bool isFrom) async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) async {
            if (result.finalResult) {
              String spokenText = result.recognizedWords;
              _speech.stop();
              setState(() => _isListening = false);

              if (isFrom) {
                _sendMessage(spokenText, fromLanguage, toLanguage);
              } else {
                _sendMessage(spokenText, toLanguage, fromLanguage);
              }
            }
          },
          localeId: isFrom
              ? languageCodes[fromLanguage]!
              : languageCodes[toLanguage]!,
        );
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  Future<void> _sendMessage(
    String text,
    String sourceLang,
    String targetLang,
  ) async {
    setState(() {
      messages.add({"text": text, "isUser": true, "lang": sourceLang});
    });

    String translatedText = await _translateText(
      text,
      languageCodes[sourceLang]!,
      languageCodes[targetLang]!,
    );

    setState(() {
      messages.add({
        "text": translatedText,
        "isUser": false,
        "lang": targetLang,
      });
    });
  }

  /// ✅ Multi-server fallback translation
  Future<String> _translateText(
    String text,
    String fromCode,
    String toCode,
  ) async {
    for (final server in translationServers) {
      try {
        final response = await http.post(
          Uri.parse(server),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "q": text,
            "source": fromCode,
            "target": toCode,
            "format": "text",
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data["translatedText"] ?? "No translation found.";
        }
      } catch (e) {
        debugPrint("⚠️ Server failed: $server -> $e");
      }
    }
    return "⚠️ All translation servers failed.";
  }

  @override
  Widget build(BuildContext context) {
    const Color userBubbleColor = Color(0x803E7AFF); // lighter blue
    const Color replyBubbleColor = Color(0xFF3E7AFF); // solid blue

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
                      "Chat",
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/images/right_icon.png",
                  height: 24,
                  width: 24,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 White Chat Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black.withOpacity(0.4)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isUser = msg["isUser"];
                    final lang = msg["lang"];
                    final flagPath = languageFlags[lang]!;

                    return Row(
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(flagPath),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? userBubbleColor
                                  : replyBubbleColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isUser ? 16 : 6),
                                topRight: const Radius.circular(16),
                                bottomLeft: const Radius.circular(16),
                                bottomRight: Radius.circular(isUser ? 6 : 16),
                              ),
                            ),
                            child: Text(
                              msg["text"],
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        if (isUser) ...[
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(flagPath),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 Language Selector Row (Dropdown + Mic)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLanguageSelector(true),
                Container(
                  width: 46,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.swap_horiz, color: Colors.blue),
                ),
                _buildLanguageSelector(false),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 Bottom Navigation
          Container(
            width: double.infinity,
            height: 56,
            color: Colors.white,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNav(
                  iconPath: "assets/images/bottom_text.png",
                  label: "Text Translation",
                  active: false,
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
                  active: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(bool isFrom) {
    return Container(
      width: 150,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: isFrom ? fromLanguage : toLanguage,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (String? newLang) {
                  if (newLang != null) {
                    setState(() {
                      if (isFrom) {
                        fromLanguage = newLang;
                      } else {
                        toLanguage = newLang;
                      }
                    });
                  }
                },
                items: languageCodes.keys.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.blue),
            onPressed: () => _listenAndTranslate(isFrom),
          ),
        ],
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
