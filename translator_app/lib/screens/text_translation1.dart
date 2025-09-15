import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextTranslation1Screen extends StatelessWidget {
  final String translatedText; // ✅ Receive translated text

  const TextTranslation1Screen({super.key, required this.translatedText});

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
                  "Translator",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ✅ Translated result box
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
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Image.asset(
                      "assets/images/inside_left.png",
                      width: 56,
                      height: 56,
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 12,
                    right: 12,
                    child: Text(
                      translatedText,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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
