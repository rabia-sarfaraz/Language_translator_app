import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),

            /// App Title
            Text(
              "Language Translate\nApp",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),

            /// Main Illustration (Globe + Bubbles + Flags)
            Expanded(
              flex: 3,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// Globe background
                    Image.asset(
                      "assets/images/globe.png", // apna globe ya lottie asset rakho
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),

                    /// English Bubble
                    Positioned(
                      right: 20,
                      top: 40,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "How are you?",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    /// Spanish Bubble
                    Positioned(
                      left: 20,
                      bottom: 40,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "¡Hola!\n¿Cómo estás?",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    /// Flags (you can use asset images here)
                    Positioned(
                      top: 20,
                      right: 0,
                      child: Image.asset(
                        "assets/icons/uk_flag.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      child: Image.asset(
                        "assets/icons/spain_flag.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 30,
                      child: Image.asset(
                        "assets/icons/brazil_flag.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 40,
                      child: Image.asset(
                        "assets/icons/india_flag.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Tagline
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text(
                    "Translate your Language",
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Loader + Loading text
                  Column(
                    children: const [
                      CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Loading...",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
