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
        Uri.parse("https://libretranslate.de/translate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "q": text,
          "source": fromCode,
          "target": toCode,
          "format": "text",
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["translatedText"];
      } else {
        return "Translation error!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color userBubbleColor = Color(0x803E7AFF); // #3E7AFF80
    const Color replyBubbleColor = Color(0xFF3E7AFF); // #3E7AFF

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Voice Chat",
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// 🔹 Chat List
          Expanded(
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
                          color: isUser ? userBubbleColor : replyBubbleColor,
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

          const Divider(height: 1),

          /// 🔹 Language selection row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLangSelector(
                  selectedLang: fromLanguage,
                  onChanged: (val) {
                    setState(() => fromLanguage = val!);
                  },
                  onMicPressed: () => _listenAndTranslate(true),
                ),
                _buildLangSelector(
                  selectedLang: toLanguage,
                  onChanged: (val) {
                    setState(() => toLanguage = val!);
                  },
                  onMicPressed: () => _listenAndTranslate(false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangSelector({
    required String selectedLang,
    required void Function(String?) onChanged,
    required VoidCallback onMicPressed,
  }) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedLang,
          items: languages.keys.map((String lang) {
            return DropdownMenuItem<String>(
              value: lang,
              child: Text(lang, style: GoogleFonts.roboto(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        IconButton(
          icon: const Icon(Icons.mic, color: Colors.blue),
          onPressed: onMicPressed,
        ),
      ],
    );
  }
}
