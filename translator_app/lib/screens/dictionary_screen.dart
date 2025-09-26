import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

// ✅ import conversation screen
import 'conversation_screen.dart';

/// Full language codes (same as before, dropdown ke liye)
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

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? _wordData;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _searchWord() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _wordData = null;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse(
        "https://api.dictionaryapi.dev/api/v2/entries/en/$query",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          setState(() {
            _wordData = data[0];
          });
        } else {
          setState(() {
            _errorMessage = "No result found for \"$query\".";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Word not found.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching word: $e";
      });
    }

    setState(() => _isLoading = false);
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/images/back.png",
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Dictionary",
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

          // Language selectors row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLanguageButton("English"),
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
                _buildLanguageButton("Spanish"),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Big white dictionary box
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ).copyWith(bottom: 16), // 2 line spacing from bottom bar
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    TextField(
                      controller: _controller,
                      onSubmitted: (_) => _searchWord(),
                      decoration: InputDecoration(
                        hintText: "Search word...",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: primaryBlue),
                          onPressed: _searchWord,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()),

                    if (_errorMessage != null)
                      Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    if (_wordData != null) ...[
                      Text(
                        _wordData!["word"] ?? "",
                        style: GoogleFonts.roboto(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue, // highlighted word
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (_wordData!["meanings"] != null &&
                          _wordData!["meanings"].isNotEmpty) ...[
                        Text(
                          "Part of Speech: ${_wordData!["meanings"][0]["partOfSpeech"]}",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_wordData!["meanings"][0]["definitions"] != null &&
                            _wordData!["meanings"][0]["definitions"].isNotEmpty)
                          Text(
                            "Definition: ${_wordData!["meanings"][0]["definitions"][0]["definition"]}",
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                      ],

                      const SizedBox(height: 10),

                      if (_wordData!["origin"] != null)
                        Text(
                          "Origin: ${_wordData!["origin"]}",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),

                      const SizedBox(height: 10),

                      // Derivation aur initial use manually check karne ka jagah
                      if (_wordData!["meanings"] != null &&
                          _wordData!["meanings"][0]["definitions"] != null &&
                          _wordData!["meanings"][0]["definitions"].isNotEmpty &&
                          _wordData!["meanings"][0]["definitions"][0]["example"] !=
                              null)
                        Text(
                          "Initially Used: ${_wordData!["meanings"][0]["definitions"][0]["example"]}",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Bottom nav bar
          Container(
            width: double.infinity,
            height: 56,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const _BottomNav(
                  iconPath: "assets/images/bottom_text.png",
                  label: "Text Translation",
                  active: false,
                ),
                const _BottomNav(
                  iconPath: "assets/images/bottom_voice.png",
                  label: "Voice Translation",
                  active: false,
                ),
                const _BottomNav(
                  iconPath: "assets/images/bottom_dict.png",
                  label: "Dictionary",
                  active: true,
                ),
                _BottomNav(
                  iconPath: "assets/images/bottom_conv.png",
                  label: "Conversation",
                  active: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConversationScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String lang) {
    return Container(
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
    );
  }
}

class _BottomNav extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _BottomNav({
    required this.iconPath,
    required this.label,
    required this.active,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2076F7);
    const Color bottomInactive = Color(0xFF6F6F77);

    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }
}
