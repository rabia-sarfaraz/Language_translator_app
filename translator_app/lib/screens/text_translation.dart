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
                      "Translated",
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

          // ✅ Translated rectangle UI (same as your second screen)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Original ($fromLanguage):",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    originalText,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Translated ($toLanguage):",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translatedText,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Colors.white,
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
