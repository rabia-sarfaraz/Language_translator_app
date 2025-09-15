// text_translation1.dart (Second Screen)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTranslation1Screen extends StatelessWidget {
  final String originalText;
  final String translatedText;
  final String fromLanguage;
  final String toLanguage;

  const TextTranslation1Screen({
    super.key,
    required this.originalText,
    required this.translatedText,
    required this.fromLanguage,
    required this.toLanguage,
  });

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
                      "Translation Result",
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

          // Box with texts
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From ($fromLanguage):",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    originalText,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    "To ($toLanguage):",
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    translatedText,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
