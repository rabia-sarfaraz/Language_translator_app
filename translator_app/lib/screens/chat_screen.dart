import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;

/// Language codes + flag paths
const Map<String, Map<String, String>> languages = {
  "English": {"code": "en", "flag": "assets/flags/english.png"},
  "Spanish": {"code": "es", "flag": "assets/flags/spanish.png"},
  "French": {"code": "fr", "flag": "assets/flags/french.png"},
  "German": {"code": "de", "flag": "assets/flags/german.png"},
  "Italian": {"code": "it", "flag": "assets/flags/italian.png"},
  "Urdu": {"code": "ur", "flag": "assets/flags/urdu.png"},
  "Arabic": {"code": "ar", "flag": "assets/flags/arabic.png"},
  "Hindi": {"code": "hi", "flag": "assets/flags/hindi.png"},
  "Chinese": {"code": "zh", "flag": "assets/flags/chinese.png"},
  "Russian": {"code": "ru", "flag": "assets/flags/russian.png"},
};

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
              ? languages[fromLanguage]!["code"]!
              : languages[toLanguage]!["code"]!,
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
      languages[sourceLang]!["code"]!,
      languages[targetLang]!["code"]!,
    );

    setState(() {
      messages.add({
        "text": translatedText,
        "isUser": false,
        "lang": targetLang,
      });
    });
  }

  Future<String> _translateText(
    String text,
    String fromCode,
    String toCode,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("https://translate.argosopentech.com/translate"),
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
      } else {
        return "Translation error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
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
                    final flagPath = languages[lang]!["flag"]!;

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
                  child: const Icon(Icons.swap_horiz, color: Colors.blue),
                ),
                _buildLanguageButton(toLanguage, isFrom: false),
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

  Widget _buildLanguageButton(String lang, {required bool isFrom}) {
    return Container(
      width: 130,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
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
